extends Node
class_name BuildingSystem

# Building placement and management system

signal building_placed(building_id: String, position: Vector2i)
signal building_destroyed(building_id: String)
signal building_completed(building_id: String)

var buildings: Dictionary = {}  # building_instance_id -> building_data
var next_building_id: int = 0

# Building costs and data (loaded from buildings.json)
var building_definitions: Dictionary = {}

func _ready():
	load_building_definitions()

func load_building_definitions():
	"""Load building definitions from JSON"""
	var file = FileAccess.open("res://data/eras/buildings.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parsed = json.parse_string(file.get_as_text())
		if parsed and parsed.has("buildings"):
			for building in parsed["buildings"]:
				building_definitions[building["id"]] = building

func can_place_building(building_id: String, era: String, resources: ResourceManager) -> bool:
	"""Check if a building can be placed"""
	if building_id not in building_definitions:
		return false
	
	var building_data = building_definitions[building_id]
	
	# Check era
	if building_data.get("era", "") != era:
		return false
	
	# Check resources
	if not resources.has_resources(building_data.get("cost", {})):
		return false
	
	return true

func place_building(building_id: String, position: Vector2i, era: String, resources: ResourceManager) -> bool:
	"""Place a building at the specified position"""
	if not can_place_building(building_id, era, resources):
		return false
	
	var building_data = building_definitions[building_id].duplicate()
	var cost = building_data.get("cost", {})
	
	# Pay cost
	if not resources.pay_cost(cost):
		return false
	
	# Create building instance
	var instance_id = "building_" + str(next_building_id)
	next_building_id += 1
	
	var building = {
		"id": building_id,
		"instance_id": instance_id,
		"position": position,
		"data": building_data,
		"build_progress": 0.0,
		"build_time": float(building_data.get("build_time", 100)),
		"is_completed": false
	}
	
	buildings[instance_id] = building
	building_placed.emit(building_id, position)
	print("Building placed: ", building_data["name"], " at ", position)
	return true

func update_buildings(delta: float):
	"""Update all buildings (construction progress, production)"""
	for instance_id in buildings:
		var building = buildings[instance_id]
		
		if not building["is_completed"]:
			# Update construction
			building["build_progress"] += delta
			
			if building["build_progress"] >= building["build_time"]:
				complete_building(instance_id)

func complete_building(instance_id: String):
	"""Mark a building as completed"""
	if instance_id in buildings:
		buildings[instance_id]["is_completed"] = true
		var building_id = buildings[instance_id]["id"]
		building_completed.emit(building_id)
		print("Building completed: ", building_id)

func get_building_production(instance_id: String) -> Dictionary:
	"""Get production rates from a building"""
	if instance_id not in buildings or not buildings[instance_id]["is_completed"]:
		return {}
	
	var building = buildings[instance_id]
	return building["data"].get("production", {})

func get_buildings_at_position(position: Vector2i) -> Array:
	"""Get all buildings at a specific position"""
	var result = []
	for instance_id in buildings:
		if buildings[instance_id]["position"] == position:
			result.append(buildings[instance_id])
	return result

func destroy_building(instance_id: String):
	"""Destroy a building"""
	if instance_id in buildings:
		var building = buildings[instance_id]
		buildings.erase(instance_id)
		building_destroyed.emit(instance_id)
		print("Building destroyed: ", building["id"])

func get_building_summary() -> Dictionary:
	"""Return summary of all buildings by type"""
	var summary = {}
	for instance_id in buildings:
		var building = buildings[instance_id]
		var building_id = building["id"]
		if building_id not in summary:
			summary[building_id] = {
				"name": building["data"].get("name", "Unknown"),
				"count": 0,
				"completed": 0
			}
		summary[building_id]["count"] += 1
		if building["is_completed"]:
			summary[building_id]["completed"] += 1
	
	return summary

func apply_building_effects(resource_manager: ResourceManager, government_system: GovernmentSystem, era: String):
	"""Apply effects of all completed buildings to production"""
	for instance_id in buildings:
		var building = buildings[instance_id]
		
		if not building["is_completed"]:
			continue
		
		var production = get_building_production(instance_id)
		
		# Apply government modifiers
		var gov_modifiers = government_system.get_government_modifiers()
		
		# Most production scales with government research modifier
		for resource_name in production:
			var rate = production[resource_name]
			
			# Apply research modifier
			if resource_name in ["steel", "copper", "bronze", "iron"]:
				rate *= gov_modifiers.get("research_modifier", 1.0)
			
			# Apply corruption modifier
			rate = government_system.apply_corruption_to_economy(rate)
			
			resource_manager.set_production_rate(resource_name, rate)

func get_available_buildings_for_era(era: String) -> Array:
	"""Get all buildable buildings for the current era"""
	var available = []
	for building_id in building_definitions:
		var building = building_definitions[building_id]
		if building.get("era", "") == era:
			available.append({
				"id": building_id,
				"name": building.get("name", "Unknown"),
				"description": building.get("description", ""),
				"cost": building.get("cost", {}),
				"build_time": building.get("build_time", 100)
			})
	return available

func get_building_details(building_id: String) -> Dictionary:
	"""Get detailed info about a building type"""
	if building_id in building_definitions:
		return building_definitions[building_id].duplicate()
	return {}
