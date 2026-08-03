extends PanelContainer
class_name GovernmentEffectsPanel

# Show how current government affects all game systems

var government_system: GovernmentSystem
var faction_system: FactionSystem

@onready var container = VBoxContainer.new()

func _ready():
	setup_panel()

func setup_panel():
	"""Setup the government effects display"""
	var title = Label.new()
	title.text = "GOVERNMENT: %s" % government_system.get_government_name()
	title.add_theme_font_size_override("font_size", 16)
	container.add_child(title)
	
	var separator = HSeparator.new()
	container.add_child(separator)
	
	# Get all modifiers
	var research_mod = government_system.get_research_modifier()
	var military_mod = government_system.get_military_modifier()
	var corruption = government_system.corruption_level
	var liberties = government_system.get_civil_liberties()
	
	# Display modifiers
	var research_label = Label.new()
	research_label.text = "Research Speed: x%.2f" % research_mod
	research_label.add_theme_color_override("font_color", Color.CYAN if research_mod > 1.0 else Color.RED)
	research_label.hint_tooltip = "Modifier applied to research speed by this government."
	container.add_child(research_label)
	
	var military_label = Label.new()
	military_label.text = "Military Strength: x%.2f" % military_mod
	military_label.add_theme_color_override("font_color", Color.CYAN if military_mod > 1.0 else Color.RED)
	military_label.hint_tooltip = "Modifier applied to military effectiveness and recruitment."
	container.add_child(military_label)
	
	var corruption_label = Label.new()
	corruption_label.text = "Corruption: %.0f%%" % (corruption * 100)
	corruption_label.add_theme_color_override("font_color", Color.RED if corruption > 0.3 else Color.YELLOW if corruption > 0.1 else Color.GREEN)
	corruption_label.hint_tooltip = "Estimated corruption level; higher values leak resources."
	container.add_child(corruption_label)
	
	var liberties_label = Label.new()
	liberties_label.text = "Civil Liberties: %.0f%%" % (liberties * 100)
	liberties_label.add_theme_color_override("font_color", Color.GREEN if liberties > 0.7 else Color.YELLOW if liberties > 0.3 else Color.RED)
	liberties_label.hint_tooltip = "Civil liberties affect dissent, productivity, and legitimacy."
	container.add_child(liberties_label)
	
	container.add_child(HSeparator.new())
	
	# Faction satisfaction with this government
	var factions_label = Label.new()
	factions_label.text = "Faction Satisfaction:"
	factions_label.add_theme_font_size_override("font_size", 11)
	container.add_child(factions_label)
	
	if faction_system:
		var gov_data = government_system.governments[government_system.current_government]
		var faction_modifiers = gov_data.get("faction_satisfaction_modifiers", {})
		
		for faction_id in faction_system.factions:
			var faction = faction_system.factions[faction_id]
			var faction_name = faction.get("name", faction_id)
			var mod = faction_modifiers.get(faction_id, 0)
			
			var faction_label = Label.new()
			var mod_text = "+" if mod > 0 else ""
			faction_label.text = "  %s: %s%.2f" % [faction_name, mod_text, mod]
			faction_label.add_theme_color_override("font_color", Color.GREEN if mod > 0 else Color.RED if mod < 0 else Color.GRAY)
			container.add_child(faction_label)
	
	container.add_child(HSeparator.new())
	
	# Government description
	var desc = Label.new()
	var gov_data = government_system.governments[government_system.current_government]
	desc.text = gov_data.get("description", "No description")
	desc.add_theme_font_size_override("font_size", 9)
	container.add_child(desc)
	
	add_child(container)

func get_government_effects() -> Dictionary:
	"""Get all effects of current government"""
	return {
		"name": government_system.get_government_name(),
		"research_modifier": government_system.get_research_modifier(),
		"military_modifier": government_system.get_military_modifier(),
		"corruption": government_system.corruption_level,
		"civil_liberties": government_system.get_civil_liberties(),
		"legitimacy": government_system.legitimacy
	}

func get_best_government_for(goal: String) -> String:
	"""Recommend government based on goal"""
	match goal:
		"research":
			return "meritocracy"  # Highest research bonus
		"military":
			return "fascism"  # Highest military bonus
		"happiness":
			return "democracy"  # Best civil liberties
		"stability":
			return "monarchy"  # Balanced
		_:
			return "tribal"
	
	return "tribal"

func print_government_status():
	"""Print government effects to console"""
	var effects = get_government_effects()
	
	print("\n=== GOVERNMENT STATUS ===")
	print("Type: %s" % effects["name"])
	print("Research Speed: x%.2f" % effects["research_modifier"])
	print("Military Strength: x%.2f" % effects["military_modifier"])
	print("Corruption: %.0f%%" % (effects["corruption"] * 100))
	print("Civil Liberties: %.0f%%" % (effects["civil_liberties"] * 100))
	print("Legitimacy: %.0f%%" % (effects["legitimacy"] * 100))
	print("==========================\n")

func recommend_government_change():
	"""Suggest government change based on current situation"""
	var suggestions = []
	
	var effects = get_government_effects()
	
	# If corruption too high
	if effects["corruption"] > 0.5:
		suggestions.append("High corruption - consider democracy or meritocracy")
	
	# If legitimacy too low
	if effects["legitimacy"] < 0.3:
		suggestions.append("Low legitimacy - consider changing to democracy or monarchy")
	
	# If at war and weak military
	# Would need combat_system reference here
	
	return suggestions
