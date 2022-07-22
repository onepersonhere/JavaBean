extends Area2D

func _on_Climbable_body_entered(body):
	PlayerStats.is_climbing = true

func _on_Climbable_body_exited(body):
	PlayerStats.is_climbing = false
