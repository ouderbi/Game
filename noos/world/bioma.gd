## Catálogo de biomas — PDF 04 §2. Subconjunto pro M0; os demais entram
## conforme a geração de mundo evolui.
class_name Bioma
extends RefCounted

enum Tipo { OCEANO, PLANICIE, FLORESTA, DESERTO, MONTANHA, TUNDRA }

const PASTA_ASSETS := "res://assets/kenney/isometric_blocks/"


static func cor(tipo: int) -> Color:
	match tipo:
		Tipo.OCEANO:
			return Color(0.16, 0.33, 0.62)
		Tipo.PLANICIE:
			return Color(0.55, 0.73, 0.32)
		Tipo.FLORESTA:
			return Color(0.20, 0.45, 0.20)
		Tipo.DESERTO:
			return Color(0.82, 0.70, 0.40)
		Tipo.MONTANHA:
			return Color(0.55, 0.52, 0.50)
		Tipo.TUNDRA:
			return Color(0.80, 0.85, 0.88)
		_:
			return Color.MAGENTA


## Sprite isométrico real (Kenney CC0, PDF 24 §5) pra cada bioma.
static func caminho_textura(tipo: int) -> String:
	match tipo:
		Tipo.OCEANO:
			return PASTA_ASSETS + "bioma_oceano.png"
		Tipo.PLANICIE:
			return PASTA_ASSETS + "bioma_planicie.png"
		Tipo.FLORESTA:
			return PASTA_ASSETS + "bioma_floresta.png"
		Tipo.DESERTO:
			return PASTA_ASSETS + "bioma_deserto.png"
		Tipo.MONTANHA:
			return PASTA_ASSETS + "bioma_montanha.png"
		Tipo.TUNDRA:
			return PASTA_ASSETS + "bioma_tundra.png"
		_:
			return PASTA_ASSETS + "bioma_planicie.png"
