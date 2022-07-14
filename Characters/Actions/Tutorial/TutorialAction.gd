extends DialogueAction

var dialogue
func _ready():
	pass

func interact():
	if active && not has_spoken:
		get_tree().paused = true
		active = false
		
		dialogue = Dialogic.start("Tutorial")
		dialogue.connect("dialogic_signal", self, "dialog_listener")
		
		add_child(dialogue)
		get_child(0).layer = 3

func dialog_listener(string):
	match string:
		"Adventurer's house":
			get_child(0).queue_free()
			dialogue = Dialogic.start("Adventurer's House")
			dialogue.connect("dialogic_signal", self, "dialog_listener")
			get_child(0).layer = 3
			
		"Combat Tutorial":
			get_child(0).queue_free()
			dialogue = Dialogic.start("Combat Tutorial")
			dialogue.connect("dialogic_signal", self, "dialog_listener")
			get_child(0).layer = 3
			
			combat_tutorial();
			get_tree().paused = false
			
		"end":
			get_tree().paused = false
			active = false
			emit_signal("finished")

func combat_tutorial():
	pass
