extends Node
class_name PopulationSystem

# Population system with emergent human nature:
# - People are sometimes irrational (panic, herd behavior)
# - Morale, happiness, and sentiment emerge from systemic factors
# - Class divisions and inequality drive social tension

signal population_changed(new_population: int)
signal morale_changed(new_morale: float)
signal happiness_changed(new_happiness: float)
signal class_tension_increased(tension_level: float)

var total_population: int = 1000
var population_classes: Dictionary = {
	"peasants": 700,    # farmers, laborers
	"artisans": 150,    # craftspeople, merchants
	"soldiers": 80,     # military
	"nobles": 40,       # ruling class
	"slaves": 0         # unlocked in certain governments/eras
}

var morale: float = 0.5
var happiness: float = 0.5
var food_satisfaction: float = 0.5
var freedom_satisfaction: float = 0.7
var wealth_satisfaction: float = 0.4

# Societal measures
var inequality_index: float = 0.5  # 0 = equal, 1 = extreme inequality
var sentiment: String = "neutral"  # hopeful, neutral, anxious, desperate

func _ready():
	recalculate_population()

func recalculate_population():
	total_population = 0
	for class_name in population_classes:
		total_population += population_classes[class_name]

func update_population(delta_time: float, world_state: Dictionary):
	"""Update population based on birth/death rates and migration"""
	var birth_rate = 0.03  # Base 3% growth
	var death_rate = 0.01  # Base 1% death
	
	# Modify birth rate based on happiness
	birth_rate *= happiness
	
	# Increase death rate from disease/war/famine
	if world_state.get("is_plagued", false):
		death_rate += 0.05
	if world_state.get("is_at_war", false):
		death_rate += 0.03
	if world_state.get("food_shortage", 0) > 0:
		death_rate += world_state["food_shortage"] * 0.1
	
	# Migration (people leave if very unhappy)
	var emigration_rate = 0.0
	if happiness < 0.2:
		emigration_rate = 0.02  # 2% population loss
	
	var net_growth = (birth_rate - death_rate - emigration_rate)
	total_population = int(total_population * (1.0 + net_growth * delta_time))
	
	# Minimum population (can't reach zero, but can collapse)
	if total_population < 50:
		total_population = 50
	
	population_changed.emit(total_population)
	recalculate_population()

func update_morale(delta_time: float, events: Array, government_type: String):
	"""Morale updates from events and systemic factors"""
	var base_change = 0.0
	
	# Peace and stability boost morale
	if events.is_empty():
		base_change += 0.01
	
	# Food availability
	if food_satisfaction > 0.7:
		base_change += 0.02
	else:
		base_change -= (1.0 - food_satisfaction) * 0.03
	
	# Freedom matters
	var freedom_bonus = freedom_satisfaction * 0.02
	base_change += freedom_bonus
	
	# War drastically reduces morale
	# (handled in event system)
	
	# Victories boost morale
	# (handled in military system)
	
	morale = clamp(morale + base_change * delta_time, 0.0, 1.0)
	morale_changed.emit(morale)

func update_happiness(delta_time: float, resources: ResourceManager, government_system: GovernmentSystem):
	"""Happiness is weighted combination of satisfaction metrics"""
	var weights = {
		"food": 0.35,
		"wealth": 0.25,
		"freedom": 0.25,
		"safety": 0.15
	}
	
	# Food satisfaction
	var food_available = resources.get_resource_amount("food")
	var consumption = total_population * 0.1  # Each person needs 0.1 food/tick
	food_satisfaction = clamp(float(food_available) / consumption, 0.0, 1.0)
	
	# Wealth satisfaction (average wealth per capita)
	var total_wealth = 0
	for resource_name in resources.resources:
		total_wealth += resources.resources[resource_name]
	var wealth_per_capita = float(total_wealth) / (total_population + 1)
	wealth_satisfaction = clamp(wealth_per_capita / 100.0, 0.0, 1.0)
	
	# Freedom satisfaction (inverse of government repression)
	freedom_satisfaction = government_system.get_civil_liberties()
	
	# Safety satisfaction (inverse of ongoing conflicts)
	# (set by event system)
	
	# Calculate weighted happiness
	happiness = (
		food_satisfaction * weights["food"] +
		wealth_satisfaction * weights["wealth"] +
		freedom_satisfaction * weights["freedom"]
	)
	
	# Happiness decays if nothing is improving (people get restless)
	if morale < 0.3:
		happiness -= 0.01
	
	happiness = clamp(happiness, 0.0, 1.0)
	happiness_changed.emit(happiness)
	
	update_sentiment()

