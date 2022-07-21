extends Panel
onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var price = $Price/Price_val.text
onready var amt = $Amt/Amt_val.text
onready var parent = get_parent().get_parent().get_parent();
var item_name;

func _ready():
	check_empty()

func _on_Buy_1_pressed():
	var cost = int(price);
	if is_affordable(cost):
		PlayerStats.COINS -= cost
		amt = str(int(amt) - 1);
		check_empty()
		update_inventory(1)

func _on_Buy_Half_pressed():
	var amount = int(amt) / 2
	var cost = int(price) * amount;
	if is_affordable(cost):
		PlayerStats.COINS -= cost
		amt = str(int(amt)/2);
		check_empty()
		update_inventory(amount)

func _on_Buy_All_pressed():
	var amount = int(amt)
	var cost = int(price) * amount;
	if is_affordable(cost):
		PlayerStats.COINS -= cost
		amt = str(0);
		check_empty()
		update_inventory(amount)
	
func check_empty():
	if PlayerStats.COINS <= 0:
		toggle_disabled(true)
	else:
		toggle_disabled(false)
	
	check_stack()
	
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
	PlayerInventory.add_item(item_name, amt_bought)
	get_tree().get_nodes_in_group("Inventory")[0].initialise_inventory()
	get_tree().get_nodes_in_group("Hotbar")[0].initialise_hotbar()
	# load inventory stuff
	get_tree().get_nodes_in_group("shop_inventory")[0].load_inventory_stuff()
	
	# TODO: Distribute items to hotbar once inventory is full
	if InventoryManager.is_full():
		# full
		parent.toggle_disabled_global(true)
	
func is_affordable(cost):
	# Also check if full
	var idx = PlayerInventory.inventory.size();
	var idx_hotbar = PlayerInventory.hotbar.size(); 
	return PlayerStats.COINS - cost >= 0 && (idx < PlayerInventory.NUM_INVENTORY_SLOTS || idx_hotbar < PlayerInventory.NUM_HOTBAR_SLOTS);

func toggle_disabled(boolean):
	$"Buy 1".disabled = boolean;
	$"Buy Half".disabled = boolean;
	$"Buy All".disabled = boolean;

func check_stack():
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size <= 1:
		$"Buy Half".disabled = true
		$"Buy All".disabled = true


func _on_MenuButton_pressed():
	var item = JsonData.item_data[item_name]
	for properties in item:
		$MenuButton.get_popup().add_item(properties + ": " + str(item[properties]))
