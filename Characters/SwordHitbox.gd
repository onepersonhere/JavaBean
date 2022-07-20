extends "res://Hitboxes and Hurtboxes/Hitbox.gd"

var knockback_vector = Vector2.ZERO

func _ready():
	damage = PlayerStats.DAMAGE
	#warning-ignore:return_value_discarded
	PlayerStats.connect("update", self, "update")

func update():
	damage = PlayerStats.DAMAGE
