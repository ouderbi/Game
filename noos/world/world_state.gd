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

## Catálogos estáticos — preenchidos uma vez no _ready (PDF 06 §2).
var construcoes: Dictionary = {}  ## id (String) -> Construcao
var tecnologias: Dictionary = {}  ## id (String) -> Tecnologia
var recursos_catalogo: Dictionary = {}  ## id (String) -> Recurso


func bioma_em(x: int, y: int) -> int:
	return biomas[y * largura + x]


func populacao_total() -> float:
	var soma := 0.0
	for regiao in regioes:
		soma += regiao.populacao_total
	return soma
