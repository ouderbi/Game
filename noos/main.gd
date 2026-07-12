## Ponto de entrada — monta e roda o loop (PDF 03 §2). Gera o mapa e as
## polities, sobe a câmera e a HUD, e liga o relógio à simulação.
extends Node2D

const LARGURA_MAPA := 64
const ALTURA_MAPA := 48
const SEMENTE := 1337
const TAMANHO_TILE := 16

## 1 polity reservada pro jogador (M5 pluga o controle real) + 3 líderes-
## NPC (PDF 04 §7, PDF 11) — nenhum se encontra cedo (M2 ainda não tem
## diplomacia/exploração; a distância entre pontos de partida já antecipa
## esse isolamento). Todas rodam por heurística até o M4 trazer o LLM.
const NOMES_POLITIES := ["Sua Polity", "Reino do Norte", "República do Vale", "Junta do Sul"]

var _estado: EstadoDoMundo
var _simulacao: Simulacao
var _hud: HUD


func _ready() -> void:
	_estado = GeradorDeMapa.gerar(SEMENTE, LARGURA_MAPA, ALTURA_MAPA)
	_estado.regioes = GeradorDeRegioes.gerar(_estado)
	_criar_polities()
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


func _criar_polities() -> void:
	_estado.tipos_de_governo = CatalogoDeGovernos.catalogo()
	var ids_governo: Array = _estado.tipos_de_governo.keys()

	if _estado.regioes.is_empty():
		return

	# RNG seedado — determinismo (PDF 03 §4): mesma semente, mesmas polities.
	var rng := RandomNumberGenerator.new()
	rng.seed = SEMENTE

	var indices_usados: Dictionary = {}
	var proximo_id_lider := 0
	var proximo_id_polity := 0

	for i in range(NOMES_POLITIES.size()):
		# Espalha os pontos de partida ao longo da lista de regiões (ordem
		# de geração é linha a linha — dá uma separação geográfica razoável
		# sem precisar de um algoritmo de distância completo neste marco).
		var indice_regiao := int(
			float(i + 1) / float(NOMES_POLITIES.size() + 1) * _estado.regioes.size()
		)
		indice_regiao = clampi(indice_regiao, 0, _estado.regioes.size() - 1)
		while indices_usados.has(indice_regiao) and indices_usados.size() < _estado.regioes.size():
			indice_regiao = (indice_regiao + 1) % _estado.regioes.size()
		if indices_usados.has(indice_regiao):
			break  # não há regiões suficientes pra todas as polities
		indices_usados[indice_regiao] = true

		var regiao: Regiao = _estado.regioes[indice_regiao]

		# Escopo do M2: traços sorteados uniformemente, sem preset por
		# arquétipo/governo ainda (PDF 11 §1-§2 promete isso; entra
		# quando tivermos mais de um arquétipo de verdade pra escolher).
		var lider := Lider.new()
		lider.id = proximo_id_lider
		lider.nome = "Líder %d" % proximo_id_lider
		lider.arquetipo = "pragmatico"
		lider.agressao = rng.randf()
		lider.paranoia = rng.randf()
		lider.ambicao = rng.randf()
		lider.competencia = rng.randf()
		lider.corruptibilidade = rng.randf()
		_estado.lideres[lider.id] = lider

		var polity := Polity.new()
		polity.id = proximo_id_polity
		polity.nome = NOMES_POLITIES[i]
		polity.tipo_governo_id = ids_governo[i % ids_governo.size()]
		polity.leader_id = lider.id
		polity.region_ids = [regiao.id]
		regiao.owner_polity_id = polity.id
		_estado.polities[polity.id] = polity

		proximo_id_lider += 1
		proximo_id_polity += 1
