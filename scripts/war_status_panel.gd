extends PanelContainer
class_name WarStatusPanel

# Visual panel showing active wars and military status

var combat_system: CombatSystem
var unit_system: UnitSystem

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
		var strength_label = Label.new()
		strength_label.text = "Military Strength: %.0f" % unit_system.get_total_military_strength(1.0)
		container.add_child(strength_label)
		
		# Trained units
		var units_label = Label.new()
		units_label.text = "Trained Units: %d" % unit_system.get_trained_units_count()
		container.add_child(units_label)
		
		# War status
		container.add_child(HSeparator.new())
		
		if combat_system.is_at_war():
			var war_label = Label.new()
			war_label.text = "STATUS: AT WAR"
			war_label.add_theme_color_override("font_color", Color.RED)
			war_label.add_theme_font_size_override("font_size", 12)
			container.add_child(war_label)
			
			# War details
			if combat_system.wars.size() > 0:
				var war = combat_system.wars[0]
				
				var vs_label = Label.new()
				vs_label.text = "vs. %s (enemy strength: %.0f)" % [
					war.get("enemy_name", "Unknown"),
					war.get("enemy_strength", 0)
				]
				container.add_child(vs_label)
				
				var duration_label = Label.new()
				duration_label.text = "Duration: %.1f seconds" % war.get("duration", 0)
				container.add_child(duration_label)
				
				var casualties_label = Label.new()
				casualties_label.text = "Our Casualties: %d | Enemy Casualties: %d" % [
					war.get("our_casualties", 0),
					war.get("enemy_casualties", 0)
				]
				casualties_label.add_theme_color_override("font_color", Color.YELLOW)
				container.add_child(casualties_label)
		else:
			var peace_label = Label.new()
			peace_label.text = "STATUS: PEACE"
			peace_label.add_theme_color_override("font_color", Color.GREEN)
			peace_label.add_theme_font_size_override("font_size", 12)
			container.add_child(peace_label)
	
	add_child(container)

func update_display():
	"""Update war information"""
	if combat_system and unit_system:
		container.queue_free()
		container = VBoxContainer.new()
		setup_panel()

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
