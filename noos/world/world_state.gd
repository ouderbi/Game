## O WorldState — PDF 06 §1. Tudo que é salvo mora aqui. Cada marco
## seguinte acrescenta os demais campos (pressões, relações...) sem
## trocar o formato de acesso. Dicionários indexados por id (nunca
## objeto direto, PDF 06 §4) — mantém save/load simples (M5).
class_name EstadoDoMundo
extends RefCounted

var semente: int
var largura: int
var altura: int
var biomas: PackedByteArray  ## um Bioma.Tipo por tile, indexado por y * largura + x
var tick_atual: int = 0
var regioes: Array[Regiao] = []  ## preenchido por GeradorDeRegioes (PDF 04 §1) após gerar()

var tipos_de_governo: Dictionary = {}  ## id (String) -> TipoDeGoverno
var lideres: Dictionary = {}  ## id (int) -> Lider
var polities: Dictionary = {}  ## id (int) -> Polity

## Ações que o jogador clicou e ainda não foram aplicadas — PDF 19 §2:
## "clique do jogador → ação enfileirada → aplicada pelo MESMO pipeline
## do tick". A UI só empilha aqui; SimulacaoPolitica consome e valida.
var fila_acoes_jogador: Array[Dictionary] = []


func bioma_em(x: int, y: int) -> int:
	return biomas[y * largura + x]


func populacao_total() -> float:
	var soma := 0.0
	for regiao in regioes:
		soma += regiao.populacao_total
	return soma


func polity_do_jogador() -> Polity:
	for id in polities:
		var polity: Polity = polities[id]
		if polity.eh_jogador:
			return polity
	return null
