## Câmera com pan e zoom sobre o mapa — PDF 18 §3, PDF 19 §5.
## Convenção do Godot: zoom > 1.0 = mais afastado (vê mais área);
## zoom < 1.0 = mais perto. Botão direito arrasta; roda do mouse dá zoom.
class_name ControladorDeCamera
extends Camera2D

var _zoom_minimo: float = 0.2
var _zoom_maximo: float = 5.0
var _arrastando: bool = false


func _ready() -> void:
	current = true


## Centraliza a câmera no mapa e escolhe um zoom que mostre o mapa inteiro.
func ajustar_para_mapa(largura_tiles: int, altura_tiles: int, tamanho_tile: int) -> void:
	var largura_px := largura_tiles * tamanho_tile
	var altura_px := altura_tiles * tamanho_tile
	position = Vector2(largura_px, altura_px) / 2.0

	var tamanho_viewport := get_viewport_rect().size
	var fator := maxf(float(largura_px) / tamanho_viewport.x, float(altura_px) / tamanho_viewport.y)
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
