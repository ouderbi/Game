extends Node
class_name DiplomacySystem

# NPC Rivals & Diplomatic Relationships

class NPC:
	var name: String
	var personality: String  # "aggressive", "defensive", "peaceful"
	var military_strength: float
	var research_speed: float
	var gold: float
	var happiness: float = 0.7
	var tension_with_player: float = 0.0
	var trade_routes_with_player: int = 0
	var is_at_war_with_player: bool = false
	var memory: Array = []  # Recent interactions
	
	func _init(p_name: String, p_personality: String):
		name = p_name
		personality = p_personality
		military_strength = randf_range(500, 2000)
		research_speed = randf_range(0.5, 2.0)
		gold = randf_range(500, 3000)

var npcs: Array[NPC] = []
var player_gold: float = 100

func _ready():
	create_initial_npcs()

func create_initial_npcs():
	"""Create rival civilizations"""
	npcs.append(NPC.new("Northern Empire", "aggressive"))
	npcs.append(NPC.new("Desert Kingdom", "peaceful"))
	npcs.append(NPC.new("Eastern Alliance", "defensive"))
	
	for npc in npcs:
		print("Rival created: %s (%s, military: %.0f)" % [npc.name, npc.personality, npc.military_strength])

func update_npc_ai(delta: float):
	"""Update NPC behavior"""
	for npc in npcs:
		# Update NPC research (slow)
		npc.research_speed += randf_range(-0.1, 0.1) * delta
		npc.research_speed = clamp(npc.research_speed, 0.3, 3.0)
		
		# Update happiness (varies with events)
		npc.happiness += randf_range(-0.05, 0.05) * delta
		npc.happiness = clamp(npc.happiness, 0.0, 1.0)
		
		# Update tension (diplomatic decay)
		npc.tension_with_player *= 0.98
		
		# Aggressive NPCs increase tension naturally
		if npc.personality == "aggressive":
			npc.tension_with_player += 0.01 * delta

func propose_trade(npc: NPC, gold_offered: float) -> bool:
	"""Propose trade agreement"""
	if player_gold < gold_offered:
		print("Not enough gold to trade with ", npc.name)
		return false
	
	var acceptance = randf()
	var npc_happiness_bonus = npc.happiness * 0.5
	var threshold = 0.3 + (npc.tension_with_player * 0.5) - npc_happiness_bonus
	
	if acceptance > threshold:
		player_gold -= gold_offered
		npc.gold += gold_offered
		npc.trade_routes_with_player += 1
		npc.tension_with_player -= 0.1
		npc.memory.append("player_traded")
		
		print("✓ Trade accepted: %s receives %.0f gold. Trade routes: %d" % [npc.name, gold_offered, npc.trade_routes_with_player])
		return true
	else:
		print("✗ Trade rejected by %s (tension too high)" % npc.name)
		return false

func declare_war_with_npc(npc: NPC) -> bool:
	"""Declare war on an NPC rival"""
	if npc.is_at_war_with_player:
		print("Already at war with ", npc.name)
		return false
	
	npc.is_at_war_with_player = true
	npc.tension_with_player = 1.0
	npc.memory.append("player_declared_war")
	
	print("WAR DECLARED AGAINST ", npc.name)
	print("  Their military strength: %.0f" % npc.military_strength)
	return true

func declare_peace_with_npc(npc: NPC, gold_reparations: float = 0) -> bool:
	"""End war with reparations"""
	if not npc.is_at_war_with_player:
		print(npc.name, " is not at war with player")
		return false
	
	if player_gold < gold_reparations:
		print("Not enough gold for reparations")
		return false
	
	npc.is_at_war_with_player = false
	player_gold -= gold_reparations
	npc.gold += gold_reparations
	npc.tension_with_player -= 0.3
	npc.memory.append("peace_treaty")
	
	print("PEACE TREATY WITH ", npc.name, " (%.0f gold reparations)" % gold_reparations)
	return true

func espionage_attack(target_npc: NPC, spy_cost: float) -> bool:
	"""Conduct espionage against an NPC"""
	if player_gold < spy_cost:
		return false
	
	var success_chance = randf()
	player_gold -= spy_cost
	
	if success_chance > 0.5:
		var stolen_gold = int(randf_range(100, 500))
		player_gold += stolen_gold
		target_npc.gold -= stolen_gold
		target_npc.tension_with_player += 0.2
		
		print("✓ Espionage successful! Stole %.0f gold from %s" % [stolen_gold, target_npc.name])
		return true
	else:
		target_npc.tension_with_player += 0.5
		print("✗ Espionage failed! %s discovered the plot!" % target_npc.name)
		return false

func get_npc_status() -> Array:
	"""Get all NPC statuses"""
	var statuses = []
	for npc in npcs:
		var war_status = "AT WAR" if npc.is_at_war_with_player else "Peace"
		statuses.append({
			"name": npc.name,
			"status": war_status,
			"strength": "%.0f" % npc.military_strength,
			"tension": "%.0f%%" % (npc.tension_with_player * 100),
			"trades": npc.trade_routes_with_player
		})
	return statuses

func get_npc_by_name(name: String) -> NPC:
	"""Find NPC by name"""
	for npc in npcs:
		if npc.name == name:
			return npc
	return null

func simulate_npc_decisions(world_state: Dictionary):
	"""NPC AI makes decisions based on world state"""
	for npc in npcs:
		# Aggressive NPCs might declare war if player is weak
		if npc.personality == "aggressive" and not npc.is_at_war_with_player:
			var player_strength = world_state.get("military_strength", 1000)
			var war_chance = max(0, (npc.military_strength / player_strength) - 1.0) * 0.01
			
			if randf() < war_chance:
				print("[AI] %s declares war on player!" % npc.name)
				declare_war_with_npc(npc)
		
		# Peaceful NPCs might trade
		if npc.personality == "peaceful" and npc.trade_routes_with_player < 3:
			if randf() < 0.02:
				propose_trade(npc, 200)

func get_diplomatic_summary() -> Dictionary:
	"""Return overall diplomatic status"""
	var wars = 0
	var trades = 0
	var avg_tension = 0.0
	
	for npc in npcs:
		if npc.is_at_war_with_player:
			wars += 1
		trades += npc.trade_routes_with_player
		avg_tension += npc.tension_with_player
	
	avg_tension /= float(npcs.size())
	
	return {
		"wars": wars,
		"trades": trades,
		"avg_tension": avg_tension,
		"player_gold": player_gold,
		"rivals_count": npcs.size()
	}
