extends Node


func load(profile):
	# var save_nodes = get_tree().get_nodes_in_group("persist")
	# for i in save_nodes:
	# 	i.queue_free()
	
	var player: KinematicBody2D = load("res://Characters/MainCharacter.tscn").instance()
	# location
	var world: Node2D = set_location(profile, player)
	
	# get YSort
	var ysort = world.find_node("YSort")
	ysort.add_child(player)
	player.scale = Vector2(1, 1)
	player.find_node("Camera2D").zoom = Vector2(0.45, 0.45)
	
	# is alive
	PlayerStats.IS_ALIVE = true
	
	# nickname
	player.NICKNAME = profile["nickname"]["stringValue"]
	
	# class
	match profile["character_class"]["stringValue"]:
		"warrior":
			player.CHARACTER_CLASS = "warrior"
	
	# movement
	PlayerStats.BASE_ACCELERATION = 1000 + 1 * int(profile["dexterity"]["integerValue"])
	PlayerStats.BASE_FRICTION = 1000 + 1 * int(profile["dexterity"]["integerValue"])
	PlayerStats.BASE_WALK_SPEED = 120 + 0.1 * int(profile["dexterity"]["integerValue"])
	PlayerStats.BASE_RUN_SPEED = 220 + 0.1 * int(profile["dexterity"]["integerValue"])
	
	# hp
	PlayerStats.BASE_MAX_HEALTH = int(profile["max_hp"]["integerValue"])
	PlayerStats.CURR_HEALTH = int(profile["curr_hp"]["integerValue"])
	
	# sp
	PlayerStats.BASE_MAX_SP = int(profile["max_sp"]["integerValue"])
	PlayerStats.CURR_SP = int(profile["curr_sp"]["integerValue"])
	
	# damage
	PlayerStats.BASE_DAMAGE = 10 + int(profile["strength"]["integerValue"])
	
	# defense
	PlayerStats.BASE_DEFENSE = 10 + int(profile["intelligence"]["integerValue"])
	
	# regen
	PlayerStats.BASE_REGEN = 10 + int(profile["intelligence"]["integerValue"])
	
	# experience
	PlayerStats.EXPERIENCE = int(profile["strength"]["integerValue"]) 
	+ int(profile["intelligence"]["integerValue"]) 
	+ int(profile["dexterity"]["integerValue"])
	
	# level
	PlayerStats.LEVEL = round(PlayerStats.EXPERIENCE / 10)
	
	# coins
	PlayerStats.COINS = int(profile["coins"]["integerValue"])
	
	# gems
	PlayerStats.GEMS = int(profile["gems"]["integerValue"])
	
	# stats
	PlayerStats.STRENGTH = int(profile["strength"]["integerValue"])
	PlayerStats.INTELLIGENCE = int(profile["intelligence"]["integerValue"])
	PlayerStats.DEXTERITY = int(profile["dexterity"]["integerValue"])
	
	PlayerStats.base_stat_assigned()
	
	# inventory
	load_inventory(profile);
	
	get_tree().get_root().add_child(world)
	print_debug("loaded")

func set_location(profile, player):
	var world_name = "World" # default
	var location: String = profile["location"]["stringValue"]
	var map: String = location.split(" ")[0]
	var pos_x: int = int(location.split(" ")[1].split(",")[0].split("(")[1])
	var pos_y: int = int(location.split(" ")[1].split(",")[1].split(")")[0])
	player.set_position(Vector2(pos_x, pos_y))
	
	match map:
		"Lombok-House":
			world_name = "House/House";
		"Lombok-House-2":
			world_name = "House/HouseSecondFloor"
		"Lombok-Farmhouse":
			world_name = "FarmHouse/FarmHouse"
		"Lombok-Fort-House":
			world_name = "FortifiedHouse/FortifiedHouse"
		"Lombok-Fort-Inn":
			world_name = "Inn/Inn"
		"Lombok-Fort-Inn-2":
			world_name = "Inn/InnSecondFloor"
		# others can add below
	return load("res://World/"+ world_name +".tscn").instance()
	
func load_inventory(profile):
	PlayerInventory.inventory = {}
	var stages = ["inventory", "hotbar", "equips"]
	
	for stage in stages:
		var map = profile.inventory.mapValue.fields[stage].mapValue.fields
		for item in map:
			var item_name = map[item].arrayValue.values[0].stringValue
			var item_quantity = int(map[item].arrayValue.values[1].integerValue)
			match stage:
				"inventory":
					PlayerInventory.inventory[int(item)] = [item_name, item_quantity];
				"hotbar":
					PlayerInventory.hotbar[int(item)] = [item_name, item_quantity];
				"equips":
					PlayerInventory.equips[int(item)] = [item_name, item_quantity];
	InventoryManager.refresh_inventory()
