extends Action
export var item_name: String
export var item_quantity: int

func interact():
	print("interacted")
	PlayerInventory.add_item(item_name, item_quantity)
	active = false
	emit_signal("finished")
	queue_free()
