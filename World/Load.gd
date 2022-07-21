extends Node


func load(profile):
	# var save_nodes = get_tree().get_nodes_in_group("persist")
	# for i in save_nodes:
	# 	i.queue_free()
	
	# exp
	PlayerStats.CURR_EXP = int(profile.curr_exp.integerValue)
	PlayerStats.MAX_EXP = int(profile.max_exp.integerValue)
	PlayerStats.LEVEL = int(profile.level.integerValue)
	
	# new game
	GlobalVar.new_game = bool(profile.new_game.booleanValue)
	
	#player
	var player: KinematicBody2D = load("res://Characters/MainCharacter.tscn").instance()
	
	# location
	var world: Node2D = set_location(profile, player)
	
	# get YSort
	if world.name == "World":
		var ysort = world.find_node("YSort")
		ysort.add_child(player)
	else:
		world.add_child(player)

	player.scale = Vector2(1, 1)
	player.find_node("Camera2D").zoom = Vector2(0.45, 0.45)
	
	# is alive
	PlayerStats.IS_ALIVE = true
	
	# nickname
	PlayerStats.NICKNAME = profile["nickname"]["stringValue"]
	
	# class
	match profile["character_class"]["stringValue"]:
		"warrior":
			PlayerStats.CHARACTER_CLASS = "warrior"
	
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
	
	# quest system
	load_quests(profile);
	
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
		"Lombok-Fort-Basement":
			world_name = "Basement"
		"Lombok-Dungeon-1":
			world_name = "DungeonBottomLeft"
		"Lombok-Dungeon-2":
			world_name = "DungeonBottomRight"
		"Lombok-Dungeon-3":
			world_name = "DungeonTop"
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

func load_quests(profile):
	if not get_node("/root/UserProfile").new_profile && not profile.quest.mapValue.empty():
		QuestSystem.reset_quest_system()
		
		if profile.quest.mapValue.fields.available.arrayValue.has("values"):
			for quest in profile.quest.mapValue.fields.available.arrayValue.values:
				var quest_instance = parse_quest_dict(quest.mapValue.fields)
				QuestSystem.add_available_quest(quest_instance)
				
		if profile.quest.mapValue.fields.active.arrayValue.has("values"):
			for quest in profile.quest.mapValue.fields.active.arrayValue.values:
				QuestSystem.add_active_quest(
					parse_quest_dict(quest.mapValue.fields)
				)
		if profile.quest.mapValue.fields.completed.arrayValue.has("values"):
			for quest in profile.quest.mapValue.fields.completed.arrayValue.values:
				QuestSystem.add_completed_quest(
					parse_quest_dict(quest.mapValue.fields)
				)
		if profile.quest.mapValue.fields.delivered.arrayValue.has("values"):
			for quest in profile.quest.mapValue.fields.delivered.arrayValue.values:
				QuestSystem.add_delivered_quest(
					parse_quest_dict(quest.mapValue.fields)
				)

	
func parse_quest_dict(quest):
	return QuestManager.create_quest(
		quest.name.stringValue,
		quest.description.stringValue,
		quest.objective.mapValue.fields,
		quest.reward.arrayValue.values,
		quest.type.stringValue,
		bool(quest.reward_on_delivery.booleanValue),
		quest.quest_name.stringValue
	)
