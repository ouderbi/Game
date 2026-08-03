extends Node
class_name PlaytestingAnalyzer

# Analyze game balance and identify tuning issues

var analysis_interval: float = 0.0
var checkpoints: Array = []  # Track snapshots over time

class BalanceCheckpoint:
	var timestamp: float
	var year: int
	var population: int
	var resources: Dictionary
	var morale: float
	var happiness: float
	var legitimacy: float
	var military_strength: float
	var inflation_rate: float
	var era: String
	var government: String
	var factions_satisfied: int
	var active_wars: int
	
	func _init():
		timestamp = Time.get_ticks_msec() / 1000.0

var thresholds = {
	"inflation_warning": 0.05,  # Alert if inflation > 5% per tick
	"starvation_critical": 50,   # Alert if food < 50
	"population_collapse": 100,  # Alert if population drops below 100
	"coin_spiral": 10000,        # Alert if gold exceeds 10k
	"legitimacy_crisis": 0.2,    # Alert if legitimacy < 20%
	"morale_despair": 0.1,       # Alert if morale < 10%
	"coup_risk_high": 0.7,       # Alert if any faction coup risk > 70%
	"tech_stuck": 10.0           # Alert if same tech being researched > 10 minutes
}

var issues_detected: Array = []

func _ready():
	print("Playtesting analyzer initialized")

func take_checkpoint(game_world) -> BalanceCheckpoint:
	"""Capture current game state"""
	var checkpoint = BalanceCheckpoint.new()
	
	checkpoint.timestamp = Time.get_ticks_msec() / 1000.0
	checkpoint.year = game_world.current_year
	checkpoint.population = game_world.population_system.total_population
	checkpoint.resources = game_world.resource_manager.resources.duplicate()
	checkpoint.morale = game_world.population_system.morale
	checkpoint.happiness = game_world.population_system.happiness
	checkpoint.legitimacy = game_world.government_system.legitimacy
	checkpoint.military_strength = game_world.unit_system.get_total_military_strength(game_world.government_system.get_military_modifier())
	checkpoint.era = game_world.era_manager.current_era_id
	checkpoint.government = game_world.government_system.current_government
	checkpoint.factions_satisfied = 0
	checkpoint.active_wars = 1 if game_world.combat_system.is_at_war() else 0
	
	# Calculate inflation
	if checkpoints.size() > 0:
		var prev = checkpoints[-1]
		var gold_change = float(checkpoint.resources.get("gold", 0) - prev.resources.get("gold", 0))
		var gold_base = float(prev.resources.get("gold", 1))
		checkpoint.inflation_rate = gold_change / gold_base
	else:
		checkpoint.inflation_rate = 0.0
	
	checkpoints.append(checkpoint)
	return checkpoint

func analyze_balance(game_world) -> Dictionary:
	"""Run balance analysis and return issues"""
	issues_detected.clear()
	
	var checkpoint = take_checkpoint(game_world)
	var analysis = {
		"timestamp": checkpoint.timestamp,
		"issues": [],
		"warnings": [],
		"metrics": {}
	}
	
	# Check for inflation spiral
	if checkpoint.inflation_rate > thresholds["inflation_warning"]:
		issues_detected.append("INFLATION_SPIRAL: Gold changing at %.1f%% per tick (threshold: %.1f%%)" % [checkpoint.inflation_rate * 100, thresholds["inflation_warning"] * 100])
	
	# Check for starvation
	var food = checkpoint.resources.get("food", 0)
	if food < thresholds["starvation_critical"]:
		issues_detected.append("STARVATION_RISK: Food at %d (critical: %d)" % [food, thresholds["starvation_critical"]])
	
	# Check for population collapse
	if checkpoint.population < thresholds["population_collapse"]:
		issues_detected.append("POPULATION_COLLAPSE: Population %d (critical: %d)" % [checkpoint.population, thresholds["population_collapse"]])
	
	# Check for coin spiral
	var gold = checkpoint.resources.get("gold", 0)
	if gold > thresholds["coin_spiral"]:
		issues_detected.append("MONEY_SPIRAL: Gold at %d (threshold: %d) - economy out of balance" % [gold, thresholds["coin_spiral"]])
	
	# Check legitimacy crisis
	if checkpoint.legitimacy < thresholds["legitimacy_crisis"]:
		issues_detected.append("LEGITIMACY_CRISIS: Legitimacy at %.1f%% (critical: %.1f%%)" % [checkpoint.legitimacy * 100, thresholds["legitimacy_crisis"] * 100])
	
	# Check morale despair
	if checkpoint.morale < thresholds["morale_despair"]:
		issues_detected.append("MORALE_DESPAIR: Morale at %.1f%% (critical: %.1f%%)" % [checkpoint.morale * 100, thresholds["morale_despair"] * 100])
	
	# Track metrics
	analysis["metrics"] = {
		"population": checkpoint.population,
		"food": food,
		"gold": gold,
		"morale": "%.1f%%" % (checkpoint.morale * 100),
		"happiness": "%.1f%%" % (checkpoint.happiness * 100),
		"legitimacy": "%.1f%%" % (checkpoint.legitimacy * 100),
		"military_strength": "%.0f" % checkpoint.military_strength,
		"inflation": "%.2f%%" % (checkpoint.inflation_rate * 100),
		"era": checkpoint.era,
		"government": checkpoint.government,
		"at_war": checkpoint.active_wars > 0
	}
	
	analysis["issues"] = issues_detected
	return analysis

