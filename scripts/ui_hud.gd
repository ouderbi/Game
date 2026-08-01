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
var war_active: bool = false

# Dynamic UI panels
var faction_panel: FactionStatusPanel
var war_panel: WarStatusPanel
var building_browser_panel: BuildingBrowserPanel
var government_effects_panel: GovernmentEffectsPanel

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
	
	# Instantiate and configure additional UI panels (right side)
	# Faction status
	faction_panel = preload("res://scripts/faction_status_panel.gd").new()
	faction_panel.faction_system = game_world.faction_system
	faction_panel.government_system = game_world.government_system
	faction_panel.anchor_left = 0.74
	faction_panel.anchor_top = 0.02
	faction_panel.anchor_right = 0.98
	faction_panel.anchor_bottom = 0.36
	add_child(faction_panel)
	
	# War status
	war_panel = preload("res://scripts/war_status_panel.gd").new()
	war_panel.combat_system = game_world.combat_system
	war_panel.unit_system = game_world.unit_system
	war_panel.anchor_left = 0.74
	war_panel.anchor_top = 0.38
	war_panel.anchor_right = 0.98
	war_panel.anchor_bottom = 0.62
	add_child(war_panel)
	
	# Building browser
	building_browser_panel = preload("res://scripts/building_browser_panel.gd").new()
	building_browser_panel.building_system = game_world.building_system
	building_browser_panel.era_manager = game_world.era_manager
	building_browser_panel.resource_manager = game_world.resource_manager
	building_browser_panel.anchor_left = 0.74
	building_browser_panel.anchor_top = 0.64
	building_browser_panel.anchor_right = 0.98
	building_browser_panel.anchor_bottom = 0.95
	add_child(building_browser_panel)
	
	# Government effects
	government_effects_panel = preload("res://scripts/government_effects_panel.gd").new()
	government_effects_panel.government_system = game_world.government_system
	government_effects_panel.faction_system = game_world.faction_system
	government_effects_panel.anchor_left = 0.49
	government_effects_panel.anchor_top = 0.64
	government_effects_panel.anchor_right = 0.73
	government_effects_panel.anchor_bottom = 0.95
	add_child(government_effects_panel)

func _process(_delta):
	if not game_world:
		return
	
	# Update display every frame
	update_display()
	
	# Update dynamic panels
	if faction_panel:
		faction_panel.update_display()
	if war_panel:
		war_panel.update_display()
	if building_browser_panel:
		# building browser is heavier; update less frequently could be considered
		building_browser_panel.print_building_summary()  # lightweight summary for now
	if government_effects_panel:
		# government effects are mostly static; ensure labels are current
		# recreate panel when government changes would be better; refresh here
		# Call print for debug summary
		government_effects_panel.print_government_status()

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
	
	# Military & War
	if game_world.unit_system:
		var trained = game_world.unit_system.get_trained_units_count()
		var strength = game_world.unit_system.get_total_military_strength(game_world.government_system.get_military_modifier())
		var war_status = " (AT WAR!)" if game_world.combat_system.is_at_war() else ""
		print_debug("Military: %d units, strength: %.0f%s" % [trained, strength, war_status])

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
