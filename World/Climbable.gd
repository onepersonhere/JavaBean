extends Area2D

func _on_Climbable_body_entered(body):
	print("yes")
	PlayerStats.is_climbing = true

func _on_Climbable_body_exited(body):
	print("no")
	PlayerStats.is_climbing = false
