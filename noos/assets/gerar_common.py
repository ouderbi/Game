#!/usr/bin/env python3
"""Módulo comum — paletas, helpers e dados compartilhados."""
import os
import math
import random

OUTPUT = os.path.join(os.path.dirname(os.path.abspath(__file__)))

BIOMAS = {
    "ocean":   {"base": "#1B4B7A", "dark": "#0D3560", "light": "#2A6BA0", "detail": "#3A8BC0"},
    "plains":  {"base": "#6FAE3A", "dark": "#4D8A22", "light": "#8ACE5A", "detail": "#5A9E2A"},
    "forest":  {"base": "#2D6B1F", "dark": "#1A4A12", "light": "#4D8B3A", "detail": "#3D7B2A"},
    "desert":  {"base": "#D4A85A", "dark": "#B8923E", "light": "#E4C87A", "detail": "#C4984A"},
    "mountain":{"base": "#7A7670", "dark": "#5A564F", "light": "#9A9690", "detail": "#6A6660"},
    "tundra":  {"base": "#C8D5DC", "dark": "#A8B5BC", "light": "#E8F5FC", "detail": "#B8C5CC"},
    "savanna": {"base": "#B8B44A", "dark": "#8A8620", "light": "#D8D46A", "detail": "#A8A43A"},
    "swamp":   {"base": "#4A6B3A", "dark": "#2A4A1A", "light": "#6A8B5A", "detail": "#3A5B2A"},
    "coast":   {"base": "#D4C58A", "dark": "#B89A5A", "light": "#E4D5AA", "detail": "#C4B57A"},
}

ERAS = {
    1:  {"name": "stone_age",      "base": "#8B7355", "accent": "#6B8E23", "dark": "#5A4A38", "light": "#AB9375"},
    2:  {"name": "antiquity",      "base": "#D4A76A", "accent": "#C17B3A", "dark": "#8B5A2B", "light": "#E4B78A"},
    3:  {"name": "classical",      "base": "#E8E0D0", "accent": "#D4AF37", "dark": "#8B7355", "light": "#F8F0E0"},
    4:  {"name": "medieval",       "base": "#8B8B7A", "accent": "#8B0000", "dark": "#4A4A3A", "light": "#ABAB9A"},
    5:  {"name": "industrial",     "base": "#8B4513", "accent": "#4A4A4A", "dark": "#2F2F2F", "light": "#AB6533"},
    6:  {"name": "modern",         "base": "#556B2F", "accent": "#708090", "dark": "#2F4F2F", "light": "#758B4F"},
    7:  {"name": "information",    "base": "#4682B4", "accent": "#B0C4DE", "dark": "#2F5F8F", "light": "#66A2D4"},
    8:  {"name": "high_tech",      "base": "#00CEDD", "accent": "#FF6B35", "dark": "#1A1A2E", "light": "#20DEED"},
    9:  {"name": "space",          "base": "#191970", "accent": "#D0D0D0", "dark": "#0D0D4F", "light": "#393990"},
    10: {"name": "interplanetary", "base": "#1A1A2E", "accent": "#FF6B35", "dark": "#0D0D1A", "light": "#3A3A5E"},
    11: {"name": "stellar",        "base": "#2D1B4E", "accent": "#FFD700", "dark": "#1A0D2E", "light": "#4D3B6E"},
    12: {"name": "intergalactic",  "base": "#0D0D0D", "accent": "#FF00FF", "dark": "#000000", "light": "#2D2D2D"},
}

ERA_NAMES_PT = {
    1: "Pedra", 2: "Antiguidade", 3: "Clássica", 4: "Medieval",
    5: "Industrial", 6: "Moderna", 7: "Informação", 8: "Alta Tecnologia",
    9: "Espacial", 10: "Interplanetária", 11: "Estelar", 12: "Intergaláctica",
}

