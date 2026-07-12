## Motor de decisão por Utility AI — PDF 25 §1: nota(ação) = Σ
## consideração(estado) × peso(personalidade) + ruído. Os traços SÃO os
## pesos (PDF 25 §2) — os 5 traços do líder entram aqui: ambição e
## competência nas considerações de imposto; agressão empurra pra cima
## de impostos (extrai mais, se prepara pra disputa); paranoia amplifica
## a percepção de moral baixa (superestima ameaça, PDF 07 §3); e a
## competência controla a amplitude do ruído — quanto menos competente,
## mais errático (a "burrice controlável", PDF 25 §3 ★).
##
## M2: só a alavanca de impostos existe (PDF 08 §7); o cardápio cresce
## junto com governo/diplomacia completos (PDF 21). Implementa o
## contrato Decisor (brains/decider.gd) — a mesma interface que os
## providers/ de LLM vão implementar no M4 (PDF 03 §8).
class_name DecisorHeuristico
extends Decisor


func decidir(briefing: Dictionary) -> Dictionary:
	var tesouro_baixo: float = briefing.get("tesouro_baixo", 0.0)
	var moral_baixa: float = briefing.get("moral_baixa", 0.0)
	var ambicao: float = briefing.get("ambicao", 0.5)
	var competencia: float = briefing.get("competencia", 0.5)
	var agressao: float = briefing.get("agressao", 0.5)
	var paranoia: float = briefing.get("paranoia", 0.5)
	var semente_ruido: int = briefing.get("semente_ruido", 0)

	# Paranoico superestima o quanto o povo está insatisfeito.
	var moral_baixa_percebida := clampf(moral_baixa * (1.0 + paranoia * 0.5), 0.0, 1.0)

	# Ruído determinístico (semente_ruido vem do tick+polity, PDF 03 §4
	# — reproduzível). Quanto menos competente o líder, mais ele erra.
	var rng := RandomNumberGenerator.new()
	rng.seed = semente_ruido
	var amplitude_ruido := 0.05 + (1.0 - competencia) * 0.15

	var nota_subir := (
		tesouro_baixo * (0.6 + ambicao * 0.4)
		- moral_baixa_percebida * 0.5
		+ agressao * 0.2
		+ rng.randf_range(-amplitude_ruido, amplitude_ruido)
	)
	var nota_baixar := (
		moral_baixa_percebida * (0.6 + competencia * 0.4)
		- tesouro_baixo * 0.5
		+ rng.randf_range(-amplitude_ruido, amplitude_ruido)
	)
	var nota_manter := 0.2 + rng.randf_range(-amplitude_ruido, amplitude_ruido)  # inércia

	if nota_subir >= nota_baixar and nota_subir >= nota_manter:
		return {"actions": [{"type": "raise_taxes", "amount": 0.02}]}
	if nota_baixar >= nota_manter:
		return {"actions": [{"type": "lower_taxes", "amount": 0.02}]}
	return {"actions": []}
