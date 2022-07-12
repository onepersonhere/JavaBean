extends "res://Hitboxes and Hurtboxes/Hitbox.gd"

var knockback_vector = Vector2.ZERO
onready var playerStats = get_node("../../PlayerStats")

func _ready():
	damage = playerStats.DAMAGE