# 10 edifícios por era: (id_snake, nome PT, categoria)
BUILDINGS = {
    1: [("palisade","Paliçada","defense"),("stone_circle","Círculo de Pedras","civic"),
        ("hunting_camp","Acampamento de Caça","economic"),("fire_pit","Fogueira Comunal","cultural"),
        ("shaman_hut","Tenda do Xamã","religious"),("tool_workshop","Oficina de Sílex","infrastructure"),
        ("hut_cluster","Núcleo de Cabanas","housing"),("watch_tower_primitive","Torre de Observação","military"),
        ("burial_mound","Túmulo Megalítico","special"),("gatherers_camp","Acampamento Coletor","economic")],
    2: [("mud_wall","Muralha de Taipa","defense"),("ziggurat","Zigurate","religious"),
        ("granary","Celeiro","economic"),("market_stall","Barquinha de Mercado","economic"),
        ("scribes_school","Escola de Escribas","civic"),("pottery_kiln","Forno de Cerâmica","infrastructure"),
        ("mud_houses","Casas de Taipa","housing"),("chariot_workshop","Oficina de Carruagens","military"),
        ("irrigation_channel","Canal de Irrigação","infrastructure"),("temple_altar","Altar do Templo","civic")],
    3: [("stone_wall","Muralha de Pedra","defense"),("academy","Academia","civic"),
        ("agora","Ágora","economic"),("amphitheater","Anfiteatro","cultural"),
        ("pantheon","Panteão","religious"),("aqueduct","Aqueduto","infrastructure"),
        ("villa","Vila Romana","housing"),("barracks_classical","Quartel Legionário","military"),
        ("harbor_docks","Cais do Porto","economic"),("library","Biblioteca","civic")],
    4: [("castle","Castelo","defense"),("cathedral","Catedral","religious"),
        ("windmill","Moinho de Vento","economic"),("tavern","Taberna","cultural"),
        ("monastery","Mosteiro","religious"),("blacksmith","Ferreiro","infrastructure"),
        ("timber_houses","Casas de Madeira","housing"),("knight_stables","Cavalaria","military"),
        ("watchtower","Torre de Vigia","defense"),("market_square","Praça do Mercado","economic")],
    5: [("bastion_fort","Forte Bastionado","defense"),("town_hall","Câmara Municipal","civic"),
        ("factory","Fábrica","economic"),("opera_house","Casa de Ópera","cultural"),
        ("chapel_industrial","Capela Industrial","religious"),("train_station","Estação Ferroviária","infrastructure"),
        ("tenement_block","Cortço Industrial","housing"),("arsenal","Arsenal","military"),
        ("telegraph_office","Telégrafo","infrastructure"),("bank","Banco","economic")],
    6: [("bunker","Bunker","defense"),("parliament","Parlamento","civic"),
        ("power_plant","Usina","economic"),("cinema","Cinema","cultural"),
        ("cathedral_modern","Catedral Moderna","religious"),("airport","Aeroporto","infrastructure"),
        ("apartment_block","Bloco de Apartamentos","housing"),("military_base","Base Militar","military"),
        ("highway_junction","Trevo Rodoviário","infrastructure"),("stock_exchange","Bolsa de Valores","economic")],
    7: [("sam_site","Bateria de Mísseis","defense"),("data_center","Centro de Dados","civic"),
        ("solar_farm","Fazenda Solar","economic"),("stadium","Estádio","cultural"),
        ("megachurch","Megachurch","religious"),("telecom_tower","Torre de Telecom","infrastructure"),
        ("smart_apartments","Apartamentos Inteligentes","housing"),("drone_base","Base de Drones","military"),
        ("university_modern","Universidade","civic"),("shopping_mall","Shopping Center","economic")],
    8: [("energy_shield","Escudo de Energia","defense"),("ai_lab","Laboratório de IA","civic"),
        ("fusion_plant","Usina de Fusão","economic"),("holo_theater","Teatro Holográfico","cultural"),
        ("meditation_chamber","Câmara de Meditação","religious"),("maglev_station","Estação Maglev","infrastructure"),
        ("arcology","Arcologia","housing"),("power_armor_depot","Depósito de Armaduras","military"),
        ("biotech_lab","Laboratório Biotech","civic"),("replicator_factory","Fábrica de Replicadores","economic")],
    9: [("orbital_defense","Defesa Orbital","defense"),("space_colony","Colônia Espacial","civic"),
        ("rocket_launch","Complexo de Lançamento","economic"),("zero_g_arena","Arena Gravidade Zero","cultural"),
        ("meditation_chamber_space","Templo Orbital","religious"),("space_elevator","Elevador Espacial","infrastructure"),
        ("habitat_dome","Domo Habitacional","housing"),("marine_barracks","Quartel Espacial","military"),
        ("orbital_lab","Laboratório Orbital","civic"),("mining_station","Estação de Mineração","economic")],
    10: [("defense_grid","Grade de Defesa Planetária","defense"),("terraforming","Estação de Terraformação","civic"),
        ("asteroid_mine","Mineração de Asteroides","economic"),("vr_arcade","Arcade VR Planetário","cultural"),
        ("planetary_temple","Templo Planetário","religious"),("orbital_dock","Doca Orbital","infrastructure"),
        ("biodome_city","Cidade Biodomo","housing"),("mech_factory","Fábrica de Mechas","military"),
        ("gene_bank","Banco Genético","civic"),("fusion_refinery","Refinaria de Fusão","economic")],
    11: [("fleet_station","Estação de Defesa da Frota","defense"),("stellar_assembly","Assembleia Estelar","civic"),
        ("trade_hub","Hub de Comércio Interestelar","economic"),("concert_hall_stellar","Salão de Concertos Estelar","cultural"),
        ("stellar_temple","Templo Estelar","religious"),("warp_gate","Portal Dobra","infrastructure"),
        ("orbital_habitat","Habitat Orbital","housing"),("fleet_academy","Academia da Frota","military"),
        ("stellar_archive","Arquivo Estelar","civic"),("antimatter_plant","Usina de Antimatéria","economic")],
    12: [("galactic_defense","Array de Defesa Galáctica","defense"),("galactic_council","Conselho Galáctico","civic"),
        ("wormhole_gen","Gerador de Buraco de Minhoca","economic"),("reality_theater","Teatro da Realidade","cultural"),
        ("cosmic_sanctuary","Santuário Cósmico","religious"),("dimensional_gate","Portal Dimensional","infrastructure"),
        ("dyson_sphere","Esfera de Dyson","housing"),("galactic_fleet_hq","QG da Frota Galáctica","military"),
        ("quantum_archive","Arquivo Quântico","civic"),("zero_point_plant","Usina Ponto Zero","economic")],
}

