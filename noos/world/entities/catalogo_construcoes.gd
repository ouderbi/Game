## Catálogo de construções — 120 entradas (10 por era × 12 eras).
## Schema: cada entrada define id, nome, era, categoria, custos e bônus.
## O caminho do ícone SVG segue o padrão res://assets/buildings/<era>/<id>.svg
extends RefCounted

const _BASE := "res://assets/buildings/"

static func catalogo() -> Dictionary:
	var d: Dictionary = {}
	# Era 1 — Pedra
	_c(d, "palisade", "Paliçada", 1, "defense", 20, 0.5, 0.05, 0.0, 0.15, 0.0, 0.0)
	_c(d, "stone_circle", "Círculo de Pedras", 1, "religious", 40, 1.0, 0.0, 0.0, 0.0, 0.1, 0.05)
	_c(d, "hunting_camp", "Acampamento de Caça", 1, "economic", 30, 0.8, 0.0, 0.1, 0.0, 0.0, 0.0)
	_c(d, "fire_pit", "Fogueira Comunal", 1, "cultural", 15, 0.3, 0.02, 0.0, 0.0, 0.05, 0.0)
	_c(d, "shaman_hut", "Tenda do Xamã", 1, "religious", 35, 0.8, 0.03, 0.0, 0.0, 0.08, 0.03)
	_c(d, "tool_workshop", "Oficina de Sílex", 1, "infrastructure", 45, 1.2, 0.0, 0.05, 0.0, 0.0, 0.08)
	_c(d, "hut_cluster", "Núcleo de Cabanas", 1, "housing", 25, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0)
	_c(d, "watch_tower_primitive", "Torre de Observação", 1, "military", 30, 0.5, 0.03, 0.0, 0.1, 0.0, 0.0)
	_c(d, "burial_mound", "Túmulo Megalítico", 1, "special", 50, 0.5, 0.05, 0.0, 0.0, 0.08, 0.0)
	_c(d, "gatherers_camp", "Acampamento Coletor", 1, "economic", 20, 0.5, 0.0, 0.08, 0.0, 0.0, 0.0)
	# Era 2 — Antiguidade
	_c(d, "mud_wall", "Muralha de Taipa", 2, "defense", 60, 1.5, 0.1, 0.0, 0.25, 0.0, 0.0)
	_c(d, "ziggurat", "Zigurate", 2, "religious", 120, 3.0, 0.05, 0.0, 0.0, 0.15, 0.1)
	_c(d, "granary", "Celeiro", 2, "economic", 50, 1.0, 0.0, 0.2, 0.0, 0.0, 0.0)
	_c(d, "market_stall", "Barquinha de Mercado", 2, "economic", 40, 1.0, 0.0, 0.15, 0.0, 0.0, 0.0)
	_c(d, "scribes_school", "Escola de Escribas", 2, "civic", 80, 2.0, 0.05, 0.0, 0.0, 0.05, 0.15)
	_c(d, "pottery_kiln", "Forno de Cerâmica", 2, "infrastructure", 60, 1.5, 0.0, 0.1, 0.0, 0.0, 0.05)
	_c(d, "mud_houses", "Casas de Taipa", 2, "housing", 40, 0.8, 0.0, 0.0, 0.0, 0.0, 0.0)
	_c(d, "chariot_workshop", "Oficina de Carruagens", 2, "military", 70, 2.0, 0.0, 0.0, 0.15, 0.0, 0.0)
	_c(d, "irrigation_channel", "Canal de Irrigação", 2, "infrastructure", 55, 1.0, 0.0, 0.2, 0.0, 0.0, 0.0)
	_c(d, "temple_altar", "Altar do Templo", 2, "civic", 45, 1.0, 0.08, 0.0, 0.0, 0.1, 0.05)
	# Era 3 — Clássica
	_c(d, "stone_wall", "Muralha de Pedra", 3, "defense", 100, 2.0, 0.15, 0.0, 0.35, 0.0, 0.0)
	_c(d, "academy", "Academia", 3, "civic", 150, 3.0, 0.05, 0.0, 0.0, 0.1, 0.25)
	_c(d, "agora", "Ágora", 3, "economic", 80, 2.0, 0.0, 0.25, 0.0, 0.05, 0.0)
	_c(d, "amphitheater", "Anfiteatro", 3, "cultural", 120, 2.5, 0.05, 0.05, 0.0, 0.2, 0.0)
	_c(d, "pantheon", "Panteão", 3, "religious", 200, 4.0, 0.1, 0.0, 0.0, 0.15, 0.1)
	_c(d, "aqueduct", "Aqueduto", 3, "infrastructure", 90, 2.0, 0.0, 0.2, 0.0, 0.0, 0.05)
	_c(d, "villa", "Vila Romana", 3, "housing", 60, 1.0, 0.0, 0.05, 0.0, 0.0, 0.0)
	_c(d, "barracks_classical", "Quartel Legionário", 3, "military", 80, 2.0, 0.0, 0.0, 0.2, 0.0, 0.0)
	_c(d, "harbor_docks", "Cais do Porto", 3, "economic", 100, 2.5, 0.0, 0.3, 0.0, 0.0, 0.0)
	_c(d, "library", "Biblioteca", 3, "civic", 110, 2.0, 0.05, 0.0, 0.0, 0.1, 0.2)
	# Era 4 — Medieval
	_c(d, "castle", "Castelo", 4, "defense", 200, 4.0, 0.2, 0.0, 0.4, 0.0, 0.0)
	_c(d, "cathedral", "Catedral", 4, "religious", 250, 5.0, 0.15, 0.0, 0.0, 0.25, 0.1)
	_c(d, "windmill", "Moinho de Vento", 4, "economic", 80, 1.5, 0.0, 0.2, 0.0, 0.0, 0.0)
	_c(d, "tavern", "Taberna", 4, "cultural", 50, 1.0, 0.05, 0.05, 0.0, 0.1, 0.0)
	_c(d, "monastery", "Mosteiro", 4, "religious", 120, 2.5, 0.1, 0.05, 0.0, 0.15, 0.1)
	_c(d, "blacksmith", "Ferreiro", 4, "infrastructure", 70, 1.5, 0.0, 0.15, 0.0, 0.0, 0.05)
	_c(d, "timber_houses", "Casas de Madeira", 4, "housing", 50, 0.8, 0.0, 0.0, 0.0, 0.0, 0.0)
	_c(d, "knight_stables", "Cavalaria", 4, "military", 100, 2.5, 0.0, 0.0, 0.25, 0.0, 0.0)
	_c(d, "watchtower", "Torre de Vigia", 4, "defense", 60, 1.0, 0.05, 0.0, 0.15, 0.0, 0.0)
	_c(d, "market_square", "Praça do Mercado", 4, "economic", 90, 2.0, 0.0, 0.2, 0.0, 0.05, 0.0)
	# Era 5 — Industrial
	_c(d, "bastion_fort", "Forte Bastionado", 5, "defense", 180, 3.0, 0.2, 0.0, 0.45, 0.0, 0.0)
	_c(d, "town_hall", "Câmara Municipal", 5, "civic", 150, 3.0, 0.1, 0.0, 0.0, 0.1, 0.1)
	_c(d, "factory", "Fábrica", 5, "economic", 200, 4.0, 0.0, 0.4, 0.0, 0.0, 0.1)
	_c(d, "opera_house", "Casa de Ópera", 5, "cultural", 160, 3.5, 0.1, 0.05, 0.0, 0.25, 0.0)
	_c(d, "chapel_industrial", "Capela Industrial", 5, "religious", 80, 1.5, 0.08, 0.0, 0.0, 0.1, 0.05)
	_c(d, "train_station", "Estação Ferroviária", 5, "infrastructure", 140, 3.0, 0.0, 0.25, 0.0, 0.0, 0.05)
	_c(d, "tenement_block", "Cortiço Industrial", 5, "housing", 60, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	_c(d, "arsenal", "Arsenal", 5, "military", 120, 3.0, 0.0, 0.1, 0.3, 0.0, 0.0)
	_c(d, "telegraph_office", "Telégrafo", 5, "infrastructure", 70, 1.5, 0.0, 0.1, 0.0, 0.0, 0.1)
	_c(d, "bank", "Banco", 5, "economic", 130, 2.5, 0.0, 0.3, 0.0, 0.0, 0.0)
	# Era 6 — Moderna
	_c(d, "bunker", "Bunker", 6, "defense", 150, 2.5, 0.25, 0.0, 0.5, 0.0, 0.0)
	_c(d, "parliament", "Parlamento", 6, "civic", 250, 4.0, 0.15, 0.0, 0.0, 0.1, 0.15)
	_c(d, "power_plant", "Usina", 6, "economic", 220, 4.5, 0.0, 0.45, 0.0, 0.0, 0.1)
	_c(d, "cinema", "Cinema", 6, "cultural", 100, 2.0, 0.05, 0.05, 0.0, 0.2, 0.0)
	_c(d, "cathedral_modern", "Catedral Moderna", 6, "religious", 180, 3.0, 0.1, 0.0, 0.0, 0.15, 0.08)
	_c(d, "airport", "Aeroporto", 6, "infrastructure", 300, 5.0, 0.0, 0.3, 0.0, 0.0, 0.05)
	_c(d, "apartment_block", "Bloco de Apartamentos", 6, "housing", 80, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0)
	_c(d, "military_base", "Base Militar", 6, "military", 200, 4.0, 0.0, 0.05, 0.4, 0.0, 0.0)
	_c(d, "highway_junction", "Trevo Rodoviário", 6, "infrastructure", 120, 2.5, 0.0, 0.2, 0.0, 0.0, 0.0)
	_c(d, "stock_exchange", "Bolsa de Valores", 6, "economic", 280, 4.0, 0.0, 0.5, 0.0, 0.0, 0.05)
	# Era 7 — Informação
	_c(d, "sam_site", "Bateria de Mísseis", 7, "defense", 200, 3.0, 0.2, 0.0, 0.55, 0.0, 0.0)
	_c(d, "data_center", "Centro de Dados", 7, "civic", 300, 5.0, 0.1, 0.1, 0.0, 0.05, 0.3)
	_c(d, "solar_farm", "Fazenda Solar", 7, "economic", 250, 4.0, 0.0, 0.4, 0.0, 0.0, 0.1)
	_c(d, "stadium", "Estádio", 7, "cultural", 220, 4.0, 0.1, 0.1, 0.0, 0.3, 0.0)
	_c(d, "megachurch", "Megachurch", 7, "religious", 180, 3.0, 0.1, 0.05, 0.0, 0.15, 0.05)
	_c(d, "telecom_tower", "Torre de Telecom", 7, "infrastructure", 160, 3.0, 0.0, 0.2, 0.0, 0.0, 0.15)
	_c(d, "smart_apartments", "Apartamentos Inteligentes", 7, "housing", 120, 2.0, 0.0, 0.05, 0.0, 0.0, 0.0)
	_c(d, "drone_base", "Base de Drones", 7, "military", 180, 3.5, 0.0, 0.05, 0.4, 0.0, 0.05)
	_c(d, "university_modern", "Universidade", 7, "civic", 280, 4.5, 0.1, 0.05, 0.0, 0.1, 0.35)
	_c(d, "shopping_mall", "Shopping Center", 7, "economic", 200, 3.5, 0.0, 0.35, 0.0, 0.1, 0.0)
	# Era 8 — Alta Tecnologia
	_c(d, "energy_shield", "Escudo de Energia", 8, "defense", 350, 5.0, 0.3, 0.0, 0.6, 0.0, 0.0)
	_c(d, "ai_lab", "Laboratório de IA", 8, "civic", 400, 6.0, 0.1, 0.1, 0.0, 0.05, 0.4)
	_c(d, "fusion_plant", "Usina de Fusão", 8, "economic", 380, 5.5, 0.0, 0.5, 0.0, 0.0, 0.15)
	_c(d, "holo_theater", "Teatro Holográfico", 8, "cultural", 250, 4.0, 0.1, 0.1, 0.0, 0.35, 0.0)
	_c(d, "meditation_chamber", "Câmara de Meditação", 8, "religious", 200, 3.0, 0.15, 0.0, 0.0, 0.2, 0.1)
	_c(d, "maglev_station", "Estação Maglev", 8, "infrastructure", 300, 4.5, 0.0, 0.3, 0.0, 0.0, 0.1)
	_c(d, "arcology", "Arcologia", 8, "housing", 350, 5.0, 0.05, 0.1, 0.0, 0.05, 0.05)
	_c(d, "power_armor_depot", "Depósito de Armaduras", 8, "military", 280, 4.5, 0.0, 0.05, 0.5, 0.0, 0.05)
	_c(d, "biotech_lab", "Laboratório Biotech", 8, "civic", 320, 5.0, 0.05, 0.1, 0.0, 0.05, 0.3)
	_c(d, "replicator_factory", "Fábrica de Replicadores", 8, "economic", 300, 5.0, 0.0, 0.45, 0.0, 0.0, 0.1)
	# Era 9 — Espacial
	_c(d, "orbital_defense", "Defesa Orbital", 9, "defense", 500, 6.0, 0.3, 0.0, 0.7, 0.0, 0.0)
	_c(d, "space_colony", "Colônia Espacial", 9, "civic", 600, 7.0, 0.15, 0.15, 0.0, 0.1, 0.2)
	_c(d, "rocket_launch", "Complexo de Lançamento", 9, "economic", 450, 6.0, 0.0, 0.4, 0.0, 0.0, 0.2)
	_c(d, "zero_g_arena", "Arena Gravidade Zero", 9, "cultural", 300, 4.5, 0.1, 0.1, 0.0, 0.4, 0.0)
	_c(d, "meditation_chamber_space", "Templo Orbital", 9, "religious", 280, 4.0, 0.2, 0.0, 0.0, 0.25, 0.1)
	_c(d, "space_elevator", "Elevador Espacial", 9, "infrastructure", 700, 8.0, 0.0, 0.35, 0.0, 0.0, 0.15)
	_c(d, "habitat_dome", "Domo Habitacional", 9, "housing", 400, 5.5, 0.05, 0.1, 0.0, 0.05, 0.05)
	_c(d, "marine_barracks", "Quartel Espacial", 9, "military", 350, 5.0, 0.0, 0.05, 0.55, 0.0, 0.05)
	_c(d, "orbital_lab", "Laboratório Orbital", 9, "civic", 380, 5.5, 0.05, 0.1, 0.0, 0.05, 0.35)
	_c(d, "mining_station", "Estação de Mineração", 9, "economic", 320, 5.0, 0.0, 0.4, 0.0, 0.0, 0.1)
	# Era 10 — Interplanetária
	_c(d, "defense_grid", "Grade de Defesa Planetária", 10, "defense", 700, 8.0, 0.35, 0.0, 0.75, 0.0, 0.0)
	_c(d, "terraforming", "Estação de Terraformação", 10, "civic", 800, 9.0, 0.2, 0.2, 0.0, 0.1, 0.25)
	_c(d, "asteroid_mine", "Mineração de Asteroides", 10, "economic", 600, 7.0, 0.0, 0.5, 0.0, 0.0, 0.15)
	_c(d, "vr_arcade", "Arcade VR Planetário", 10, "cultural", 400, 5.5, 0.1, 0.1, 0.0, 0.45, 0.0)
	_c(d, "planetary_temple", "Templo Planetário", 10, "religious", 350, 5.0, 0.25, 0.0, 0.0, 0.3, 0.1)
	_c(d, "orbital_dock", "Doca Orbital", 10, "infrastructure", 550, 7.0, 0.0, 0.4, 0.0, 0.0, 0.1)
	_c(d, "biodome_city", "Cidade Biodomo", 10, "housing", 500, 6.0, 0.05, 0.15, 0.0, 0.05, 0.05)
	_c(d, "mech_factory", "Fábrica de Mechas", 10, "military", 450, 6.5, 0.0, 0.1, 0.6, 0.0, 0.1)
	_c(d, "gene_bank", "Banco Genético", 10, "civic", 420, 6.0, 0.1, 0.1, 0.0, 0.05, 0.3)
	_c(d, "fusion_refinery", "Refinaria de Fusão", 10, "economic", 480, 6.5, 0.0, 0.45, 0.0, 0.0, 0.1)
	# Era 11 — Estelar
	_c(d, "fleet_station", "Estação de Defesa da Frota", 11, "defense", 1000, 10.0, 0.4, 0.0, 0.8, 0.0, 0.0)
	_c(d, "stellar_assembly", "Assembleia Estelar", 11, "civic", 1200, 12.0, 0.25, 0.2, 0.0, 0.15, 0.3)
	_c(d, "trade_hub", "Hub de Comércio Interestelar", 11, "economic", 900, 10.0, 0.0, 0.6, 0.0, 0.0, 0.2)
	_c(d, "concert_hall_stellar", "Salão de Concertos Estelar", 11, "cultural", 600, 7.0, 0.15, 0.1, 0.0, 0.5, 0.0)
	_c(d, "stellar_temple", "Templo Estelar", 11, "religious", 500, 6.5, 0.3, 0.0, 0.0, 0.35, 0.15)
	_c(d, "warp_gate", "Portal Dobra", 11, "infrastructure", 1100, 11.0, 0.0, 0.45, 0.0, 0.0, 0.2)
	_c(d, "orbital_habitat", "Habitat Orbital", 11, "housing", 700, 7.5, 0.05, 0.15, 0.0, 0.05, 0.05)
	_c(d, "fleet_academy", "Academia da Frota", 11, "military", 650, 8.0, 0.0, 0.1, 0.65, 0.0, 0.1)
	_c(d, "stellar_archive", "Arquivo Estelar", 11, "civic", 580, 7.5, 0.1, 0.1, 0.0, 0.1, 0.4)
	_c(d, "antimatter_plant", "Usina de Antimatéria", 11, "economic", 750, 9.0, 0.0, 0.55, 0.0, 0.0, 0.2)
	# Era 12 — Intergaláctica
	_c(d, "galactic_defense", "Array de Defesa Galáctica", 12, "defense", 1500, 15.0, 0.5, 0.0, 0.9, 0.0, 0.0)
	_c(d, "galactic_council", "Conselho Galáctico", 12, "civic", 2000, 20.0, 0.3, 0.25, 0.0, 0.2, 0.4)
	_c(d, "wormhole_gen", "Gerador de Buraco de Minhoca", 12, "economic", 1400, 15.0, 0.0, 0.7, 0.0, 0.0, 0.3)
	_c(d, "reality_theater", "Teatro da Realidade", 12, "cultural", 900, 10.0, 0.2, 0.15, 0.0, 0.6, 0.0)
	_c(d, "cosmic_sanctuary", "Santuário Cósmico", 12, "religious", 800, 10.0, 0.4, 0.0, 0.0, 0.45, 0.2)
	_c(d, "dimensional_gate", "Portal Dimensional", 12, "infrastructure", 1800, 18.0, 0.0, 0.5, 0.0, 0.0, 0.3)
	_c(d, "dyson_sphere", "Esfera de Dyson", 12, "housing", 1000, 12.0, 0.1, 0.2, 0.0, 0.1, 0.1)
	_c(d, "galactic_fleet_hq", "QG da Frota Galáctica", 12, "military", 1100, 12.0, 0.0, 0.15, 0.8, 0.0, 0.15)
	_c(d, "quantum_archive", "Arquivo Quântico", 12, "civic", 950, 11.0, 0.15, 0.15, 0.0, 0.15, 0.5)
	_c(d, "zero_point_plant", "Usina Ponto Zero", 12, "economic", 1200, 13.0, 0.0, 0.65, 0.0, 0.0, 0.25)
	return d

static func _c(
	d: Dictionary, id: String, nome: String, era: int, cat: String,
	custo: float, manut: float, estab: float, econ: float, defesa: float, cult: float, cienc: float
) -> void:
	var c := Construcao.new()
	c.id = id
	c.nome = nome
	c.era = era
	c.categoria = cat
	c.custo = custo
	c.manutencao = manut
	c.bonus_estabilidade = estab
	c.bonus_economia = econ
	c.bonus_defesa = defesa
	c.bonus_cultura = cult
	c.bonus_ciencia = cienc
	c.caminho_icone = _BASE + _era_dir(era) + "/" + id + ".svg"
	d[id] = c

static func _era_dir(era: int) -> String:
	match era:
		1: return "stone_age"
		2: return "antiquity"
		3: return "classical"
		4: return "medieval"
		5: return "industrial"
		6: return "modern"
		7: return "information"
		8: return "high_tech"
		9: return "space"
		10: return "interplanetary"
		11: return "stellar"
		12: return "intergalactic"
		_: return "stone_age"
