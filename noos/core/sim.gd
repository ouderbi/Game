## Orquestra o pipeline de um tick — PDF 03 §5, PDF 22 §1.
## No M0 só avança o contador; cada marco seguinte pluga um passo novo,
## sempre nesta mesma ordem (ver PDF 22 §1 pra sequência completa).
class_name Simulacao
extends RefCounted


func passo(estado: EstadoDoMundo) -> void:
	# Ordem fixa do PDF 03 §5 — cada TODO abaixo é um passo futuro, na
	# posição em que vai entrar; "avançar relógio" é sempre o último.
	# TODO M3 (PDF 15/16): atualizar pressões
	# TODO M1 (PDF 07/08): população & economia
	# TODO M3 (PDF 15/16): disparar eventos que cruzaram limiar
	# TODO M2/M4 (PDF 10/11/13/14): coletar decisões (heurística + LLM) e aplicar efeitos
	estado.tick_atual += 1