# 4 unidades por era: (id_snake, nome PT, tipo)
UNITS = {
    1: [("stone_age_warrior","Guerreiro com Clava","land"),("stone_age_slinger","Fundibulário","land"),
        ("stone_age_scout","Batedor","land"),("stone_age_shaman","Xamã de Guerra","special")],
    2: [("antiquity_hoplite","Hoplita","land"),("antiquity_archer","Arqueiro","land"),
        ("antiquity_chariot","Carruagem","land"),("antiquity_siege_tower","Torre de Cerco","special")],
    3: [("classical_legionary","Legionário","land"),("classical_cavalry","Cavalaria Romana","land"),
        ("classical_trireme","Trirreme","naval"),("classical_ballista","Balista","special")],
    4: [("medieval_knight","Cavaleiro","land"),("medieval_archer","Arqueiro Longo","land"),
        ("medieval_galley","Galeão","naval"),("medieval_catapult","Catapulta","special")],
    5: [("industrial_rifleman","Fuzileiro","land"),("industrial_cavalry","Cavalaria Montada","land"),
        ("industrial_ironclad","Couraçado","naval"),("industrial_artillery","Artilharia","special")],
    6: [("modern_infantry","Infantaria Motorizada","land"),("modern_tank","Tanque","land"),
        ("modern_destroyer","Contratorpedeiro","naval"),("modern_fighter","Caça a Jato","air")],
    7: [("information_drone","Drone de Combate","air"),("information_mech","Mecha Tático","land"),
        ("information_cruiser","Cruzador de Misséis","naval"),("information_hacker","Hacker de Guerra","special")],
    8: [("high_tech_power_armor","Armadura de Potência","land"),("high_tech_hover_tank","Tanque Flutuante","land"),
        ("high_tech_stealth_jet","Caça Furtivo","air"),("high_tech_battle_droid","Androide de Combate","special")],
    9: [("space_marine","Fuzileiro Espacial","land"),("space_fighter","Interceptor Espacial","air"),
        ("space_frigate","Fragata Espacial","naval"),("space_saboteur","Sabotador Orbital","special")],
    10: [("interplanetary_mech","Mecha Planetário","land"),("interplanetary_bomber","Bombardeiro Orbital","air"),
        ("interplanetary_cruiser","Cruzador Planetário","naval"),("interplanetary_titan","Colosso de Guerra","special")],
    11: [("stellar_starship","Nave Estelar","air"),("stellar_carrier","Porta-Naves","naval"),
        ("stellar_dreadnought","Couraçado Estelar","naval"),("stellar_ranger","Ranger Estelar","special")],
    12: [("intergalactic_dreadnought","Encouraçado Galáctico","naval"),("intergalactic_titan","Titã Galáctico","land"),
        ("intergalactic_swarm","Enxame de Drones","air"),("intergalactic_walker","Andarilho Dimensional","special")],
}

