extends Node2D
signal combat_started

func _ready():
	QuestSystem.initialise(self, $YSort/Player)

func combat_start():
	emit_signal("combat_started")
