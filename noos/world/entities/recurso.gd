## Um recurso — schema PDF 08 §1. Recursos estratégicos por era que
## afetam produção, comércio e disponibilidade de unidades/construções.
class_name Recurso
extends RefCounted

var id: String
var nome: String
var era: int
var tipo: String  ## material, energia, conhecimento
var valor_base: float = 10.0
var caminho_icone: String