func update_sentiment():
	"""Sentiment is driven by trend in happiness"""
	if happiness > 0.7 and morale > 0.7:
		sentiment = "hopeful"
	elif happiness < 0.3 and morale < 0.3:
		sentiment = "desperate"
	elif happiness < 0.4:
		sentiment = "anxious"
	else:
		sentiment = "neutral"

func calculate_inequality():
	"""Calculate Gini-like inequality index"""
	# Simplified: ratio of nobles wealth to peasant wealth
	var noble_wealth = population_classes["nobles"] * 50  # Nobles are richer
	var peasant_wealth = population_classes["peasants"] * 1
	inequality_index = min(1.0, noble_wealth / max(1, peasant_wealth))
	
	if inequality_index > 0.7:
		class_tension_increased.emit(inequality_index)

func apply_class_migration(government_type: String):
	"""Some government types create or eliminate classes"""
	match government_type:
		"communism":
			# Communism tries to reduce class divisions
			var avg_pop = (population_classes["peasants"] + population_classes["artisans"] + population_classes["soldiers"]) / 3
			population_classes["peasants"] = avg_pop
			population_classes["artisans"] = avg_pop
			population_classes["nobles"] = avg_pop / 2
			population_classes["slaves"] = 0
		
		"fascism":
			# Fascism intensifies hierarchy and militarism
			population_classes["soldiers"] = int(population_classes["soldiers"] * 1.3)
			population_classes["nobles"] = int(population_classes["nobles"] * 1.2)
			population_classes["peasants"] = int(population_classes["peasants"] * 0.9)
		
		"democracy":
			# Democracy equalizes
			var total = total_population
			population_classes["peasants"] = int(total * 0.6)
			population_classes["artisans"] = int(total * 0.25)
			population_classes["soldiers"] = int(total * 0.08)
			population_classes["nobles"] = int(total * 0.07)

func apply_plague_casualties(severity: float):
	"""Plague kills proportionally across all classes"""
	for class_name in population_classes:
		population_classes[class_name] = int(population_classes[class_name] * (1.0 - severity * 0.3))
	recalculate_population()

func apply_war_casualties(severity: float, enemy_strength: float):
	"""War mostly kills soldiers, but can affect everyone"""
	population_classes["soldiers"] = int(population_classes["soldiers"] * (1.0 - severity * 0.5))
	
	# Collateral damage
	var collateral = int(total_population * severity * 0.1)
	population_classes["peasants"] = max(10, population_classes["peasants"] - collateral)
	
	recalculate_population()

func apply_famine_casualties(severity: float, duration: int):
	"""Famine kills the poor first"""
	var peasant_loss = int(population_classes["peasants"] * severity * 0.3 * duration)
	population_classes["peasants"] = max(10, population_classes["peasants"] - peasant_loss)
	
	# Nobles are protected but lose morale
	recalculate_population()

func apply_revolution(success: bool):
	"""Revolution reshapes class structure"""
	if success:
		# Successful revolution kills many nobles
		population_classes["nobles"] = int(population_classes["nobles"] * 0.3)
		population_classes["peasants"] = int(population_classes["peasants"] * 1.1)
		happiness = 0.8  # People hopeful after success
	else:
		# Failed revolution crushes commoners
		population_classes["peasants"] = int(population_classes["peasants"] * 0.8)
		happiness = 0.2
	
	recalculate_population()

func get_population_summary() -> Dictionary:
	return {
		"total": total_population,
		"by_class": population_classes.duplicate(),
		"morale": morale,
		"happiness": happiness,
		"sentiment": sentiment,
		"inequality": inequality_index,
		"food_satisfaction": food_satisfaction,
		"wealth_satisfaction": wealth_satisfaction,
		"freedom_satisfaction": freedom_satisfaction
	}

func get_labor_force() -> int:
	"""Effective labor force (peasants + artisans, minus soldiers)"""
	return population_classes["peasants"] + population_classes["artisans"]

func get_military_potential() -> int:
	"""Potential soldiers that can be recruited"""
	var max_soldiers = int(total_population * 0.15)  # Max 15% can be soldiers
	return max_soldiers - population_classes["soldiers"]
