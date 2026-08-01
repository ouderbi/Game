extends PanelContainer
class_name BuildingBrowserPanel

# Browse and filter buildings by type, cost, era

var building_system: BuildingSystem
var era_manager: EraManager
var resource_manager: ResourceManager

var buildings_data: Dictionary = {}
var current_filter: String = ""  # Filter by era or building type

@onready var container = VBoxContainer.new()

func _ready():
	load_building_data()

func load_building_data():
	"""Load building definitions from JSON"""
	var file = FileAccess.open("res://data/eras/buildings.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parsed = json.parse_string(file.get_as_text())
		if parsed and parsed.has("buildings"):
			for building in parsed["buildings"]:
				buildings_data[building["id"]] = building

func setup_panel():
	"""Setup the building browser"""
	var title = Label.new()
	title.text = "BUILDING BROWSER"
	title.add_theme_font_size_override("font_size", 16)
	container.add_child(title)
	
	var separator = HSeparator.new()
	container.add_child(separator)
	
	# Get current era buildings
	var era_buildings = get_buildings_for_era(era_manager.current_era_id)
	
	# Display available buildings for this era
	for building_id in era_buildings:
		var building = buildings_data[building_id]
		
		# Building header
		var header = Label.new()
		header.text = building["name"]
		header.add_theme_font_size_override("font_size", 11)
		container.add_child(header)
		
		# Building description
		var desc = Label.new()
		desc.text = building.get("description", "No description")
		desc.add_theme_font_size_override("font_size", 9)
		container.add_child(desc)
		
		# Costs
		var cost_text = "Cost: "
		var costs = building.get("cost", {})
		for resource in costs:
			cost_text += "%s:%d " % [resource, costs[resource]]
		
		var cost_label = Label.new()
		cost_label.text = cost_text
		
		# Color code if player can afford
		var can_afford = true
		for resource in costs:
			if resource_manager.get_resource_amount(resource) < costs[resource]:
				can_afford = false
				break
		
		if can_afford:
			cost_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			cost_label.add_theme_color_override("font_color", Color.RED)
		
		container.add_child(cost_label)
		
		# Production/Effects
		var production = building.get("production", {})
		if not production.is_empty():
			var prod_text = "Produces: "
			for resource in production:
				prod_text += "%s:+%s/t " % [resource, production[resource]]
			
			var prod_label = Label.new()
			prod_label.text = prod_text
			prod_label.add_theme_color_override("font_color", Color.YELLOW)
			container.add_child(prod_label)
		
		# Separator
		container.add_child(HSeparator.new())
	
	add_child(container)

func get_buildings_for_era(era_id: String) -> Array:
	"""Get buildings available in this era"""
	var available = []
	
	for building_id in buildings_data:
		var building = buildings_data[building_id]
		var building_eras = building.get("available_in_eras", [])
		
		if era_id in building_eras:
			available.append(building_id)
	
	return available

func get_affordable_buildings() -> Array:
	"""Get buildings player can currently afford"""
	var affordable = []
	
	for building_id in buildings_data:
		var building = buildings_data[building_id]
		var costs = building.get("cost", {})
		
		var can_afford = true
		for resource in costs:
			if resource_manager.get_resource_amount(resource) < costs[resource]:
				can_afford = false
				break
		
		if can_afford:
			affordable.append(building_id)
	
	return affordable

func get_most_productive_buildings() -> Array:
	"""Get buildings with highest production"""
	var productive = []
	
	for building_id in buildings_data:
		var building = buildings_data[building_id]
		var production = building.get("production", {})
		
		if not production.is_empty():
			productive.append({
				"id": building_id,
				"name": building["name"],
				"total_production": production.values().reduce(func(acc, val): return acc + val, 0)
			})
	
	productive.sort_custom(func(a, b): return a["total_production"] > b["total_production"])
	return productive

func filter_buildings(filter_type: String) -> Array:
	"""Filter buildings by type"""
	var filtered = []
	
	for building_id in buildings_data:
		var building = buildings_data[building_id]
		if filter_type.to_lower() in building_id.to_lower():
			filtered.append(building)
	
	return filtered

func print_building_summary():
	"""Print building information to console"""
	var era_buildings = get_buildings_for_era(era_manager.current_era_id)
	var affordable = get_affordable_buildings()
	var productive = get_most_productive_buildings()
	
	print("\n=== BUILDING BROWSER ===")
	print("Era: %s" % era_manager.current_era_id)
	print("Buildings available: %d" % era_buildings.size())
	print("Can afford: %d" % affordable.size())
	
	print("\nMost Productive:")
	for building in productive.slice(0, min(5, productive.size())):
		print("  %s (production: %d/t)" % [building["name"], building["total_production"]])
	
	print("========================\n")
