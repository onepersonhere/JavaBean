extends StaticBody2D

export var openable = true;
export var flipped = false;
onready var animation = $AnimatedSprite
onready var collider = $Collider

func _ready():
	collider.set_disabled(openable);
	animation.set_animation("default")
	if flipped:
		animation.set_flip_h(true)


func _on_Area2D_body_entered(body):
	if body.name == "Player" && openable:
		animation.play("default")
		play_audio("res://Assets/Sounds/door_open.mp3")


func _on_Area2D_body_exited(body):
	if body.name == "Player" && openable:
		animation.play("default", true)
		play_audio("res://Assets/Sounds/door_close.mp3")

func play_audio(path):
	var audio = AudioStreamPlayer2D.new()
	audio.set_stream(GlobalVar.get_as_AudioStreamMp3(path))
	audio.connect("finished", self, "finished", [audio])
	add_child(audio)
	audio.play()

func finished(audio):
	audio.queue_free()
