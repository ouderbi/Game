## Desenha o mapa de tiles e as fronteiras de região — camadas 1 e 2 do
## PDF 18 §2, lente País (PDF 24 §2). Retângulos coloridos por bioma e
## por dono; TileSet/sprites reais entram quando os assets placeholder
## (Kenney, PDF 24 §5) forem integrados.
class_name VisaoDoMapa
extends Node2D

const PALETA_DONOS := [Color.RED, Color.BLUE, Color.YELLOW, Color.MAGENTA, Color.CYAN, Color.ORANGE]

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

	for regiao in estado.regioes:
		_desenhar_fronteira(regiao)


func _desenhar_fronteira(regiao: Regiao) -> void:
	if regiao.tiles.is_empty():
		return

	var min_x := regiao.tiles[0].x
	var max_x := regiao.tiles[0].x
	var min_y := regiao.tiles[0].y
	var max_y := regiao.tiles[0].y
	for tile in regiao.tiles:
		min_x = mini(min_x, tile.x)
		max_x = maxi(max_x, tile.x)
		min_y = mini(min_y, tile.y)
		max_y = maxi(max_y, tile.y)

	var retangulo := Rect2(
		min_x * tamanho_tile,
		min_y * tamanho_tile,
		(max_x - min_x + 1) * tamanho_tile,
		(max_y - min_y + 1) * tamanho_tile
	)
	draw_rect(retangulo, _cor_da_fronteira(regiao), false, 2.0)


func _cor_da_fronteira(regiao: Regiao) -> Color:
	if regiao.owner_polity_id < 0:
		return Color(1.0, 1.0, 1.0, 0.25)
	return PALETA_DONOS[regiao.owner_polity_id % PALETA_DONOS.size()]
