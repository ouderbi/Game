extends Node
class_name UnitSystem

# Military unit system with era-specific units
# Hunters → Warriors → Knights → Soldiers → Tanks → Drones

signal unit_created(unit_id: String)
signal unit_destroyed(unit_id: String)
signal unit_died(unit_id: String)

var unit_definitions: Dictionary = {
	# Stone Age
	"hunter": {
		"era": "stone_age",
		"name": "Hunter",
		"description": "Skilled tracker and fighter",
		"cost": 20,  # Food cost to recruit
		"training_time": 50,
		"health": 15,
		"attack": 8,
		"defense": 3,
		"speed": 5,
		"morale_impact": 0.0
	},
	"gatherer": {
		"era": "stone_age",
		"name": "Gatherer",
		"description": "Collects resources",
		"cost": 10,
		"training_time": 20,
		"health": 10,
		"attack": 0,
		"defense": 2,
		"speed": 3,
		"morale_impact": 0.05
	},
	
	# Bronze Age
	"warrior_bronze": {
		"era": "bronze_age",
		"name": "Bronze Warrior",
		"description": "Armed with bronze weapons",
		"cost": 50,
		"training_time": 80,
		"health": 20,
		"attack": 12,
		"defense": 5,
		"speed": 4,
		"morale_impact": 0.1
	},
	
	# Iron Age
	"soldier_iron": {
		"era": "iron_age",
		"name": "Iron Soldier",
		"description": "Equipped with iron weapons and armor",
		"cost": 80,
		"training_time": 120,
		"health": 30,
		"attack": 16,
		"defense": 8,
		"speed": 3,
		"morale_impact": 0.15
	},
	
	# Medieval
	"knight": {
		"era": "medieval",
		"name": "Knight",
		"description": "Mounted warrior in plate armor",
		"cost": 200,
		"training_time": 300,
		"health": 50,
		"attack": 25,
		"defense": 15,
		"speed": 6,
		"morale_impact": 0.3
	},
	"archer": {
		"era": "medieval",
		"name": "Archer",
		"description": "Ranged support",
		"cost": 100,
		"training_time": 150,
		"health": 20,
		"attack": 20,
		"defense": 5,
		"speed": 4,
		"morale_impact": 0.1
	},
	
	# Renaissance
	"musketeer": {
		"era": "renaissance",
		"name": "Musketeer",
		"description": "Early gunpowder soldier",
		"cost": 150,
		"training_time": 200,
		"health": 25,
		"attack": 22,
		"defense": 8,
		"speed": 3,
		"morale_impact": 0.2
	},
	
	# Industrial
	"soldier_rifle": {
		"era": "industrial",
		"name": "Rifle Soldier",
		"description": "Armed with reliable rifles",
		"cost": 120,
		"training_time": 180,
		"health": 30,
		"attack": 28,
		"defense": 10,
		"speed": 3,
		"morale_impact": 0.15
	},
	"soldier_machine_gun": {
		"era": "modern",
		"name": "Machine Gunner",
		"description": "Heavy firepower",
		"cost": 150,
		"training_time": 250,
		"health": 25,
		"attack": 35,
		"defense": 8,
		"speed": 2,
		"morale_impact": 0.25
	},
	"tank": {
		"era": "modern",
		"name": "Tank",
		"description": "Armored fighting vehicle",
		"cost": 500,
		"training_time": 600,
		"health": 150,
		"attack": 40,
		"defense": 25,
		"speed": 2,
		"morale_impact": 0.4
	},
	
	# Atomic Era
	"tank_advanced": {
		"era": "atomic",
		"name": "Advanced Tank",
		"description": "Modern main battle tank",
		"cost": 600,
		"training_time": 800,
		"health": 200,
		"attack": 50,
		"defense": 30,
		"speed": 3,
		"morale_impact": 0.3
	},
	"pilot_jet": {
		"era": "atomic",
		"name": "Jet Pilot",
		"description": "Fighter jet pilot",
		"cost": 400,
		"training_time": 1000,
		"health": 20,
		"attack": 60,
		"defense": 5,
		"speed": 8,
		"morale_impact": 0.5
	},
	
	# Information Era
	"soldier_ai": {
		"era": "information",
		"name": "AI-Assisted Soldier",
		"description": "Enhanced with AI targeting",
		"cost": 250,
		"training_time": 300,
		"health": 35,
		"attack": 50,
		"defense": 15,
		"speed": 4,
		"morale_impact": 0.2
	},
	"drone": {
		"era": "information",
		"name": "Combat Drone",
		"description": "Autonomous aerial unit",
		"cost": 300,
		"training_time": 200,
		"health": 15,
		"attack": 45,
		"defense": 8,
		"speed": 7,
		"morale_impact": 0.1
	}
}

