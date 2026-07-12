extends Node
class_name EventSystem

# Procedural event generation based on accumulated pressures
# Events emerge from state, never from pure randomness

signal event_triggered(event_data: Dictionary)
signal event_resolved(event_id: String)

# Pressure thresholds (0 to 1)
const PRESSURE_THRESHOLD_BASE = 0.65

var pressures: Dictionary = {
	"pandemic": 0.0,
	"war": 0.0,
	"famine": 0.0,
	"revolt": 0.0,
	"plague": 0.0,
	"economic_collapse": 0.0,
	"nuclear_war": 0.0,
	"diplomatic_crisis": 0.0,
	"technological_explosion": 0.0,
	"cultural_shift": 0.0
}

var active_events: Array[Dictionary] = []
var pressure_history: Dictionary = {}

func _ready():
	initialize_pressure_history()

func initialize_pressure_history():
	for pressure_type in pressures.keys():
		pressure_history[pressure_type] = []

func update_pressures(world_state: Dictionary, delta_time: float):
	# Pandemic pressure rises with: density + poor sanitation + trade + refugees
	var population = world_state.get("population", 0)
	var sanitation_level = world_state.get("sanitation", 0.5)
	var trade_routes = world_state.get("trade_routes", 0)
	pressures["pandemic"] += (population * 0.001 * (1.0 - sanitation_level) + trade_routes * 0.05) * delta_time
	
	# War pressure rises with: militarization + hostility + warmongering leader + resources
	var military_strength = world_state.get("military_strength", 0)
	var hostility_level = world_state.get("hostility_with_neighbors", 0.5)
	var leader_belligerence = world_state.get("leader_belligerence", 0.0)
	pressures["war"] += (military_strength * 0.0001 + hostility_level * 0.1 + leader_belligerence * 0.15) * delta_time
	
	# Famine pressure rises with: low production + war + disaster + drought
	var production = world_state.get("food_production", 100)
	var consumption = world_state.get("food_consumption", 80)
	var is_at_war = world_state.get("is_at_war", false)
	pressures["famine"] += max(0.0, ((consumption - production) / consumption) + (0.2 if is_at_war else 0.0)) * delta_time
	
	# Revolt pressure rises with: inequality + repression + low legitimacy + low morale
	var inequality = world_state.get("inequality", 0.5)
	var repression_level = world_state.get("repression", 0.0)
	var legitimacy = world_state.get("legitimacy", 0.5)
	var morale = world_state.get("morale", 0.5)
	pressures["revolt"] += (inequality * 0.1 + repression_level * 0.15 + (1.0 - legitimacy) * 0.1 + (1.0 - morale) * 0.1) * delta_time
	
	# Economic collapse pressure rises with: inflation + debt + corruption + declining GDP
	var inflation_rate = world_state.get("inflation", 0.0)
	var debt_ratio = world_state.get("debt_ratio", 0.0)
	var corruption = world_state.get("corruption", 0.0)
	pressures["economic_collapse"] += (inflation_rate * 0.1 + max(0.0, debt_ratio - 0.5) * 0.1 + corruption * 0.05) * delta_time
	
	# Nuclear war (only in modern era+)
	if world_state.get("era", "") in ["atomic", "information", "space", "intergalactic"]:
		var nuclear_stockpile = world_state.get("nuclear_weapons", 0)
		pressures["nuclear_war"] += (nuclear_stockpile * 0.001 + hostility_level * 0.15) * delta_time
	
	# Clamp all pressures
	for pressure_type in pressures:
		pressures[pressure_type] = clamp(pressures[pressure_type], 0.0, 1.0)

func check_and_trigger_events(world_state: Dictionary) -> Array[Dictionary]:
	var triggered: Array[Dictionary] = []
	
	for pressure_type in pressures.keys():
		var threshold = PRESSURE_THRESHOLD_BASE + randf_range(-0.1, 0.05)
		
		if pressures[pressure_type] > threshold:
			var event = create_event(pressure_type, world_state, pressures[pressure_type])
			if event:
				triggered.append(event)
				active_events.append(event)
				event_triggered.emit(event)
				# Reset pressure after event triggers
				pressures[pressure_type] *= 0.3
	
	return triggered

