extends Node2D
signal combat_started

func _ready():
	yield(get_tree().create_timer(0.25), "timeout")
	QuestSystem.initialise(self, $YSort/Player)

func combat_start():
	emit_signal("combat_started")
