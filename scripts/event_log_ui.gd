extends Control
class_name EventLogUI

# Track and display all game events for history/debugging

var events_log: Array = []
var max_log_size: int = 500  # Keep last 500 events
var log_filter: String = ""  # Filter by event type

class LogEntry:
	var timestamp: int
	var year: int
	var event_type: String
	var message: String
	var severity: String  # info, warning, critical
	var data: Dictionary
	
	func _init(p_type: String, p_msg: String, p_year: int, p_severity: String = "info"):
		timestamp = Time.get_ticks_msec()
		event_type = p_type
		message = p_msg
		year = p_year
		severity = p_severity
		data = {}
	
	func _to_string() -> String:
		return "[Y%d] %s: %s" % [year, event_type, message]

func _ready():
	pass

func log_event(event_type: String, message: String, year: int, severity: String = "info", event_data: Dictionary = {}):
	"""Log an event to the history"""
	var entry = LogEntry.new(event_type, message, year, severity)
	entry.data = event_data
	
	events_log.append(entry)
	
	# Keep log size manageable
	if events_log.size() > max_log_size:
		events_log.pop_front()
	
	# Print to console with color coding
	var color_prefix = {
		"info": "[INF]",
		"warning": "[WRN]",
		"critical": "[CRT]"
	}
	
	print("%s [Y%d] %s" % [
		color_prefix.get(severity, "[UNK]"),
		year,
		message
	])

func log_government_change(old_gov: String, new_gov: String, year: int):
	"""Log government type change"""
	log_event("GOVERNMENT", 
		"Government changed from %s to %s" % [old_gov, new_gov], 
		year, "warning")

func log_era_advance(era_name: String, year: int):
	"""Log era advancement"""
	log_event("ERA", 
		"Entered era: %s" % era_name, 
		year, "critical")

func log_population_event(event: String, population: int, year: int):
	"""Log population changes"""
	log_event("POPULATION", 
		"%s (now %d)" % [event, population], 
		year, "info",
		{"population": population})

func log_war_event(event: String, enemy: String, year: int):
	"""Log war-related events"""
	log_event("WAR", 
		"%s: %s" % [event, enemy], 
		year, "critical")

func log_economic_event(event: String, resource: String, amount: float, year: int):
	"""Log economic changes"""
	log_event("ECONOMY", 
		"%s: %s %+.0f" % [event, resource, amount], 
		year, "warning" if amount < 0 else "info",
		{"resource": resource, "amount": amount})

func log_disaster(disaster_type: String, severity_level: float, year: int):
	"""Log disasters and catastrophes"""
	log_event("DISASTER", 
		"%s (Severity: %.0f%%)" % [disaster_type, severity_level * 100], 
		year, "critical")

func log_building_construction(building_type: String, year: int):
	"""Log building completion"""
	log_event("CONSTRUCTION", 
		"Completed: %s" % building_type, 
		year, "info")

func log_technology_researched(tech_name: String, year: int):
	"""Log technology research completion"""
	log_event("TECHNOLOGY", 
		"Researched: %s" % tech_name, 
		year, "info")

func log_faction_event(faction_name: String, event: String, year: int):
	"""Log faction-related events"""
	log_event("FACTION", 
		"%s: %s" % [faction_name, event], 
		year, "warning")

func get_recent_events(count: int = 20) -> Array:
	"""Get the most recent N events"""
	var recent = []
	var start = max(0, events_log.size() - count)
	for i in range(start, events_log.size()):
		recent.append(events_log[i])
	return recent

func get_events_by_type(event_type: String) -> Array:
	"""Get all events of a specific type"""
	var filtered = []
	for entry in events_log:
		if entry.event_type == event_type:
			filtered.append(entry)
	return filtered

func get_events_by_year_range(start_year: int, end_year: int) -> Array:
	"""Get events within a year range"""
	var filtered = []
	for entry in events_log:
		if entry.year >= start_year and entry.year <= end_year:
			filtered.append(entry)
	return filtered

func get_critical_events() -> Array:
	"""Get all critical events (wars, eras, disasters)"""
	var critical = []
	for entry in events_log:
		if entry.severity == "critical":
			critical.append(entry)
	return critical

func get_log_summary() -> Dictionary:
	"""Get summary statistics of the log"""
	var summary = {
		"total_events": events_log.size(),
		"wars": get_events_by_type("WAR").size(),
		"technologies": get_events_by_type("TECHNOLOGY").size(),
		"disasters": get_events_by_type("DISASTER").size(),
		"government_changes": get_events_by_type("GOVERNMENT").size(),
		"eras_advanced": get_events_by_type("ERA").size(),
		"critical_events": 0
	}
	
	for entry in events_log:
		if entry.severity == "critical":
			summary["critical_events"] += 1
	
	return summary

func print_log_summary():
	"""Print a human-readable log summary"""
	var summary = get_log_summary()
	print("\n=== EVENT LOG SUMMARY ===")
	print("Total events: ", summary["total_events"])
	print("Wars: ", summary["wars"])
	print("Technologies: ", summary["technologies"])
	print("Disasters: ", summary["disasters"])
	print("Government changes: ", summary["government_changes"])
	print("Eras entered: ", summary["eras_advanced"])
	print("Critical events: ", summary["critical_events"])
	print("========================\n")

func export_log_to_file(filename: String) -> bool:
	"""Export log to text file"""
	var content = "=== CIVILIZATION HISTORY LOG ===\n\n"
	
	for entry in events_log:
		content += "[Y%d] %s: %s\n" % [entry.year, entry.event_type, entry.message]
	
	content += "\n=== SUMMARY ===\n"
	var summary = get_log_summary()
	for key in summary:
		content += "%s: %s\n" % [key, summary[key]]
	
	var path = "user://logs/%s.txt" % filename
	
	# Ensure logs directory exists
	if not DirAccess.dir_exists_absolute("user://logs"):
		DirAccess.make_absolute("user://", "logs")
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(content)
		print("✓ Log exported to: ", path)
		return true
	
	print("✗ Failed to export log!")
	return false

func clear_log():
	"""Clear the event log"""
	events_log.clear()
	print("Event log cleared")
