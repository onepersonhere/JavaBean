extends Node

func _ready():
	OS.center_window()
	if GlobalVar.prev_played != "":
		# reload every thing
		reset_quest_system()
		reset_global_var()
		reset_quest_manager()

func reset_quest_system():
	get_tree().get_root().remove_child(get_node("/root/QuestSystem"))
	get_tree().get_root().add_child(load("res://Quest/QuestSystem.tscn").instance())

func reset_global_var():
	get_tree().get_root().remove_child(get_node("/root/GlobalVar"))
	var node = Node.new()
	node.set_script(load("res://global_var.gd"))
	node.name = "GlobalVar"
	get_tree().get_root().add_child(node)
	
func reset_quest_manager():
	get_tree().get_root().remove_child(get_node("/root/QuestManager"))
	var node = Node.new()
	node.set_script(load("res://Quest/QuestManager.gd"))
	node.name = "QuestManager"
	get_tree().get_root().add_child(node)
