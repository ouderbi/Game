extends Node
class_name CombatSystem

# Combat system handling wars between civilizations
# Turn-based or real-time damage application

signal war_started(attacker: String, defender: String)
signal war_ended(winner: String)
signal battle_report(report: Dictionary)

enum WarState { PEACE, PREPARING, ACTIVE, RESOLVING }

var active_wars: Array[Dictionary] = []

func start_war(attacker_id: String, defender_id: String, attacker_strength: float, defender_strength: float) -> Dictionary:
	"""Initiate a war between two civilizations"""
	var war = {
		"id": "war_" + str(randi()),
		"attacker_id": attacker_id,
		"defender_id": defender_id,
		"attacker_strength": attacker_strength,
		"defender_strength": defender_strength,
		"attacker_casualties": 0.0,
		"defender_casualties": 0.0,
		"duration": 0.0,
		"state": WarState.ACTIVE,
		"attacker_morale": 1.0,
		"defender_morale": 1.0
	}
	
	active_wars.append(war)
	war_started.emit(attacker_id, defender_id)
	print("WAR STARTED: ", attacker_id, " vs ", defender_id)
	
	return war

func resolve_battle(war: Dictionary, delta: float) -> Dictionary:
	"""Resolve one round of combat"""
	
	# Combat resolution: stronger army wins, but both suffer casualties
	var attacker_damage = war["defender_strength"] * 0.3 * delta  # Defender deals 30% of strength as damage
	var defender_damage = war["attacker_strength"] * 0.4 * delta  # Attacker deals 40% as offensive advantage
	
	# Morale affects effectiveness
	attacker_damage *= war["attacker_morale"]
	defender_damage *= war["defender_morale"]
	
	war["attacker_strength"] -= attacker_damage
	war["defender_strength"] -= defender_damage
	
	war["attacker_casualties"] += attacker_damage
	war["defender_casualties"] += defender_damage
	
	war["duration"] += delta
	
	# Check for winner
	var winner = ""
	if war["attacker_strength"] <= 0:
		winner = war["defender_id"]
	elif war["defender_strength"] <= 0:
		winner = war["attacker_id"]
	
	return {
		"winner": winner,
		"attacker_damage": attacker_damage,
		"defender_damage": defender_damage
	}

func update_wars(unit_system: UnitSystem, population_system: PopulationSystem, delta: float):
	"""Update all active wars"""
	var wars_to_remove = []
	
	for i in range(active_wars.size()):
		var war = active_wars[i]
		
		var battle_result = resolve_battle(war, delta)
		
		if battle_result["winner"] != "":
			# War ended
			end_war(war, battle_result["winner"], population_system)
			wars_to_remove.append(i)
			
			# Apply casualties to population
			var casualty_rate = max(war["attacker_casualties"], war["defender_casualties"]) / 1000.0
			population_system.apply_war_casualties(casualty_rate, 0.5)
	
	# Remove ended wars (in reverse to avoid index issues)
	for i in wars_to_remove.reverse():
		active_wars.remove_at(i)

func end_war(war: Dictionary, winner_id: String, population_system: PopulationSystem):
	"""Resolve end of war"""
	war["state"] = WarState.RESOLVING
	
	var loser_id = war["defender_id"] if winner_id == war["attacker_id"] else war["attacker_id"]
	
	print("WAR ENDED: ", winner_id, " defeated ", loser_id)
	print("  Attacker casualties: ", int(war["attacker_casualties"]))
	print("  Defender casualties: ", int(war["defender_casualties"]))
	print("  Duration: ", int(war["duration"]), " seconds")
	
	war_ended.emit(winner_id)
	
	var report = {
		"winner": winner_id,
		"loser": loser_id,
		"attacker_casualties": int(war["attacker_casualties"]),
		"defender_casualties": int(war["defender_casualties"]),
		"duration_ticks": int(war["duration"])
	}
	
	battle_report.emit(report)
	
	# Morale impact
	population_system.morale += 0.3 if winner_id == population_system else -0.4
	population_system.legitimacy = government_system.legitimacy if "government_system" in self else 0.5

func get_active_war_status() -> Array:
	"""Get status of all active wars"""
	var status = []
	for war in active_wars:
		status.append({
			"attacker": war["attacker_id"],
			"defender": war["defender_id"],
			"attacker_strength": war["attacker_strength"],
			"defender_strength": war["defender_strength"],
			"duration": war["duration"]
		})
	return status

func is_at_war() -> bool:
	"""Check if currently in any war"""
	return active_wars.size() > 0

func declare_war(attacker_strength: float, defender_strength: float, attacker_morale: float = 1.0, defender_morale: float = 1.0) -> bool:
	"""Simple war declaration (player initiates)"""
	var war = start_war("Player", "Enemy", attacker_strength, defender_strength)
	war["attacker_morale"] = attacker_morale
	war["defender_morale"] = defender_morale
	return true

func surrender_war(war: Dictionary):
	"""Player surrenders current war"""
	var winner = war["attacker_id"] if war["attacker_id"] != "Player" else war["defender_id"]
	end_war(war, winner, null)
	
	if active_wars.has(war):
		active_wars.erase(war)

func apply_casualty_modifier(casualty_type: String, modifier: float):
	"""Modify casualty rates for different unit types"""
	# TODO: Implement unit-specific casualty rates
	pass

func calculate_war_economic_impact(war: Dictionary) -> Dictionary:
	"""Calculate economic impact of war (resource drain, production loss)"""
	var war_duration = war["duration"]
	var total_strength = war["attacker_strength"] + war["defender_strength"]
	
	return {
		"daily_cost": total_strength * 0.1,
		"production_loss": 0.2,  # 20% production lost to war effort
		"trade_loss": 0.3,  # 30% trade routes damaged
		"infrastructure_damage": war["attacker_casualties"] + war["defender_casualties"]
	}

func get_combat_report(war: Dictionary) -> String:
	"""Generate human-readable combat report"""
	var report = "WAR REPORT:\n"
	report += "Attacker (%s): Strength=%.1f, Casualties=%.0f\n" % [war["attacker_id"], war["attacker_strength"], war["attacker_casualties"]]
	report += "Defender (%s): Strength=%.1f, Casualties=%.0f\n" % [war["defender_id"], war["defender_strength"], war["defender_casualties"]]
	report += "Duration: %.1f seconds\n" % war["duration"]
	return report
