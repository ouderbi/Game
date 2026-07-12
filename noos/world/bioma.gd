## Catálogo de biomas — PDF 04 §2. Subconjunto pro M0; os demais entram
## conforme a geração de mundo evolui.
class_name Bioma
extends RefCounted

enum Tipo { OCEANO, PLANICIE, FLORESTA, DESERTO, MONTANHA, TUNDRA }


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
