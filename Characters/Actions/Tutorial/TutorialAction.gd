extends DialogueAction

var dialog_scene = "Tutorial"

func _ready():
	pass

func interact():
	if not GlobalVar.new_game:
		dialog_scene = get_node("/root/QuestSystem/Active/TutorialQuest/Objectives/TutorialObjective").get_stage()
		
	if active && not has_spoken:
		get_tree().paused = true
		active = false
		
		var dialogue = Dialogic.start(dialog_scene)
		dialogue.connect("dialogic_signal", self, "dialog_listener")
		
		add_child(dialogue)
		get_child(0).layer = 3

func dialog_listener(string):
	match string:
		"end":
			get_tree().paused = false
			active = false
			emit_signal("finished")
		
		"skipped":
			var quest = QuestSystem.get_node("Available/TutorialQuest")
			QuestSystem.skip_quest(quest)
			get_tree().paused = false
			active = false
			emit_signal("finished")

func change_dialog(new_scene):
	dialog_scene = new_scene
