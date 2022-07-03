extends Action


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact():
	if active:
		$Popup.popup_centered()
		active = false
	else:
		$Popup.hide()
		emit_signal("finished")
		active = true
