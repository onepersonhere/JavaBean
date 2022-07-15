extends Action
class_name DialogueAction
export var timeline: String;
var has_spoken = false;
export var repeat = false;

func _ready():
	pass

func interact() -> void:
	if active && (not has_spoken || repeat):
		get_tree().paused = true
		active = false
		var dialogue = Dialogic.start(timeline)
		dialogue.connect("dialogic_signal", self, "dialog_listener")
		add_child(dialogue)
		get_child(0).layer = 3
		
func dialog_listener(string):
	match string:
		"end":
			get_tree().paused = false
			active = true
			emit_signal("finished")
