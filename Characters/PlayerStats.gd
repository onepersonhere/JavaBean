extends Node

var ACCELERATION = 1000
var WALK_SPEED = 120
var RUN_SPEED = 220
var FRICTION = 1000

var DAMAGE = 0
var DEFENSE = 0

onready var UI = get_tree().get_nodes_in_group("UI")[0].get_node("Stats/GUI/HBoxContainer")
onready var life_bar = UI.find_node("LifeBar")
onready var energy_bar = UI.find_node("EnergyBar")

onready var CURR_HEALTH = life_bar.CURRENT_HEALTH
onready var MAX_HEALTH = life_bar.MAX_HEALTH

onready var CURR_SP = energy_bar.CURRENT_SP
onready var MAX_SP = energy_bar.MAX_SP
onready var REGEN = energy_bar.RECHARGE

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
