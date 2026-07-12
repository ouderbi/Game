## Orquestra o pipeline de um tick — PDF 03 §5, PDF 22 §1.
## No M0 só avança o contador; cada marco seguinte pluga um passo novo,
## sempre nesta mesma ordem (ver PDF 22 §1 pra sequência completa).
class_name Simulacao
extends RefCounted


func passo(estado: EstadoDoMundo) -> void:
	estado.tick_atual += 1
	# TODO M1 (PDF 07/08): população & economia
	# TODO M3 (PDF 15/16): pressões & eventos
	# TODO M2 (PDF 10/11/17): governo, líderes heurísticos, medidores
	# TODO M4 (PDF 12/13/14): decisões de líderes (heurística + LLM) e diplomacia
