extends Node2D
class_name BuildingPlacer

# Visual building placement system with drag-drop

var building_system: BuildingSystem
var game_world: GameWorld

var selected_building: String = ""
var is_dragging: bool = false
var drag_start_pos: Vector2 = Vector2.ZERO
var preview_rect: Rect2 = Rect2()

const GRID_SIZE = 32
const PREVIEW_COLOR = Color(0, 1, 0, 0.3)
const INVALID_COLOR = Color(1, 0, 0, 0.3)

func _ready():
	game_world = get_parent()
	building_system = BuildingSystem.new()
	game_world.add_child(building_system)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if selected_building:
			_attempt_place_building()
	
	if Input.is_action_just_pressed("ui_cancel"):
		selected_building = ""
	
	queue_redraw()

func _draw():
	"""Draw building preview"""
	if selected_building and is_dragging:
		var color = PREVIEW_COLOR
		if not _can_place_at_preview():
			color = INVALID_COLOR
		
		draw_rect(preview_rect, color)
		draw_rect(preview_rect, Color.WHITE, false, 1.0)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if selected_building:
				is_dragging = true
				drag_start_pos = get_global_mouse_position()
		else:
			is_dragging = false
	
	if event is InputEventMouseMotion and is_dragging and selected_building:
		var mouse_pos = get_global_mouse_position()
		var grid_pos = _to_grid_pos(mouse_pos)
		var size = building_system.building_definitions.get(selected_building, {}).get("size", [1, 1])
		preview_rect = Rect2(grid_pos * GRID_SIZE, Vector2(size[0], size[1]) * GRID_SIZE)

func select_building(building_id: String):
	"""Select a building to place"""
	selected_building = building_id
	print("Selected building: ", building_id)

func _attempt_place_building():
	"""Try to place the selected building"""
	if not selected_building:
		return
	
	var mouse_pos = get_global_mouse_position()
	var grid_pos = _to_grid_pos(mouse_pos)
	
	var success = building_system.place_building(
		selected_building,
		grid_pos,
		game_world.era_manager.current_era_id,
		game_world.resource_manager
	)
	
	if success:
		print("Building placed at: ", grid_pos)
	else:
		print("Cannot place building - insufficient resources or invalid position")

func _to_grid_pos(world_pos: Vector2) -> Vector2i:
	"""Convert world position to grid coordinates"""
	return Vector2i(int(world_pos.x / GRID_SIZE), int(world_pos.y / GRID_SIZE))

func _can_place_at_preview() -> bool:
	"""Check if current preview position is valid"""
	if not selected_building:
		return false
	
	var grid_pos = Vector2i(int(preview_rect.position.x / GRID_SIZE), int(preview_rect.position.y / GRID_SIZE))
	
	return building_system.can_place_building(
		selected_building,
		game_world.era_manager.current_era_id,
		game_world.resource_manager
	)

func get_building_placer() -> BuildingSystem:
	return building_system
