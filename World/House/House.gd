extends Node2D

func _ready():
	if QuestSystem.get_node_or_null("Delivered/TutorialQuest") != null:
		add_npc()
	if QuestSystem.get_node_or_null("Active/TutorialQuest") != null: 
		if QuestSystem.get_node("Active/TutorialQuest/Objectives/TutorialObjective").get_stage() == "Adventurer's House":
			add_npc()

func add_npc():
	var npc = load("res://Characters/NPCs/Adventurer.tscn").instance()
	npc.set_position(Vector2(208,112));
	add_child(npc)
