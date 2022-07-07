extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	get_parent().queue_free()
	get_node("/root/UI/CanvasLayer/UserInterface/Hotbar").visible = true
	get_node("/root/UI/Quest GUI/Container").visible = true
	get_tree().paused = false
