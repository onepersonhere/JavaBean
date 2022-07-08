extends 'res://addons/gut/test.gd'

var world = load("res://World/World.tscn")
var _world = null
var player = null

func before_each():
	_world = world.instance()
	get_node("/root").add_child(_world)
	player = get_node("/root/World/YSort/Player")

func after_each():
	_world.queue_free()

func test_position():
	assert_true(player.position.x == 1936 and player.position.y == 968)

func test_item_position():
	var item_drop = load("res://Inventory/Items/ItemDrop.tscn").instance()
	get_node("/root/World/YSort").add_child(item_drop)
	
	item_drop.position.x = player.position.x
	item_drop.position.y = player.position.y
	
	assert_true(item_drop.position.x == 1936 and item_drop.position.y == 968)
	item_drop.queue_free()
	
func test_item_pickup():
	var item_drop = load("res://Inventory/Items/ItemDrop.tscn").instance()
	get_node("/root/World/YSort").add_child(item_drop)
	
	var pick_up_zone = get_node("/root/World/YSort/Player/PickupZone")
	pick_up_zone._on_PickupZone_body_entered(item_drop)
	
	var a = InputEventAction.new()
	a.action = "pickup"
	a.pressed = true
	player._input(a)
	
	yield(get_tree().create_timer(1), "timeout")
	assert_freed(item_drop)

