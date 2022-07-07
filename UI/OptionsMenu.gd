extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SaveGame_pressed():
	Save.save()
	$Label.text = "Done"
	$Label.visible = true
	yield(get_tree().create_timer(1), "timeout")
	$Label.visible = false
	remove_child(get_node("Save"))


func _on_Settings_pressed():
	$Label.text = "WIP"
	$Label.visible = true
	yield(get_tree().create_timer(1), "timeout")
	$Label.visible = false
	# get_tree().change_scene("res://UI/Options.tscn")


func _on_Quests_pressed():
	get_node("/root/World/YSort/Player/UI/Quest GUI")._on_QuestButton_pressed()
	_on_Close_pressed()

func _on_Shop_pressed():
	var shop_nft = load("res://NFT/Openseas.tscn").instance()
	var parent = get_node("/root/World/YSort/Player/UI")
	parent.add_child(shop_nft)
	get_node("/root/World/YSort/Player/UI/Quest GUI/Container").visible = false
	get_node("/root/World/YSort/Player/UI/CanvasLayer/UserInterface/Hotbar").visible = false
	_on_Close_pressed()
	get_tree().paused = true
	
func _on_Map_pressed():
	var parent = get_node("/root/World/YSort/Player/UI")
	var minimap = load("res://UI/Minimap/Minimap.tscn").instance()
	parent.add_child(minimap)
	get_node("/root/World/YSort/Player/UI/CanvasLayer/UserInterface/Hotbar").visible = false
	_on_Close_pressed()
	get_tree().paused = true


func _on_Inventory_pressed():
	var ev = InputEventAction.new()
	ev.action = "inventory"
	ev.pressed = true
	Input.parse_input_event(ev)
	_on_Close_pressed()


func _on_Help_pressed():
	$Label.text = "No help for you!"
	$Label.visible = true
	yield(get_tree().create_timer(1), "timeout")
	$Label.visible = false


func _on_Main_Menu_pressed():
	get_tree().paused = false
	get_node("/root/World").queue_free()
	get_tree().change_scene("res://UI/Main Menu.tscn")


func _on_Exit_pressed():
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().quit()


func _on_Close_pressed():
	hide()
