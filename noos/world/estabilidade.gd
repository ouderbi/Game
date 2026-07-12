## Medidores de estabilidade e legitimidade — PDF 17 §1, versão
## simplificada: sem facções/eventos/inflação ainda (chegam nos marcos
## seguintes e alimentam as equações completas de risco de golpe/
## revolução do PDF 17 §2). Prosperidade e moral das regiões, a tendência
## de corrupção do governo E o próprio líder (corruptibilidade puxa
## corrupção pra cima ou pra baixo; competência sustenta legitimidade —
## PDF 17 §1) empurram os medidores rumo a um alvo, suavizado tick a tick.
## A MANUTENÇÃO do governo (Manutencao) entra como penalidade quando o
## recurso que o sustenta falha.
class_name CalculadoraDeEstabilidade
extends RefCounted

const VELOCIDADE := 0.03


static func avancar(
	polity: Polity, tipo_governo: TipoDeGoverno, lider: Lider, regioes_da_polity: Array[Regiao]
) -> void:
	if regioes_da_polity.is_empty():
		return

	var soma_riqueza := 0.0
	var soma_humor := 0.0
	for regiao in regioes_da_polity:
		soma_riqueza += regiao.riqueza_media
		soma_humor += regiao.humor_medio
	var prosperidade := soma_riqueza / regioes_da_polity.size()
	var moral := soma_humor / regioes_da_polity.size()

	# Corrupção varia por forma de governo E por líder (PDF 08 §4) — um
	# líder corruptível empurra a corrupção acima da tendência do
	# governo; um íntegro, abaixo.
	var alvo_corrupcao := clampf(
		tipo_governo.tendencia_corrupcao + (lider.corruptibilidade - 0.5) * 0.3, 0.0, 1.0
	)
	polity.corrupcao += (alvo_corrupcao - polity.corrupcao) * VELOCIDADE
	polity.corrupcao = clampf(polity.corrupcao, 0.0, 1.0)

	var alvo_legitimidade := clampf(
		tipo_governo.estabilidade_base
		+ prosperidade * 0.3
		+ lider.competencia * 0.15
		- polity.corrupcao * 0.4,
		0.0,
		1.0
	)
	polity.legitimidade += (alvo_legitimidade - polity.legitimidade) * VELOCIDADE
	polity.legitimidade = clampf(polity.legitimidade, 0.0, 1.0)

	# Manutenção do governo (PDF 10 §5): se o recurso que sustenta este
	# governo (militares numa ditadura, comida num feudo...) cai abaixo do
	# limiar, a estabilidade despenca proporcionalmente ao déficit. É o que
	# faz "manter a forma de governo" custar esforço constante.
	var manutencao := Manutencao.avaliar(tipo_governo, polity, regioes_da_polity)
	var penalidade_manutencao: float = manutencao["deficit"] * 0.8

	var alvo_estabilidade := clampf(
		polity.legitimidade * 0.5 + moral * 0.3 + prosperidade * 0.2 - penalidade_manutencao,
		0.0,
		1.0
	)
	polity.estabilidade += (alvo_estabilidade - polity.estabilidade) * VELOCIDADE
	polity.estabilidade = clampf(polity.estabilidade, 0.0, 1.0)
