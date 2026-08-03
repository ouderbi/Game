## Uma construção — schema PDF 21 §1. Cada região pode ter construções
## que afetam economia, defesa, cultura, etc. Referenciada por id, nunca
## por objeto direto (PDF 06 §4).
class_name Construcao
extends RefCounted

var id: String
var nome: String
var era: int  ## 1-12
var categoria: String  ## defense, civic, economic, cultural, religious, infrastructure, housing, military, special
var custo: float = 50.0
var manutencao: float = 1.0
var bonus_estabilidade: float = 0.0
var bonus_economia: float = 0.0
var bonus_defesa: float = 0.0
var bonus_cultura: float = 0.0
var bonus_ciencia: float = 0.0
var caminho_icone: String  ## caminho do SVG no sistema de arquivos
