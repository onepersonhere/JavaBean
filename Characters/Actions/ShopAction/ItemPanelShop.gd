extends Panel
onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var price = $Price/Price_val.text
onready var amt = $Amt/Amt_val.text
var item_name;

func _ready():
	check_empty()

func _on_Buy_1_pressed():
	var cost = int(price);
	if is_affordable(cost):
		player.COINS -= cost
		amt = str(int(amt) - 1);
		check_empty()
		update_inventory(1)

func _on_Buy_Half_pressed():
	var amount = int(amt) / 2
	var cost = int(price) * amount;
	if is_affordable(cost):
		player.COINS -= cost
		amt = str(int(amt)/2);
		check_empty()
		update_inventory(amount)

func _on_Buy_All_pressed():
	var amount = int(amt)
	var cost = int(price) * amount;
	if is_affordable(cost):
		player.COINS -= cost
		amt = str(0);
		check_empty()
		update_inventory(amount)
	
func check_empty():
	if player.COINS <= 0:
		toggle_disabled(true)
	else:
		toggle_disabled(false)
	
	if int(amt) < 2:
		$"Buy Half".disabled = true;
	if amt == str(0):
		queue_free()
	update_vals()

func update_vals():
	$Amt/Amt_val.text = amt;
	get_tree().get_nodes_in_group("ShopAction")[0].update_val()
	player.update_stat_vals();
	

func update_inventory(amt_bought):
	var idx = PlayerInventory.inventory.size();
	var idx_hotbar = PlayerInventory.hotbar.size();
	
	if (idx < PlayerInventory.NUM_INVENTORY_SLOTS): #BUG: item is not added to hotbar when inv is full
		PlayerInventory.inventory[idx] = [item_name, int(amt_bought)]
	elif (idx_hotbar < PlayerInventory.NUM_HOTBAR_SLOTS):
		PlayerInventory.hotbar[idx] = [item_name, int(amt_bought)]
	
	
	var parent = player.get_node("UI").get_node("CanvasLayer").get_node("UserInterface")
	RefreshInv.refresh(parent)
	
	# load inventory stuff
	get_tree().get_nodes_in_group("shop_inventory")[0].load_inventory_stuff()
	
	
func is_affordable(cost):
	# Also check if full
	var idx = PlayerInventory.inventory.size();
	var idx_hotbar = PlayerInventory.hotbar.size(); #BUG: does not detect if inventory is full, also did not take note of the stack size
	return player.COINS - cost >= 0 && (idx < PlayerInventory.NUM_INVENTORY_SLOTS || idx_hotbar < PlayerInventory.NUM_HOTBAR_SLOTS);

func toggle_disabled(boolean):
	$"Buy 1".disabled = boolean;
	$"Buy Half".disabled = boolean;
	$"Buy All".disabled = boolean;
