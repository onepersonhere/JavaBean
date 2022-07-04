extends Panel

onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var price = $Price/Price_val.text
onready var amt = $Amt/Amt_val.text
var location;
var stuff;

func _ready():
	check_empty()
		
func _on_Sell_1_pressed():
	player.COINS += int(price);
	amt = str(int(amt) - 1);
	check_empty()
	update_inventory()

func _on_Sell_Half_pressed():
	player.COINS += int(price) * (int(amt) / 2);
	amt = str(int(amt)/2);
	check_empty()
	update_inventory()

func _on_Sell_All_pressed():
	player.COINS += int(price) * int(amt);
	amt = str(0);
	check_empty()
	update_inventory()

func check_empty():
	if int(amt) < 2:
		$"Sell Half".disabled = true;
	if amt == str(0):
		queue_free()
	update_vals()

func update_vals():
	# reassign to update
	$Amt/Amt_val.text = amt;
	get_tree().get_nodes_in_group("ShopAction")[0].update_val()
	player.update_stat_vals();
	
	add_to_shop();

func update_inventory():
	if int(amt) == 0:
		match location:
			"inventory":
				PlayerInventory.inventory.erase(stuff)
			"hotbar":
				PlayerInventory.hotbar.erase(stuff)
	else:
		match location:
			"inventory":
				PlayerInventory.inventory[stuff][1] = amt
			"hotbar":
				PlayerInventory.hotbar[stuff][1] = amt
				
	var parent = player.get_node("UI").get_node("CanvasLayer").get_node("UserInterface")
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
		
	
func add_to_shop():
	# TODO
	pass
