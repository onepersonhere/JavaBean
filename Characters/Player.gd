extends KinematicBody2D
class_name Player

enum {
	WALK, RUN, ATTACK
}

export var NICKNAME = ""
export var CHARACTER_CLASS = "Warrior"

var state = WALK
var velocity = Vector2.ZERO

onready var playerStats = $PlayerStats
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
		velocity = velocity.move_toward(input_vector * playerStats.WALK_SPEED, playerStats.ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, playerStats.FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if playerStats.energy_bar.CURRENT_SP > 0 && Input.is_action_pressed("run"):
		state = RUN
	
func run_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		playerStats.energy_bar.sprint(3 * delta)
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		if playerStats.energy_bar.CURRENT_SP > 0:
			velocity = velocity.move_toward(input_vector * playerStats.RUN_SPEED, playerStats.ACCELERATION * delta)
		else:
			playerStats.energy_bar.stopped()
			animationState.travel("Walk")
			velocity = velocity.move_toward(input_vector * playerStats.WALK_SPEED, playerStats.ACCELERATION * delta)
	else:
		playerStats.energy_bar.stopped()
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, playerStats.FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		playerStats.energy_bar.stopped()
		state = ATTACK
	
	if !Input.is_action_pressed("run"):
		playerStats.energy_bar.stopped()
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
		playerStats.COINS += 1;
		update_stat_vals()

func _on_PlayerHurtBox_area_entered(area):
	playerStats.life_bar.deal_damage(area.damage)
	playerStats.CURR_HEALTH = playerStats.life_bar.CURRENT_HEALTH

func _on_LifeBar_no_health():
	queue_free()
	
func _on_EnergyBar_got_stamina():
	playerStats.can_sprint = true

func _on_EnergyBar_no_stamina():
	playerStats.can_sprint = false

func update_stat_vals():
	playerStats.UI.find_node("CoinCounter").get_node("Background").get_node("Number").text = str(playerStats.COINS);
	playerStats.UI.find_node("GemCounter").get_node("Background").get_node("Number").text = str(playerStats.GEMS);
