extends Node2D

func _ready():
	if QuestSystem.get_node_or_null("Available/TutorialQuest") == null:
		add_npc()

func add_npc():
	var npc = load("res://Characters/NPCs/Adventurer.tscn").instance()
	npc.set_position(Vector2(208,112));
	npc.respawn_on_interaction = true
	
	add_child(npc)

