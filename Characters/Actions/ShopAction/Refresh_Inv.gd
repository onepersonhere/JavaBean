extends Node


func refresh(parent):
	var old_inventory = get_tree().get_nodes_in_group("Inventory")[0]
	var old_hotbar = get_tree().get_nodes_in_group("Hotbar")[0]
	
	var inventory = load("res://Inventory/Inventory.tscn").instance();
	var hotbar = load("res://Inventory/Hotbar.tscn").instance();
	# properties to match
	var name = old_inventory.get_name()
	old_inventory.set_name("old_inventory")
	inventory.set_name(name)
	
	name = old_hotbar.get_name()
	old_hotbar.set_name("old_hotbar")
	hotbar.set_name(name)
	
	inventory.set_position(old_inventory.get_position())
	hotbar.set_position(old_hotbar.get_position())
	
	inventory.visible = old_inventory.visible
	hotbar.set_scale(old_hotbar.get_scale())
	
	old_inventory.queue_free()
	old_hotbar.queue_free()
	
	parent.add_child(inventory, true);
	parent.add_child(hotbar, true);
