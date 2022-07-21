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
	
func test_position():
	_player.set_position(Vector2(1936, 968))
	assert_true(_player.position.x == 1936 and _player.position.y == 968)

func test_item_position():
	_player.set_position(Vector2(1936, 968))
	var item_drop = load("res://Inventory/Items/ItemDrop.tscn").instance()
	get_node("/root/World/YSort").add_child(item_drop)
	
	item_drop.position.x = _player.position.x
	item_drop.position.y = _player.position.y
	
	assert_true(item_drop.position.x == 1936 and item_drop.position.y == 968)
	item_drop.queue_free()
	
func test_item_pickup():
	# Sometimes fails for some reason? Not really sure why
	var item_drop = load("res://Inventory/Items/ItemDrop.tscn").instance()
	get_node("/root/World/YSort").add_child(item_drop)
	
	var pick_up_zone = get_node("/root/World/YSort/Player/PickupZone")
	pick_up_zone._on_PickupZone_body_entered(item_drop)
	
	var a = InputEventAction.new()
	a.action = "interact"
	a.pressed = true
	_player._input(a)
	
	yield(get_tree().create_timer(2), "timeout")
	assert_freed(item_drop)

