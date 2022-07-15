extends Node
signal update

var ACCELERATION = 1000
var CLIMB_SPEED = 50
var WALK_SPEED = 120
var RUN_SPEED = 220
var FRICTION = 1000

var BASE_ACCELERATION = 1000
var BASE_WALK_SPEED = 120
var BASE_RUN_SPEED = 220
var BASE_FRICTION = 1000

var DAMAGE = 0
var DMG_SPEED = 0
var DEFENSE = 0
var CRITIC_PERCENTAGE = 0

var BASE_DAMAGE = 0
var BASE_DMG_SPEED = 0
var BASE_DEFENSE = 0
var BASE_CRITIC_PERCENTAGE = 0

var UI 
var life_bar
var energy_bar 
var exp_bar

var CURR_HEALTH 
var MAX_HEALTH 
var BASE_MAX_HEALTH

var CURR_SP 
var MAX_SP 
var BASE_MAX_SP

var CURR_EXP
var MAX_EXP

var REGEN 
var BASE_REGEN

var is_climbing = false
var can_sprint = true
var IS_ALIVE = true

var EXPERIENCE = 0
var LEVEL
var COINS = 0
var GEMS = 0

var STRENGTH = 0
var INTELLIGENCE = 0
var DEXTERITY = 0

var MAP = "Lombok"

func initialize():
	PlayerInventory.connect("active_item_updated", self, "update");
	UI_created()
	
func base_stat_assigned():
	reset()
	update();
	
func UI_created():
	UI = get_tree().get_nodes_in_group("UI")[0].get_node("Stats/GUI/HBoxContainer")
	life_bar = UI.find_node("LifeBar")
	energy_bar = UI.find_node("EnergyBar")
	exp_bar = UI.find_node("ExpBar")

	CURR_HEALTH = life_bar.CURRENT_HEALTH
	MAX_HEALTH = life_bar.MAX_HEALTH

	CURR_SP = energy_bar.CURRENT_SP
	MAX_SP = energy_bar.MAX_SP
	REGEN = energy_bar.RECHARGE
	
	CURR_EXP = exp_bar.CURRENT_EXP
	MAX_EXP = exp_bar.MAX_EXP
	LEVEL = exp_bar.LEVEL
	

func reset():
	ACCELERATION = BASE_ACCELERATION
	WALK_SPEED = BASE_WALK_SPEED
	RUN_SPEED = BASE_RUN_SPEED
	FRICTION = BASE_FRICTION
	
	DAMAGE = BASE_DAMAGE
	DMG_SPEED = BASE_DMG_SPEED
	DEFENSE = BASE_DEFENSE
	CRITIC_PERCENTAGE = BASE_CRITIC_PERCENTAGE
	
	MAX_HEALTH = BASE_MAX_HEALTH
	MAX_SP = BASE_MAX_SP
	REGEN = BASE_REGEN
	
func update():
	var active_item = InventoryManager.get_active_item_stats()
	if is_weapon(active_item):
		set_stats_weapon(active_item);
	else:
		reset();
		
	emit_signal("update")

func set_stats_weapon(item):
	if item.has("Damage"):
		DAMAGE = BASE_DAMAGE + int(item["Damage"])
	if item.has("Defense"):
		DEFENSE = BASE_DEFENSE + int(item["Defense"])
	if item.has("Speed"):
		DMG_SPEED = BASE_DMG_SPEED + int(item["Speed"])
	if item.has("Critic"):
		CRITIC_PERCENTAGE = BASE_CRITIC_PERCENTAGE + int(item["Critic"])
	
func is_weapon(item):
	if item == null: return false;
	match item["ItemCategory"]:
		"Sword":
			return true;
		_:
			return false; 
