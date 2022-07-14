extends "res://Characters/NPCs/NPC.gd"

func _ready():
	# Copied from parent, no super in gdscript
	var quest_actions: Array = []
	for action in actions.get_children():
		if not (action is GiveQuestAction or action is CompleteQuestAction):
			continue
		quest_actions.append(action)
	if quest_actions.size() == 0:
		return
	quest_bubble.initialize(quest_actions)
	
	if GlobalVar.new_game:
		$"Press E".material.set_shader_param("value", 1)
	else:
		$"Press E".hide()

func _input(event):
	# Copied from parent, no super in gdscript
	if event.is_action_pressed("interact") && nearby:
		$"Press E".hide()
		var actions = $Actions.get_children()
		assert(actions != [])
		for action in actions:
			action.interact()
			yield(action, "finished")
		emit_signal("interaction_finished", self)
		if vanish_on_interaction:
			queue_free()

