extends Node2D
class_name GameWorld

# Main game world - coordinates all systems and rendering

@onready var tile_renderer = $TileRenderer
@onready var camera = $Camera2D
@onready var ui_layer = $UILayer

var era_manager: EraManager
var resource_manager: ResourceManager
var government_system: GovernmentSystem
var faction_system: FactionSystem
var event_system: EventSystem
var population_system: PopulationSystem
var building_system: BuildingSystem
var building_placer: BuildingPlacer
var unit_system: UnitSystem
var combat_system: CombatSystem
var diplomacy_system: DiplomacySystem
var save_load_system: SaveLoadSystem
var tech_tree_ui: TechTreeUI
var multi_scale_viewport: MultiScaleViewport
var event_log: EventLogUI
var playtesting_analyzer: PlaytestingAnalyzer

# Game state
var game_speed: float = 1.0  # 1x, 2x, 3x
var is_paused: bool = false
var current_year: int = 0

# Tilemap settings
const TILE_SIZE = 32
const MAP_WIDTH = 256
const MAP_HEIGHT = 256
const STARTING_ZOOM = 2.0

func _ready():
	# Initialize all systems
	era_manager = EraManager.new()
	add_child(era_manager)
	
	resource_manager = ResourceManager.new()
	add_child(resource_manager)
	
	government_system = GovernmentSystem.new()
	add_child(government_system)
	
	faction_system = FactionSystem.new()
	add_child(faction_system)
	
	event_system = EventSystem.new()
	add_child(event_system)
	
	population_system = PopulationSystem.new()
	add_child(population_system)
	
	building_system = BuildingSystem.new()
	add_child(building_system)
	
	building_placer = BuildingPlacer.new()
	add_child(building_placer)
	
	unit_system = UnitSystem.new()
	add_child(unit_system)
	
	combat_system = CombatSystem.new()
	add_child(combat_system)
	
	diplomacy_system = DiplomacySystem.new()
	add_child(diplomacy_system)
	
	save_load_system = SaveLoadSystem.new()
	add_child(save_load_system)
	
	tech_tree_ui = TechTreeUI.new()
	tech_tree_ui.era_manager = era_manager
	add_child(tech_tree_ui)
	
	multi_scale_viewport = MultiScaleViewport.new()
	add_child(multi_scale_viewport)
	
	event_log = EventLogUI.new()
	add_child(event_log)
	
	playtesting_analyzer = PlaytestingAnalyzer.new()
	add_child(playtesting_analyzer)
	
	# Wait for systems to initialize
	await get_tree().process_frame
	
	setup_camera()
	setup_tilemap()
	connect_signals()
	
	print("\n=== DEEP CIVILIZATION GAME ===")
	print("Current Era: ", era_manager.get_era_name())
	print("Population: ", population_system.total_population)
	print("Government: ", government_system.get_government_name())
	print("Military: ", unit_system.get_trained_units_count(), " trained units")
	print("Resources: Food=%d, Wood=%d, Stone=%d" % [
		resource_manager.get_resource_amount("food"),
		resource_manager.get_resource_amount("wood"),
		resource_manager.get_resource_amount("stone")
	])
	print("Mood: ", population_system.sentiment)
	print("\nCHEATS & CONTROLS:")
	print("  F1: Fill Resources")
	print("  F2: Next Era")
	print("  F3: Democracy")
	print("  F4: Military Coup Risk")
	print("  F5: Recruit Hunter (costs food)")
	print("  F6: Declare War")
	print("  S: Save Game | L: Load Game")
	print("  T: Toggle Tech Tree | D: Diplomacy Panel")
	print("  Z/X: Zoom In/Out (Multi-Scale)")
	print("  E: Event Log | H: Export History")
	print("  B: Balance Report (for tuning)")
	print("  Arrows: Move camera | Scroll: Zoom | 1/2/3: Speed | ESC: Pause")
	print("============================\n")

func setup_camera():
	camera.zoom = Vector2(STARTING_ZOOM, STARTING_ZOOM)
	camera.global_position = Vector2(MAP_WIDTH * TILE_SIZE / 2, MAP_HEIGHT * TILE_SIZE / 2)

func setup_tilemap():
	"""Setup tile renderer"""
	tile_renderer.set_era(era_manager.current_era_id)

func connect_signals():
	era_manager.era_changed.connect(_on_era_changed)
	event_system.event_triggered.connect(_on_event_triggered)
	population_system.population_changed.connect(_on_population_changed)
	government_system.legitimacy_changed.connect(_on_legitimacy_changed)

