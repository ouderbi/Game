## Forma de governo — schema PDF 10 §1 (subconjunto pros marcos iniciais;
## PDF 23 §7: poucos governos com perfis simples agora, o catálogo
## completo dos ~45 chega pós-M6). Sem era/policies/tech_bias ainda —
## entram junto com eras (M5/M6) e políticas (pós-M6).
class_name TipoDeGoverno
extends RefCounted

var id: String
var nome: String
var concentracao_poder: float  ## 0-1: difuso ↔ absoluto
var tendencia_corrupcao: float  ## 0-1: base de corrupção (PDF 08 §4)
var militarismo: float  ## 0-1: propensão à guerra
var liberdades_civis: float  ## 0-1: repressivo ↔ livre
var estabilidade_base: float  ## 0-1: estabilidade de partida