# 5 líderes por era: (id_snake, nome PT, arquetipo)
LEADERS = {
    1: [("elder_chieftain","Ancião Caique","sabio"),("warlord_primitive","Senhor da Guerra","agressor"),
        ("shaman_seer","Xamã Vidente","mistico"),("hunter_leader","Caçador Líder","pragmatico"),
        ("tribal_matriarch","Matriarca Tribal","diplomata")],
    2: [("pharaoh","Faraó","autocrata"),("senator_patrician","Senador Patrício","republicano"),
        ("warlord_antiquity","General Antigo","agressor"),("high_priest_antiquity","Sumo Sacerdote","mistico"),
        ("merchant_prince","Príncipe Mercador","diplomata")],
    3: [("emperor_classical","Imperador","autocrata"),("philosopher_king","Rei Filósofo","sabio"),
        ("consul","Cônsul","republicano"),("strategos","Estratego","agressor"),
        ("oracle_priest","Oráculo","mistico")],
    4: [("feudal_king","Rei Feudal","autocrata"),("crusader_lord","Senhor Cruzado","agressor"),
        ("pope_medieval","Papa","mistico"),("guild_master","Mestre de Guilda","diplomata"),
        ("steward_sage","Mordomo Sábio","sabio")],
    5: [("industrial_tyrant","Tyran Industrial","autocrata"),("general_industrial","General de Exército","agressor"),
        ("industrialist","Industrialista","pragmatico"),("reformer","Reformador","republicano"),
        ("labor_leader","Líder Trabalhista","diplomata")],
    6: [("president_modern","Presidente","republicano"),("field_marshal","Marechal","agressor"),
        ("tech_visionary","Visionário Tech","sabio"),("media_mogul","Magnata da Mídia","diplomata"),
        ("ideologue","Ideólogo","mistico")],
    7: [("tech_ceo","CEO Tech","pragmatico"),("ai_administrator","Administrador de IA","sabio"),
        ("cyber_warlord","Senhor da Guerra Cibernética","agressor"),("digital_activist","Ativista Digital","republicano"),
        ("data_prophet","Profeta dos Dados","mistico")],
    8: [("augmented_general","General Augmentado","agressor"),("ai_overseer","Supervisor de IA","autocrata"),
        ("bioengineer","Bioengenheiro","sabio"),("corporate_diplomat","Diplomata Corporativo","diplomata"),
        ("transhuman_prophet","Profeta Transumanista","mistico")],
    9: [("fleet_admiral","Almirante da Frota","agressor"),("colony_governor","Governador Colonial","pragmatico"),
        ("space_explorer","Explorador Espacial","sabio"),("orbital_diplomat","Diplomata Orbital","diplomata"),
        ("cosmic_philosopher","Filósofo Cósmico","mistico")],
    10: [("planetary_conqueror","Conquistador Planetário","agressor"),("terraformer_director","Diretor de Terraformação","sabio"),
        ("system_baron","Barão do Sistema","pragmatico"),("interplanetary_envoy","Enviado Interplanetário","diplomata"),
        ("machine_prophet","Profeta das Máquinas","mistico")],
    11: [("stellar_emperor","Imperador Estelar","autocrata"),("fleet_commander","Comandante da Frota","agressor"),
        ("stellar_scientist","Cientista Estelar","sabio"),("galactic_diplomat","Diplomata Galáctico","diplomata"),
        ("void_mystic","Místico do Vazio","mistico")],
    12: [("galactic_sovereign","Soberano Galáctico","autocrata"),("dimensional_warlord","Senhor da Guerra Dimensional","agressor"),
        ("transcendent_sage","Sábio Transcendente","sabio"),("cosmic_negotiator","Negociador Cósmico","diplomata"),
        ("reality_architect","Arquiteto da Realidade","mistico")],
}

