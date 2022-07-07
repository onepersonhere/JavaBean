extends Action
class_name GiveQuestAction

export var quest_reference: PackedScene
var quest: Quest = null

func _ready() -> void:
	assert(quest_reference)
	if not is_quest_in_progress():
		quest = QuestSystem.find_available(quest_reference.instance())
		quest.connect("started", self, "_on_Quest_started")
	else:
		quest = QuestSystem.find_active(quest_reference.instance())
		quest.connect("started", self, "_on_Quest_started")
		_on_Quest_started()
		

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

func is_quest_in_progress():
	return QuestSystem.is_active(quest_reference.instance())
