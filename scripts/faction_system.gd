extends Node
class_name FactionSystem

# Internal factions that compete for power within a polity
# Military, Clergy, Oligarchs, Masses, Bureaucracy, Corporations, etc.

signal faction_loyalty_changed(faction_id: String, new_loyalty: float)
signal faction_coup_risk_increased(faction_id: String, risk_level: float)

var factions: Dictionary = {
	"military": {
		"name": "Military",
		"agenda": "power, war, defense spending",
		"power": 0.3,
		"loyalty": 0.7,
		"satisfaction": 0.5
	},
	"clergy": {
		"name": "Clergy",
		"agenda": "influence, orthodoxy, religious authority",
		"power": 0.2,
		"loyalty": 0.7,
		"satisfaction": 0.5
	},
	"oligarchs": {
		"name": "Economic Elite",
		"agenda": "wealth, low taxation, deregulation",
		"power": 0.25,
		"loyalty": 0.6,
		"satisfaction": 0.5
	},
	"masses": {
		"name": "Common People",
		"agenda": "welfare, bread, security, freedom",
		"power": 0.15,
		"loyalty": 0.6,
		"satisfaction": 0.4
	},
	"bureaucracy": {
		"name": "Bureaucracy",
		"agenda": "stability, order, self-preservation",
		"power": 0.2,
		"loyalty": 0.8,
		"satisfaction": 0.5
	},
	"corporations": {
		"name": "Corporations",
		"agenda": "profit, market access, light regulation",
		"power": 0.0,  # Unlocks in Information Era
		"loyalty": 0.5,
		"satisfaction": 0.5
	},
	"nobility": {
		"name": "Nobility",
		"agenda": "privilege, tradition, hereditary power",
		"power": 0.0,  # Unlocks in Medieval era
		"loyalty": 0.7,
		"satisfaction": 0.5
	},
	"technocracy": {
		"name": "Technocrats / Scientists",
		"agenda": "optimization, research, data control",
		"power": 0.0,  # Unlocks in Information Era
		"loyalty": 0.6,
		"satisfaction": 0.5
	}
}

# How government types affect faction satisfaction
var government_faction_bonuses: Dictionary = {
	"monarchy": {
		"military": 0.15,
		"nobility": 0.3,
		"clergy": 0.1,
		"oligarchs": 0.05,
		"masses": -0.1
	},
	"democracy": {
		"masses": 0.3,
		"bureaucracy": 0.1,
		"oligarchs": -0.1,
		"military": -0.1
	},
	"fascism": {
		"military": 0.4,
		"oligarchs": 0.2,
		"bureaucracy": 0.15,
		"masses": -0.3,
		"clergy": -0.2
	},
	"communism": {
		"masses": 0.3,
		"bureaucracy": 0.3,
		"military": 0.1,
		"oligarchs": -0.4,
		"nobility": -0.5
	},
	"theocracy": {
		"clergy": 0.4,
		"masses": 0.1,
		"bureaucracy": 0.05,
		"military": -0.1,
		"oligarchs": 0.05
	},
	"technocracy": {
		"technocracy": 0.5,
		"bureaucracy": 0.2,
		"masses": 0.1,
		"military": -0.1,
		"clergy": -0.2
	}
}

# Decision impacts on faction satisfaction
var decision_impacts: Dictionary = {
	"high_taxes": {
		"oligarchs": -0.2,
		"masses": -0.15,
		"bureaucracy": 0.1
	},
	"low_taxes": {
		"oligarchs": 0.2,
		"bureaucracy": -0.1,
		"masses": -0.1
	},
	"military_spending": {
		"military": 0.2,
		"oligarchs": -0.1,
		"masses": -0.15
	},
	"welfare_spending": {
		"masses": 0.2,
		"oligarchs": -0.15,
		"military": -0.1
	},
	"religious_freedom": {
		"clergy": -0.2,
		"masses": 0.2,
		"oligarchs": 0.05
	},
	"religious_oppression": {
		"clergy": 0.1,
		"masses": -0.2,
		"bureaucracy": 0.1
	},
	"free_market": {
		"oligarchs": 0.25,
		"corporations": 0.2,
		"masses": -0.1
	},
	"state_control": {
		"bureaucracy": 0.2,
		"masses": 0.1,
		"oligarchs": -0.3
	},
	"technology_investment": {
		"technocracy": 0.25,
		"oligarchs": 0.1,
		"masses": -0.05
	},
	"war_declaration": {
		"military": 0.3,
		"nationalism": 0.15,  # temporary population boost
		"masses": -0.2
	},
	"peace_treaty": {
		"masses": 0.1,
		"oligarchs": 0.15,
		"military": -0.2,
		"clergy": 0.1
	}
}

