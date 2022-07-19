extends Node

onready var http = $HTTPRequest
var profile = {
	"nickname": {},
	"character_class": {},
	"location": {},
	"max_hp": {},
	"max_sp": {},
	"curr_hp": {},
	"curr_sp": {},
	"strength": {},
	"intelligence": {},
	"dexterity": {},
	"coins": {},
	"gems": {},
	"inventory": {
		"mapValue": {
			"fields": {
				"inventory": {
					"mapValue": {
						"fields": {}
					}
				},
				"hotbar": {
					"mapValue": {
						"fields": {}
					}
				},
				"equips": {
					"mapValue": {
						"fields": {}
					}
				}
			}
		}
	},
} 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func save():
	save_stats()
	save_quests()
	
	Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print_debug("saved")
	else:
		print_debug(JSON.parse(body.get_string_from_ascii()).result)

# TODO: SAVE the following: Quest System
func save_stats():
	var player = get_node("/root/World/YSort/Player")
	
	profile.nickname = {"stringValue": player.NICKNAME}
	profile.character_class = {"stringValue": player.CHARACTER_CLASS}
	profile.location = {"stringValue": get_world_name() + " (" + str(round(player.get_position().x)) + "," + str(round(player.get_position().y)) + ")"}
	profile.max_hp = {"integerValue": PlayerStats.MAX_HEALTH}
	profile.max_sp = {"integerValue": PlayerStats.MAX_SP}
	profile.curr_hp = {"integerValue": PlayerStats.CURR_HEALTH}
	profile.curr_sp = {"integerValue": PlayerStats.CURR_SP}
	profile.strength = {"integerValue": PlayerStats.STRENGTH}
	profile.intelligence = {"integerValue": PlayerStats.INTELLIGENCE}
	profile.dexterity = {"integerValue": PlayerStats.DEXTERITY}
	profile.coins = {"integerValue": PlayerStats.COINS}
	profile.gems = {"integerValue": PlayerStats.GEMS}
	
	save_inventory()

func get_world_name():
	var map = get_tree().get_nodes_in_group("map")[0].get_name()
	var world_name = "Lombok" # default
	
	match map:
		"House":
			world_name = "Lombok-House";
		"HouseSecondFloor":
			world_name = "Lombok-House-2"
		"FarmHouse":
			world_name = "Lombok-Farmhouse"
		"FortifiedHouse":
			world_name = "Lombok-Fort-House"
		"Inn":
			world_name = "Lombok-Fort-Inn"
		"InnSecondFloor":
			world_name = "Lombok-Fort-Inn-2"
		# others can add below
	return world_name

func save_quests():
	pass

func save_inventory():
	var inventory = PlayerInventory.inventory
	var hotbar = PlayerInventory.hotbar
	var equips = PlayerInventory.equips
	
	for item in inventory:
		profile.inventory[item] = {"arrayValue": inventory[item]}
	
	for item in hotbar:
		profile.hotbar[item] = {"arrayValue": hotbar[item]}
	
	for item in equips:
		profile.equips[item] = {"arrayValue": equips[item]}
