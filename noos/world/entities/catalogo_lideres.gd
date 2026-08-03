## Catálogo de líderes — 60 entradas (5 por era × 12 eras).
## Cada líder tem traços de personalidade (0-1) que a Utility AI usa
## para pontuar ações (PDF 25 §2). O caminho do retrato SVG segue
## res://assets/leaders/<id>.svg
extends RefCounted

static func catalogo() -> Dictionary:
	var d: Dictionary = {}
	# Era 1 — Pedra
	_l(d, "elder_chieftain", "Ancião Caique", 1, "sabio", 0.2, 0.3, 0.4, 0.7, 0.2)
	_l(d, "warlord_primitive", "Senhor da Guerra", 1, "agressor", 0.9, 0.5, 0.8, 0.3, 0.4)
	_l(d, "shaman_seer", "Xamã Vidente", 1, "mistico", 0.3, 0.8, 0.5, 0.5, 0.1)
	_l(d, "hunter_leader", "Caçador Líder", 1, "pragmatico", 0.6, 0.2, 0.6, 0.6, 0.2)
	_l(d, "tribal_matriarch", "Matriarca Tribal", 1, "diplomata", 0.2, 0.3, 0.5, 0.7, 0.1)
	# Era 2 — Antiguidade
	_l(d, "pharaoh", "Faraó", 2, "autocrata", 0.7, 0.6, 0.8, 0.5, 0.5)
	_l(d, "senator_patrician", "Senador Patrício", 2, "republicano", 0.4, 0.3, 0.5, 0.7, 0.2)
	_l(d, "warlord_antiquity", "General Antigo", 2, "agressor", 0.85, 0.4, 0.7, 0.6, 0.5)
	_l(d, "high_priest_antiquity", "Sumo Sacerdote", 2, "mistico", 0.3, 0.7, 0.6, 0.4, 0.1)
	_l(d, "merchant_prince", "Príncipe Mercador", 2, "diplomata", 0.3, 0.2, 0.8, 0.6, 0.2)
	# Era 3 — Clássica
	_l(d, "emperor_classical", "Imperador", 3, "autocrata", 0.8, 0.5, 0.9, 0.6, 0.4)
	_l(d, "philosopher_king", "Rei Filósofo", 3, "sabio", 0.2, 0.3, 0.5, 0.9, 0.1)
	_l(d, "consul", "Cônsul", 3, "republicano", 0.4, 0.2, 0.6, 0.7, 0.2)
	_l(d, "strategos", "Estratego", 3, "agressor", 0.8, 0.4, 0.7, 0.8, 0.3)
	_l(d, "oracle_priest", "Oráculo", 3, "mistico", 0.2, 0.8, 0.4, 0.5, 0.1)
	# Era 4 — Medieval
	_l(d, "feudal_king", "Rei Feudal", 4, "autocrata", 0.7, 0.5, 0.8, 0.5, 0.4)
	_l(d, "crusader_lord", "Senhor Cruzado", 4, "agressor", 0.9, 0.4, 0.6, 0.4, 0.6)
	_l(d, "pope_medieval", "Papa", 4, "mistico", 0.2, 0.6, 0.7, 0.5, 0.1)
	_l(d, "guild_master", "Mestre de Guilda", 4, "diplomata", 0.3, 0.2, 0.7, 0.6, 0.2)
	_l(d, "steward_sage", "Mordomo Sábio", 4, "sabio", 0.2, 0.3, 0.4, 0.8, 0.1)
	# Era 5 — Industrial
	_l(d, "industrial_tyrant", "Tyrano Industrial", 5, "autocrata", 0.8, 0.6, 0.8, 0.5, 0.5)
	_l(d, "general_industrial", "General de Exército", 5, "agressor", 0.85, 0.4, 0.6, 0.7, 0.4)
	_l(d, "industrialist", "Industrialista", 5, "pragmatico", 0.5, 0.2, 0.8, 0.6, 0.2)
	_l(d, "reformer", "Reformador", 5, "republicano", 0.3, 0.3, 0.5, 0.7, 0.2)
	_l(d, "labor_leader", "Líder Trabalhista", 5, "diplomata", 0.2, 0.3, 0.6, 0.7, 0.1)
	# Era 6 — Moderna
	_l(d, "president_modern", "Presidente", 6, "republicano", 0.3, 0.2, 0.6, 0.7, 0.2)
	_l(d, "field_marshal", "Marechal", 6, "agressor", 0.9, 0.5, 0.7, 0.8, 0.4)
	_l(d, "tech_visionary", "Visionário Tech", 6, "sabio", 0.2, 0.3, 0.7, 0.9, 0.1)
	_l(d, "media_mogul", "Magnata da Mídia", 6, "diplomata", 0.3, 0.2, 0.7, 0.6, 0.2)
	_l(d, "ideologue", "Ideólogo", 6, "mistico", 0.4, 0.7, 0.6, 0.4, 0.2)
	# Era 7 — Informação
	_l(d, "tech_ceo", "CEO Tech", 7, "pragmatico", 0.4, 0.2, 0.8, 0.7, 0.2)
	_l(d, "ai_administrator", "Administrador de IA", 7, "sabio", 0.2, 0.3, 0.6, 0.9, 0.1)
	_l(d, "cyber_warlord", "Senhor da Guerra Cibernética", 7, "agressor", 0.9, 0.6, 0.7, 0.5, 0.5)
	_l(d, "digital_activist", "Ativista Digital", 7, "republicano", 0.2, 0.3, 0.5, 0.7, 0.1)
	_l(d, "data_prophet", "Profeta dos Dados", 7, "mistico", 0.3, 0.8, 0.5, 0.4, 0.1)
	# Era 8 — Alta Tecnologia
	_l(d, "augmented_general", "General Augmentado", 8, "agressor", 0.9, 0.5, 0.7, 0.8, 0.4)
	_l(d, "ai_overseer", "Supervisor de IA", 8, "autocrata", 0.7, 0.6, 0.8, 0.7, 0.3)
	_l(d, "bioengineer", "Bioengenheiro", 8, "sabio", 0.2, 0.3, 0.6, 0.9, 0.1)
	_l(d, "corporate_diplomat", "Diplomata Corporativo", 8, "diplomata", 0.3, 0.2, 0.7, 0.7, 0.2)
	_l(d, "transhuman_prophet", "Profeta Transumanista", 8, "mistico", 0.3, 0.7, 0.6, 0.5, 0.1)
	# Era 9 — Espacial
	_l(d, "fleet_admiral", "Almirante da Frota", 9, "agressor", 0.9, 0.4, 0.7, 0.8, 0.3)
	_l(d, "colony_governor", "Governador Colonial", 9, "pragmatico", 0.5, 0.2, 0.7, 0.7, 0.2)
	_l(d, "space_explorer", "Explorador Espacial", 9, "sabio", 0.2, 0.3, 0.6, 0.9, 0.1)
	_l(d, "orbital_diplomat", "Diplomata Orbital", 9, "diplomata", 0.2, 0.2, 0.7, 0.7, 0.1)
	_l(d, "cosmic_philosopher", "Filósofo Cósmico", 9, "mistico", 0.2, 0.7, 0.4, 0.5, 0.1)
	# Era 10 — Interplanetária
	_l(d, "planetary_conqueror", "Conquistador Planetário", 10, "agressor", 0.95, 0.5, 0.8, 0.7, 0.5)
	_l(d, "terraformer_director", "Diretor de Terraformação", 10, "sabio", 0.2, 0.3, 0.7, 0.9, 0.1)
	_l(d, "system_baron", "Barão do Sistema", 10, "pragmatico", 0.5, 0.2, 0.8, 0.6, 0.2)
	_l(d, "interplanetary_envoy", "Enviado Interplanetário", 10, "diplomata", 0.2, 0.2, 0.7, 0.8, 0.1)
	_l(d, "machine_prophet", "Profeta das Máquinas", 10, "mistico", 0.3, 0.8, 0.6, 0.5, 0.1)
	# Era 11 — Estelar
	_l(d, "stellar_emperor", "Imperador Estelar", 11, "autocrata", 0.8, 0.6, 0.9, 0.7, 0.4)
	_l(d, "fleet_commander", "Comandante da Frota", 11, "agressor", 0.95, 0.4, 0.7, 0.9, 0.3)
	_l(d, "stellar_scientist", "Cientista Estelar", 11, "sabio", 0.2, 0.3, 0.6, 0.95, 0.1)
	_l(d, "galactic_diplomat", "Diplomata Galáctico", 11, "diplomata", 0.2, 0.2, 0.8, 0.8, 0.1)
	_l(d, "void_mystic", "Místico do Vazio", 11, "mistico", 0.3, 0.8, 0.5, 0.5, 0.1)
	# Era 12 — Intergaláctica
	_l(d, "galactic_sovereign", "Soberano Galáctico", 12, "autocrata", 0.85, 0.6, 0.95, 0.8, 0.4)
	_l(d, "dimensional_warlord", "Senhor da Guerra Dimensional", 12, "agressor", 0.95, 0.5, 0.8, 0.9, 0.5)
	_l(d, "transcendent_sage", "Sábio Transcendente", 12, "sabio", 0.1, 0.2, 0.5, 0.95, 0.1)
	_l(d, "cosmic_negotiator", "Negociador Cósmico", 12, "diplomata", 0.1, 0.1, 0.8, 0.9, 0.1)
	_l(d, "reality_architect", "Arquiteto da Realidade", 12, "mistico", 0.2, 0.8, 0.6, 0.6, 0.1)
	return d

static func _l(
	d: Dictionary, id: String, nome: String, era: int, arq: String,
	aggr: float, par: float, amb: float, comp: float, corr: float
) -> void:
	var l := Lider.new()
	l.id = hash(id) % 100000
	l.nome = nome
	l.arquetipo = arq
	l.agressao = aggr
	l.paranoia = par
	l.ambicao = amb
	l.competencia = comp
	l.corruptibilidade = corr
	d[id] = l
