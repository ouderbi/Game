extends Node
class_name GovernmentSystem

# Government types and their political mechanics
# Each government has: power concentration, legitimacy source, succession rules, tech viases

signal government_type_changed(new_government: String)
signal legitimacy_changed(new_legitimacy: float)

var government_types: Dictionary = {
	"tribal": {
		"name": "Tribal",
		"era": "stone_age",
		"power_concentration": 0.2,
		"decision_speed": 0.6,
		"legitimacy_source": "tradition",
		"succession_rule": "none",
		"corruption_tendency": 0.1,
		"militarism": 0.4,
		"economic_model": "communal",
		"civil_liberties": 0.8,
		"stability_baseline": 0.7,
		"leader_archetype": "chieftain",
		"research_modifier": 0.1,
		"military_modifier": 0.1
	},
	"monarchy": {
		"name": "Monarchy",
		"era": "medieval",
		"power_concentration": 0.9,
		"decision_speed": 0.9,
		"legitimacy_source": "tradition",
		"succession_rule": "hereditary",
		"corruption_tendency": 0.4,
		"militarism": 0.8,
		"economic_model": "feudal",
		"civil_liberties": 0.1,
		"stability_baseline": 0.6,
		"leader_archetype": "king",
		"research_modifier": 0.3,
		"military_modifier": 1.0
	},
	"democracy": {
		"name": "Democracy",
		"era": "enlightenment",
		"power_concentration": 0.1,
		"decision_speed": 0.4,
		"legitimacy_source": "vote",
		"succession_rule": "election",
		"corruption_tendency": 0.2,
		"militarism": 0.3,
		"economic_model": "market",
		"civil_liberties": 0.9,
		"stability_baseline": 0.7,
		"leader_archetype": "president",
		"research_modifier": 1.5,
		"military_modifier": 0.9
	},
	"fascism": {
		"name": "Fascism",
		"era": "modern",
		"power_concentration": 1.0,
		"decision_speed": 1.0,
		"legitimacy_source": "force",
		"succession_rule": "golpe",
		"corruption_tendency": 0.3,
		"militarism": 2.0,
		"economic_model": "comando",
		"civil_liberties": 0.0,
		"stability_baseline": 0.4,
		"leader_archetype": "dictator",
		"research_modifier": 0.4,
		"military_modifier": 2.0
	},
	"communism": {
		"name": "Communism",
		"era": "industrial",
		"power_concentration": 0.8,
		"decision_speed": 0.6,
		"legitimacy_source": "ideology",
		"succession_rule": "party_selection",
		"corruption_tendency": 0.3,
		"militarism": 1.2,
		"economic_model": "estado",
		"civil_liberties": 0.1,
		"stability_baseline": 0.5,
		"leader_archetype": "general_secretary",
		"research_modifier": 0.7,
		"military_modifier": 1.5
	},
	"theocracy": {
		"name": "Theocracy",
		"era": "medieval",
		"power_concentration": 0.85,
		"decision_speed": 0.7,
		"legitimacy_source": "divine",
		"succession_rule": "appointment",
		"corruption_tendency": 0.35,
		"militarism": 0.6,
		"economic_model": "ecclesiastical",
		"civil_liberties": 0.05,
		"stability_baseline": 0.65,
		"leader_archetype": "pope",
		"research_modifier": 0.3,
		"military_modifier": 0.8
	},
	"republic": {
		"name": "Republic",
		"era": "iron_age",
		"power_concentration": 0.3,
		"decision_speed": 0.5,
		"legitimacy_source": "legal",
		"succession_rule": "election",
		"corruption_tendency": 0.4,
		"militarism": 0.5,
		"economic_model": "market",
		"civil_liberties": 0.6,
		"stability_baseline": 0.6,
		"leader_archetype": "senator",
		"research_modifier": 0.8,
		"military_modifier": 0.7
	},
	"technocracy": {
		"name": "Technocracy",
		"era": "information",
		"power_concentration": 0.5,
		"decision_speed": 0.8,
		"legitimacy_source": "expertise",
		"succession_rule": "selection",
		"corruption_tendency": 0.15,
		"militarism": 0.4,
		"economic_model": "optimized",
		"civil_liberties": 0.3,
		"stability_baseline": 0.7,
		"leader_archetype": "chief_scientist",
		"research_modifier": 3.0,
		"military_modifier": 1.2
	},
	"corporatocracy": {
		"name": "Corporatocracy",
		"era": "information",
		"power_concentration": 0.9,
		"decision_speed": 0.95,
		"legitimacy_source": "wealth",
		"succession_rule": "appointment",
		"corruption_tendency": 0.8,
		"militarism": 0.7,
		"economic_model": "capitalist",
		"civil_liberties": 0.2,
		"stability_baseline": 0.5,
		"leader_archetype": "ceo",
		"research_modifier": 1.8,
		"military_modifier": 0.9
	}
}

