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
		print_debug(body)

# TODO: SAVE the following: Quest System
func save_stats():
	var player = get_node("/root/World/YSort/Player")
	
	profile.nickname = {"stringValue": player.NICKNAME}
	profile.character_class = {"stringValue": player.CHARACTER_CLASS}
	profile.location = {"stringValue": player.MAP + " (" + str(round(player.get_position().x)) + "," + str(round(player.get_position().y)) + ")"}
	profile.max_hp = {"integerValue": player.MAX_HEALTH}
	profile.max_sp = {"integerValue": player.MAX_SP}
	profile.curr_hp = {"integerValue": player.CURR_HEALTH}
	profile.curr_sp = {"integerValue": player.CURR_SP}
	profile.strength = {"integerValue": player.STRENGTH}
	profile.intelligence = {"integerValue": player.INTELLIGENCE}
	profile.dexterity = {"integerValue": player.DEXTERITY}
	profile.coins = {"integerValue": player.COINS}
	profile.gems = {"integerValue": player.GEMS}

func save_quests():
	pass
