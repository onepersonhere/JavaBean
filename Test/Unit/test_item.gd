extends 'res://addons/gut/test.gd'


func test_item_freed():
	var item = load("res://Inventory/Items/ItemDrop.tscn").instance()
	get_node("/root").add_child(item)
	yield(get_tree().create_timer(10), "timeout")
	assert_freed(item)
