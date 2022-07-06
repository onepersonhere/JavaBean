extends Node


func refresh(parent, item_name):
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
	
	stack_items(item_name, PlayerInventory.inventory)
	
# stack items in the inventory
func stack_items(item_name, location):
	var max_stack_size = int(JsonData.item_data[item_name]["StackSize"])
	
	var stack_size_array: Array;
	stack_size_array.resize(PlayerInventory.NUM_INVENTORY_SLOTS + 1)
	var curr_stack_size = 0;
	
	for item in location:
		if location[item][0] == item_name:
			stack_size_array[item] = location[item][1]
			curr_stack_size += location[item][1]
			
	# restack them
	for i in range(1, stack_size_array.size()):
		if stack_size_array[i] != null && curr_stack_size >= 0:
			var amt = 0;
			if max_stack_size < curr_stack_size:
				amt = max_stack_size;
			else:
				amt = curr_stack_size;
			location[i][1] = amt
			curr_stack_size -= max_stack_size;
