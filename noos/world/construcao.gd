## Escolha de sprite de construção por "nível" — hoje só um proxy visual
## de população/riqueza, NÃO o catálogo de construções de verdade do
## PDF 21 (muralhas, universidades, usinas, elevador espacial...) nem a
## progressão pelas 12 eras do PDF 05. Esta função é o único lugar que
## decide "que sprite desenhar" — quando o catálogo completo (PDF 21) e
## as eras (PDF 05) entrarem em produção, crescer é só preencher mais
## níveis aqui, igual o resto do projeto já faz (nunca reescrever o
## pipeline de render).
##
## Materiais por era (PDF 05 §4) — hoje só a Pedra existe de verdade
## (toda polity começa Tribo, sem transição de governo ainda), então só
## madeira/pedra fazem sentido; "tijolo" (cerâmica cozida) é anacrônico
## aqui e entra só na Antiguidade/Clássica em diante. Bronze/ferro
## (Clássica-Industrial), concreto/aço (Industrial-Informação) e
## materiais exóticos (Espacial-Intergaláctica) chegam como níveis novos
## conforme eras e governos avançados ficarem alcançáveis de verdade.
class_name Construcao
extends RefCounted

enum Nivel { MADEIRA, PEDRA }

const PASTA_ASSETS := "res://assets/kenney/isometric_blocks/"


static func caminho_textura(nivel: int) -> String:
	match nivel:
		Nivel.MADEIRA:
			return PASTA_ASSETS + "construcao_madeira.png"
		Nivel.PEDRA:
			return PASTA_ASSETS + "construcao_pedra.png"
		_:
			return PASTA_ASSETS + "construcao_madeira.png"


## Nível a partir de riqueza média da região (0-1) — puramente visual
## por ora; vira "que construção específica aparece" quando o catálogo
## do PDF 21 estiver de pé.
static func nivel_por_riqueza(riqueza_media: float) -> int:
	if riqueza_media > 0.5:
		return Nivel.PEDRA
	return Nivel.MADEIRA
