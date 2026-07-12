## Motor de decisão por Utility AI — PDF 25. Cada ação possível recebe
## uma nota a partir do estado do mundo e da personalidade do líder
## (os traços SÃO os pesos das considerações, PDF 25 §2); a de maior
## nota vence. M2: só a alavanca de impostos existe (PDF 08 §7); o
## cardápio cresce junto com governo/diplomacia completos (PDF 21).
## Implementa o contrato Decisor (brains/decider.gd) — a mesma interface
## que os providers/ de LLM vão implementar no M4 (PDF 03 §8).
class_name DecisorHeuristico
extends Decisor


func decidir(briefing: Dictionary) -> Dictionary:
	var tesouro_baixo: float = briefing.get("tesouro_baixo", 0.0)
	var moral_baixa: float = briefing.get("moral_baixa", 0.0)
	var ambicao: float = briefing.get("ambicao", 0.5)
	var competencia: float = briefing.get("competencia", 0.5)

	var nota_subir := tesouro_baixo * (0.6 + ambicao * 0.4) - moral_baixa * 0.5
	var nota_baixar := moral_baixa * (0.6 + competencia * 0.4) - tesouro_baixo * 0.5
	var nota_manter := 0.2  # inércia — nem toda decisão precisa de ação

	if nota_subir >= nota_baixar and nota_subir >= nota_manter:
		return {"actions": [{"type": "raise_taxes", "amount": 0.02}]}
	if nota_baixar >= nota_manter:
		return {"actions": [{"type": "lower_taxes", "amount": 0.02}]}
	return {"actions": []}
