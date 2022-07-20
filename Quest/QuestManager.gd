extends Node
onready var quest_loader = load("res://Quest/Quest.tscn")
onready var rewards_loader = load("res://Quest/QuestItemReward.tscn")

func create_quest(name, description, objective, rewards, type, reward_on_delivery):
	var quest = null
	match type:
		"QuestSlayObjective":
			quest = create_slay_quest(name, description, objective, rewards, reward_on_delivery)
		"QuestInteractObjective":
			quest = create_interact_quest(name, description, objective, rewards, reward_on_delivery)
		"TutorialObjective":
			quest = create_tutorial_quest(objective)
	return quest;

func create_slay_quest(name, description, objective, rewards, reward_on_delivery):
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
	quest_scene.reward_on_delivery = reward_on_delivery
	return quest_scene

func create_interact_quest(name, description, objective, rewards, reward_on_delivery):
	pass
	
func create_tutorial_quest(objective):
	var quest = load("res://Quest/quests/TutorialQuest.tscn").instance()
	quest.get_objectives()[0].stage = objective.stage
	return quest
	
func add_quest_and_start(quest):
	QuestSystem.add_available_quest(quest)
	QuestSystem.start(quest)
	get_tree().get_nodes_in_group("QuestJournal")[0]._on_quest_started(quest)

func quest_to_dict(quest: Quest):
	var quest_dict = {
		"mapValue": {
			"fields": {
				"name": {"stringValue": {}},
				"description": {"stringValue": {}},
				"objective": { # right now we restrict it to one objective
					"mapValue": {
						"fields": {}
					}
				},
				"reward" : {
					"arrayValue": {
						"values": []
					}
				},
				"reward_on_delivery": {"booleanValue": {}},
				"type": {
					"stringValue": {}
				}
			}
		}
	}
	
	quest_dict.mapValue.fields.name.stringValue = quest.title
	quest_dict.mapValue.fields.description.stringValue = quest.description
	quest_dict.mapValue.fields.reward_on_delivery.booleanValue = quest.reward_on_delivery
	
	# objectives
	var objective = quest.get_objectives()[0]
	if objective.name == "QuestSlayObjective":
		quest_dict.mapValue.fields.objective.mapValue.fields = add_slay_objective_to_dict(objective.battler_to_slay.instance().name, objective.amount)
		quest_dict.mapValue.fields.type.stringValue = "QuestSlayObjective"
	if objective.name == "TutorialObjective":
		quest_dict.mapValue.fields.objective.mapValue.fields = {
			"stage": {"stringValue": objective.stage}
		}
		quest_dict.mapValue.fields.type.stringValue = "TutorialObjective"
		
	# rewards
	for reward in quest.get_rewards().items:
		quest_dict.mapValue.fields.reward.arrayValue.values.append(add_reward_to_dict(reward));
	# exp
	quest_dict.mapValue.fields.reward.arrayValue.values.append({
		"mapValue": {
			"fields": {
				"amount" : {"integerValue": quest.get_rewards().experience},
				"item_name": {"stringValue": "exp"}
			}
		}
	})
	
	return quest_dict

func add_slay_objective_to_dict(battler_to_slay, amt): # there will be other objectives
	var objective = {
		"battler_to_slay": {"stringValue": battler_to_slay},
		"amount": {"integerValue": amt}
	}
	return objective

func add_reward_to_dict(reward: QuestItemReward):
	return {
		"mapValue": {
			"fields": {
				"amount": {"integerValue": reward.amount},
				"item_name": {"stringValue": reward.item_name}
			}
		}
	}

func quest_system_to_dict():
	var quest_system_dict = {
		"available": {
			"arrayValue": {
				"values": []
			}
		},
		"active": {
			"arrayValue": {
				"values": []
			}
		},
		"completed": {
			"arrayValue": {
				"values": []
			}
		},
		"delivered": {
			"arrayValue": {
				"values": []
			}
		}
	}
	var vals = ["available", "active", "completed", "delivered"];
	
	for val in vals:
		match val:
			"available":
				for quest in QuestSystem.available_quests.get_children():
					quest_system_dict[val].arrayValue.values.append(quest_to_dict(quest))
			"active":
				for quest in QuestSystem.active_quests.get_children():
					quest_system_dict[val].arrayValue.values.append(quest_to_dict(quest))
			"completed":
				for quest in QuestSystem.completed_quests.get_children():
					quest_system_dict[val].arrayValue.values.append(quest_to_dict(quest))
			"delivered":
				for quest in QuestSystem.delivered_quests.get_children():
					quest_system_dict[val].arrayValue.values.append(quest_to_dict(quest))
	return quest_system_dict