func update_faction_satisfaction(decision: String, government_type: String):
	"""Update faction satisfaction based on a player/leader decision"""
	if decision in decision_impacts:
		for faction_id in decision_impacts[decision]:
			var impact = decision_impacts[decision][faction_id]
			if faction_id in factions:
				factions[faction_id]["satisfaction"] = clamp(
					factions[faction_id]["satisfaction"] + impact, 0.0, 1.0
				)
				recalculate_loyalty(faction_id, government_type)

func recalculate_loyalty(faction_id: String, government_type: String):
	"""Recalculate faction loyalty based on satisfaction and government"""
	if faction_id not in factions:
		return
	
	var faction = factions[faction_id]
	var base_loyalty = faction["satisfaction"]
	
	# Government affects baseline loyalty
	if government_type in government_faction_bonuses and faction_id in government_faction_bonuses[government_type]:
		base_loyalty += government_faction_bonuses[government_type][faction_id]
	
	faction["loyalty"] = clamp(base_loyalty, 0.0, 1.0)
	faction_loyalty_changed.emit(faction_id, faction["loyalty"])
	
	# Check for coup risk
	var coup_risk = calculate_coup_risk(faction_id)
	if coup_risk > 0.5:
		faction_coup_risk_increased.emit(faction_id, coup_risk)

func calculate_coup_risk(faction_id: String) -> float:
	"""Risk of a coup = low loyalty + high power"""
	if faction_id not in factions:
		return 0.0
	
	var faction = factions[faction_id]
	# Coup risk formula: (1 - loyalty) * power * 2
	return (1.0 - faction["loyalty"]) * faction["power"] * 2.0

func get_coup_risk_summary() -> Dictionary:
	"""Return all factions with high coup risk"""
	var summary = {}
	for faction_id in factions:
		var risk = calculate_coup_risk(faction_id)
		if risk > 0.3:
			summary[faction_id] = {
				"faction_name": factions[faction_id]["name"],
				"risk": risk,
				"loyalty": factions[faction_id]["loyalty"],
				"power": factions[faction_id]["power"]
			}
	return summary

func trigger_potential_coup(world_state: Dictionary) -> bool:
	"""Check if any faction should attempt a coup"""
	var highest_risk_faction = ""
	var highest_risk = 0.0
	
	for faction_id in factions:
		var risk = calculate_coup_risk(faction_id)
		if risk > highest_risk:
			highest_risk = risk
			highest_risk_faction = faction_id
	
	# Coup threshold: 70% risk + some randomness
	if highest_risk > 0.7 and randf() < highest_risk:
		return attempt_coup(highest_risk_faction, world_state)
	
	return false

func attempt_coup(faction_id: String, world_state: Dictionary) -> bool:
	"""Execute a coup by the specified faction"""
	if faction_id not in factions:
		return false
	
	var faction = factions[faction_id]
	var success_chance = faction["power"] * faction["loyalty"]  # Low loyalty helps
	
	if randf() < success_chance:
		print("COUP SUCCESSFUL: ", faction["name"], " has taken control!")
		return true
	else:
		print("COUP FAILED: ", faction["name"], " attempt thwarted")
		# Failed coup increases government legitimacy temporarily
		factions[faction_id]["power"] *= 0.7  # Faction weakened
		return false

func get_faction_status() -> Dictionary:
	"""Return status of all factions"""
	var status = {}
	for faction_id in factions:
		var faction = factions[faction_id]
		status[faction_id] = {
			"name": faction["name"],
			"power": faction["power"],
			"loyalty": faction["loyalty"],
			"satisfaction": faction["satisfaction"],
			"coup_risk": calculate_coup_risk(faction_id)
		}
	return status

func unlock_faction_for_era(faction_id: String, era_id: String):
	"""Unlock a faction when entering an era"""
	var era_unlocks = {
		"medieval": ["nobility"],
		"information": ["corporations", "technocracy"],
		"space": ["technocracy"]
	}
	
	if era_id in era_unlocks and faction_id in era_unlocks[era_id]:
		if faction_id in factions:
			factions[faction_id]["power"] = 0.15
			factions[faction_id]["loyalty"] = 0.5
			print("Faction unlocked: ", factions[faction_id]["name"])
