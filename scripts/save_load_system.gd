extends Node
class_name SaveLoadSystem

# Save/Load game state to JSON

const SAVE_DIR = "user://saves/"

func _ready():
	# Create saves directory if it doesn't exist
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_absolute("user://", SAVE_DIR)

func save_game(filename: String, game_world) -> bool:
	"""Save complete game state"""
	var game_state = {
		"timestamp": Time.get_ticks_msec(),
		"era": game_world.era_manager.current_era_id,
		"government": game_world.government_system.current_government,
		"resources": game_world.resource_manager.resources.duplicate(),
		"population": {
			"total": game_world.population_system.total_population,
			"morale": game_world.population_system.morale,
			"happiness": game_world.population_system.happiness,
			"classes": game_world.population_system.classes.duplicate()
		},
		"buildings": game_world.building_system.buildings.duplicate(),
		"units": game_world.unit_system.units.duplicate(),
		"factions": game_world.faction_system.factions.duplicate(),
		"events": game_world.event_system.active_events.duplicate(),
		"techs_researched": {},
		"game_speed": game_world.game_speed
	}
	
	# Save to JSON file
	var path = SAVE_DIR + filename + ".json"
	var json = JSON.stringify(game_state)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(json)
		print("✓ Game saved to: ", path)
		return true
	else:
		print("✗ Failed to save game!")
		return false

func load_game(filename: String, game_world) -> bool:
	"""Load complete game state"""
	var path = SAVE_DIR + filename + ".json"
	
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("✗ Save file not found: ", path)
		return false
	
	var json = JSON.new()
	var game_state = json.parse_string(file.get_as_text())
	
	if not game_state:
		print("✗ Failed to parse save file!")
		return false
	
	# Restore game state
	game_world.era_manager.current_era_id = game_state.get("era", "stone_age")
	game_world.government_system.current_government = game_state.get("government", "tribal")
	
	# Restore resources
	for resource in game_state.get("resources", {}):
		game_world.resource_manager.resources[resource] = game_state["resources"][resource]
	
	# Restore population
	var pop_data = game_state.get("population", {})
	game_world.population_system.total_population = pop_data.get("total", 100)
	game_world.population_system.morale = pop_data.get("morale", 0.5)
	game_world.population_system.happiness = pop_data.get("happiness", 0.5)
	
	for class_name in pop_data.get("classes", {}):
		game_world.population_system.classes[class_name] = pop_data["classes"][class_name]
	
	# Restore buildings
	game_world.building_system.buildings = game_state.get("buildings", {}).duplicate()
	
	# Restore units
	game_world.unit_system.units = game_state.get("units", {}).duplicate()
	
	# Restore game speed
	game_world.game_speed = game_state.get("game_speed", 1.0)
	
	print("✓ Game loaded from: ", path)
	return true

func get_save_files() -> Array:
	"""List all save files"""
	var saves = []
	var dir = DirAccess.open(SAVE_DIR)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".json"):
				var file_path = SAVE_DIR + file_name
				var mod_time = FileAccess.get_modified_time(file_path)
				saves.append({
					"name": file_name.trim_suffix(".json"),
					"path": file_path,
					"timestamp": mod_time
				})
			file_name = dir.get_next()
	
	return saves

func delete_save(filename: String) -> bool:
	"""Delete a save file"""
	var path = SAVE_DIR + filename + ".json"
	
	if DirAccess.remove_absolute(path) == OK:
		print("✓ Save deleted: ", path)
		return true
	else:
		print("✗ Failed to delete save!")
		return false

func quick_save(game_world):
	"""Quick save to autosave.json"""
	return save_game("autosave", game_world)

func quick_load(game_world) -> bool:
	"""Quick load from autosave.json"""
	return load_game("autosave", game_world)
