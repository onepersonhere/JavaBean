extends Node2D
signal combat_started

func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	# if ($YSort.find_node("Player") != null):
	
	QuestSystem.initialise(self, $YSort/Player);
	# print("Quest System initialised")
	
	# for first timer:
	if GlobalVar.new_game == true || QuestSystem.find_available(load("res://Quest/quests/TutorialQuest.tscn").instance()) != null:
		var npc = load("res://Characters/NPCs/Adventurer.tscn").instance()
		npc.set_position(Vector2(1816, 1000))
		$YSort/NPC.add_child(npc)

func _exit_tree():
	if QuestSystem.find_available(load("res://Quest/quests/TutorialQuest.tscn").instance()) == null:
		GlobalVar.new_game = false;
			
func combat_start():
	emit_signal("combat_started")
