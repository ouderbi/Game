## Uma tecnologia — schema PDF 05 §3. Desbloqueia construções, unidades
## e bônus. Organizada em ramos: base, military, economy, culture.
class_name Tecnologia
extends RefCounted

var id: String
var nome: String
var era: int  ## 1-12
var ramo: String  ## base, military, economy, culture
var custo_pesquisa: float = 100.0
var desbloqueia_construcoes: Array[String] = []
var desbloqueia_unidades: Array[String] = []
var bonus_economia: float = 0.0
var bonus_militar: float = 0.0
var bonus_ciencia: float = 0.0
var bonus_cultura: float = 0.0
var caminho_icone: String
