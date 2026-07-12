extends Node
class_name EraManager

# Era system that handles progression through different historical eras
# Each era has unique buildings, units, technologies, and government options

signal era_changed(new_era_id: String)
signal technology_unlocked(tech_id: String)
signal government_changed(government_type: String)

var eras: Dictionary = {}
var technologies: Dictionary = {}
var buildings: Dictionary = {}
var governments: Dictionary = {}

var current_era_id: String = "stone_age"
var current_era: Dictionary = {}
var researched_technologies: Array[String] = []
var current_government: String = "tribal"

# Timeline tracking
var years_elapsed: int = 0
var era_start_year: int = 0

func _ready():
	load_eras_data()
	load_technologies_data()
	load_buildings_data()
	load_governments_data()
	initialize_era(current_era_id)

func load_eras_data():
	var file = FileAccess.open("res://data/eras/eras.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parsed = json.parse_string(file.get_as_text())
		if parsed and parsed.has("eras"):
			for era in parsed["eras"]:
				eras[era["id"]] = era

func load_technologies_data():
	var file = FileAccess.open("res://data/eras/technologies.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parsed = json.parse_string(file.get_as_text())
		if parsed and parsed.has("technologies"):
			for tech in parsed["technologies"]:
				technologies[tech["id"]] = tech

func load_buildings_data():
	var file = FileAccess.open("res://data/eras/buildings.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parsed = json.parse_string(file.get_as_text())
		if parsed and parsed.has("buildings"):
			for building in parsed["buildings"]:
				buildings[building["id"]] = building

func load_governments_data():
	# TODO: Load government types and their modifiers
	governments = {
		"tribal": {
			"name": "Tribal",
			"military_modifier": 1.0,
			"research_modifier": 0.5,
			"happiness_modifier": 1.0,
			"production_modifier": 1.0
		},
		"monarchy": {
			"name": "Monarchy",
			"military_modifier": 1.2,
			"research_modifier": 0.6,
			"happiness_modifier": 0.8,
			"production_modifier": 1.0
		},
		"democracy": {
			"name": "Democracy",
			"military_modifier": 0.9,
			"research_modifier": 1.5,
			"happiness_modifier": 1.2,
			"production_modifier": 1.0
		},
		"fascism": {
			"name": "Fascism",
			"military_modifier": 2.0,
			"research_modifier": 0.4,
			"happiness_modifier": 0.3,
			"production_modifier": 0.9
		},
		"communism": {
			"name": "Communism",
			"military_modifier": 1.5,
			"research_modifier": 0.7,
			"happiness_modifier": 0.6,
			"production_modifier": 1.1
		},
		"theocracy": {
			"name": "Theocracy",
			"military_modifier": 1.1,
			"research_modifier": 0.3,
			"happiness_modifier": 1.3,
			"production_modifier": 1.0
		}
	}

func initialize_era(era_id: String):
	if era_id in eras:
		current_era_id = era_id
		current_era = eras[era_id]
		era_start_year = years_elapsed
		print("Entered era: ", current_era["name"])

func advance_year(delta_years: int = 1):
	years_elapsed += delta_years
	check_era_transitions()

func check_era_transitions():
	# Check if we should auto-transition to next era based on conditions
	pass

func is_technology_available(tech_id: String) -> bool:
	if tech_id in technologies:
		var tech = technologies[tech_id]
		# Check if tech's era matches current era or is earlier
		return tech.get("era", "") == current_era_id or is_current_era_or_later(tech["era"])
	return false

func is_current_era_or_later(era_id: String) -> bool:
	var current_index = get_era_index(current_era_id)
	var target_index = get_era_index(era_id)
	return target_index <= current_index

func get_era_index(era_id: String) -> int:
	var era_ids = ["stone_age", "bronze_age", "iron_age", "medieval", "renaissance", 
				   "enlightenment", "industrial", "modern", "atomic", "information", "space", "intergalactic"]
	return era_ids.find(era_id)

func research_technology(tech_id: String) -> bool:
	if tech_id in researched_technologies:
		return false
	
	if is_technology_available(tech_id):
		researched_technologies.append(tech_id)
		technology_unlocked.emit(tech_id)
		
		# Check if this tech unlocks a new era
		var tech = technologies[tech_id]
		if tech.has("unlocks_era"):
			advance_to_era(tech["unlocks_era"])
		
		return true
	return false

func advance_to_era(era_id: String):
	if era_id in eras and era_id != current_era_id:
		initialize_era(era_id)
		era_changed.emit(era_id)
		print("Civilization advanced to ", eras[era_id]["name"])

func set_government(government_type: String) -> bool:
	if government_type in governments:
		current_government = government_type
		government_changed.emit(government_type)
		print("Government changed to: ", governments[government_type]["name"])
		return true
	return false

func get_available_governments() -> Array:
	if current_era_id in eras:
		return eras[current_era_id].get("governments_available", [])
	return []

func get_available_buildings() -> Array:
	var available = []
	if current_era_id in eras:
		for building_id in eras[current_era_id].get("buildings", []):
			if building_id in buildings:
				available.append(buildings[building_id])
	return available

func get_available_units() -> Array:
	var available = []
	if current_era_id in eras:
		for unit_id in eras[current_era_id].get("units", []):
			# TODO: Load units from data
			available.append({"id": unit_id})
	return available

func get_government_modifiers(government_type: String = current_government) -> Dictionary:
	if government_type in governments:
		return governments[government_type]
	return governments["tribal"]

func get_era_name() -> String:
	return current_era.get("name", "Unknown")

func get_era_description() -> String:
	return current_era.get("description", "")

func debug_advance_era():
	# For testing: advance to next era
	var era_ids = ["stone_age", "bronze_age", "iron_age", "medieval", "renaissance", 
				   "enlightenment", "industrial", "modern", "atomic", "information", "space", "intergalactic"]
	var current_index = era_ids.find(current_era_id)
	if current_index < era_ids.size() - 1:
		advance_to_era(era_ids[current_index + 1])
