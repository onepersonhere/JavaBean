extends "res://Hitboxes and Hurtboxes/Hitbox.gd"

var knockback_vector = Vector2.ZERO

func _ready():
	damage = PlayerStats.DAMAGE
