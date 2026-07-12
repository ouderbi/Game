## Aplica a decisão do líder de cada polity e atualiza seus medidores —
## PDF 13 (ciclo cérebro/corpo: monta briefing → Decider.decide() →
## engine valida e aplica), PDF 17 (estabilidade). M2: o "briefing" é um
## resumo mínimo (tesouro/moral/personalidade); o schema completo do
## PDF 13 §2 (nação, eventos, relações, memória, pressões) chega junto
## com os sistemas que o alimentam.
class_name SimulacaoPolitica
extends RefCounted


static func avancar(estado: EstadoDoMundo) -> void:
	var decisor := DecisorHeuristico.new()
	for id in estado.polities:
		var polity: Polity = estado.polities[id]
		var lider: Lider = estado.lideres[polity.leader_id]
		var tipo_governo: TipoDeGoverno = estado.tipos_de_governo[polity.tipo_governo_id]
		var regioes_da_polity := _regioes_da_polity(estado, polity)

		if regioes_da_polity.is_empty():
			continue

		var briefing := _montar_briefing(polity, lider, regioes_da_polity)
		var decisao: Dictionary = decisor.decidir(briefing)
		_aplicar_decisao(polity, regioes_da_polity, decisao)

		CalculadoraDeEstabilidade.avancar(polity, tipo_governo, regioes_da_polity)


static func _regioes_da_polity(estado: EstadoDoMundo, polity: Polity) -> Array[Regiao]:
	var regioes: Array[Regiao] = []
	for regiao in estado.regioes:
		if regiao.id in polity.region_ids:
			regioes.append(regiao)
	return regioes


static func _montar_briefing(polity: Polity, lider: Lider, regioes: Array[Regiao]) -> Dictionary:
	var soma_humor := 0.0
	for regiao in regioes:
		soma_humor += regiao.humor_medio
	var humor_medio := soma_humor / regioes.size()

	return {
		"tesouro_baixo": clampf(1.0 - polity.tesouro / 200.0, 0.0, 1.0),
		"moral_baixa": clampf(1.0 - humor_medio, 0.0, 1.0),
		"ambicao": lider.ambicao,
		"competencia": lider.competencia,
	}


## A engine é a autoridade: valida o "cardápio" de ações conhecido e
## aplica os efeitos — nunca confia cego no que o Decisor devolveu
## (PDF 13 §8, mesmo valendo pra heurística quanto pro LLM no M4).
static func _aplicar_decisao(polity: Polity, regioes: Array[Regiao], decisao: Dictionary) -> void:
	var acoes: Array = decisao.get("actions", [])
	for acao in acoes:
		var tipo: String = acao.get("type", "")
		var quantidade: float = acao.get("amount", 0.02)
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
		regiao.riqueza_media = maxf(regiao.riqueza_media - arrecadado, 0.0)
		regiao.humor_medio = maxf(regiao.humor_medio - quantidade * 0.5, 0.0)
		polity.tesouro += arrecadado * 50.0  # escala riqueza (0-1) pra tesouro (unidades abstratas)


static func _baixar_impostos(polity: Polity, regioes: Array[Regiao], quantidade: float) -> void:
	for regiao in regioes:
		regiao.humor_medio = minf(regiao.humor_medio + quantidade * 0.5, 1.0)
	polity.tesouro = maxf(polity.tesouro - quantidade * 10.0 * regioes.size(), 0.0)
