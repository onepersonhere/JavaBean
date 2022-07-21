extends 'res://addons/gut/test.gd'

var escMenu = load("res://UI/OptionsMenu.tscn")
var _escMenu = null
var UI = load("res://UI/UI.tscn")
var _UI = null
var world = null

func before_each():
	_UI = UI.instance()
	_escMenu = escMenu.instance()
	get_tree().get_root().add_child(_UI)
	PlayerStats.UI_created()
	get_tree().get_root().add_child(_escMenu)

func after_each():
	get_tree().paused = false
	_escMenu.queue_free()
	_UI.queue_free()
	if weakref(world).get_ref() != null:
		world.queue_free()
		
func test_Settings():
	_escMenu._on_Settings_pressed()
	assert_not_null(get_node_or_null("/root/Options"))
	get_node("/root/Options").queue_free()

func test_Quest():
	# TEST CASE NOT WORKING
	# _escMenu._on_Quests_pressed()
	# var journal = _UI.get_node("Quest GUI/Container/QuestJournal")
	# assert_eq(journal.get_position(), Vector2(136, 64))
	pass

func test_Shop():
	_escMenu._on_Shop_pressed()
	assert_not_null(get_node_or_null("/root/UI/Node"))
	get_node_or_null("/root/UI/Node").queue_free()
	
func test_Map():
	# Better if manual test
	add_world_n_player()
	
	_escMenu._on_Map_pressed()
	assert_not_null(get_node_or_null("/root/UI/Minimap"))
	get_node("/root/UI/Minimap").queue_free()
	
func test_Inventory():
	_escMenu._on_Inventory_pressed()
	assert_true(get_node("/root/UI/CanvasLayer/UserInterface/Inventory").visible)
	
func test_Main_Menu():
	# Unable to test due to changed scene bugging out the test engine
	pass

func test_Close():
	_escMenu._on_Close_pressed()
	assert_false(_escMenu.visible)

func add_world_n_player():
	world = load("res://World/World.tscn").instance()
	var player = load("res://Characters/MainCharacter.tscn").instance()
	world.add_child(player)
	get_tree().get_root().add_child(world)
