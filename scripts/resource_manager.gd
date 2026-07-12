extends Node
class_name ResourceManager

# Manages civilization resources and economy

signal resource_changed(resource_name: String, new_amount: int)
signal resource_depleted(resource_name: String)

var resources: Dictionary = {
	# Stone Age
	"food": 100,
	"wood": 50,
	"stone": 30,
	
	# Bronze Age onwards
	"copper": 0,
	"bronze": 0,
	"iron": 0,
	"gold": 0,
	"salt": 0,
	"wheat": 0,
	
	# Medieval
	"coal": 0,
	"ore": 0,
	
	# Industrial
	"steel": 0,
	"cotton": 0,
	"power": 0,
	
	# Modern
	"oil": 0,
	"rubber": 0,
	"concrete": 0,
	
	# Atomic
	"uranium": 0,
	"silicon": 0,
	"cobalt": 0,
	
	# Information
	"rare_earth": 0,
	"synthetic_dna": 0,
	"data": 0,
	"robots": 0,
	
	# Space
	"helium3": 0,
	"rare_metals_asteroid": 0,
	"cosmic_water": 0,
	"titanium": 0,
	
	# Intergalactic
	"pure_energy": 0,
	"exotic_matter": 0,
	"quantum_calculations": 0
}

# Storage capacity per resource type
var storage_capacity: Dictionary = {}
var max_total_storage: int = 1000

# Production/consumption rates
var production_rates: Dictionary = {}
var consumption_rates: Dictionary = {}

func _ready():
	initialize_storage()
	initialize_rates()

func initialize_storage():
	for resource in resources.keys():
		storage_capacity[resource] = max_total_storage

func initialize_rates():
	for resource in resources.keys():
		production_rates[resource] = 0.0
		consumption_rates[resource] = 0.0

func add_resource(resource_name: String, amount: int) -> int:
	if resource_name not in resources:
		push_error("Unknown resource: ", resource_name)
		return 0
	
	var new_amount = resources[resource_name] + amount
	new_amount = clamp(new_amount, 0, storage_capacity.get(resource_name, max_total_storage))
	resources[resource_name] = new_amount
	resource_changed.emit(resource_name, new_amount)
	return new_amount

func remove_resource(resource_name: String, amount: int) -> bool:
	if resource_name not in resources:
		push_error("Unknown resource: ", resource_name)
		return false
	
	if resources[resource_name] >= amount:
		resources[resource_name] -= amount
		resource_changed.emit(resource_name, resources[resource_name])
		
		if resources[resource_name] == 0:
			resource_depleted.emit(resource_name)
		return true
	return false

func has_resources(cost: Dictionary) -> bool:
	for resource_name in cost:
		if resources.get(resource_name, 0) < cost[resource_name]:
			return false
	return true

func pay_cost(cost: Dictionary) -> bool:
	if not has_resources(cost):
		return false
	
	for resource_name in cost:
		remove_resource(resource_name, cost[resource_name])
	return true

func get_resource_amount(resource_name: String) -> int:
	return resources.get(resource_name, 0)

func get_all_resources() -> Dictionary:
	return resources.duplicate()

func set_production_rate(resource_name: String, rate: float):
	if resource_name in resources:
		production_rates[resource_name] = rate

func set_consumption_rate(resource_name: String, rate: float):
	if resource_name in resources:
		consumption_rates[resource_name] = rate

func update_production(delta_time: float):
	for resource_name in production_rates:
		var net_rate = production_rates[resource_name] - consumption_rates.get(resource_name, 0.0)
		if net_rate != 0:
			add_resource(resource_name, int(net_rate * delta_time))

func get_storage_used() -> int:
	var used = 0
	for resource_name in resources:
		used += resources[resource_name]
	return used

func get_storage_percentage() -> float:
	var used = get_storage_used()
	var max_storage = max_total_storage * resources.size()
	return float(used) / max_storage

# Debug: Add resources via cheat console
func cheat_add_resources(resource_name: String, amount: int):
	add_resource(resource_name, amount)
	print("Cheated: Added ", amount, " of ", resource_name)

func cheat_fill_all_resources(amount: int = 500):
	for resource_name in resources:
		resources[resource_name] = amount
		resource_changed.emit(resource_name, amount)
	print("Cheated: Filled all resources with ", amount)
