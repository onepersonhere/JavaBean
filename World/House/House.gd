extends Node2D

func _ready():
	if QuestSystem.find_available(load("res://Quest/quests/TutorialQuest.tscn").instance()) == null:
		add_npc()

func add_npc():
	var npc = load("res://Characters/NPCs/Adventurer.tscn").instance()
	npc.set_position(Vector2(208,112));
	npc.respawn_on_interaction = true
	
	add_child(npc)

