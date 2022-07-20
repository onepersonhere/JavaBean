extends DialogueAction

var dialog_scene = "Tutorial"
onready var TutorialQuest = load("res://Quest/quests/TutorialQuest.tscn")
func _ready():
	if not GlobalVar.new_game and QuestSystem.find_available(TutorialQuest.instance()) == null:
		var dialog = QuestSystem.find_active(TutorialQuest.instance())
		if dialog == null:
			dialog = QuestSystem.find_delivered(TutorialQuest.instance())
		dialog_scene = dialog.get_objectives()[0].get_stage()
		if dialog_scene == "skipped" || dialog_scene == "completed":
			skipped()

func interact():
	if not GlobalVar.new_game and QuestSystem.find_available(TutorialQuest.instance()) == null:
		var dialog = QuestSystem.find_active(TutorialQuest.instance())
		if dialog == null:
			dialog = QuestSystem.find_delivered(TutorialQuest.instance())
		dialog_scene = dialog.get_objectives()[0].get_stage()
		if dialog_scene == "skipped" || dialog_scene == "completed":
			skipped()
		
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
			get_parent().get_parent().queue_free()

func change_dialog(new_scene):
	dialog_scene = new_scene

func skipped():
	var parent = get_parent().get_parent()
	parent.get_node("QuestBubble").hide()
	parent.get_node("Press E").hide()
	active = false
