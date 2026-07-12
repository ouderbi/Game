## Escolha de sprite de construção por "nível" — hoje só um proxy visual
## de população/riqueza (madeira → tijolo → pedra), NÃO o catálogo de
## construções de verdade do PDF 21 (muralhas, universidades, usinas,
## elevador espacial...) nem a progressão pelas 12 eras do PDF 05.
## Esta função é o único lugar que decide "que sprite desenhar" — quando
## o catálogo completo (PDF 21) e as eras (PDF 05) entrarem em produção,
## crescer é só preencher mais níveis aqui, igual o resto do projeto já
## faz (nunca reescrever o pipeline de render).
class_name Construcao
extends RefCounted

## Níveis de hoje — placeholder da era Pedra/Antiguidade. Eras seguintes
## (Medieval → Intergaláctica, PDF 05) e o catálogo do PDF 21 (prefeitura,
## muralha, universidade, usina nuclear, reator de fusão, megaestrutura
## orbital...) entram como níveis/entradas novas neste mesmo esquema.
enum Nivel { MADEIRA, TIJOLO, PEDRA }

const PASTA_ASSETS := "res://assets/kenney/isometric_blocks/"


static func caminho_textura(nivel: int) -> String:
	match nivel:
		Nivel.MADEIRA:
			return PASTA_ASSETS + "construcao_madeira.png"
		Nivel.TIJOLO:
			return PASTA_ASSETS + "construcao_tijolo.png"
		Nivel.PEDRA:
			return PASTA_ASSETS + "construcao_pedra.png"
		_:
			return PASTA_ASSETS + "construcao_madeira.png"


## Nível a partir de riqueza média da região (0-1) — puramente visual
## por ora; vira "que construção específica aparece" quando o catálogo
## do PDF 21 estiver de pé.
static func nivel_por_riqueza(riqueza_media: float) -> int:
	if riqueza_media > 0.66:
		return Nivel.PEDRA
	if riqueza_media > 0.33:
		return Nivel.TIJOLO
	return Nivel.MADEIRA
