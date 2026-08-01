extends PanelContainer
class_name WarStatusPanel

# Visual panel showing active wars and military status

var combat_system: CombatSystem
var unit_system: UnitSystem

# Cached UI nodes for efficient updates
var strength_label: Label
var units_label: Label
var war_label: Label
var vs_label: Label
var duration_label: Label
var casualties_label: Label
var peace_label: Label

@onready var container = VBoxContainer.new()

func _ready():
	setup_panel()

func setup_panel():
	"""Setup the visual panel"""
	var title = Label.new()
	title.text = "MILITARY & WAR STATUS"
	title.add_theme_font_size_override("font_size", 16)
	container.add_child(title)
	
	var separator = HSeparator.new()
	container.add_child(separator)
	
	if combat_system and unit_system:
		# Military strength
		strength_label = Label.new()
		strength_label.text = "Military Strength: %.0f" % unit_system.get_total_military_strength(1.0)
		strength_label.hint_tooltip = "Total combat strength of all trained units."
		container.add_child(strength_label)
		
		# Trained units
		units_label = Label.new()
		units_label.text = "Trained Units: %d" % unit_system.get_trained_units_count()
		units_label.hint_tooltip = "Number of trained combat units ready for deployment."
		container.add_child(units_label)
		
		# War status
		container.add_child(HSeparator.new())
		
		if combat_system.is_at_war():
			war_label = Label.new()
			war_label.text = "STATUS: AT WAR"
			war_label.add_theme_color_override("font_color", Color.RED)
			war_label.add_theme_font_size_override("font_size", 12)
			war_label.hint_tooltip = "Currently at war. Click for war details."
			container.add_child(war_label)
			
			# War details
			if combat_system.wars.size() > 0:
				var war = combat_system.wars[0]
				
				vs_label = Label.new()
				vs_label.text = "vs. %s (enemy strength: %.0f)" % [
					war.get("enemy_name", "Unknown"),
					war.get("enemy_strength", 0)
				]
				vs_label.hint_tooltip = "Enemy name and estimated strength."
				container.add_child(vs_label)
				
				duration_label = Label.new()
				duration_label.text = "Duration: %.1f seconds" % war.get("duration", 0)
				duration_label.hint_tooltip = "Time the war has been active."
				container.add_child(duration_label)
				
				casualties_label = Label.new()
				casualties_label.text = "Our Casualties: %d | Enemy Casualties: %d" % [
					war.get("our_casualties", 0),
					war.get("enemy_casualties", 0)
				]
				casualties_label.add_theme_color_override("font_color", Color.YELLOW)
				casualties_label.hint_tooltip = "Casualties so far in this conflict."
				container.add_child(casualties_label)
		else:
			peace_label = Label.new()
			peace_label.text = "STATUS: PEACE"
			peace_label.add_theme_color_override("font_color", Color.GREEN)
			peace_label.add_theme_font_size_override("font_size", 12)
			peace_label.hint_tooltip = "No active wars."
			container.add_child(peace_label)
	
	add_child(container)

func update_display():
	"""Update war information efficiently without rebuilding UI"""
	if not (combat_system and unit_system):
		return
	
	# Update basic metrics
	if strength_label:
		strength_label.text = "Military Strength: %.0f" % unit_system.get_total_military_strength(1.0)
	if units_label:
		units_label.text = "Trained Units: %d" % unit_system.get_trained_units_count()
	
	# Update war details
	if combat_system.is_at_war():
		if war_label:
			war_label.visible = true
		if peace_label:
			peace_label.visible = false
		if combat_system.wars.size() > 0:
			var war = combat_system.wars[0]
			if vs_label:
				vs_label.text = "vs. %s (enemy strength: %.0f)" % [war.get("enemy_name", "Unknown"), war.get("enemy_strength", 0)]
			if duration_label:
				duration_label.text = "Duration: %.1f seconds" % war.get("duration", 0)
			if casualties_label:
				casualties_label.text = "Our Casualties: %d | Enemy Casualties: %d" % [war.get("our_casualties", 0), war.get("enemy_casualties", 0)]
	else:
		# Not at war
		if war_label:
			war_label.visible = false
		if peace_label:
			peace_label.visible = true

func get_war_summary() -> Dictionary:
	"""Get current war status"""
	var summary = {
		"is_at_war": false,
		"military_strength": 0,
		"trained_units": 0,
		"active_wars": 0,
		"total_casualties": 0
	}
	
	if combat_system and unit_system:
		summary["military_strength"] = unit_system.get_total_military_strength(1.0)
		summary["trained_units"] = unit_system.get_trained_units_count()
		summary["is_at_war"] = combat_system.is_at_war()
		summary["active_wars"] = combat_system.wars.size()
		
		for war in combat_system.wars:
			summary["total_casualties"] += war.get("our_casualties", 0)
	
	return summary

func print_war_status():
	"""Print war status to console"""
	var summary = get_war_summary()
	
	print("\n=== WAR STATUS ===")
	print("Military Strength: %.0f" % summary["military_strength"])
	print("Trained Units: %d" % summary["trained_units"])
	print("Status: %s" % ("AT WAR" if summary["is_at_war"] else "PEACE"))
	print("Active Wars: %d" % summary["active_wars"])
	print("Total Casualties: %d" % summary["total_casualties"])
	
	if combat_system and summary["active_wars"] > 0:
		for i in range(combat_system.wars.size()):
			var war = combat_system.wars[i]
			print("  War %d vs %s: Our:%d casualties, Enemy:%d casualties" % [
				i+1,
				war.get("enemy_name", "Unknown"),
				war.get("our_casualties", 0),
				war.get("enemy_casualties", 0)
			])
	
	print("==================\n")
