extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SaveGame_pressed():
	pass # Replace with function body.


func _on_Settings_pressed():
	get_tree().change_scene("res://UI/Options.tscn")


func _on_Quests_pressed():
	pass # Replace with function body.


func _on_Shop_pressed():
	pass # Replace with function body.


func _on_Map_pressed():
	pass # Replace with function body.


func _on_Inventory_pressed():
	var ev = InputEventAction.new()
	ev.action = "inventory"
	ev.pressed = true
	Input.parse_input_event(ev)


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
