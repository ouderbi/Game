## Forma de governo — schema PDF 10 §1 + PDF 23 (particularidades) + a
## MANUTENÇÃO (novo): o que o jogador precisa sustentar o tempo todo pra
## manter este governo de pé, senão ele desmorona sozinho (PDF 01 §7).
## Preenchido a partir de data/governos.json (CatalogoDeGovernos) — 54
## governos pelas 12 eras. Sem policies/tech_bias ainda (entram com
## eras/políticas nos marcos seguintes).
class_name TipoDeGoverno
extends RefCounted

var id: String
var nome: String  ## PT-BR
var nome_en: String
var era: String  ## era em que destrava (PDF 05 §4)

var concentracao_poder: float  ## 0-1: difuso ↔ absoluto
var tendencia_corrupcao: float  ## 0-1: base de corrupção (PDF 08 §4)
var militarismo: float  ## 0-1: propensão à guerra
var liberdades_civis: float  ## 0-1: repressivo ↔ livre
var estabilidade_base: float  ## 0-1: estabilidade de partida

## Identidade (texto de design, PDF 10 §1 / PDF 23 §4).
var bonus: String  ## o que este governo faz de bom
var penalidade: String  ## o que ele custa
var consequencia: String  ## o que ele faz da civilização com o tempo

## Manutenção — o esforço constante que mantém o governo (ex.: ditadura
## precisa de militares fortes; feudo, de comida e proteção).
var manutencao_descricao: String
## recurso: comida|consenso|riqueza|forca_militar|pesquisa|coesao|fe|dados|energia
var manutencao_recurso: String
var manutencao_limiar: float  ## nível mínimo do recurso pra sustentar o governo
var manutencao_falha: String  ## o que acontece quando a manutenção falha
