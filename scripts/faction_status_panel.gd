extends PanelContainer
class_name FactionStatusPanel

# Visual panel showing faction loyalty, satisfaction, and coup risk

var faction_system: FactionSystem
var government_system: GovernmentSystem

@onready var container = VBoxContainer.new()

var faction_display_items: Dictionary = {}

class FactionDisplay:
	var faction_name: String
	var loyalty_bar: ProgressBar
	var satisfaction_bar: ProgressBar
	var coup_risk_label: Label
	
	func _init(name: String):
		faction_name = name

func _ready():
	setup_panel()

func setup_panel():
	"""Setup the visual panel"""
	var title = Label.new()
	title.text = "FACTION STATUS"
	title.add_theme_font_size_override("font_size", 16)
	container.add_child(title)
	
	var separator = HSeparator.new()
	container.add_child(separator)
	
	# Create display for each faction
	if faction_system:
		for faction_id in faction_system.factions:
			var faction = faction_system.factions[faction_id]
			
			var faction_name = faction.get("name", faction_id)
			var faction_label = Label.new()
			faction_label.text = faction_name
			faction_label.add_theme_font_size_override("font_size", 12)
			faction_label.hint_tooltip = "Faction: %s — click for details" % faction.get("name", faction_id)
			container.add_child(faction_label)
		
			# Loyalty bar
			var loyalty_bar = ProgressBar.new()
			loyalty_bar.min_value = 0
			loyalty_bar.max_value = 100
			loyalty_bar.value = faction.get("loyalty", 0.5) * 100
			loyalty_bar.show_percentage = true
			loyalty_bar.hint_tooltip = "Current loyalty (higher = less likely to coup)."
			container.add_child(loyalty_bar)
		
			# Satisfaction bar
			var satisfaction_bar = ProgressBar.new()
			satisfaction_bar.min_value = 0
			satisfaction_bar.max_value = 100
			satisfaction_bar.value = faction.get("satisfaction", 0.5) * 100
			satisfaction_bar.show_percentage = true
			satisfaction_bar.hint_tooltip = "Satisfaction affects population behaviour and support for government."
			container.add_child(satisfaction_bar)
		
			# Coup risk label
			var coup_risk = faction_system.calculate_coup_risk(faction_id)
			var coup_label = Label.new()
			coup_label.text = "Coup Risk: %.0f%%" % (coup_risk * 100)
			coup_label.hint_tooltip = "Estimated coup probability based on loyalty, power and current policies."
			var color = Color.RED if coup_risk > 0.7 else Color.YELLOW if coup_risk > 0.4 else Color.GREEN
			coup_label.add_theme_color_override("font_color", color)
			container.add_child(coup_label)
			
			# Store display
			var display = FactionDisplay.new(faction_name)
			display.loyalty_bar = loyalty_bar
			display.satisfaction_bar = satisfaction_bar
			display.coup_risk_label = coup_label
			faction_display_items[faction_id] = display
			
			# Separator between factions
			container.add_child(HSeparator.new())
	
	add_child(container)

func update_display():
	"""Update faction information"""
	if not faction_system:
		return
	
	for faction_id in faction_display_items:
		var faction = faction_system.factions.get(faction_id)
		if not faction:
			continue
		
		var display = faction_display_items[faction_id]
		
		# Update bars
		display.loyalty_bar.value = faction.get("loyalty", 0.5) * 100
		display.satisfaction_bar.value = faction.get("satisfaction", 0.5) * 100
		
		# Update coup risk
		var coup_risk = faction_system.calculate_coup_risk(faction_id)
		display.coup_risk_label.text = "Coup Risk: %.0f%%" % (coup_risk * 100)
		var color = Color.RED if coup_risk > 0.7 else Color.YELLOW if coup_risk > 0.4 else Color.GREEN
		display.coup_risk_label.add_theme_color_override("font_color", color)

func get_faction_summary() -> Array:
	"""Return summary of all factions"""
	var summary = []
	
	if faction_system:
		for faction_id in faction_system.factions:
			var faction = faction_system.factions[faction_id]
			var coup_risk = faction_system.calculate_coup_risk(faction_id)
			
			summary.append({
				"name": faction.get("name", faction_id),
				"loyalty": "%.0f%%" % (faction.get("loyalty", 0.5) * 100),
				"satisfaction": "%.0f%%" % (faction.get("satisfaction", 0.5) * 100),
				"power": "%.0f%%" % (faction.get("power", 0.5) * 100),
				"coup_risk": "%.0f%%" % (coup_risk * 100),
				"status": "CRITICAL" if coup_risk > 0.7 else "WARNING" if coup_risk > 0.4 else "OK"
			})
	
	return summary

func print_faction_status():
	"""Print faction status to console"""
	print("\n=== FACTION STATUS ===")
	for item in get_faction_summary():
		print("%s:" % item["name"])
		print("  Loyalty: %s | Satisfaction: %s" % [item["loyalty"], item["satisfaction"]])
		print("  Power: %s | Coup Risk: %s (%s)" % [item["power"], item["coup_risk"], item["status"]])
	print("======================\n")