var units: Dictionary = {}  # unit_instance_id -> unit_data
var next_unit_id: int = 0

func recruit_unit(unit_type: String, population_system: PopulationSystem, resource_manager: ResourceManager) -> bool:
	"""Recruit a unit from population"""
	if unit_type not in unit_definitions:
		return false
	
	var unit_def = unit_definitions[unit_type]
	
	# Check if population has available soldiers
	var available_soldiers = population_system.get_military_potential()
	if available_soldiers <= 0:
		return false
	
	# Check resources (recruitment cost in food)
	if not resource_manager.remove_resource("food", unit_def["cost"]):
		return false
	
	# Create unit instance
	var instance_id = "unit_" + str(next_unit_id)
	next_unit_id += 1
	
	var unit = {
		"instance_id": instance_id,
		"type": unit_type,
		"data": unit_def.duplicate(),
		"current_health": unit_def["health"],
		"experience": 0,
		"training_progress": 0.0,
		"training_time": float(unit_def["training_time"]),
		"is_trained": false,
		"morale": 0.5
	}
	
	units[instance_id] = unit
	
	# Add to military population
	population_system.population_classes["soldiers"] += 1
	
	unit_created.emit(instance_id)
	return true

func update_units(delta: float):
	"""Update unit training and status"""
	for instance_id in units:
		var unit = units[instance_id]
		
		if not unit["is_trained"]:
			unit["training_progress"] += delta
			if unit["training_progress"] >= unit["training_time"]:
				unit["is_trained"] = true
				print("Unit ready: ", unit["data"]["name"])

func get_unit_info(instance_id: String) -> Dictionary:
	"""Get unit information"""
	if instance_id in units:
		return units[instance_id].duplicate()
	return {}

func damage_unit(instance_id: String, damage: float):
	"""Apply damage to a unit"""
	if instance_id in units:
		var unit = units[instance_id]
		unit["current_health"] -= damage
		
		if unit["current_health"] <= 0:
			unit["current_health"] = 0
			unit_died.emit(instance_id)

func heal_unit(instance_id: String, amount: float):
	"""Heal a unit"""
	if instance_id in units:
		var unit = units[instance_id]
		unit["current_health"] = min(unit["current_health"] + amount, unit["data"]["health"])

func get_unit_strength(instance_id: String) -> float:
	"""Get effective combat strength of a unit"""
	if instance_id not in units:
		return 0.0
	
	var unit = units[instance_id]
	var health_factor = unit["current_health"] / float(unit["data"]["health"])
	var morale_factor = 0.5 + (unit["morale"] * 0.5)  # Morale affects 50-100% effectiveness
	
	var strength = unit["data"]["attack"] * health_factor * morale_factor
	return strength

func get_trained_units_count() -> int:
	"""Get count of fully trained units"""
	var count = 0
	for instance_id in units:
		if units[instance_id]["is_trained"]:
			count += 1
	return count

def get_units_for_era(era: String) -> Array:
	"""Get all unit types available in an era"""
	var available = []
	for unit_type in unit_definitions:
		if unit_definitions[unit_type].get("era", "") == era:
			available.append(unit_type)
	return available

func get_total_military_strength(government_modifier: float = 1.0) -> float:
	"""Get total military strength of all trained units"""
	var total = 0.0
	for instance_id in units:
		if units[instance_id]["is_trained"]:
			total += get_unit_strength(instance_id)
	
	return total * government_modifier

func get_unit_summary() -> Dictionary:
	"""Return summary of all units by type"""
	var summary = {}
	for instance_id in units:
		var unit = units[instance_id]
		var unit_type = unit["type"]
		
		if unit_type not in summary:
			summary[unit_type] = {
				"name": unit["data"]["name"],
				"count": 0,
				"trained": 0,
				"total_health": 0,
				"total_morale": 0.0
			}
		
		summary[unit_type]["count"] += 1
		if unit["is_trained"]:
			summary[unit_type]["trained"] += 1
		summary[unit_type]["total_health"] += unit["current_health"]
		summary[unit_type]["total_morale"] += unit["morale"]
	
	return summary

func boost_morale(faction_id: String = "", amount: float = 0.1):
	"""Boost morale of all units (or faction)"""
	for instance_id in units:
		units[instance_id]["morale"] = clamp(units[instance_id]["morale"] + amount, 0.0, 1.0)

func damage_all_units(amount: float):
	"""Apply damage to all units (from e.g. artillery strike)"""
	for instance_id in units:
		damage_unit(instance_id, amount)

func disband_unit(instance_id: String):
	"""Remove a unit from service"""
	if instance_id in units:
		units.erase(instance_id)
		unit_destroyed.emit(instance_id)
