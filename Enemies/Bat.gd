extends KinematicBody2D

const DeathEffect = preload("res://Effects/BatDeathEffect.tscn")
const DamageIndicator = preload("res://UI/Indicators/DamageIndicator.tscn")
const ExpIndicator = preload("res://UI/Indicators/ExpIndicator.tscn")
const CoinIndicator = preload("res://UI/Indicators/CoinIndicator.tscn")

signal died(battler)

var ACCELERATION = 150
var MAX_SPEED = 60
var FRICTION = 150
var ATTACK_RATE = 1
var MIN_EXP = 4
var MAX_EXP = 8
var MIN_COIN = 0
var MAX_COIN = 10

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
onready var wanderController = $WanderController

func _ready():
	timer.one_shot = true
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 2))
			
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 2))
			
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
			
			if global_position.distance_to(wanderController.target_position) <= 4:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 2))
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
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
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Bat_HurtBox_area_entered(area):
	get_node("/root/World").combat_start()
	spawn_damage_indicator(area.damage)
	knockback = area.knockback_vector * 150
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
	var batDeathEffect = DeathEffect.instance()
	get_parent().add_child(batDeathEffect)
	batDeathEffect.global_position = global_position
	emit_signal("died", self)
	
	var exp_gain = floor(rand_range(MIN_EXP, MAX_EXP))
	PlayerStats.exp_bar.gain_exp(exp_gain)
	
	var coins_gain = floor(rand_range(MIN_COIN, MAX_COIN))
	PlayerStats.COINS += coins_gain;
	spawn_coin_indicator(coins_gain)
	get_tree().get_nodes_in_group("Player")[0].update_stat_vals()
	
	spawn_exp_indicator(exp_gain)

func _on_Timer_timeout():
	$HitBox/CollisionShape2D.set_disabled(false)
	
func _on_HitBox_area_entered(area):
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	timer.start(ATTACK_RATE)

func spawn_damage_indicator(damage):
	var damage_indicator = DamageIndicator.instance()
	get_parent().add_child(damage_indicator)
	damage_indicator.set_value(damage)
	damage_indicator.global_position = global_position
	
func spawn_exp_indicator(value):
	var exp_indicator = ExpIndicator.instance()
	get_parent().add_child(exp_indicator)
	exp_indicator.set_value(value)
	exp_indicator.global_position = global_position
	
func spawn_coin_indicator(value):
	var coin_indicator = CoinIndicator.instance()
	get_parent().add_child(coin_indicator)
	coin_indicator.set_value(value)
	coin_indicator.global_position = global_position


