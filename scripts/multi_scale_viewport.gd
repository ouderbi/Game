extends Node2D
class_name MultiScaleViewport

# Multi-scale map zoom system: City -> Country -> Planet -> Galaxy

enum ZoomLevel {
	CITY = 0,        # 256x256 tiles - detailed building view
	COUNTRY = 1,     # 1024x1024 tiles - cities as blocks
	PLANET = 2,      # 4096x4096 tiles - continents, countries aggregated
	GALAXY = 3       # Space view - planets as dots, space stations visible
}

var current_zoom_level: ZoomLevel = ZoomLevel.CITY
var zoom_history: Array[ZoomLevel] = []
var camera: Camera2D
var tile_renderer: TileRenderer

const ZOOM_LEVELS = {
	ZoomLevel.CITY: {"scale": 2.0, "detail": "buildings", "name": "City View"},
	ZoomLevel.COUNTRY: {"scale": 1.0, "detail": "districts", "name": "Country View"},
	ZoomLevel.PLANET: {"scale": 0.5, "detail": "regions", "name": "Planet View"},
	ZoomLevel.GALAXY: {"scale": 0.1, "detail": "celestial", "name": "Galaxy View"}
}

const MAP_SIZES = {
	ZoomLevel.CITY: Vector2i(256, 256),      # Tile count
	ZoomLevel.COUNTRY: Vector2i(1024, 1024),
	ZoomLevel.PLANET: Vector2i(4096, 4096),
	ZoomLevel.GALAXY: Vector2i(16384, 16384)
}

const TILE_SIZE = 32

func _ready():
	# Get references from parent (GameWorld)
	camera = get_parent().camera
	tile_renderer = get_parent().tile_renderer

func set_zoom_level(level: ZoomLevel) -> bool:
	"""Transition to a new zoom level"""
	if level == current_zoom_level:
		return false
	
	# Save history for zoom out/in navigation
	if level > current_zoom_level:
		zoom_history.append(current_zoom_level)  # Going out (away)
	elif level < current_zoom_level and not zoom_history.is_empty():
		zoom_history.pop_back()  # Going in (closer)
	
	current_zoom_level = level
	apply_zoom_level(level)
	return true

func apply_zoom_level(level: ZoomLevel):
	"""Apply visual changes for this zoom level"""
	var zoom_config = ZOOM_LEVELS[level]
	
	# Update camera zoom
	if camera:
		camera.zoom = Vector2(zoom_config["scale"], zoom_config["scale"])
	
	# Update tile renderer detail level
	if tile_renderer:
		tile_renderer.set_detail_level(zoom_config["detail"])
	
	print("Zoom Level: ", zoom_config["name"], " (", zoom_config["detail"], ")")
	
	# Show/hide UI elements based on zoom level
	update_ui_for_zoom(level)

func update_ui_for_zoom(level: ZoomLevel):
	"""Update UI visibility based on zoom level"""
	match level:
		ZoomLevel.CITY:
			print("  - Building details visible")
			print("  - Unit positions visible")
			print("  - Population classes breakdown")
		ZoomLevel.COUNTRY:
			print("  - Districts/cities grouped")
			print("  - Army formations visible")
			print("  - Regional resources")
		ZoomLevel.PLANET:
			print("  - Continents visible")
			print("  - Countries as large blocks")
			print("  - Global resource distribution")
		ZoomLevel.GALAXY:
			print("  - Planets visible")
			print("  - Space stations")
			print("  - Trade routes between worlds")

func zoom_in() -> bool:
	"""Zoom to more detail"""
	if current_zoom_level > 0:
		return set_zoom_level(current_zoom_level - 1)
	return false

func zoom_out() -> bool:
	"""Zoom to less detail"""
	if current_zoom_level < ZoomLevel.GALAXY:
		return set_zoom_level(current_zoom_level + 1)
	return false