var current_government: String = "tribal"
var legitimacy: float = 0.7
var stability: float = 0.7
var corruption_level: float = 0.0
var population_happiness: float = 0.5

func _ready():
	pass

func get_government_data(government_type: String = current_government) -> Dictionary:
	if government_type in government_types:
		return government_types[government_type]
	return government_types["tribal"]

func change_government(new_government: String) -> bool:
	if new_government in government_types:
		current_government = new_government
		stability = get_government_data()["stability_baseline"]
		legitimacy = 0.5  # New government starts with uncertain legitimacy
		government_type_changed.emit(new_government)
		print("Government changed to: ", get_government_data()["name"])
		return true
	return false

func update_legitimacy(delta_change: float):
	"""Update legitimacy based on actions and events"""
	legitimacy = clamp(legitimacy + delta_change, 0.0, 1.0)
	legitimacy_changed.emit(legitimacy)

func apply_corruption_to_economy(production: float) -> float:
	"""Apply corruption to reduce effective production"""
	var gov_corruption = get_government_data().get("corruption_tendency", 0.0)
	corruption_level = clamp(corruption_level + gov_corruption * 0.01, 0.0, 1.0)
	var effective_corruption = corruption_level * gov_corruption
	return production * (1.0 - effective_corruption)

func get_research_modifier() -> float:
	"""Different governments research at different speeds"""
	return get_government_data().get("research_modifier", 1.0)

func get_military_modifier() -> float:
	"""Military strength varies by government type"""
	return get_government_data().get("military_modifier", 1.0)

func get_decision_speed() -> float:
	"""How fast the government can make decisions"""
	return get_government_data().get("decision_speed", 0.5)

func get_power_concentration() -> float:
	"""0 = distributed power, 1 = absolute power"""
	return get_government_data().get("power_concentration", 0.5)

func get_civil_liberties() -> float:
	"""0 = oppressive, 1 = free"""
	return get_government_data().get("civil_liberties", 0.5)

func get_government_name() -> String:
	return get_government_data().get("name", "Unknown")

func check_government_stability(faction_system: FactionSystem) -> float:
	"""Check if government will remain stable"""
	var gov_stability = get_government_data()["stability_baseline"]
	var coup_risks = faction_system.get_coup_risk_summary()
	
	# Each faction coup risk reduces stability
	var total_coup_risk = 0.0
	for faction_id in coup_risks:
		total_coup_risk += coup_risks[faction_id]["risk"]
	
	var effective_stability = gov_stability - (total_coup_risk * 0.2)
	return clamp(effective_stability, 0.0, 1.0)

func can_change_to_era_government(government_type: String, current_era: String) -> bool:
	"""Check if a government is available in the current era"""
	if government_type not in government_types:
		return false
	
	var gov_data = government_types[government_type]
	var gov_era = gov_data.get("era", "stone_age")
	
	var era_order = ["stone_age", "bronze_age", "iron_age", "medieval", "renaissance", 
					"enlightenment", "industrial", "modern", "atomic", "information", "space", "intergalactic"]
	
	var gov_era_index = era_order.find(gov_era)
	var current_era_index = era_order.find(current_era)
	
	return current_era_index >= gov_era_index

func get_available_governments_for_era(era: String) -> Array:
	"""Return list of governments available in current era"""
	var available = []
	for gov_id in government_types:
		if can_change_to_era_government(gov_id, era):
			available.append({
				"id": gov_id,
				"name": government_types[gov_id]["name"]
			})
	return available

func get_government_summary() -> Dictionary:
	return {
		"type": current_government,
		"name": get_government_name(),
		"legitimacy": legitimacy,
		"stability": stability,
		"corruption": corruption_level,
		"happiness": population_happiness,
		"power_concentration": get_power_concentration(),
		"civil_liberties": get_civil_liberties(),
		"research_speed": get_research_modifier(),
		"military_strength": get_military_modifier()
	}
