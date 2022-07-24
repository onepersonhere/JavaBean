extends Area2D

onready var label = $Label

func _on_Future_Development_body_entered(body):
	if body.name == "Player":
		label.visible = true


func _on_Future_Development_body_exited(body):
		label.visible = false