# 4 tecnologias por era: (id_snake, nome PT, ramo)
TECHS = {
    1: [("fire_mastery","Domínio do Fogo","base"),("stone_tools","Ferramentas de Pedra","military"),
        ("agriculture_primitive","Agricultura Primitiva","economy"),("ritual_knowledge","Conhecimento Ritual","culture")],
    2: [("writing","Escrita","base"),("bronze_working","Metalurgia do Bronze","military"),
        ("irrigation","Irrigação","economy"),("astronomy_early","Astronomia Antiga","culture")],
    3: [("mathematics","Matemática","base"),("siege_engineering","Engenharia de Cerco","military"),
        ("road_building","Construção de Estradas","economy"),("philosophy","Filosofia","culture")],
    4: [("feudalism","Feudalismo","base"),("steel_smelting","Fundição de Aço","military"),
        ("crop_rotation","Rotação de Culturas","economy"),("scholasticism","Escolástica","culture")],
    5: [("steam_engine","Motor a Vapor","base"),("rifled_barrel","Cano Raiado","military"),
        ("mass_production","Produção em Massa","economy"),("sociology","Sociologia","culture")],
    6: [("nuclear_physics","Física Nuclear","base"),("jet_propulsion","Propulsão a Jato","military"),
        ("automation","Automação","economy"),("mass_media","Mídia de Massa","culture")],
    7: [("quantum_computing","Computação Quântica","base"),("cyber_warfare","Guerra Cibernética","military"),
        ("renewable_energy","Energia Renovável","economy"),("social_networks","Redes Sociais","culture")],
    8: [("fusion_power","Energia de Fusão","base"),("plasma_weapons","Armas de Plasma","military"),
        ("nanotechnology","Nanotecnologia","economy"),("neural_interface","Interface Neural","culture")],
    9: [("orbital_mechanics","Mecânica Orbital","base"),("space_combat","Combate Espacial","military"),
        ("zero_g_manufacturing","Manufatura Gravidade Zero","economy"),("xenobiology","Xenobiologia","culture")],
    10: [("warp_theory","Teoria da Dobra","base"),("planetary_shields","Escudos Planetários","military"),
        ("asteroid_mining_tech","Mineração de Asteroides","economy"),("terraforming_science","Ciência da Terraformação","culture")],
    11: [("antimatter_reactor","Reator de Antimatéria","base"),("stellar_weapons","Armas Estelares","military"),
        ("interstellar_trade","Comércio Interestelar","economy"),("galactic_law","Lei Galáctica","culture")],
    12: [("dimensional_physics","Física Dimensional","base"),("reality_warping","Distorção da Realidade","military"),
        ("zero_point_energy","Energia Ponto Zero","economy"),("transcendence","Transcendência","culture")],
}