func get_tuning_recommendations(game_world) -> Array:
	"""Provide tuning recommendations based on analysis"""
	var recommendations = []
	var analysis = analyze_balance(game_world)
	
	for issue in analysis["issues"]:
		if "INFLATION" in issue:
			recommendations.append({
				"problem": issue,
				"cause": "Resources producing faster than consumption or resource sink too weak",
				"actions": [
					"Increase building maintenance costs",
					"Reduce production output of buildings by 20-30%",
					"Increase tax collection rate",
					"Add luxury buildings that consume gold"
				],
				"priority": "high"
			})
		
		if "STARVATION" in issue:
			recommendations.append({
				"problem": issue,
				"cause": "Food consumption exceeds production",
				"actions": [
					"Reduce population consumption rate by 10-20%",
					"Increase farm production bonuses",
					"Add more basic farms to starting buildings",
					"Reduce population growth rate in low-food situations"
				],
				"priority": "critical"
			})
		
		if "POPULATION_COLLAPSE" in issue:
			recommendations.append({
				"problem": issue,
				"cause": "Deaths from war/famine exceed births",
				"actions": [
					"Reduce casualty rates in combat by 20-30%",
					"Increase natural population recovery rate",
					"Add hospitals/healers that reduce casualty impact",
					"Add immigration mechanic during peace"
				],
				"priority": "critical"
			})
		
		if "MONEY_SPIRAL" in issue:
			recommendations.append({
				"problem": issue,
				"cause": "Gold accumulating faster than spending",
				"actions": [
					"Add gold sinks (trade costs, building maintenance, unit upkeep)",
					"Reduce starting gold",
					"Increase tech research costs by 50%",
					"Add interest/corruption that reduces gold over time"
				],
				"priority": "high"
			})
		
		if "LEGITIMACY_CRISIS" in issue:
			recommendations.append({
				"problem": issue,
				"cause": "Government losing public support",
				"actions": [
					"Reduce corruption rate by 30%",
					"Increase happiness from resources",
					"Reduce repression impact on legitimacy",
					"Add festivals/entertainment buildings to boost legitimacy"
				],
				"priority": "high"
			})
		
		if "MORALE_DESPAIR" in issue:
			recommendations.append({
				"problem": issue,
				"cause": "Population is suffering and unhappy",
				"actions": [
					"Reduce war impact on morale",
					"Increase food/resource happiness bonus",
					"Add morale recovery over time",
					"Reduce casualty morale penalty"
				],
				"priority": "high"
			})
	
	return recommendations

func get_era_pacing(game_world) -> Dictionary:
	"""Analyze era progression pacing"""
	if checkpoints.size() < 2:
		return {"status": "Need more data"}
	
	var first = checkpoints[0]
	var last = checkpoints[-1]
	
	var era_changes = 0
	for checkpoint in checkpoints:
		if checkpoint.era != first.era:
			era_changes += 1
	
	var elapsed_seconds = last.timestamp - first.timestamp
	var elapsed_minutes = elapsed_seconds / 60.0
	
	return {
		"elapsed_minutes": "%.1f" % elapsed_minutes,
		"era_changes": era_changes,
		"minutes_per_era": "%.1f" % (elapsed_minutes / max(1, era_changes)) if era_changes > 0 else "N/A",
		"status": "Too fast (< 3 min/era)" if era_changes > elapsed_minutes / 3 else "Too slow (> 10 min/era)" if era_changes < elapsed_minutes / 10 else "Balanced (3-10 min/era)"
	}

func get_coup_frequency(game_world) -> Dictionary:
	"""Analyze coup event frequency"""
	var coup_events = game_world.event_log.get_events_by_type("FACTION")
	var elapsed_minutes = (Time.get_ticks_msec() / 1000.0 - checkpoints[0].timestamp) / 60.0
	var coup_count = 0
	
	for event in coup_events:
		if "coup" in event.message.to_lower():
			coup_count += 1
	
	var coups_per_minute = float(coup_count) / max(0.1, elapsed_minutes)
	
	return {
		"total_coups": coup_count,
		"elapsed_minutes": "%.1f" % elapsed_minutes,
		"coups_per_minute": "%.2f" % coups_per_minute,
		"status": "Too frequent (> 1 per 5 min)" if coups_per_minute > 0.2 else "Too rare (< 1 per 15 min)" if coups_per_minute < 0.067 else "Balanced (~1 per 5-10 min)"
	}

func print_balance_report(game_world):
	"""Print comprehensive balance analysis"""
	var analysis = analyze_balance(game_world)
	
	print("\n" + "=".repeat(60))
	print("BALANCE ANALYSIS REPORT")
	print("=".repeat(60))
	
	print("\n--- CURRENT METRICS ---")
	for metric in analysis["metrics"]:
		print("%s: %s" % [metric, analysis["metrics"][metric]])
	
	if analysis["issues"].size() > 0:
		print("\n--- ISSUES DETECTED ---")
		for issue in analysis["issues"]:
			print("⚠️  " + issue)
	else:
		print("\n--- STATUS ---")
		print("✓ No balance issues detected")
	
	print("\n--- ERA PACING ---")
	var pacing = get_era_pacing(game_world)
	for metric in pacing:
		print("%s: %s" % [metric, pacing[metric]])
	
	print("\n--- COUP FREQUENCY ---")
	var coups = get_coup_frequency(game_world)
	for metric in coups:
		print("%s: %s" % [metric, coups[metric]])
	
	print("\n--- RECOMMENDATIONS ---")
	var recommendations = get_tuning_recommendations(game_world)
	if recommendations.size() > 0:
		for rec in recommendations:
			print("• %s (Priority: %s)" % [rec["problem"], rec["priority"]])
			print("  Cause: %s" % rec["cause"])
			for action in rec["actions"]:
				print("  → %s" % action)
	else:
		print("✓ No tuning recommendations")
	
	print("=".repeat(60) + "\n")
