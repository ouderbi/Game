extends Control
class_name TechTreeUI

# Visual technology tree interface

var era_manager: EraManager
var tech_definitions: Dictionary = {}
var researched_techs: Dictionary = {}  # tech_id -> true if researched
var current_research: String = ""
var research_progress: float = 0.0

const TECH_SIZE = 60
const SPACING = 20
const ROWS = 4
const COLS = 5

func _ready():
	load_tech_definitions()

func load_tech_definitions():
	"""Load technology data"""
	var file = FileAccess.open("res://data/eras/technologies.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parsed = json.parse_string(file.get_as_text())
		if parsed and parsed.has("technologies"):
			for tech in parsed["technologies"]:
				tech_definitions[tech["id"]] = tech

func _draw():
	"""Draw technology tree"""
	if tech_definitions.is_empty():
		return
	
	var era_techs = get_techs_for_era(era_manager.current_era_id)
	
	var pos = Vector2(20, 20)
	var col = 0
	var row = 0
	
	for tech_id in era_techs:
		if col >= COLS:
			col = 0
			row += 1
		
		var tech = tech_definitions[tech_id]
		var rect = Rect2(pos + Vector2(col * (TECH_SIZE + SPACING), row * (TECH_SIZE + SPACING)), Vector2(TECH_SIZE, TECH_SIZE))
		
		# Draw background based on research status
		if tech_id in researched_techs:
			draw_rect(rect, Color.GREEN)  # Researched
		elif tech_id == current_research:
			draw_rect(rect, Color.YELLOW)  # In progress
		else:
			draw_rect(rect, Color.GRAY)  # Available but not researched
		
		# Draw border
		draw_rect(rect, Color.BLACK, false, 2.0)
		
		# Draw tech name (truncated)
		draw_string(
			get_theme_font("font"),
			rect.position + Vector2(5, 15),
			tech["name"].substr(0, 8),
			HORIZONTAL_ALIGNMENT_LEFT,
			TECH_SIZE - 10,
			12
		)
		
		# Draw research time
		draw_string(
			get_theme_font("font"),
			rect.position + Vector2(5, 40),
			str(tech["research_time"]) + "t",
			HORIZONTAL_ALIGNMENT_LEFT,
			TECH_SIZE - 10,
			10
		)
		
		col += 1

func get_techs_for_era(era: String) -> Array:
	"""Get all techs available in this era"""
	var techs = []
	for tech_id in tech_definitions:
		var tech = tech_definitions[tech_id]
		if tech.get("era", "") == era:
			techs.append(tech_id)
	return techs

func select_tech_for_research(tech_id: String) -> bool:
	"""Queue a technology for research"""
	if tech_id in tech_definitions and tech_id not in researched_techs:
		current_research = tech_id
		research_progress = 0.0
		print("Researching: ", tech_definitions[tech_id]["name"])
		return true
	return false

func update_research(delta: float, research_speed: float = 1.0):
	"""Update research progress"""
	if current_research == "":
		return
	
	var tech = tech_definitions[current_research]
	var research_time = float(tech.get("research_time", 100))
	
	research_progress += delta * research_speed
	
	if research_progress >= research_time:
		complete_research(current_research)

func complete_research(tech_id: String):
	"""Mark technology as researched"""
	if tech_id in tech_definitions:
		researched_techs[tech_id] = true
		print("✓ TECHNOLOGY RESEARCHED: ", tech_definitions[tech_id]["name"])
		
		# Check if this tech unlocks a new era
		var tech = tech_definitions[tech_id]
		if tech.has("unlocks_era"):
			print("   → Unlocks era: ", tech["unlocks_era"])
		
		current_research = ""
		research_progress = 0.0
		queue_redraw()

func get_research_summary() -> Dictionary:
	"""Return current research status"""
	var summary = {
		"current": current_research,
		"progress": research_progress,
		"researched_count": researched_techs.size(),
		"researched": researched_techs
	}
	
	if current_research != "":
		summary["current_name"] = tech_definitions[current_research]["name"]
		summary["current_time"] = tech_definitions[current_research]["research_time"]
	
	return summary

func is_tech_researched(tech_id: String) -> bool:
	"""Check if a technology has been researched"""
	return tech_id in researched_techs

func get_available_technologies() -> Array:
	"""Get all techs that can be researched in current era"""
	var available = []
	var era_techs = get_techs_for_era(era_manager.current_era_id)
	
	for tech_id in era_techs:
		if tech_id not in researched_techs:
			available.append({
				"id": tech_id,
				"name": tech_definitions[tech_id]["name"],
				"description": tech_definitions[tech_id].get("description", ""),
				"research_time": tech_definitions[tech_id]["research_time"]
			})
	
	return available
