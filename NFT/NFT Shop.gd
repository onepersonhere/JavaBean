extends CanvasLayer

func _ready():
	pass # Replace with function body.


func _on_Back_pressed():
	get_parent().queue_free()
	get_node("/root/UI/CanvasLayer/UserInterface/Hotbar").visible = true
	get_node("/root/UI/Quest GUI/Container").visible = true
	get_tree().paused = false

