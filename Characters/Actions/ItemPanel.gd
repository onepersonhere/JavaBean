extends Panel

onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var price = $Price/Price_val.text
onready var amt = $Amt/Amt_val.text

func _ready():
	check_empty()
		
func _on_Sell_1_pressed():
	player.COINS += int(price);
	amt = str(int(amt) - 1);
	check_empty()

func _on_Sell_Half_pressed():
	player.COINS += int(price) * (int(amt) / 2);
	amt = str(int(amt)/2);
	check_empty()

func _on_Sell_All_pressed():
	player.COINS += int(price) * int(amt);
	amt = str(0);
	check_empty()

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
	
	update_inventory();
	add_to_shop();

func update_inventory():
	# TODO
	pass
	
func add_to_shop():
	# TODO
	pass
