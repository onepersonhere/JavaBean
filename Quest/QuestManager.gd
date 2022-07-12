extends Node
onready var quest_loader = load("res://Quest/Quest.tscn")
onready var rewards_loader = load("res://Quest/QuestItemReward.tscn")

func create_quest(name, description, objective, rewards, type):
	var quest = null
	match type:
		"QuestSlayObjective":
			quest = create_slay_quest(name, description, objective, rewards)
		"QuestInteractObjective":
			quest = create_interact_quest(name, description, objective, rewards)
	return quest;

func create_slay_quest(name, description, objective, rewards):
	var quest_scene = quest_loader.instance()
	quest_scene.title = name
	quest_scene.description = description
	quest_scene.reward_on_delivery = true
	
	var objective_scene = load("res://Quest/objectives/QuestSlayObjective.tscn").instance()
	
	objective_scene.battler_to_slay = load("res://Enemies/" + objective["battler_to_slay"]["stringValue"] + ".tscn")
	objective_scene.amount = int(objective["amount"]["integerValue"])
	
	for reward in rewards:
		var reward_scene = rewards_loader.instance()
		var fields = reward.mapValue.fields
		var item_name = fields.item_name.stringValue
		
		if item_name == "exp":
			quest_scene._reward_experience = int(fields.amount.integerValue)
		else:
			reward_scene.item_name = item_name
			reward_scene.amount = int(fields.amount.integerValue)
			quest_scene.get_node("ItemRewards").add_child(reward_scene)
	
	quest_scene.get_node("Objectives").add_child(objective_scene)
	
	return quest_scene

func create_interact_quest(name, description, objective, rewards):
	pass
	
func add_quest(quest):
	QuestSystem.add_available_quest(quest)
	QuestSystem.start(quest)
	get_tree().get_nodes_in_group("QuestJournal")[0]._on_quest_started(quest)
