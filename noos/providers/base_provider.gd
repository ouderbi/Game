## Interface comum dos provedores de decisão — PDF 03 §8, PDF 14 §1.
## Toda decisão "inteligente" passa por aqui: trocar de motor nunca
## reescreve o jogo, só troca qual Provedor está plugado.
## Implementações concretas (heurística em M2; Ollama/Anthropic/destilada
## em M4, PDF 14) chegam nos marcos seguintes.
class_name Provedor
extends RefCounted


func decidir(_briefing: Dictionary) -> Dictionary:
	push_error("Provedor.decidir() é abstrato — implemente numa subclasse.")
	return {}