func _process(delta):
	if is_paused:
		return
	
	# Handle input
	_handle_input()
	
	# Update all systems
	_update_systems(delta)
	
	# Advance year tracker
	current_year += int(delta * game_speed * 10)  # ~1 year per 0.1 seconds at 1x speed

func _handle_input():
	# Camera controls
	if Input.is_action_pressed("ui_up"):
		camera.global_position.y -= 10 / camera.zoom.y
	if Input.is_action_pressed("ui_down"):
		camera.global_position.y += 10 / camera.zoom.y
	if Input.is_action_pressed("ui_left"):
		camera.global_position.x -= 10 / camera.zoom.x
	if Input.is_action_pressed("ui_right"):
		camera.global_position.x += 10 / camera.zoom.x
	
	# Zoom controls
	if Input.is_action_pressed("ui_scroll_up"):
		camera.zoom *= 1.05
	if Input.is_action_pressed("ui_scroll_down"):
		camera.zoom /= 1.05
	
	# Game speed
	if Input.is_key_pressed(KEY_1):
		game_speed = 1.0
	if Input.is_key_pressed(KEY_2):
		game_speed = 2.0
	if Input.is_key_pressed(KEY_3):
		game_speed = 3.0
	
	# Pause
	if Input.is_action_just_pressed("ui_cancel"):
		is_paused = !is_paused
		print("GAME ", "PAUSED" if is_paused else "RESUMED")
	
	# Cheats (F-keys)
	if Input.is_key_pressed(KEY_F1):
		resource_manager.cheat_fill_all_resources(500)
		print("Cheated: Resources filled!")
	if Input.is_key_pressed(KEY_F2):
		era_manager.debug_advance_era()
		tile_renderer.set_era(era_manager.current_era_id)
	if Input.is_key_pressed(KEY_F3):
		government_system.change_government("democracy")
	if Input.is_key_pressed(KEY_F4):
		faction_system.factions["military"]["power"] = 0.8
		print("Cheated: Military coup risk raised!")
	if Input.is_key_pressed(KEY_F5):
		var unit_type = "hunter" if era_manager.current_era_id == "stone_age" else "warrior_bronze"
		if unit_system.recruit_unit(unit_type, population_system, resource_manager):
			print("Recruited: ", unit_type)
	if Input.is_key_pressed(KEY_F6):
		var strength = unit_system.get_total_military_strength(government_system.get_military_modifier())
		if strength > 0:
			combat_system.declare_war(strength, strength * 0.8)
		else:
			print("Cannot declare war - no military units!")
	
	# Save/Load
	if Input.is_key_pressed(KEY_S):
		save_load_system.save_game("save1", self)
	if Input.is_key_pressed(KEY_L):
		save_load_system.load_game("save1", self)
	
	# Diplomacy
	if Input.is_key_pressed(KEY_D):
		print("\n=== DIPLOMACY STATUS ===")
		for npc_status in diplomacy_system.get_npc_status():
			print(npc_status)
		var summary = diplomacy_system.get_diplomatic_summary()
		print("Wars: ", summary["wars"])
		print("Trade Routes: ", summary["trades"])
		print("Avg Tension: ", summary["avg_tension"])
	
	# Multi-scale viewport zoom
	if Input.is_key_pressed(KEY_Z):
		multi_scale_viewport.zoom_in()
	if Input.is_key_pressed(KEY_X):
		multi_scale_viewport.zoom_out()
	
	# Event log
	if Input.is_key_pressed(KEY_E):
		print("\n=== RECENT EVENTS ===")
		for event in event_log.get_recent_events(10):
			print(event)
		event_log.print_log_summary()
	
	if Input.is_key_pressed(KEY_H):
		event_log.export_log_to_file("history_%d" % current_year)
	
	# Playtesting/Balance report
	if Input.is_key_pressed(KEY_B):
		playtesting_analyzer.print_balance_report(self)

