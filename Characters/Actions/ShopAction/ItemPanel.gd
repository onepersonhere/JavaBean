extends Panel

onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var price = $Price/Price_val.text
onready var amt = $Amt/Amt_val.text
var amt_sold = 0;
var location;
var slot;
var item_name;
var odd = false;

func _ready():
	check_empty()
		
func _on_Sell_1_pressed():
	amt_sold = 1;
	player.COINS += int(price);
	
	amt = str(int(amt) - amt_sold);
	check_empty()
	update_inventory()
	update_shop_panels()
	
func _on_Sell_Half_pressed():
	if int(amt) % 2 != 0:
		odd = true
	amt_sold = floor(float(amt)/2)
	player.COINS += int(price) * int(amt_sold);
	
	amt = str(amt_sold);
	check_empty()
	update_inventory()
	update_shop_panels()
	
func _on_Sell_All_pressed():
	amt_sold = int(amt)
	player.COINS += int(price) * amt_sold;
	
	amt = str(0);
	check_empty()
	update_inventory()
	update_shop_panels()
	
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
		PlayerInventory.remove_item(slot)
		get_tree().get_nodes_in_group("Hotbar")[0].initialise_hotbar()
	else:
		if odd:
			PlayerInventory.add_item_quantity(slot, -1 * (amt_sold + 1))
			odd = false;
		else:
			PlayerInventory.add_item_quantity(slot, -1 * amt_sold)
	
func add_to_shop():
	# TODO
	pass

func update_shop_panels():
	var nodes = get_tree().get_nodes_in_group("item_panel_shop")
	for node in nodes:
		node.check_empty()
