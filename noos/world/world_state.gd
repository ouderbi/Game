## O WorldState — PDF 06 §1. Tudo que é salvo mora aqui; no M0 só o mapa
## e o tick atual. Cada marco seguinte acrescenta os demais campos
## (polities, líderes, pressões...) sem trocar o formato de acesso.
class_name EstadoDoMundo
extends RefCounted

var semente: int
var largura: int
var altura: int
var biomas: PackedByteArray  ## um Bioma.Tipo por tile, indexado por y * largura + x
var tick_atual: int = 0


func bioma_em(x: int, y: int) -> int:
	return biomas[y * largura + x]
