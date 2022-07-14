extends Area2D
class_name NPC

onready var quest_bubble: Node = $QuestBubble
onready var actions: Node = $Actions

signal interaction_finished(NPC)
export var vanish_on_interaction := false
var nearby = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var quest_actions: Array = []
	for action in actions.get_children():
		if not (action is GiveQuestAction or action is CompleteQuestAction):
			continue
		quest_actions.append(action)
	if quest_actions.size() == 0:
		return
	quest_bubble.initialize(quest_actions)

func _input(event):
	if event.is_action_pressed("interact") && nearby:
		var actions = $Actions.get_children()
		assert(actions != [])
		for action in actions:
			action.interact()
			yield(action, "finished")
		emit_signal("interaction_finished", self)
		if vanish_on_interaction:
			queue_free()


func _on_NPC_body_entered(body):
	if body.name == "Player":
		nearby = true


func _on_NPC_body_exited(body):
	if body.name == "Player":
		nearby = false
