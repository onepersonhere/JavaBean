extends 'res://addons/gut/test.gd'

var openseas = load("res://NFT/Openseas.tscn")
var _openseas;
var _UI;

func before_each():
	_openseas = openseas.instance()
	_UI = load("res://UI/UI.tscn").instance()
	get_tree().get_root().add_child(_UI)
	get_tree().get_root().add_child(_openseas)
	
func after_each():
	if weakref(_openseas).get_ref() != null:
		_openseas.queue_free()
	_UI.queue_free()

func test_load_assets():
	# see if assets are loaded
	var children = _openseas.get_node("Shop/Control/ScrollContainer/HBoxContainer/VBoxContainer/MarginContainer").get_children()
	assert_not_null(children)

func test_back():
	_openseas.get_node("Shop")._on_Back_pressed()
	yield(get_tree().create_timer(0.5), "timeout")
	assert_false(is_instance_valid(_openseas))

func test_item_appears_in_inventory():
	GlobalVar.nft_addr = "0xd8b6eb581F77B1205fa312EC9C1A22D960B5900F"
	_openseas.check_purchase(
		"98022765745955927761920208486426559694950621028490842310820234511019612831754",
		"0x88b48f654c30e99bc2e4a1559b4dcf1ad93fa656")
	_openseas.get_node("Control")._on_ConfirmationDialog_confirmed()
	yield(_openseas.get_node("Control/AcceptDialog"), "about_to_show")
	assert_not_null(PlayerInventory.inventory[3][0])

