extends KinematicBody2D

export var NICKNAME = ""
export var CHARACTER_CLASS = "Warrior"

export var ACCELERATION = 1000
export var WALK_SPEED = 120
export var SPRINT_SPEED = 220
export var FRICTION = 1000

export var DAMAGE = 0
export var DEFENSE = 0
export var CURR_HEALTH = 0
export var MAX_HEALTH = 0
export var CURR_SP = 0
export var MAX_SP = 0
export var REGEN = 0
export var IS_ALIVE = true
export var EXPERIENCE = 0
export var LEVEL = 0
export var COINS = 0
export var GEMS = 0

export var STRENGTH = 0
export var INTELLIGENCE = 0
export var DEXTERITY = 0

export var MAP = "Lombok"

enum {
	WALK, SPRINT, ATTACK
}

var is_right = false
var state = WALK
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitBoxDirection/SwordHitBox

func _physics_process(delta):
	match state:
		WALK:
			walk_state(delta)
		SPRINT:
			sprint_state(delta)
		ATTACK:
			attack_state(delta)

func walk_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			is_right = true
			swordHitbox.knockback_vector = Vector2(1, 0)
			animationTree.set("parameters/Walk/blend_position", Vector2(1, 0))
			animationTree.set("parameters/Sprint/blend_position", Vector2(1, 0))
			animationTree.set("parameters/Attack/blend_position", Vector2(1, 0))
		elif input_vector.x < 0:
			is_right = false
			swordHitbox.knockback_vector = Vector2(-1, 0)
			animationTree.set("parameters/Walk/blend_position", Vector2(-1, 0))
			animationTree.set("parameters/Sprint/blend_position", Vector2(-1, 0))
			animationTree.set("parameters/Attack/blend_position", Vector2(-1, 0))
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * WALK_SPEED, ACCELERATION * delta)
	else:
		if is_right == true:
			animationTree.set("parameters/Idle/blend_position", Vector2(1, 0))
		else:
			animationTree.set("parameters/Idle/blend_position", Vector2(-1, 0))
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_pressed("sprint"):
		state = SPRINT
		
	
func sprint_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			is_right = true
			swordHitbox.knockback_vector = Vector2(1, 0)
			animationTree.set("parameters/Walk/blend_position", Vector2(1, 0))
			animationTree.set("parameters/Sprint/blend_position", Vector2(1, 0))
			animationTree.set("parameters/Attack/blend_position", Vector2(1, 0))
		elif input_vector.x < 0:
			is_right = false
			swordHitbox.knockback_vector = Vector2(-1, 0)
			animationTree.set("parameters/Walk/blend_position", Vector2(-1, 0))
			animationTree.set("parameters/Sprint/blend_position", Vector2(-1, 0))
			animationTree.set("parameters/Attack/blend_position", Vector2(-1, 0))
		animationState.travel("Sprint")
		velocity = velocity.move_toward(input_vector * SPRINT_SPEED, ACCELERATION * delta)
	else:
		if is_right == true:
			animationTree.set("parameters/Idle/blend_position", Vector2(1, 0))
		else:
			animationTree.set("parameters/Idle/blend_position", Vector2(-1, 0))
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if !Input.is_action_pressed("sprint"):
		state = WALK

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = WALK
	
func _input(event):
	if event.is_action_pressed("pickup"):
		$PickupZone.pickup(self)
