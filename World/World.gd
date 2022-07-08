extends Node2D
signal combat_started

func _ready():
	yield(get_tree().create_timer(0.25), "timeout")
	# if ($YSort.find_node("Player") != null):
	
	QuestSystem.initialise(self, $YSort/Player);
	print("Quest System initialised")

func combat_start():
	emit_signal("combat_started")
