extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false

onready var UI = get_tree().get_nodes_in_group("UI")[0]


func _on_SaveGame_pressed():
	Save.save()
	$Label.text = "Done"
	$Label.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$Label.visible = false


func _on_Settings_pressed():
	get_tree().get_root().add_child(load("res://UI/Options.tscn").instance())


func _on_Quests_pressed():
	UI.get_node("Quest GUI")._on_QuestButton_pressed()
	_on_Close_pressed()

func _on_Shop_pressed():
	var shop_nft = load("res://NFT/Openseas.tscn").instance()
	var parent = UI
	parent.add_child(shop_nft)
	UI.get_node("Quest GUI/Container").visible = false
	UI.get_node("CanvasLayer/UserInterface/Hotbar").visible = false
	_on_Close_pressed()
	get_tree().paused = true
	
func _on_Map_pressed():
	var parent = UI
	var minimap = load("res://UI/Minimap/Minimap.tscn").instance()
	parent.add_child(minimap)
	UI.get_node("CanvasLayer/UserInterface/Hotbar").visible = false
	_on_Close_pressed()
	get_tree().paused = true


func _on_Inventory_pressed():
	var ev = InputEventAction.new()
	ev.action = "inventory"
	ev.pressed = true
	Input.parse_input_event(ev)
	_on_Close_pressed()


func _on_Help_pressed():
	# Expansion: implement a help screen
	$Label.text = "No help for you!"
	$Label.visible = true
	yield(get_tree().create_timer(1), "timeout")
	$Label.visible = false


func _on_Main_Menu_pressed():
	get_tree().paused = false
	get_tree().get_nodes_in_group("map")[0].queue_free()
	get_node("/root/UI").queue_free()
	#warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/Main Menu.tscn")


func _on_Exit_pressed():
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().quit()


func _on_Close_pressed():
	hide()
