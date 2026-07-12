## Aplica a decisão do líder de cada polity, atualiza seus medidores e
## avalia transições de governo — PDF 13 (ciclo cérebro/corpo: monta
## briefing → Decider.decide() → engine valida e aplica), PDF 17
## (estabilidade + transições, TransicaoDeGoverno). O "briefing" é um
## resumo mínimo (tesouro/moral/personalidade); o schema completo do
## PDF 13 §2 (nação, eventos, relações, memória, pressões) chega junto
## com os sistemas que o alimentam.
class_name SimulacaoPolitica
extends RefCounted

## Teto de segurança pra magnitude de qualquer ação numérica — a engine
## nunca aplica cego o que o Decisor manda (PDF 13 §8); hoje só a
## heurística existe e sempre manda 0.02, mas o teto já protege contra
## um provider de LLM (M4) devolvendo um valor absurdo.
const AMOUNT_MAXIMO := 0.15


static func avancar(estado: EstadoDoMundo) -> void:
	var decisor := DecisorHeuristico.new()
	for id in estado.polities:
		var polity: Polity = estado.polities[id]
		var lider: Lider = estado.lideres.get(polity.leader_id)
		var tipo_governo: TipoDeGoverno = estado.tipos_de_governo.get(polity.tipo_governo_id)
		if lider == null or tipo_governo == null:
			push_warning("Polity %s sem líder/governo válido — pulando este tick" % polity.id)
			continue

		var regioes_da_polity := _regioes_da_polity(estado, polity)
		if regioes_da_polity.is_empty():
			continue

		var briefing := _montar_briefing(estado, polity, lider, regioes_da_polity)
		var decisao: Dictionary = decisor.decidir(briefing)
		_aplicar_decisao(polity, regioes_da_polity, decisao)

		CalculadoraDeEstabilidade.avancar(polity, tipo_governo, lider, regioes_da_polity)
		TransicaoDeGoverno.avaliar_e_aplicar(estado, polity, tipo_governo)


static func _regioes_da_polity(estado: EstadoDoMundo, polity: Polity) -> Array[Regiao]:
	var regioes: Array[Regiao] = []
	for regiao in estado.regioes:
		if regiao.id in polity.region_ids:
			regioes.append(regiao)
	return regioes


static func _montar_briefing(
	estado: EstadoDoMundo, polity: Polity, lider: Lider, regioes: Array[Regiao]
) -> Dictionary:
	var soma_humor := 0.0
	for regiao in regioes:
		soma_humor += regiao.humor_medio
	var humor_medio := soma_humor / regioes.size()

	return {
		"tesouro_baixo": clampf(1.0 - polity.tesouro / 200.0, 0.0, 1.0),
		"moral_baixa": clampf(1.0 - humor_medio, 0.0, 1.0),
		"ambicao": lider.ambicao,
		"competencia": lider.competencia,
		"agressao": lider.agressao,
		"paranoia": lider.paranoia,
		# Determinístico por (semente do mundo, tick, polity) — mesma
		# partida sempre reproduz o mesmo "erro" do líder (PDF 03 §4).
		"semente_ruido": estado.semente * 1000003 + estado.tick_atual * 97 + polity.id,
	}


## A engine é a autoridade: valida o "cardápio" de ações conhecido,
## clampa a magnitude e só então aplica os efeitos — nunca confia cego
## no que o Decisor devolveu (PDF 13 §8, vale pra heurística hoje e pro
## LLM no M4).
static func _aplicar_decisao(polity: Polity, regioes: Array[Regiao], decisao: Dictionary) -> void:
	var acoes: Array = decisao.get("actions", [])
	for acao in acoes:
		var tipo: String = acao.get("type", "")
		var quantidade: float = clampf(acao.get("amount", 0.02), 0.0, AMOUNT_MAXIMO)
		if tipo == "raise_taxes":
			_subir_impostos(polity, regioes, quantidade)
		elif tipo == "lower_taxes":
			_baixar_impostos(polity, regioes, quantidade)
		# Ações desconhecidas são ignoradas — cardápio fechado, PDF 13 §8.


## Impostos altos financiam o tesouro, mas derrubam humor e riqueza das
## regiões — o trade-off do PDF 08 §7 ("tesouro cheio vs. povo satisfeito").
static func _subir_impostos(polity: Polity, regioes: Array[Regiao], quantidade: float) -> void:
	for regiao in regioes:
		var arrecadado := regiao.riqueza_media * quantidade
		regiao.riqueza_media = clampf(regiao.riqueza_media - arrecadado, 0.0, 1.0)
		regiao.humor_medio = clampf(regiao.humor_medio - quantidade * 0.5, 0.0, 1.0)
		polity.tesouro += arrecadado * 50.0  # escala riqueza (0-1) pra tesouro (unidades abstratas)


static func _baixar_impostos(polity: Polity, regioes: Array[Regiao], quantidade: float) -> void:
	for regiao in regioes:
		regiao.humor_medio = clampf(regiao.humor_medio + quantidade * 0.5, 0.0, 1.0)
	polity.tesouro = maxf(polity.tesouro - quantidade * 10.0 * regioes.size(), 0.0)
