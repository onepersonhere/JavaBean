extends "res://Hitboxes and Hurtboxes/Hitbox.gd"

var knockback_vector = Vector2.ZERO

func _ready():
	damage = PlayerStats.DAMAGE
	PlayerStats.connect("update", self, "update")

func update():
	damage = PlayerStats.DAMAGE
	print_debug(damage)
