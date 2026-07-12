## O líder de uma polity — schema PDF 11 §1 (subconjunto: sem memory_ref/
## goals/brain_tier ainda — chegam no M4 junto com a camada de LLM,
## PDF 13/14). Os traços de personalidade são os pesos que a Utility AI
## (PDF 25 §2) usa pra pontuar ações; a mesma situação pesa diferente
## conforme quem está no comando.
class_name Lider
extends RefCounted

var id: int
var nome: String
var arquetipo: String

## Traços de personalidade (PDF 11 §1), cada um 0-1.
var agressao: float
var paranoia: float
var ambicao: float
var competencia: float
var corruptibilidade: float
