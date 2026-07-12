## Câmera com pan e zoom sobre o mapa — PDF 18 §3, PDF 19 §5.
## Convenção do Godot: zoom > 1.0 = mais afastado (vê mais área);
## zoom < 1.0 = mais perto. Botão direito arrasta; roda do mouse dá zoom.
class_name ControladorDeCamera
extends Camera2D

var _zoom_minimo: float = 0.2
var _zoom_maximo: float = 5.0
var _arrastando: bool = false


func _ready() -> void:
	enabled = true  # no Godot 4, Camera2D usa "enabled" (não "current", que era Godot 3.x)


## Centraliza a câmera no mapa e escolhe um zoom que mostre o mapa inteiro
## (grade quadrada — mantido pra referência/telas futuras não-isométricas).
func ajustar_para_mapa(largura_tiles: int, altura_tiles: int, tamanho_tile: int) -> void:
	var largura_px := largura_tiles * tamanho_tile
	var altura_px := altura_tiles * tamanho_tile
	position = Vector2(largura_px, altura_px) / 2.0
	_ajustar_zoom_pro_retangulo(largura_px, altura_px)


## Mesma ideia, mas pro losango da projeção isométrica (PDF 24 §4):
## tela_x=(gx−gy)·L/2, tela_y=(gx+gy)·A/2 — o "retângulo" que cobre o
## losango inteiro tem largura (W+H)·L e altura (W+H)·A.
func ajustar_para_mapa_isometrico(
	largura_tiles: int, altura_tiles: int, largura_iso: float, altura_iso: float
) -> void:
	var soma := largura_tiles + altura_tiles
	var largura_px := soma * largura_iso
	var altura_px := soma * altura_iso
	position = Vector2((largura_tiles - altura_tiles) * largura_iso / 2.0, altura_px / 2.0)
	_ajustar_zoom_pro_retangulo(largura_px, altura_px)


func _ajustar_zoom_pro_retangulo(largura_px: float, altura_px: float) -> void:
	# get_viewport_rect() é método de Control, não de Camera2D — o caminho
	# universal (qualquer Node) é get_viewport().get_visible_rect().
	var tamanho_viewport := get_viewport().get_visible_rect().size
	var fator := maxf(largura_px / tamanho_viewport.x, altura_px / tamanho_viewport.y)
	fator = clampf(fator, _zoom_minimo, _zoom_maximo)
	zoom = Vector2(fator, fator)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_aplicar_zoom(1.0 / 1.1)  # roda pra cima = aproxima
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_aplicar_zoom(1.1)  # roda pra baixo = afasta
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_arrastando = event.pressed
	elif event is InputEventMouseMotion and _arrastando:
		position -= event.relative * zoom


func _aplicar_zoom(fator: float) -> void:
	var novo_zoom: Vector2 = zoom * fator
	novo_zoom.x = clampf(novo_zoom.x, _zoom_minimo, _zoom_maximo)
	novo_zoom.y = clampf(novo_zoom.y, _zoom_minimo, _zoom_maximo)
	zoom = novo_zoom
