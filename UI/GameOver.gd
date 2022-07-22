extends CanvasLayer

func _on_Main_Menu_pressed():
	get_tree().paused = false
	get_tree().get_nodes_in_group("map")[0].queue_free()
	get_node("/root/UI").queue_free()
	#warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")
