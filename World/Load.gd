extends Node


func load(profile):
	# var save_nodes = get_tree().get_nodes_in_group("Persist")
	# for i in save_nodes:
	# 	i.queue_free()
	
	var world: Node2D = load("res://World/World.tscn").instance()
	var player: KinematicBody2D = world.find_node("Player")
	
	# is alive
	player.IS_ALIVE = true
	
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
	player.ACCELERATION = 1000 + 1 * int(profile["dexterity"]["integerValue"])
	player.FRICTION = 1000 + 1 * int(profile["dexterity"]["integerValue"])
	player.WALK_SPEED = 120 + 0.1 * int(profile["dexterity"]["integerValue"])
	player.SPRINT_SPEED = 220 + 0.1 * int(profile["dexterity"]["integerValue"])
	
	# hp
	player.MAX_HEALTH = int(profile["max_hp"]["integerValue"])
	player.CURR_HEALTH = int(profile["curr_hp"]["integerValue"])
	
	# sp
	player.MAX_SP = int(profile["max_sp"]["integerValue"])
	player.CURR_SP = int(profile["curr_sp"]["integerValue"])
	
	# damage
	player.DAMAGE = 10 + int(profile["strength"]["integerValue"])
	
	# defense
	player.DEFENSE = 10 + int(profile["intelligence"]["integerValue"])
	
	# regen
	player.REGEN = 10 + int(profile["intelligence"]["integerValue"])
	
	# experience
	player.EXPERIENCE = int(profile["strength"]["integerValue"]) 
	+ int(profile["intelligence"]["integerValue"]) 
	+ int(profile["dexterity"]["integerValue"])
	
	# level
	player.LEVEL = round(player.EXPERIENCE / 10)
	
	# coins
	player.COINS = int(profile["coins"]["integerValue"])
	
	# gems
	player.GEMS = int(profile["gems"]["integerValue"])
	
	# stats
	player.STRENGTH = int(profile["strength"]["integerValue"])
	player.INTELLIGENCE = int(profile["intelligence"]["integerValue"])
	player.DEXTERITY = int(profile["dexterity"]["integerValue"])
	
	get_tree().get_root().add_child(world)
	print_debug("loaded")
