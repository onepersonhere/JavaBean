extends Area2D

export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_HurtBox_area_entered(_area):
	if show_hit:
		var effect = HitEffect.instance()
		var main = get_tree().get_nodes_in_group("map")[0]
		main.add_child(effect)
		effect.global_position = global_position