# 4 governos por era: (id_snake, nome PT)
GOVS = {
    1: [("tribal_council","Conselho Tribal"),("chieftain_rule","Governo do Cacique"),
        ("elder_oligarchy","Oligarquia dos Anciãos"),("shaman_theocracy","Teocracia Xamânica")],
    2: [("pharaonic_kingdom","Reino Faraônico"),("city_state","Cidade-Estado"),
        ("military_junta_antiquity","Junta Militar"),("temple_state","Estado Templo")],
    3: [("roman_republic","República Romana"),("imperial_autocracy","Autocracia Imperial"),
        ("greek_democracy","Democracia Grega"),("military_dictatorship","Ditadura Militar")],
    4: [("feudal_monarchy","Monarquia Feudal"),("theocratic_state","Estado Teocrático"),
        ("merchant_republic","República Mercante"),("military_order","Ordem Militar")],
    5: [("constitutional_monarchy","Monarquia Constitucional"),("industrial_oligarchy","Oligarquia Industrial"),
        ("parliamentary_democracy","Democracia Parlamentar"),("military_dictatorship_ind","Ditadura Militar")],
    6: [("presidential_republic","República Presidencial"),("single_party_state","Estado de Partido Único"),
        ("military_junta_modern","Junta Militar"),("technocratic_council","Conselho Tecnocrático")],
    7: [("digital_democracy","Democracia Digital"),("corporate_state","Estado Corporativo"),
        ("ai_assisted_gov","Governo Assistido por IA"),("surveillance_state","Estado de Vigilância")],
    8: [("augmented_democracy","Democracia Augmentada"),("ai_directorate","Diretoria de IA"),
        ("corporate_hegemony","Hegemonia Corporativa"),("transhuman_collective","Coletivo Transumanista")],
    9: [("space_colony_council","Conselho Colonial"),("fleet_admiralty","Almirantado da Frota"),
        ("orbital_democracy","Democracia Orbital"),("corporate_space_state","Estado Corporativo Espacial")],
    10: [("planetary_federation","Federação Planetária"),("system_hegemony","Hegemonia do Sistema"),
        ("interplanetary_republic","República Interplanetária"),("military_high_command","Alto Comando Militar")],
    11: [("stellar_empire","Império Estelar"),("galactic_republic","República Galáctica"),
        ("fleet_command","Comando da Frota"),("stellar_theocracy","Teocracia Estelar")],
    12: [("galactic_federation","Federação Galáctica"),("dimensional_empire","Império Dimensional"),
        ("cosmic_consciousness","Consciência Cósmica"),("transcendent_council","Conselho Transcendente")],
}

# 2 recursos por era: (id_snake, nome PT)
RESOURCES = {
    1: [("flint","Sílex"),("hides","Couros")],
    2: [("bronze","Bronze"),("papyrus","Papiro")],
    3: [("iron","Ferro"),("marble","Mármore")],
    4: [("steel","Aço"),("timber","Madeira Nobre")],
    5: [("coal","Carvão"),("steel_industrial","Aço Industrial")],
    6: [("uranium","Urânio"),("oil","Petróleo")],
    7: [("silicon","Silício"),("rare_earths","Terras Raras")],
    8: [("plasma_crystals","Cristais de Plasma"),("quantum_chips","Chips Quânticos")],
    9: [("lunar_helium3","Hélio-3 Lunar"),("orbital_alloys","Ligas Orbitais")],
    10: [("antimatter","Antimatéria"),("exotic_matter","Matéria Exótica")],
    11: [("stellar_fuel","Combustível Estelar"),("dark_matter","Matéria Escura")],
    12: [("void_crystals","Cristais do Vazio"),("reality_fragments","Fragmentos de Realidade")],
}