func create_event(event_type: String, world_state: Dictionary, pressure_value: float) -> Dictionary:
	match event_type:
		"pandemic":
			return {
				"id": "pandemic_" + str(randi()),
				"type": "pandemic",
				"severity": clamp(pressure_value * 1.5, 0.3, 1.0),
				"affected_population_pct": randf_range(0.1, 0.5),
				"duration_years": randi_range(3, 10),
				"description": "A pandemic sweeps through your lands"
			}
		"war":
			return {
				"id": "war_" + str(randi()),
				"type": "war",
				"severity": clamp(pressure_value * 1.2, 0.3, 1.0),
				"enemy": world_state.get("random_rival", "Unknown Enemy"),
				"duration_years": randi_range(2, 8),
				"description": "War has been declared!"
			}
		"famine":
			return {
				"id": "famine_" + str(randi()),
				"type": "famine",
				"severity": clamp(pressure_value, 0.3, 1.0),
				"affected_population_pct": randf_range(0.2, 0.8),
				"duration_years": randi_range(1, 5),
				"description": "Famine strikes your lands"
			}
		"revolt":
			return {
				"id": "revolt_" + str(randi()),
				"type": "revolt",
				"severity": clamp(pressure_value, 0.3, 1.0),
				"rebel_strength": randf_range(0.2, 0.7),
				"duration_years": randi_range(1, 4),
				"description": "The people have risen in rebellion!"
			}
		"economic_collapse":
			return {
				"id": "econ_" + str(randi()),
				"type": "economic_collapse",
				"severity": clamp(pressure_value, 0.3, 1.0),
				"gdp_loss_pct": randf_range(0.1, 0.5),
				"duration_years": randi_range(2, 6),
				"description": "Your economy has collapsed"
			}
		"nuclear_war":
			return {
				"id": "nuclear_" + str(randi()),
				"type": "nuclear_war",
				"severity": 1.0,
				"damage_radius": randf_range(500, 2000),
				"survivors_pct": randf_range(0.0, 0.3),
				"description": "Nuclear weapons have been deployed!",
				"is_catastrophic": true
			}
	
	return {}

func resolve_event(event_id: String):
	var event_index = -1
	for i in range(active_events.size()):
		if active_events[i]["id"] == event_id:
			event_index = i
			break
	
	if event_index >= 0:
		active_events.remove_at(event_index)
		event_resolved.emit(event_id)

func get_pressures_summary() -> Dictionary:
	return pressures.duplicate()

func apply_event_consequences(event: Dictionary, world_state: Dictionary) -> Dictionary:
	var consequences = {}
	
	match event.get("type"):
		"pandemic":
			consequences["population_loss"] = world_state.get("population", 0) * event["affected_population_pct"] * event["severity"]
			consequences["morale_change"] = -0.3
			consequences["economy_change"] = -0.2
		"war":
			consequences["military_casualties"] = 0.15 * event["severity"]
			consequences["economic_cost"] = 0.2 * event["severity"]
			consequences["morale_change"] = -0.2 if world_state.get("is_winning", false) else -0.5
		"famine":
			consequences["population_loss"] = world_state.get("population", 0) * event["affected_population_pct"]
			consequences["morale_change"] = -0.4
			consequences["legitimacy_change"] = -0.3
		"revolt":
			consequences["authority_loss"] = event["rebel_strength"] * event["severity"]
			consequences["military_engagement"] = true
			consequences["morale_change"] = -0.3
		"economic_collapse":
			consequences["gdp_loss"] = world_state.get("gdp", 100) * event["gdp_loss_pct"]
			consequences["unemployment_rise"] = 0.2
			consequences["morale_change"] = -0.5
		"nuclear_war":
			consequences["total_population_loss"] = world_state.get("population", 0) * (1.0 - event["survivors_pct"])
			consequences["civilization_damage"] = 0.7
			consequences["is_existential"] = true
	
	return consequences
