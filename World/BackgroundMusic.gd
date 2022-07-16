extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_stream(GlobalVar.random_background_music())
	play()


func _on_BackgroundMusic_finished():
	set_stream(GlobalVar.random_background_music())
	play()
