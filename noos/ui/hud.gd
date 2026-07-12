## Painel de nação mínimo — PDF 19 §1/§5: tick atual, população total,
## governo + manutenção e medidores da "Sua Polity", pausa e velocidade
## (1x/2x/3x). Os demais painéis (Governo, Diplomacia...) entram nos
## marcos seguintes.
class_name HUD
extends Control

const ID_POLITY_DO_JOGADOR := 0

var estado: EstadoDoMundo

var _rotulo_tick: Label
var _rotulo_populacao: Label
var _rotulo_governo: Label
var _rotulo_manutencao: Label
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

	_rotulo_governo = Label.new()
	_rotulo_governo.text = ""
	caixa.add_child(_rotulo_governo)

	_rotulo_manutencao = Label.new()
	_rotulo_manutencao.text = ""
	caixa.add_child(_rotulo_manutencao)

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

	if not estado.polities.has(ID_POLITY_DO_JOGADOR):
		return
	var polity: Polity = estado.polities[ID_POLITY_DO_JOGADOR]
	var tipo_governo: TipoDeGoverno = estado.tipos_de_governo.get(polity.tipo_governo_id)

	if tipo_governo != null:
		_rotulo_governo.text = "Governo: %s" % tipo_governo.nome
		_rotulo_manutencao.text = _texto_manutencao(polity, tipo_governo)
	_rotulo_polity.text = (
		"%s — tesouro: %d, estabilidade: %.2f, legitimidade: %.2f"
		% [polity.nome, int(polity.tesouro), polity.estabilidade, polity.legitimidade]
	)


func _texto_manutencao(polity: Polity, tipo_governo: TipoDeGoverno) -> String:
	var regioes := _regioes_da_polity(polity)
	if regioes.is_empty():
		return ""
	var m := Manutencao.avaliar(tipo_governo, polity, regioes)
	var recurso: String = m["recurso"]
	match m["status"]:
		Manutencao.STATUS_OK:
			return "Manutenção (%s): OK (%.2f / %.2f)" % [recurso, m["valor"], m["limiar"]]
		Manutencao.STATUS_FALHANDO:
			return (
				"Manutenção (%s): FALHANDO (%.2f / %.2f) — %s"
				% [recurso, m["valor"], m["limiar"], tipo_governo.manutencao_falha]
			)
		_:
			return "Manutenção (%s): pendente (sistema ainda não construído)" % recurso


func _regioes_da_polity(polity: Polity) -> Array[Regiao]:
	var regioes: Array[Regiao] = []
	for regiao in estado.regioes:
		if regiao.id in polity.region_ids:
			regioes.append(regiao)
	return regioes
