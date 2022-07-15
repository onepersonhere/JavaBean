extends Action
class_name ShopAction

func _ready():
	pass # Replace with function body.


func interact():
	get_tree().paused = !get_tree().paused
	if active:
		$Popup.popup_centered()
		active = false
		
		update_val()
		$Popup/Inventory.load_inventory_stuff()
		$Popup/Shop.load_shop_stuff()
	else:
		$Popup.hide()
		emit_signal("finished")
		active = true

func update_val():
	var player = get_tree().get_nodes_in_group("Player")[0];
	$Popup/Coins/Coins_value.text = str(PlayerStats.COINS)
	$Popup/Gems/Gems_value.text = str(PlayerStats.GEMS)
	

