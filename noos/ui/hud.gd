## Painel de nação mínimo — PDF 19 §1/§5: tick atual, população total,
## medidores da "Sua Polity", pausa e velocidade (1x/2x/3x). Os demais
## painéis (Governo, Diplomacia...) entram nos marcos seguintes.
class_name HUD
extends Control

const ID_POLITY_DO_JOGADOR := 0

var estado: EstadoDoMundo

var _rotulo_tick: Label
var _rotulo_populacao: Label
var _rotulo_polity: Label
var _botao_pausa: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_TOP_LEFT)

	var caixa := VBoxContainer.new()
	caixa.position = Vector2(12, 12)
	add_child(caixa)

	_rotulo_tick = Label.new()
	_rotulo_tick.text = "Tick: 0"
	caixa.add_child(_rotulo_tick)

	_rotulo_populacao = Label.new()
	_rotulo_populacao.text = "População: 0"
	caixa.add_child(_rotulo_populacao)

	_rotulo_polity = Label.new()
	_rotulo_polity.text = ""
	caixa.add_child(_rotulo_polity)

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
	if estado == null:
		return
	_rotulo_tick.text = "Tick: %d" % estado.tick_atual
	_rotulo_populacao.text = "População: %d" % int(estado.populacao_total())

	if estado.polities.has(ID_POLITY_DO_JOGADOR):
		var polity: Polity = estado.polities[ID_POLITY_DO_JOGADOR]
		_rotulo_polity.text = (
			"%s — tesouro: %d, estabilidade: %.2f, legitimidade: %.2f"
			% [polity.nome, int(polity.tesouro), polity.estabilidade, polity.legitimidade]
		)
