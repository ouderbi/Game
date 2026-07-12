## Contrato comum de decisão — PDF 03 §8, PDF 13 §1.
## Toda "mente" (heurística ou LLM) implementa este método; a engine
## nunca precisa saber qual motor respondeu — ela só valida e aplica
## (PDF 13, regra soberana: "o LLM propõe; a simulação valida").
## Implementações concretas (heuristic.gd em M2, providers/ em M4)
## chamam este contrato; ele mesmo não decide nada.
class_name Decisor
extends RefCounted


func decidir(_briefing: Dictionary) -> Dictionary:
	push_error("Decisor.decidir() é abstrato — implemente numa subclasse.")
	return {}
