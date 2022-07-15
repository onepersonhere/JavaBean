extends Node
class_name CompleteQuestAction

signal finished
export var quest_reference: PackedScene
var quest: Quest = null
var active: bool = true

func _ready() -> void:
	assert(quest_reference)
	quest = QuestSystem.find_available(quest_reference.instance())
	active = false
	quest.connect("completed", self, "_on_Quest_completed")


func _on_Quest_completed() -> void:
	active = true


func interact() -> void:
	get_tree().paused = false
	if not active:
		emit_signal("finished")
		return
	QuestSystem.deliver(quest)
	active = false
	emit_signal("finished")
