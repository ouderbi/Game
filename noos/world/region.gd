## Uma região — a unidade real de jogo (PDF 04 §1, PDF 06 §2). Agrega um
## bloco de tiles; carrega o estado agregado de população (PDF 06 §3, PDF 07).
## `owner_polity_id` fica -1 até o M2 (nenhuma polity ainda reivindica nada).
class_name Regiao
extends RefCounted

var id: int
var tiles: Array[Vector2i] = []
var bioma_predominante: int
var owner_polity_id: int = -1

## Capacidade agregada de sustento da região (PDF 08 §1: recursos × bioma).
var capacidade_alimento: float = 0.0

## Estado agregado da população — PDF 06 §3, PDF 07 §1. Nunca um array por
## cidadão: sempre médias/distribuições por região.
var populacao_total: float = 0.0
var humor_medio: float = 0.6
var saude_media: float = 0.7
var riqueza_media: float = 0.1
