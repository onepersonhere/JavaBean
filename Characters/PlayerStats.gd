extends Node

var ACCELERATION = 1000
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

onready var UI = get_tree().get_nodes_in_group("UI")[0].get_node("Stats/GUI/HBoxContainer")
onready var life_bar = UI.find_node("LifeBar")
onready var energy_bar = UI.find_node("EnergyBar")

onready var CURR_HEALTH = life_bar.CURRENT_HEALTH
onready var MAX_HEALTH = life_bar.MAX_HEALTH
onready var BASE_MAX_HEALTH

onready var CURR_SP = energy_bar.CURRENT_SP
onready var MAX_SP = energy_bar.MAX_SP
onready var BASE_MAX_SP

onready var REGEN = energy_bar.RECHARGE
onready var BASE_REGEN

var can_sprint = true
var IS_ALIVE = true

var EXPERIENCE = 0
var LEVEL = 0
var COINS = 0
var GEMS = 0

var STRENGTH = 0
var INTELLIGENCE = 0
var DEXTERITY = 0

var MAP = "Lombok"

func _ready():
	reset();
	update();
	PlayerInventory.connect("active_item_updated", self, "update");

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
	match item["ItemCategory"]:
		"Sword":
			return true;
		_:
			return false; 
