## Desenha o mapa de tiles — lente País (PDF 24 §2), render mínimo do M0
## (PDF 20). Um retângulo colorido por bioma; TileSet/sprites reais entram
## quando os assets placeholder (Kenney, PDF 24 §5) forem integrados.
class_name VisaoDoMapa
extends Node2D

var estado: EstadoDoMundo
var tamanho_tile: int = 16


func _draw() -> void:
	if estado == null:
		return
	for y in range(estado.altura):
		for x in range(estado.largura):
			var tipo := estado.bioma_em(x, y)
			var cor := Bioma.cor(tipo)
			var retangulo := Rect2(x * tamanho_tile, y * tamanho_tile, tamanho_tile, tamanho_tile)
			draw_rect(retangulo, cor, true)
