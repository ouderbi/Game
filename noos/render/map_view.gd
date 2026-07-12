## Vista isométrica do mapa (estilo SimCity 2000, PDF 18 §1/§4, PDF 24 §4)
## — sprites reais (Kenney CC0, PDF 24 §5), não retângulos abstratos.
## Terreno é construído uma vez (não muda); construções são reconstruídas
## sempre que a população muda (chamado pelo main.gd a cada tick).
##
## Projeção dimétrica 2:1 do PDF 18 §3: tela_x=(gx−gy)·L/2, tela_y=(gx+gy)·A/2.
## Cada sprite de cubo Kenney é 111×128px; o topo em losango ocupa
## aproximadamente a metade superior — por isso o offset vertical abaixo
## (ajustável, não pixel-perfeito sem ver renderizado de verdade).
class_name VisaoDoMapa
extends Node2D

const LARGURA_TILE := 111.0
const ALTURA_TOPO := LARGURA_TILE / 2.0  ## 2:1 — metade da largura
const OFFSET_VERTICAL_SPRITE := 36.5  ## desloca o "centro do topo" pro pivô

const MAX_CONSTRUCOES_POR_REGIAO := 12

var estado: EstadoDoMundo

var _texturas_bioma: Dictionary = {}  ## Bioma.Tipo -> Texture2D (cache)
var _texturas_construcao: Dictionary = {}  ## Construcao.Nivel -> Texture2D (cache)
var _dono_por_tile: PackedInt32Array = PackedInt32Array()
var _no_terreno: Node2D
var _no_construcoes: Node2D


func grade_para_tela(gx: float, gy: float) -> Vector2:
	return Vector2((gx - gy) * LARGURA_TILE / 2.0, (gx + gy) * ALTURA_TOPO / 2.0)


## Chamado uma vez pelo main.gd depois de atribuir `estado`.
func preparar() -> void:
	if estado == null:
		return
	_carregar_texturas()
	_calcular_donos_por_tile()

	_no_terreno = Node2D.new()
	add_child(_no_terreno)
	_construir_terreno()

	_no_construcoes = Node2D.new()
	add_child(_no_construcoes)
	atualizar_construcoes()


## Chamado a cada tick (main.gd) — só reconstrói as construções, que são
## poucas; o terreno (milhares de tiles) fica parado.
func atualizar_construcoes() -> void:
	if _no_construcoes == null:
		return
	for filho in _no_construcoes.get_children():
		filho.queue_free()

	var construcoes := _coletar_construcoes()
	construcoes.sort_custom(
		func(a, b): return (a["tile"].x + a["tile"].y) < (b["tile"].x + b["tile"].y)
	)
	for construcao in construcoes:
		_criar_sprite_construcao(construcao["tile"], construcao["regiao"])


func _carregar_texturas() -> void:
	for tipo in [
		Bioma.Tipo.OCEANO,
		Bioma.Tipo.PLANICIE,
		Bioma.Tipo.FLORESTA,
		Bioma.Tipo.DESERTO,
		Bioma.Tipo.MONTANHA,
		Bioma.Tipo.TUNDRA
	]:
		_texturas_bioma[tipo] = load(Bioma.caminho_textura(tipo))
	for nivel in [Construcao.Nivel.MADEIRA, Construcao.Nivel.PEDRA]:
		_texturas_construcao[nivel] = load(Construcao.caminho_textura(nivel))


func _calcular_donos_por_tile() -> void:
	_dono_por_tile.resize(estado.largura * estado.altura)
	_dono_por_tile.fill(-1)
	for regiao in estado.regioes:
		for tile in regiao.tiles:
			_dono_por_tile[tile.y * estado.largura + tile.x] = regiao.owner_polity_id


func _construir_terreno() -> void:
	for y in range(estado.altura):
		for x in range(estado.largura):
			var tipo := estado.bioma_em(x, y)
			var sprite := Sprite2D.new()
			sprite.texture = _texturas_bioma[tipo]
			sprite.centered = true
			sprite.offset = Vector2(0, OFFSET_VERTICAL_SPRITE)
			sprite.position = grade_para_tela(x, y)
			sprite.z_index = (x + y) * 2
			var dono: int = _dono_por_tile[y * estado.largura + x]
			if dono >= 0:
				sprite.modulate = _tingir_por_dono(dono)
			_no_terreno.add_child(sprite)


## Tinge o terreno com a cor do dono (Civilization-style), sem esconder
## o sprite original — fronteiras de posse legíveis sem precisar de uma
## camada de UI extra (PDF 18 §2).
func _tingir_por_dono(id_polity: int) -> Color:
	var paleta := [Color.RED, Color.BLUE, Color.YELLOW, Color.MAGENTA, Color.CYAN, Color.ORANGE]
	var cor: Color = paleta[id_polity % paleta.size()]
	return cor.lerp(Color.WHITE, 0.5)


func _coletar_construcoes() -> Array:
	var lista: Array = []
	for regiao in estado.regioes:
		if regiao.tiles.is_empty() or regiao.populacao_total <= 0.0:
			continue
		var ocupacao := clampf(regiao.populacao_total / regiao.capacidade_alimento, 0.0, 1.0)
		var quantidade := int(round(ocupacao * mini(regiao.tiles.size(), MAX_CONSTRUCOES_POR_REGIAO)))
		for i in range(quantidade):
			var tile: Vector2i = regiao.tiles[i]
			if estado.bioma_em(tile.x, tile.y) == Bioma.Tipo.OCEANO:
				continue
			lista.append({"tile": tile, "regiao": regiao})
	return lista


func _criar_sprite_construcao(tile: Vector2i, regiao: Regiao) -> void:
	var nivel := Construcao.nivel_por_riqueza(regiao.riqueza_media)
	var sprite := Sprite2D.new()
	sprite.texture = _texturas_construcao[nivel]
	sprite.centered = true
	# Empilhado acima do tile de terreno (o mesmo pivô, deslocado pra cima).
	sprite.offset = Vector2(0, OFFSET_VERTICAL_SPRITE - LARGURA_TILE * 0.55)
	sprite.position = grade_para_tela(tile.x, tile.y)
	sprite.z_index = (tile.x + tile.y) * 2 + 1
	_no_construcoes.add_child(sprite)
