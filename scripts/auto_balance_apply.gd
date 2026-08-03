extends Node

# Auto-apply balance recommendations based on playtest reports
# This script is intended to be run manually or by CI after playtests

func _ready():
	print("Auto-balance apply starting...")
	var reports_dir = ProjectSettings.globalize_path("res://playtest_reports")
	var dir = Directory.new()
	if not dir.dir_exists(reports_dir):
		print("No playtest_reports directory found: %s" % reports_dir)
		get_tree().quit()
		return
	
	dir.open(reports_dir)
	dir.list_dir_begin()
	var fname = dir.get_next()
	var latest = ""
	var latest_time = 0
	while fname != "":
		if fname.ends_with('.json'):
			var path = reports_dir.plus_file(fname)
			var mod = FileAccess.get_modified_time(path)
			if mod > latest_time:
				latest_time = mod
				latest = path
		fname = dir.get_next()
	
	if latest == "":
		print("No report files found")
		get_tree().quit()
		return
	
	print("Applying auto-balance from report: %s" % latest)
	var f = File.new()
	if f.open(latest, File.READ) != OK:
		printerr("Failed to open report")
		get_tree().quit()
		return
	var data = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(data) != TYPE_ARRAY:
		printerr("Report format unexpected")
		get_tree().quit()
		return
	
	# Simple heuristic: if any report contains MONEY_SPIRAL or INFLATION_SPIRAL -> reduce production globally by 20%
	var adjust_production = false
	var increase_farms = false
	for run in data:
		for issue in run.get("issues", []):
			if issue.find("INFLATION") != -1 or issue.find("MONEY_SPIRAL") != -1:
				adjust_production = true
			if issue.find("STARVATION") != -1:
				increase_farms = true
	
	# Apply to buildings.json
	var bpath = ProjectSettings.globalize_path("res://data/eras/buildings.json")
	var bf = File.new()
	if bf.open(bpath, File.READ) != OK:
		printerr("Failed to open buildings.json for reading")
		get_tree().quit()
		return
	var parsed = JSON.parse_string(bf.get_as_text())
	bf.close()
	var changed = false
	if adjust_production and parsed.has("buildings"):
		for j in range(parsed["buildings"].size()):
			var b = parsed["buildings"][j]
			if b.has("production"):
				for key in b["production"]:
					b["production"][key] = float(b["production"][key]) * 0.8
					changed = true
	
	if increase_farms and parsed.has("buildings"):
		for j in range(parsed["buildings"].size()):
			var b = parsed["buildings"][j]
			if b.get("id","").find("farm") != -1 and b.has("production"):
				b["production"]["food"] = float(b["production"].get("food",0)) * 1.3
				changed = true
	
	if changed:
		var wf = File.new()
		if wf.open(bpath, File.WRITE) == OK:
			wf.store_string(JSON.print(parsed, true))
			wf.close()
			print("Applied auto-balance changes to buildings.json")
		else:
			printerr("Failed to write buildings.json")
	else:
		print("No automatic adjustments necessary based on reports")

	get_tree().quit()
