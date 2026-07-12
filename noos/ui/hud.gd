## Painel de nação mínimo do M0 — PDF 19 §1/§5: tick atual, pausa e
## velocidade (1x/2x/3x). Os demais painéis (Governo, Diplomacia...)
## entram nos marcos seguintes.
class_name HUD
extends Control

var estado: EstadoDoMundo

var _rotulo_tick: Label
var _botao_pausa: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_TOP_LEFT)

	var caixa := VBoxContainer.new()
	caixa.position = Vector2(12, 12)
	add_child(caixa)

	_rotulo_tick = Label.new()
	_rotulo_tick.text = "Tick: 0"
	caixa.add_child(_rotulo_tick)

	_botao_pausa = Button.new()
	_botao_pausa.text = "Pausar"
	_botao_pausa.pressed.connect(_ao_clicar_pausa)
	caixa.add_child(_botao_pausa)

	var caixa_velocidade := HBoxContainer.new()
	caixa.add_child(caixa_velocidade)
	for multiplicador in [1.0, 2.0, 3.0]:
		var botao := Button.new()
		botao.text = "%dx" % int(multiplicador)
		botao.pressed.connect(Relogio.definir_velocidade.bind(multiplicador))
		caixa_velocidade.add_child(botao)


func _ao_clicar_pausa() -> void:
	Relogio.alternar_pausa()
	_botao_pausa.text = "Retomar" if Relogio.pausado else "Pausar"


## Chamado pelo main.gd depois de cada passo de simulação — deixa a ordem
## "simula, depois mostra" explícita, sem depender da ordem de conexão
## de sinais.
func atualizar() -> void:
	if estado != null:
		_rotulo_tick.text = "Tick: %d" % estado.tick_atual
