extends Node

# Headless playtest runner
# Instantiates the main scene, runs accelerated ticks, collects PlaytestingAnalyzer output and writes JSON report to user://

const TICKS_PER_RUN = 600  # number of _update_systems calls per run (tunable)
const DELTA = 0.1  # simulated seconds per tick

func _ready():
	print("Headless playtest runner starting...")
	# Load main scene
	var main_scene = load("res://scenes/main.tscn")
	var root = main_scene.instantiate()
	get_tree().get_root().add_child(root)
	
	# root is the GameWorld (named "Main")
	var game_world = root
	if not game_world:
		printerr("Failed to instantiate GameWorld")
		get_tree().quit()
		return
	
	# Allow initialization
	await get_tree().process_frame
	
	# Default number of runs configurable via env variable
	var env_runs = OS.get_environment("PLAYTEST_RUNS")
	var runs = int(env_runs) if env_runs != "" and env_runs != null else 10
	var out_reports = []
	for r in range(runs):
		print("Starting run %d/%d" % [r+1, runs])
		# Optionally cheat to stabilize start state
		if game_world.resource_manager:
			game_world.resource_manager.cheat_fill_all_resources(500)
	
			# Run ticks
			for i in range(TICKS_PER_RUN):
			game_world._update_systems(DELTA)
			# take periodic checkpoints
			if i % 60 == 0 and game_world.playtesting_analyzer:
				game_world.playtesting_analyzer.take_checkpoint(game_world)
	
		# Analyze and collect report
		if game_world.playtesting_analyzer:
			var analysis = game_world.playtesting_analyzer.analyze_balance(game_world)
			out_reports.append(analysis)
		else:
			out_reports.append({"error": "no analyzer"})
		
		# Reset or reload world between runs: re-instantiate for isolation
		root.queue_free()
		await get_tree().process_frame
		root = main_scene.instantiate()
		get_tree().get_root().add_child(root)
		game_world = root
		await get_tree().process_frame
	
	# Write reports to user://
	var file = File.new()
	var fname = "user://playtest_report_%d.json" % OS.get_unix_time()
	if file.open(fname, File.WRITE) == OK:
		file.store_string(JSON.print(out_reports))
		file.close()
		print("Playtest report written to: %s" % fname)
	else:
		printerr("Failed to write playtest report")

	# Also write to project workspace (repo root) so CI can collect artifact easily
	var repo_root = ProjectSettings.globalize_path("res://")
	var out_dir = repo_root.plus_file("playtest_reports")
	var dir = Directory.new()
	if not dir.dir_exists(out_dir):
		dir.make_dir_recursive(out_dir)
	var out_path = out_dir.plus_file("playtest_report_%d.json" % OS.get_unix_time())
	var wf = File.new()
	if wf.open(out_path, File.WRITE) == OK:
		wf.store_string(JSON.print(out_reports))
		wf.close()
		print("Playtest report also written to workspace: %s" % out_path)
	else:
		printerr("Failed to write workspace playtest report")
	
	get_tree().quit()
