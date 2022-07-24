extends Action
class_name GiveQuestAction

export var quest_reference: PackedScene
var quest: Quest = null

func _ready() -> void:
	assert(quest_reference)
	
	if not is_quest_in_progress() && not is_quest_completed() && not is_quest_delivered():
		quest = QuestSystem.find_available(quest_reference.instance())
		quest.connect("started", self, "_on_Quest_started")
	else:
		quest = QuestSystem.find_active(quest_reference.instance())
		if is_quest_completed():
			quest = QuestSystem.find_completed(quest_reference.instance())
		elif is_quest_delivered():
			quest = QuestSystem.find_delivered(quest_reference.instance())
		_on_Quest_started()
		# set quest bubble
		var quest_bubble = get_parent().get_parent().get_node("QuestBubble")
		quest_bubble._on_Quest_started()
		# set has_spoken
		set_has_spoken()
		
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

func is_quest_completed():
	return QuestSystem.is_completed(quest_reference.instance())

func is_quest_delivered():
	return QuestSystem.is_delivered(quest_reference.instance())
	
func set_has_spoken():
	var dialogue = get_parent().find_node("DialogueAction")
	if dialogue != null:
		dialogue.has_spoken = true
