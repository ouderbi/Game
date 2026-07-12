## Transições de governo — PDF 10 §5, PDF 17 §2/§4. Uma polity muda de
## tipo por crise, nunca por escolha direta do jogador: golpe (poder
## concentra), revolução (poder se dissolve) ou colapso total (estado
## falido). O GATILHO vem só do estado acumulado (estabilidade,
## legitimidade, corrupção — nunca um contador de turnos fixo); o
## DESTINO vem da pontuação por contexto real, com um componente de
## ruído determinístico — sem favoritismo por nenhum governo específico,
## nenhum é o "final feliz" escrito de propósito (PDF 15 §1, PDF 25 §3).
class_name TransicaoDeGoverno
extends RefCounted

const ID_ESTADO_FALIDO := "estado_falido"
const ERA_QUALQUER := "qualquer"

## Colapso total: abaixo disto, não é mais "escolha" — é o fundo do poço
## (PDF 17 §4), sem sorteio de destino.
const LIMIAR_COLAPSO := 0.08

## Risco de golpe/revolução — cruzar isto não dispara na hora; só abre a
## chance estocástica abaixo, pra o timing não ficar robótico (PDF 15 §2).
const LIMIAR_RISCO := 0.5
const CHANCE_POR_TICK_ACIMA_DO_LIMIAR := 0.05

## Ajuste pós-transição: todo regime novo ganha um pequeno fôlego, mas
## nunca reinicia do zero — as cicatrizes (corrupção, etc.) persistem.
const FOLEGO_POS_TRANSICAO := 0.15


static func avaliar_e_aplicar(
	estado: EstadoDoMundo, polity: Polity, tipo_governo_atual: TipoDeGoverno
) -> void:
	if polity.estabilidade < LIMIAR_COLAPSO:
		_aplicar_transicao(estado, polity, tipo_governo_atual, ID_ESTADO_FALIDO, "colapso")
		return

	var risco_golpe := _risco_golpe(polity)
	var risco_revolucao := _risco_revolucao(estado, polity)
	var maior_risco := maxf(risco_golpe, risco_revolucao)
	if maior_risco < LIMIAR_RISCO:
		return

	var rng := _rng_para(estado, polity, "gatilho")
	if rng.randf() >= CHANCE_POR_TICK_ACIMA_DO_LIMIAR:
		return  # cruzou o limiar, mas o timing exato tem um componente de acaso

	var motivo := "golpe" if risco_golpe >= risco_revolucao else "revolucao"
	var alvo := _escolher_destino(estado, polity, tipo_governo_atual, motivo)
	if alvo != "":
		_aplicar_transicao(estado, polity, tipo_governo_atual, alvo, motivo)


## risco_golpe = poder concentrado sem legitimidade pra sustentá-lo,
## agravado por corrupção — versão sem facções do PDF 17 §2 (o termo de
## poder/lealdade de facção entra quando facções existirem).
static func _risco_golpe(polity: Polity) -> float:
	var bruto := (
		(1.0 - polity.estabilidade) * (1.0 - polity.legitimidade) * (1.0 + polity.corrupcao)
	)
	return clampf(bruto / 2.0, 0.0, 1.0)


## risco_revolução = legitimidade caindo enquanto o povo sofre de verdade
## (moral baixa nas regiões) — proxy do PDF 17 §2 sem desigualdade/
## repressão explícitas ainda (chegam com sociedade, PDF 09).
static func _risco_revolucao(estado: EstadoDoMundo, polity: Polity) -> float:
	var moral := _moral_media(estado, polity)
	return clampf((1.0 - polity.legitimidade) * (1.0 - moral), 0.0, 1.0)


static func _moral_media(estado: EstadoDoMundo, polity: Polity) -> float:
	var regioes := _regioes_da_polity(estado, polity)
	if regioes.is_empty():
		return 0.5
	var soma := 0.0
	for regiao in regioes:
		soma += regiao.humor_medio
	return soma / regioes.size()


static func _regioes_da_polity(estado: EstadoDoMundo, polity: Polity) -> Array[Regiao]:
	var regioes: Array[Regiao] = []
	for regiao in estado.regioes:
		if regiao.id in polity.region_ids:
			regioes.append(regiao)
	return regioes


## Escolhe o novo governo por PONTUAÇÃO CONTEXTUAL — nunca uma tabela
## fixa "golpe sempre vira X". Golpe favorece mais concentração de poder
## que o atual (a força restabelece ordem); revolução favorece mais
## liberdade civil (reação à opressão). Os dois favorecem menos corrupção
## que o regime que acabou de falhar. Ruído determinístico impede que o
## resultado seja sempre "o único ótimo" pro mesmo estado.
static func _escolher_destino(
	estado: EstadoDoMundo, polity: Polity, atual: TipoDeGoverno, motivo: String
) -> String:
	var catalogo := CatalogoDeGovernos.catalogo()
	var rng := _rng_para(estado, polity, "destino")

	var melhor_id := ""
	var melhor_nota := -INF
	for id in catalogo:
		if id == polity.tipo_governo_id or id == ID_ESTADO_FALIDO:
			continue
		var candidato: TipoDeGoverno = catalogo[id]
		if candidato.era != polity.era and candidato.era != ERA_QUALQUER:
			continue  # governos de eras não alcançadas ainda ficam fora do sorteio

		var nota := 0.0
		if motivo == "golpe":
			nota += (candidato.concentracao_poder - atual.concentracao_poder)
		else:
			nota += (candidato.liberdades_civis - atual.liberdades_civis)
		nota += (atual.tendencia_corrupcao - candidato.tendencia_corrupcao) * 0.6
		nota += rng.randf_range(-0.3, 0.3)  # sem favoritismo: nenhum destino é garantido

		if nota > melhor_nota:
			melhor_nota = nota
			melhor_id = id

	return melhor_id


static func _aplicar_transicao(
	estado: EstadoDoMundo,
	polity: Polity,
	tipo_governo_atual: TipoDeGoverno,
	novo_id: String,
	motivo: String
) -> void:
	var nome_antigo := polity.tipo_governo_id
	if tipo_governo_atual != null:
		nome_antigo = tipo_governo_atual.nome
	polity.tipo_governo_id = novo_id
	polity.historico_governos.append(
		"%d:%s->%s:%s" % [estado.tick_atual, nome_antigo, novo_id, motivo]
	)
	# Fôlego do regime novo — nunca reinicia do zero (as cicatrizes ficam).
	polity.estabilidade = clampf(polity.estabilidade + FOLEGO_POS_TRANSICAO, 0.0, 1.0)
	polity.legitimidade = clampf(polity.legitimidade + FOLEGO_POS_TRANSICAO, 0.0, 1.0)
	print(
		(
			"[transição] %s (tick %d): %s -> %s (%s)"
			% [polity.nome, estado.tick_atual, nome_antigo, novo_id, motivo]
		)
	)


## RNG determinístico por (semente do mundo, tick, polity, sal) — mesma
## partida sempre reproduz a mesma transição (PDF 03 §4).
static func _rng_para(estado: EstadoDoMundo, polity: Polity, sal: String) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = estado.semente * 1000003 + estado.tick_atual * 97 + polity.id * 31 + sal.hash()
	return rng
