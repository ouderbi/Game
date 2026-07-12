## Ponto de entrada — monta e roda o loop (PDF 03 §2). M0: gera o mapa,
## sobe a câmera e a HUD, e liga o relógio à simulação.
extends Node2D

const LARGURA_MAPA := 64
const ALTURA_MAPA := 48
const SEMENTE := 1337
const TAMANHO_TILE := 16

var _estado: EstadoDoMundo
var _simulacao: Simulacao
var _hud: HUD


func _ready() -> void:
	_estado = GeradorDeMapa.gerar(SEMENTE, LARGURA_MAPA, ALTURA_MAPA)
	_estado.regioes = GeradorDeRegioes.gerar(_estado)
	_simulacao = Simulacao.new()

	var visao_mapa := VisaoDoMapa.new()
	visao_mapa.estado = _estado
	visao_mapa.tamanho_tile = TAMANHO_TILE
	add_child(visao_mapa)
	visao_mapa.queue_redraw()

	var camera := ControladorDeCamera.new()
	add_child(camera)
	camera.ajustar_para_mapa(LARGURA_MAPA, ALTURA_MAPA, TAMANHO_TILE)

	var camada_ui := CanvasLayer.new()
	add_child(camada_ui)
	_hud = HUD.new()
	_hud.estado = _estado
	camada_ui.add_child(_hud)
	_hud.atualizar()

	Relogio.tick.connect(_ao_tick)


func _ao_tick() -> void:
	_simulacao.passo(_estado)
	_hud.atualizar()
