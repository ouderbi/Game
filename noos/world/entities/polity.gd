## Uma polity — qualquer unidade política, governo ou não-governo
## (glossário do PDF 01 §10; schema do PDF 06 §2, subconjunto). Referências
## por id, nunca por objeto direto (PDF 06 §4) — mantém save/load simples
## e evita ciclos quando polities/líderes forem serializados (M5).
class_name Polity
extends RefCounted

var id: int
var nome: String
var tipo_governo_id: String
var leader_id: int
var region_ids: Array[int] = []

var tesouro: float = 100.0
var corrupcao: float = 0.1
var estabilidade: float = 0.6
var legitimidade: float = 0.6
