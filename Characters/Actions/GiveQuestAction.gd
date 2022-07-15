extends Node
class_name GiveQuestAction

signal finished
export var quest_reference: PackedScene
var quest: Quest = null
var active: bool = true

func _ready() -> void:
	assert(quest_reference)
	quest = QuestSystem.find_available(quest_reference.instance())
	quest.connect("started", self, "_on_Quest_started")


func _on_Quest_started():
	active = false


func interact() -> void:
	if not active:
		emit_signal("finished")
		return
	var quest: Quest = quest_reference.instance()
	
	if not QuestSystem.is_available(quest):
		return
	
	QuestSystem.start(quest)
	emit_signal("finished")