func get_current_zoom_name() -> String:
	"""Get readable name for current zoom level"""
	return ZOOM_LEVELS[current_zoom_level]["name"]

func get_visible_map_size() -> Vector2i:
	"""Get the total map size at current zoom level"""
	return MAP_SIZES[current_zoom_level]

func get_tile_size_at_zoom() -> int:
	"""Get effective tile size at current zoom level"""
	match current_zoom_level:
		ZoomLevel.CITY:
			return 32  # Full detail
		ZoomLevel.COUNTRY:
			return 128  # 4x4 city blocks
		ZoomLevel.PLANET:
			return 512  # 16x16 city areas
		ZoomLevel.GALAXY:
			return 2048  # Planets
	return 32

func aggregate_buildings_at_zoom(buildings: Dictionary) -> Dictionary:
	"""Aggregate buildings into districts/regions at zoom level"""
	var aggregated = {}
	
	match current_zoom_level:
		ZoomLevel.CITY:
			# No aggregation - show individual buildings
			return buildings
		
		ZoomLevel.COUNTRY:
			# Group buildings into 4x4 districts
			for building_pos in buildings:
				var district = Vector2i(building_pos) / Vector2i(4, 4)
				var key = "%d,%d" % [district.x, district.y]
				if not aggregated.has(key):
					aggregated[key] = {"count": 0, "types": {}}
				aggregated[key]["count"] += 1
				var building_type = buildings[building_pos].get("type", "unknown")
				aggregated[key]["types"][building_type] = aggregated[key]["types"].get(building_type, 0) + 1
			return aggregated
		
		ZoomLevel.PLANET:
			# Group buildings into 16x16 regions
			for building_pos in buildings:
				var region = Vector2i(building_pos) / Vector2i(16, 16)
				var key = "%d,%d" % [region.x, region.y]
				if not aggregated.has(key):
					aggregated[key] = {"count": 0}
				aggregated[key]["count"] += 1
			return aggregated
		
		ZoomLevel.GALAXY:
			# Entire world is one mega-city
			aggregated["world"] = {"count": buildings.size()}
			return aggregated
	
	return buildings

func aggregate_units_at_zoom(units: Array) -> Array:
	"""Aggregate military units into army groups at zoom level"""
	var aggregated = []
	
	match current_zoom_level:
		ZoomLevel.CITY:
			# Show each unit individually
			return units
		
		ZoomLevel.COUNTRY:
			# Group units into armies (4x4 tile groups)
			var armies = {}
			for unit in units:
				var pos = unit.get("position", Vector2(0, 0))
				var army_zone = Vector2i(pos) / Vector2i(4 * TILE_SIZE, 4 * TILE_SIZE)
				var key = "%d,%d" % [army_zone.x, army_zone.y]
				if not armies.has(key):
					armies[key] = {"count": 0, "strength": 0}
				armies[key]["count"] += 1
				armies[key]["strength"] += unit.get("attack", 10)
			
			for key in armies:
				aggregated.append(armies[key])
			return aggregated
		
		ZoomLevel.PLANET:
			# Show only major armies (100+ units)
			var major_armies = []
			for unit in units:
				if units.size() > 100:
					major_armies.append({"count": units.size(), "strength": units.size() * 10})
					break
			return major_armies
		
		ZoomLevel.GALAXY:
			# Show single galactic fleet indicator
			if units.size() > 0:
				return [{"count": units.size(), "label": "Galactic Fleet"}]
			return []
	
	return units

func is_detailed_view() -> bool:
	"""Check if current zoom is detailed enough to show individual entities"""
	return current_zoom_level in [ZoomLevel.CITY, ZoomLevel.COUNTRY]

func handle_zoom_input(direction: int):
	"""Handle zoom input (1 = zoom in, -1 = zoom out)"""
	if direction > 0:
		zoom_in()
	elif direction < 0:
		zoom_out()
	
	print("Current zoom: ", get_current_zoom_name())
