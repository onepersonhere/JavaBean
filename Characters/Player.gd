extends KinematicBody2D
class_name Player

export var NICKNAME = ""
export var CHARACTER_CLASS = "Warrior"

var ACCELERATION = 1000
var WALK_SPEED = 120
var RUN_SPEED = 220
var FRICTION = 1000

onready var DAMAGE = $HitBoxDirection/SwordHitBox.damage
var DEFENSE = 0

onready var UI = get_tree().get_nodes_in_group("UI")[0].get_node("Stats/GUI/HBoxContainer")

onready var life_bar = UI.find_node("LifeBar")
onready var energy_bar = UI.find_node("EnergyBar")

onready var CURR_HEALTH = life_bar.CURRENT_HEALTH
onready var MAX_HEALTH = life_bar.MAX_HEALTH

onready var CURR_SP = energy_bar.CURRENT_SP
onready var MAX_SP = energy_bar.MAX_SP
onready var REGEN = energy_bar.RECHARGE

var can_sprint = true
var IS_ALIVE = true

var EXPERIENCE = 0
var LEVEL = 0
var COINS = 0
var GEMS = 0

var STRENGTH = 0
var INTELLIGENCE = 0
var DEXTERITY = 0

var MAP = "Lombok"

enum {
	WALK, RUN, ATTACK
}

var state = WALK
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitBoxDirection/SwordHitBox

func _ready():
	swordHitbox.knockback_vector = Vector2.DOWN
	animationTree.set("parameters/Idle/blend_position", Vector2.DOWN)
	animationTree.set("parameters/Walk/blend_position", Vector2.DOWN)
	animationTree.set("parameters/Run/blend_position", Vector2.DOWN)
	animationTree.set("parameters/Attack/blend_position", Vector2.DOWN)
	animationTree.active = true
	update_stat_vals()
	randomize()

func _physics_process(delta):
	match state:
		WALK:
			walk_state(delta)
		RUN:
			run_state(delta)
		ATTACK:
			attack_state(delta)

func walk_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * WALK_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if energy_bar.CURRENT_SP > 0 && Input.is_action_pressed("run"):
		state = RUN
	
func run_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		energy_bar.sprint(3 * delta)
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		if energy_bar.CURRENT_SP > 0:
			velocity = velocity.move_toward(input_vector * RUN_SPEED, ACCELERATION * delta)
		else:
			energy_bar.stopped()
			animationState.travel("Walk")
			velocity = velocity.move_toward(input_vector * WALK_SPEED, ACCELERATION * delta)
	else:
		energy_bar.stopped()
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		energy_bar.stopped()
		state = ATTACK
	
	if !Input.is_action_pressed("run"):
		energy_bar.stopped()
		state = WALK

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = WALK
	
func _input(event):
	if event.is_action_pressed("interact"):
		$PickupZone.pickup(self)
	
	# cheats for debugging purposes
	if event.is_action_pressed("add_money"):
		COINS += 1;
		update_stat_vals()

func _on_PlayerHurtBox_area_entered(area):
	life_bar.deal_damage(area.damage)
	CURR_HEALTH = life_bar.CURRENT_HEALTH

func _on_LifeBar_no_health():
	queue_free()
	
func _on_EnergyBar_got_stamina():
	can_sprint = true

func _on_EnergyBar_no_stamina():
	can_sprint = false

func update_stat_vals():
	UI.find_node("CoinCounter").get_node("Background").get_node("Number").text = str(COINS);
	UI.find_node("GemCounter").get_node("Background").get_node("Number").text = str(GEMS);
