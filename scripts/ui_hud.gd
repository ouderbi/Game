extends Control
class_name UIHUD

# HUD for displaying game information

@onready var era_label = %EraLabel
@onready var population_label = %PopulationLabel
@onready var government_label = %GovernmentLabel
@onready var legitimacy_label = %LegitimacyLabel
@onready var morale_label = %MoraleLabel
@onready var happiness_label = %HappinessLabel

@onready var food_label = %FoodLabel
@onready var wood_label = %WoodLabel
@onready var stone_label = %StoneLabel

var game_world: GameWorld

func _ready():
	game_world = get_parent().get_parent()  # Navigate up to GameWorld
	
	# Connect to updates
	if game_world and game_world.era_manager:
		game_world.era_manager.era_changed.connect(_on_era_changed)
	
	if game_world and game_world.population_system:
		game_world.population_system.population_changed.connect(_on_population_changed)
		game_world.population_system.morale_changed.connect(_on_morale_changed)
		game_world.population_system.happiness_changed.connect(_on_happiness_changed)
	
	if game_world and game_world.government_system:
		game_world.government_system.legitimacy_changed.connect(_on_legitimacy_changed)
	
	if game_world and game_world.resource_manager:
		game_world.resource_manager.resource_changed.connect(_on_resource_changed)

func _process(_delta):
	if not game_world:
		return
	
	# Update display every frame
	update_display()

func update_display():
	if not game_world:
		return
	
	# Era
	if game_world.era_manager:
		era_label.text = "Era: " + game_world.era_manager.get_era_name()
	
	# Government
	if game_world.government_system:
		government_label.text = "Government: " + game_world.government_system.get_government_name()
	
	# Population
	if game_world.population_system:
		population_label.text = "Population: " + str(game_world.population_system.total_population)
		morale_label.text = "Morale: %.0f%%" % (game_world.population_system.morale * 100)
		happiness_label.text = "Happiness: %.0f%%" % (game_world.population_system.happiness * 100)
	
	# Government
	if game_world.government_system:
		legitimacy_label.text = "Legitimacy: %.0f%%" % (game_world.government_system.legitimacy * 100)
	
	# Resources
	if game_world.resource_manager:
		food_label.text = "Food: " + str(game_world.resource_manager.get_resource_amount("food"))
		wood_label.text = "Wood: " + str(game_world.resource_manager.get_resource_amount("wood"))
		stone_label.text = "Stone: " + str(game_world.resource_manager.get_resource_amount("stone"))

func _on_era_changed(era_id: String):
	era_label.text = "Era: " + game_world.era_manager.get_era_name()

func _on_population_changed(new_population: int):
	population_label.text = "Population: " + str(new_population)

func _on_morale_changed(new_morale: float):
	morale_label.text = "Morale: %.0f%%" % (new_morale * 100)

func _on_happiness_changed(new_happiness: float):
	happiness_label.text = "Happiness: %.0f%%" % (new_happiness * 100)

func _on_legitimacy_changed(new_legitimacy: float):
	legitimacy_label.text = "Legitimacy: %.0f%%" % (new_legitimacy * 100)

func _on_resource_changed(resource_name: String, new_amount: int):
	match resource_name:
		"food":
			food_label.text = "Food: " + str(new_amount)
		"wood":
			wood_label.text = "Wood: " + str(new_amount)
		"stone":
			stone_label.text = "Stone: " + str(new_amount)
