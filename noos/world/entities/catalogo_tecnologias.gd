## Catálogo de tecnologias — 48 entradas (4 por era × 12 eras).
## Schema: cada entrada define id, nome, era, ramo, custo e bônus.
## O caminho do ícone SVG segue res://assets/techs/<id>.svg
extends RefCounted

static func catalogo() -> Dictionary:
	var d: Dictionary = {}
	# Era 1
	_t(d, "fire_mastery", "Domínio do Fogo", 1, "base", 50, 0.05, 0.0, 0.1, 0.0)
	_t(d, "stone_tools", "Ferramentas de Pedra", 1, "military", 60, 0.0, 0.15, 0.0, 0.0)
	_t(d, "agriculture_primitive", "Agricultura Primitiva", 1, "economy", 70, 0.0, 0.0, 0.2, 0.0)
	_t(d, "ritual_knowledge", "Conhecimento Ritual", 1, "culture", 40, 0.0, 0.0, 0.0, 0.15)
	# Era 2
	_t(d, "writing", "Escrita", 2, "base", 100, 0.05, 0.0, 0.0, 0.2)
	_t(d, "bronze_working", "Metalurgia do Bronze", 2, "military", 120, 0.0, 0.2, 0.0, 0.0)
	_t(d, "irrigation", "Irrigação", 2, "economy", 110, 0.0, 0.0, 0.25, 0.0)
	_t(d, "astronomy_early", "Astronomia Antiga", 2, "culture", 90, 0.0, 0.0, 0.0, 0.2)
	# Era 3
	_t(d, "mathematics", "Matemática", 3, "base", 200, 0.1, 0.0, 0.0, 0.25)
	_t(d, "siege_engineering", "Engenharia de Cerco", 3, "military", 180, 0.0, 0.3, 0.0, 0.0)
	_t(d, "road_building", "Construção de Estradas", 3, "economy", 150, 0.0, 0.0, 0.3, 0.0)
	_t(d, "philosophy", "Filosofia", 3, "culture", 160, 0.0, 0.0, 0.0, 0.3)
	# Era 4
	_t(d, "feudalism", "Feudalismo", 4, "base", 300, 0.15, 0.0, 0.0, 0.15)
	_t(d, "steel_smelting", "Fundição de Aço", 4, "military", 280, 0.0, 0.35, 0.0, 0.0)
	_t(d, "crop_rotation", "Rotação de Culturas", 4, "economy", 250, 0.0, 0.0, 0.35, 0.0)
	_t(d, "scholasticism", "Escolástica", 4, "culture", 220, 0.0, 0.0, 0.0, 0.35)
	# Era 5
	_t(d, "steam_engine", "Motor a Vapor", 5, "base", 500, 0.1, 0.0, 0.15, 0.1)
	_t(d, "rifled_barrel", "Cano Raiado", 5, "military", 450, 0.0, 0.4, 0.0, 0.0)
	_t(d, "mass_production", "Produção em Massa", 5, "economy", 480, 0.0, 0.0, 0.5, 0.0)
	_t(d, "sociology", "Sociologia", 5, "culture", 380, 0.0, 0.0, 0.0, 0.4)
	# Era 6
	_t(d, "nuclear_physics", "Física Nuclear", 6, "base", 800, 0.15, 0.0, 0.1, 0.2)
	_t(d, "jet_propulsion", "Propulsão a Jato", 6, "military", 750, 0.0, 0.5, 0.0, 0.0)
	_t(d, "automation", "Automação", 6, "economy", 700, 0.0, 0.0, 0.55, 0.0)
	_t(d, "mass_media", "Mídia de Massa", 6, "culture", 600, 0.0, 0.0, 0.0, 0.5)
	# Era 7
	_t(d, "quantum_computing", "Computação Quântica", 7, "base", 1200, 0.2, 0.0, 0.15, 0.3)
	_t(d, "cyber_warfare", "Guerra Cibernética", 7, "military", 1000, 0.0, 0.6, 0.0, 0.0)
	_t(d, "renewable_energy", "Energia Renovável", 7, "economy", 900, 0.0, 0.0, 0.6, 0.0)
	_t(d, "social_networks", "Redes Sociais", 7, "culture", 800, 0.0, 0.0, 0.0, 0.6)
	# Era 8
	_t(d, "fusion_power", "Energia de Fusão", 8, "base", 2000, 0.25, 0.0, 0.2, 0.2)
	_t(d, "plasma_weapons", "Armas de Plasma", 8, "military", 1800, 0.0, 0.7, 0.0, 0.0)
	_t(d, "nanotechnology", "Nanotecnologia", 8, "economy", 1600, 0.0, 0.0, 0.7, 0.0)
	_t(d, "neural_interface", "Interface Neural", 8, "culture", 1500, 0.0, 0.0, 0.0, 0.7)
	# Era 9
	_t(d, "orbital_mechanics", "Mecânica Orbital", 9, "base", 3000, 0.2, 0.0, 0.25, 0.25)
	_t(d, "space_combat", "Combate Espacial", 9, "military", 2800, 0.0, 0.8, 0.0, 0.0)
	_t(d, "zero_g_manufacturing", "Manufatura Gravidade Zero", 9, "economy", 2600, 0.0, 0.0, 0.8, 0.0)
	_t(d, "xenobiology", "Xenobiologia", 9, "culture", 2400, 0.0, 0.0, 0.0, 0.8)
	# Era 10
	_t(d, "warp_theory", "Teoria da Dobra", 10, "base", 5000, 0.3, 0.0, 0.3, 0.3)
	_t(d, "planetary_shields", "Escudos Planetários", 10, "military", 4500, 0.0, 0.9, 0.0, 0.0)
	_t(d, "asteroid_mining_tech", "Mineração de Asteroides", 10, "economy", 4200, 0.0, 0.0, 0.9, 0.0)
	_t(d, "terraforming_science", "Ciência da Terraformação", 10, "culture", 4000, 0.0, 0.0, 0.0, 0.9)
	# Era 11
	_t(d, "antimatter_reactor", "Reator de Antimatéria", 11, "base", 8000, 0.35, 0.0, 0.35, 0.35)
	_t(d, "stellar_weapons", "Armas Estelares", 11, "military", 7500, 0.0, 1.0, 0.0, 0.0)
	_t(d, "interstellar_trade", "Comércio Interestelar", 11, "economy", 7000, 0.0, 0.0, 1.0, 0.0)
	_t(d, "galactic_law", "Lei Galáctica", 11, "culture", 6500, 0.0, 0.0, 0.0, 1.0)
	# Era 12
	_t(d, "dimensional_physics", "Física Dimensional", 12, "base", 15000, 0.5, 0.0, 0.5, 0.5)
	_t(d, "reality_warping", "Distorção da Realidade", 12, "military", 14000, 0.0, 1.2, 0.0, 0.0)
	_t(d, "zero_point_energy", "Energia Ponto Zero", 12, "economy", 13000, 0.0, 0.0, 1.2, 0.0)
	_t(d, "transcendence", "Transcendência", 12, "culture", 12000, 0.0, 0.0, 0.0, 1.2)
	return d

static func _t(
	d: Dictionary, id: String, nome: String, era: int, ramo: String,
	custo: float, econ: float, mil: float, cienc: float, cult: float
) -> void:
	var t := Tecnologia.new()
	t.id = id
	t.nome = nome
	t.era = era
	t.ramo = ramo
	t.custo_pesquisa = custo
	t.bonus_economia = econ
	t.bonus_militar = mil
	t.bonus_ciencia = cienc
	t.bonus_cultura = cult
	t.caminho_icone = "res://assets/techs/" + id + ".svg"
	d[id] = t
