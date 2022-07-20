extends Area2D

export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(_area):
	if show_hit:
		var effect = HitEffect.instance()
		var main  = get_node("/root/World")
		main.add_child(effect)
		effect.global_position = global_position

