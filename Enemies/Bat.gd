extends KinematicBody2D

const DeathEffect = preload("res://Effects/BatDeathEffect.tscn")

signal died(battler)

var ACCELERATION = 150
var MAX_SPEED = 60
var FRICTION = 150
var ATTACK_RATE = 1

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

onready var timer = $Timer
onready var stats = $Stats
onready var sprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision

func _ready():
	timer.one_shot = true

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
			
	if softCollision.is_colliding():
		velocity = softCollision.get_push_vector() * delta * 200
	velocity = move_and_slide(velocity)
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Bat_HurtBox_area_entered(area):
	get_node("/root/World").combat_start()
	knockback = area.knockback_vector * 150
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
	var batDeathEffect = DeathEffect.instance()
	get_parent().add_child(batDeathEffect)
	batDeathEffect.global_position = global_position
	emit_signal("died", self)

func _on_Timer_timeout():
	$HitBox/CollisionShape2D.set_disabled(false)
	
func _on_HitBox_area_entered(area):
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	timer.start(ATTACK_RATE)
