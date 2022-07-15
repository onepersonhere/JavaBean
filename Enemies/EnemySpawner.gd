extends Node
class_name EnemySpawner

export var enemy: PackedScene = load("res://Enemies/Bat.tscn")
export var quantity = 3;

signal spawned

func spawn(_min: Vector2, _max: Vector2):
	var rng = RandomNumberGenerator.new()
	var parent = get_parent()
	rng.randomize()
	
	for i in range(1, quantity):
		var instanced_ememy = enemy.instance();
		instanced_ememy.position = Vector2(rng.randf_range(_min.x, _max.x), rng.randf_range(_min.y, _max.y))
		parent.add_child(instanced_ememy)
	
	emit_signal("spawned")