# 2 bandeiras por era: (id_snake, nome PT)
FLAGS = {
    1: [("tribal_banner","Estandarte Tribal"),("clan_totem","Totem do Clã")],
    2: [("kingdom_banner","Bandeira do Reino"),("city_standard","Padrão da Cidade")],
    3: [("legion_standard","Padrão da Legião"),("senate_flag","Bandeira do Senado")],
    4: [("royal_banner","Estandarte Real"),("crusade_flag","Bandeira Cruzada")],
    5: [("national_flag","Bandeira Nacional"),("industrial_pennant","Flâmula Industrial")],
    6: [("republic_flag","Bandeira Republicana"),("military_ensign","Insígnia Militar")],
    7: [("digital_flag","Bandeira Digital"),("corporate_logo","Logotipo Corporativo")],
    8: [("augmented_banner","Estandarte Augmentado"),("fusion_pennant","Flâmula de Fusão")],
    9: [("orbital_ensign","Insígnia Orbital"),("colony_flag","Bandeira Colonial")],
    10: [("planetary_flag","Bandeira Planetária"),("system_banner","Estandarte do Sistema")],
    11: [("stellar_ensign","Insígnia Estelar"),("galactic_banner","Estandarte Galáctico")],
    12: [("cosmic_flag","Bandeira Cósmica"),("dimensional_pennant","Flâmula Dimensional")],
}

# Elementos de UI extras (26 total)
UI_ELEMENTS = [
    "panel_dark", "panel_light", "button_normal", "button_hover", "button_pressed",
    "icon_treasury", "icon_stability", "icon_legitimacy", "icon_population", "icon_era",
    "leader_frame", "minimap_frame",
    # 14 novos:
    "panel_thin", "panel_wide", "button_small", "button_large", "button_icon",
    "icon_food", "icon_military", "icon_science", "icon_culture", "icon_corruption",
    "icon_diplomacy", "icon_happiness", "cursor_default", "cursor_pointer",
]

# Efeitos (30 total)
EFFECTS = [
    "fire", "nuclear_explosion", "fallout", "plague", "riot", "famine",
    "revolution", "coup", "earthquake", "volcano", "tech_advance", "religious_schism",
    # 18 novos:
    "boom_economy", "depression", "gold_rush", "cultural_renaissance", "golden_age",
    "dark_age", "civil_war", "independence", "trade_boom", "embargo",
    "flood", "meteor_impact", "alien_contact", "ai_awakening", "space_race",
    "pandemic_modern", "cyber_attack", "dimensional_rift",
]

def ensure_dir(path):
    os.makedirs(path, exist_ok=True)

def save_svg(path, content):
    ensure_dir(os.path.dirname(path))
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def svg_wrap(w, h, body, extra_defs=""):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">
<defs>
  <linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
    <stop offset="0" stop-color="#fff" stop-opacity="0.15"/>
    <stop offset="1" stop-color="#000" stop-opacity="0.15"/>
  </linearGradient>
  {extra_defs}
</defs>
{body}
</svg>'''

def iso_polygon(cx, cy, w, h):
    hw = w / 2
    hh = h / 2
    return f"{cx},{cy-hh} {cx+hw},{cy} {cx},{cy+hh} {cx-hw},{cy}"

def shade(color, factor):
    """Escurece ou clareia uma cor hex por um fator (0-1 = escurecer, 1-2 = clarear)."""
    r = int(color[1:3], 16)
    g = int(color[3:5], 16)
    b = int(color[5:7], 16)
    if factor <= 1:
        r = int(r * factor)
        g = int(g * factor)
        b = int(b * factor)
    else:
        f = factor - 1
        r = min(255, int(r + (255 - r) * f))
        g = min(255, int(g + (255 - g) * f))
        b = min(255, int(b + (255 - b) * f))
    return f"#{r:02X}{g:02X}{b:02X}"
