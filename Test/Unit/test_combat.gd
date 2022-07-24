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

func test_receive_damage():
	var damage = load("res://Hitboxes and Hurtboxes/Hitbox.tscn").instance()
	var dmg_amt = 10
	damage.damage = dmg_amt
	# get player's current health
	_player._on_PlayerHurtBox_area_entered(damage)
	assert_eq(PlayerStats.CURR_HEALTH, 90);

func test_give_damage():
	pass

func test_damage_changed():
	pass

func test_distance_to_receive_damage():
	pass

func test_distance_to_give_damage():
	pass

func test_death_screen():
	pass

func test_enemy_death():
	pass

func test_enemy_ai():
	pass
