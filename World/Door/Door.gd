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


func _on_Area2D_body_exited(body):
	if body.name == "Player" && openable:
		animation.play("default", true)
