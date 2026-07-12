## Vista do mapa — HOI4 (PDF 01 §6, referência nº 1) + SimCity: mapa
## político plano com terreno e fronteiras grossas coloridas, e um ÍCONE
## DE PRÉDIO top-down (não isométrico) por região, que cresce e muda de
## material conforme a população/riqueza — a sensação de "ver a
## civilização crescer" do SimCity, sem sair do mapa plano.
##
## O ícone é desenhado por código (retângulos simples), não por sprite —
## garantidamente renderiza sem depender de alinhar tiles de um pacote
## externo. Sprites reais (Kenney, já em assets/kenney/) entram quando
## puderem ser ajustados visualmente no editor. A lente Cidade isométrica
## 3D (PDF 24 §4) fica documentada pra um zoom futuro, não implementada
## agora.
class_name VisaoDoMapa
extends Node2D

const TAMANHO_TILE := 16
const ESPESSURA_FRONTEIRA := 3.0
const OCUPACAO_MINIMA_VISIVEL := 0.02

const PALETA_DONOS := [Color.RED, Color.BLUE, Color.YELLOW, Color.MAGENTA, Color.CYAN, Color.ORANGE]

var estado: EstadoDoMundo


func _draw() -> void:
	if estado == null:
		return
	_desenhar_terreno()
	for regiao in estado.regioes:
		_desenhar_fronteira(regiao)
	for regiao in estado.regioes:
		_desenhar_icone_povoado(regiao)


func _desenhar_terreno() -> void:
	for y in range(estado.altura):
		for x in range(estado.largura):
			var tipo := estado.bioma_em(x, y)
			var retangulo := Rect2(x * TAMANHO_TILE, y * TAMANHO_TILE, TAMANHO_TILE, TAMANHO_TILE)
			draw_rect(retangulo, Bioma.cor(tipo), true)


## Fronteira grossa colorida por dono (estilo HOI4) — cinza claro e fina
## pra território sem dono ainda.
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
		min_x * TAMANHO_TILE,
		min_y * TAMANHO_TILE,
		(max_x - min_x + 1) * TAMANHO_TILE,
		(max_y - min_y + 1) * TAMANHO_TILE
	)
	var cor := _cor_do_dono(regiao.owner_polity_id)
	var espessura := ESPESSURA_FRONTEIRA if regiao.owner_polity_id >= 0 else 1.0
	draw_rect(retangulo, cor, false, espessura)


## Ícone de prédio top-down: paredes + telhado (inset) + porta. Tamanho
## cresce com a ocupação da região; material (madeira/pedra) muda com a
## riqueza — o mesmo proxy visual usado desde o M2 (Construcao).
func _desenhar_icone_povoado(regiao: Regiao) -> void:
	if regiao.tiles.is_empty() or regiao.populacao_total <= 0.0 or regiao.capacidade_alimento <= 0.0:
		return
	var ocupacao := clampf(regiao.populacao_total / regiao.capacidade_alimento, 0.0, 1.0)
	if ocupacao < OCUPACAO_MINIMA_VISIVEL:
		return

	var centro := _centro_da_regiao(regiao)
	var tamanho := lerpf(6.0, float(TAMANHO_TILE) * 1.6, ocupacao)
	var eh_madeira := Construcao.nivel_por_riqueza(regiao.riqueza_media) == Construcao.Nivel.MADEIRA
	var cor_parede := Color(0.55, 0.4, 0.25) if eh_madeira else Color(0.6, 0.6, 0.62)
	var cor_telhado := Color(0.35, 0.2, 0.1) if eh_madeira else Color(0.3, 0.3, 0.32)

	var metade := tamanho / 2.0
	var corpo := Rect2(centro.x - metade, centro.y - metade, tamanho, tamanho)
	draw_rect(corpo, cor_parede, true)
	draw_rect(corpo, Color.BLACK, false, 1.0)

	var margem := tamanho * 0.18
	var telhado := Rect2(
		centro.x - metade + margem,
		centro.y - metade + margem,
		tamanho - margem * 2.0,
		tamanho - margem * 2.0
	)
	draw_rect(telhado, cor_telhado, true)

	var porta_largura := maxf(tamanho * 0.22, 2.0)
	var porta := Rect2(
		centro.x - porta_largura / 2.0,
		centro.y + metade - porta_largura * 0.6,
		porta_largura,
		porta_largura * 0.6
	)
	draw_rect(porta, Color(0.2, 0.12, 0.05), true)


func _centro_da_regiao(regiao: Regiao) -> Vector2:
	var soma_x := 0.0
	var soma_y := 0.0
	for tile in regiao.tiles:
		soma_x += tile.x
		soma_y += tile.y
	var media_x := soma_x / regiao.tiles.size()
	var media_y := soma_y / regiao.tiles.size()
	return Vector2((media_x + 0.5) * TAMANHO_TILE, (media_y + 0.5) * TAMANHO_TILE)


func _cor_do_dono(id_polity: int) -> Color:
	if id_polity < 0:
		return Color(1.0, 1.0, 1.0, 0.3)
	return PALETA_DONOS[id_polity % PALETA_DONOS.size()]
