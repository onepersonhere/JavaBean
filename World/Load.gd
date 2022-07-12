extends Node


func load(profile, world_name):
	# var save_nodes = get_tree().get_nodes_in_group("Persist")
	# for i in save_nodes:
	# 	i.queue_free()
	
	var world: Node2D = load("res://World/"+ world_name +".tscn").instance()
	var player: KinematicBody2D = load("res://Characters/MainCharacter.tscn").instance()
	
	# get YSort
	var ysort = world.find_node("YSort")
	ysort.add_child(player)
	player.scale = Vector2(1, 1)
	player.find_node("Camera2D").zoom = Vector2(0.45, 0.45)
	# is alive
	player.get_node("PlayerStats").IS_ALIVE = true
	
	# nickname
	player.NICKNAME = profile["nickname"]["stringValue"]
	
	# class
	match profile["character_class"]["stringValue"]:
		"warrior":
			player.CHARACTER_CLASS = "warrior"
	
	# location
	var location: String = profile["location"]["stringValue"]
	var map: String = location.split(" ")[0]
	var pos_x: int = int(location.split(" ")[1].split(",")[0].split("(")[1])
	var pos_y: int = int(location.split(" ")[1].split(",")[1].split(")")[0])
	player.set_position(Vector2(pos_x, pos_y))
	
	# movement
	player.get_node("PlayerStats").BASE_ACCELERATION = 1000 + 1 * int(profile["dexterity"]["integerValue"])
	player.get_node("PlayerStats").BASE_FRICTION = 1000 + 1 * int(profile["dexterity"]["integerValue"])
	player.get_node("PlayerStats").BASE_WALK_SPEED = 120 + 0.1 * int(profile["dexterity"]["integerValue"])
	player.get_node("PlayerStats").BASE_RUN_SPEED = 220 + 0.1 * int(profile["dexterity"]["integerValue"])
	
	# hp
	player.get_node("PlayerStats").BASE_MAX_HEALTH = int(profile["max_hp"]["integerValue"])
	player.get_node("PlayerStats").CURR_HEALTH = int(profile["curr_hp"]["integerValue"])
	
	# sp
	player.get_node("PlayerStats").BASE_MAX_SP = int(profile["max_sp"]["integerValue"])
	player.get_node("PlayerStats").CURR_SP = int(profile["curr_sp"]["integerValue"])
	
	# damage
	player.get_node("PlayerStats").BASE_DAMAGE = 10 + int(profile["strength"]["integerValue"])
	
	# defense
	player.get_node("PlayerStats").BASE_DEFENSE = 10 + int(profile["intelligence"]["integerValue"])
	
	# regen
	player.get_node("PlayerStats").BASE_REGEN = 10 + int(profile["intelligence"]["integerValue"])
	
	# experience
	player.get_node("PlayerStats").EXPERIENCE = int(profile["strength"]["integerValue"]) 
	+ int(profile["intelligence"]["integerValue"]) 
	+ int(profile["dexterity"]["integerValue"])
	
	# level
	player.get_node("PlayerStats").LEVEL = round(player.get_node("PlayerStats").EXPERIENCE / 10)
	
	# coins
	player.get_node("PlayerStats").COINS = int(profile["coins"]["integerValue"])
	
	# gems
	player.get_node("PlayerStats").GEMS = int(profile["gems"]["integerValue"])
	
	# stats
	player.get_node("PlayerStats").STRENGTH = int(profile["strength"]["integerValue"])
	player.get_node("PlayerStats").INTELLIGENCE = int(profile["intelligence"]["integerValue"])
	player.get_node("PlayerStats").DEXTERITY = int(profile["dexterity"]["integerValue"])
	
	get_tree().get_root().add_child(world)
	print_debug("loaded")
