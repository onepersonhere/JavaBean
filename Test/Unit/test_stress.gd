extends 'res://addons/gut/test.gd'

var world = load("res://World/World.tscn")
var _world = null
var player = load("res://Characters/MainCharacter.tscn")
var _player = null
var UI = load("res://UI/UI.tscn")
var _UI = null

func before_each():
	_world = world.instance()
	_UI = UI.instance()
	_player = player.instance()
	
	get_node("/root").add_child(_UI)
	PlayerStats.UI_created()
	
	get_node("/root").add_child(_world)
	get_node("/root/World/YSort").add_child(_player)

func after_each():
	_world.queue_free()
	_UI.queue_free()

# These tests should be run in isolation
func test_stress_bat_100():
	#var bat = load("res://Enemies/Bat.tscn")
	
	#for i in range(100):
	#	var _bat = bat.instance()
	#	_world.add_child(_bat)
	#assert_almost_eq(_world.get_child_count(), 100, 10)
	pass
func test_stress_bat_300():
	#var bat = load("res://Enemies/Bat.tscn")
	
	#for i in range(500):
	#	var _bat = bat.instance()
	#	_world.add_child(_bat)
	#assert_almost_eq(_world.get_child_count(), 300, 10)
	pass
func test_stress_bat_500():
	#var bat = load("res://Enemies/Bat.tscn")
	
	#for i in range(500):
	#	var _bat = bat.instance()
	#	_world.add_child(_bat)
	#assert_almost_eq(_world.get_child_count(), 500, 10)
	pass
