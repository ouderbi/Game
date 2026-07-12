## Catálogo inicial de governos — valores a partir da tabela de exemplo
## do PDF 10 §2. Subconjunto pequeno de propósito (PDF 23 §7); o
## catálogo completo dos ~45 é só preencher mais entradas neste mesmo
## schema, nunca reescrever código.
class_name CatalogoDeGovernos
extends RefCounted


static func catalogo() -> Dictionary:
	var tipos: Dictionary = {}
	tipos["tribo"] = _criar("tribo", "Tribo", 0.2, 0.2, 0.5, 0.8, 0.6)
	tipos["monarquia"] = _criar("monarquia", "Monarquia", 0.7, 0.4, 0.6, 0.3, 0.55)
	tipos["republica_democratica"] = _criar(
		"republica_democratica", "República Democrática", 0.2, 0.15, 0.2, 0.85, 0.5
	)
	tipos["ditadura_militar"] = _criar(
		"ditadura_militar", "Ditadura Militar", 0.85, 0.7, 0.85, 0.15, 0.45
	)
	return tipos


static func _criar(
	id: String,
	nome: String,
	concentracao_poder: float,
	tendencia_corrupcao: float,
	militarismo: float,
	liberdades_civis: float,
	estabilidade_base: float
) -> TipoDeGoverno:
	var tipo := TipoDeGoverno.new()
	tipo.id = id
	tipo.nome = nome
	tipo.concentracao_poder = concentracao_poder
	tipo.tendencia_corrupcao = tendencia_corrupcao
	tipo.militarismo = militarismo
	tipo.liberdades_civis = liberdades_civis
	tipo.estabilidade_base = estabilidade_base
	return tipo