func _update_systems(delta: float):
	"""Update all game systems each frame"""
	resource_manager.update_production(delta * game_speed)
	
	# Apply building production
	building_system.apply_building_effects(resource_manager, government_system, era_manager.current_era_id)
	
	# Update buildings
	building_system.update_buildings(delta * game_speed)
	
	# Update units
	unit_system.update_units(delta * game_speed)
	
	# Update wars
	combat_system.update_wars(unit_system, population_system, delta * game_speed)
	
	# Update diplomacy
	diplomacy_system.update_npc_ai(delta * game_speed)
	
	# Update tech research
	tech_tree_ui.update_research(delta * game_speed, 1.0)
	
	var world_state = get_world_state()
	
	# Update war pressure if at war
	if combat_system.is_at_war():
		world_state["is_at_war"] = true
		event_system.pressures["war"] = 0.9  # Keep war pressure high
	
	# NPC AI makes decisions
	diplomacy_system.simulate_npc_decisions(world_state)
	
	event_system.update_pressures(world_state, delta * game_speed)
	
	population_system.update_population(delta * game_speed, world_state)
	population_system.update_morale(delta * game_speed, event_system.active_events, government_system.current_government)
	population_system.update_happiness(delta * game_speed, resource_manager, government_system)
	population_system.calculate_inequality()
	
	# Check for events every tick
	var triggered_events = event_system.check_and_trigger_events(world_state)
	for event in triggered_events:
		var consequences = event_system.apply_event_consequences(event, world_state)
		apply_event_consequences(event, consequences)
	
	# Check for coups
	if randf() < 0.001:  # Low chance per tick
		if faction_system.trigger_potential_coup(world_state):
			_handle_coup()

func get_world_state() -> Dictionary:
	"""Gather current world state for systems to consume"""
	return {
		"population": population_system.total_population,
		"sanitation": 0.5,  # TODO: Link to infrastructure
		"trade_routes": 3,
		"military_strength": unit_system.get_total_military_strength(government_system.get_military_modifier()),
		"hostility_with_neighbors": 0.3,
		"leader_belligerence": 0.2 if not combat_system.is_at_war() else 0.8,
		"food_production": 150,
		"food_consumption": population_system.total_population * 0.1,
		"is_at_war": combat_system.is_at_war(),
		"inequality": population_system.inequality_index,
		"repression": 1.0 - government_system.get_civil_liberties(),
		"legitimacy": government_system.legitimacy,
		"morale": population_system.morale,
		"inflation": 0.02,
		"debt_ratio": 0.3,
		"corruption": government_system.corruption_level,
		"nuclear_weapons": 0 if era_manager.current_era_id not in ["atomic", "information", "space"] else 50,
		"era": era_manager.current_era_id,
		"random_rival": "Neighboring Kingdom"
	}

func apply_event_consequences(event: Dictionary, consequences: Dictionary):
	"""Apply event consequences to population and economy"""
	if consequences.is_empty():
		return
	
	if "population_loss" in consequences:
		var loss = int(consequences["population_loss"])
		if loss > 0:
			population_system.total_population = max(50, population_system.total_population - loss)
	
	if "morale_change" in consequences:
		population_system.morale += consequences["morale_change"]
	
	if "legitimacy_change" in consequences:
		government_system.update_legitimacy(consequences["legitimacy_change"])
	
	if "gdp_loss" in consequences:
		var loss = int(consequences["gdp_loss"])
		resource_manager.remove_resource("gold", loss)

func _on_era_changed(new_era_id: String):
	print(">>> ERA CHANGED: ", era_manager.get_era_name())
	event_log.log_era_advance(era_manager.get_era_name(), current_year)
	tile_renderer.set_era(era_manager.current_era_id)
	population_system.total_population = int(population_system.total_population * 1.2)  # Growth when era changes

func _on_event_triggered(event_data: Dictionary):
	var event_type = event_data.get("type", "unknown")
	var description = event_data.get("description", "Unknown event")
	print("⚠️  EVENT: ", description, " (severity: %.1f)" % event_data.get("severity", 0.5))
	event_log.log_event(event_type, description, current_year, "warning")

func _on_population_changed(new_population: int):
	pass  # Too frequent to print

func _on_legitimacy_changed(new_legitimacy: float):
	pass  # Too frequent to print

func _handle_coup():
	print("⚡ COUP ATTEMPT IN PROGRESS!")
	# TODO: Display UI for coup

func get_game_state() -> Dictionary:
	"""Return complete game state for UI display"""
	return {
		"year": current_year,
		"era": era_manager.get_era_name(),
		"population": population_system.total_population,
		"resources": resource_manager.get_all_resources(),
		"government": government_system.get_government_summary(),
		"factions": faction_system.get_faction_status(),
		"population_summary": population_system.get_population_summary(),
		"event_pressures": event_system.get_pressures_summary()
	}
