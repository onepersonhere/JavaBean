extends KinematicBody2D
class_name Player

const HealIndicator = preload("res://UI/Indicators/HealIndicator.tscn")
const ReceiveDamageIndicator = preload("res://UI/Indicators/ReceiveDamageIndicator.tscn")

enum {
	WALK, RUN, CLIMB, ATTACK
}

var state = WALK
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitBoxDirection/SwordHitBox
onready var axeHitbox = $AxeHitBox
onready var audioPlayer = $AudioManager

func _ready():
	swordHitbox.knockback_vector = Vector2.DOWN
	animationTree.set("parameters/Idle/blend_position", Vector2.DOWN)
	animationTree.set("parameters/Walk/blend_position", Vector2.DOWN)
	animationTree.set("parameters/Run/blend_position", Vector2.DOWN)
	animationTree.set("parameters/Attack/blend_position", Vector2.DOWN)
	animationTree.active = true
	update_stat_vals()
	randomize()
	PlayerStats.life_bar.connect("no_health", self, "_on_LifeBar_no_health")

func _physics_process(delta):
	match state:
		WALK:
			walk_state(delta)
		RUN:
			run_state(delta)
		CLIMB:
			climb_state(delta)
		ATTACK:
			attack_state(delta)

func walk_state(delta):
	audioPlayer.play_footsteps(WALK)
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
		velocity = velocity.move_toward(input_vector * PlayerStats.WALK_SPEED, PlayerStats.ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, PlayerStats.FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		audioPlayer.play_attack()
		state = ATTACK
	
	if PlayerStats.energy_bar.CURRENT_SP > 0 && Input.is_action_pressed("run"):
		state = RUN
		
	if PlayerStats.is_climbing:
		state = CLIMB
	
func run_state(delta):
	audioPlayer.play_footsteps(RUN)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		PlayerStats.energy_bar.sprint(3 * delta)
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		if PlayerStats.energy_bar.CURRENT_SP > 0:
			velocity = velocity.move_toward(input_vector * PlayerStats.RUN_SPEED, PlayerStats.ACCELERATION * delta)
		else:
			PlayerStats.energy_bar.stopped()
			animationState.travel("Walk")
			velocity = velocity.move_toward(input_vector * PlayerStats.WALK_SPEED, PlayerStats.ACCELERATION * delta)
	else:
		PlayerStats.energy_bar.stopped()
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, PlayerStats.FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		audioPlayer.play_attack()
		PlayerStats.energy_bar.stopped()
		state = ATTACK
	
	if !Input.is_action_pressed("run"):
		PlayerStats.energy_bar.stopped()
		state = WALK
	
	if PlayerStats.is_climbing:
		PlayerStats.energy_bar.stopped()
		state = CLIMB
		
func climb_state(delta):
	audioPlayer.play_footsteps(CLIMB)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationState.travel("Climbing")
		velocity = velocity.move_toward(input_vector * PlayerStats.CLIMB_SPEED, PlayerStats.ACCELERATION * delta)
	else:
		animationState.travel("Backward Idle")
		velocity = velocity.move_toward(Vector2.ZERO, PlayerStats.FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	if !PlayerStats.is_climbing:
		state = WALK

func attack_state(_delta):
	velocity = Vector2.ZERO
	var category = InventoryManager.get_active_item_category()
	if category == "Sword":
		animationState.travel("Attack")
	else:
		animationState.travel("Axe Attack")
	"""
	else:
		animationState.travel("Fist Attack")
	"""
	
func attack_animation_finished():
	state = WALK
	
func _input(event):
	if event.is_action_pressed("interact"):
		$PickupZone.pickup(self)
	
	# cheats for debugging purposes
	if event.is_action_pressed("add_money"):
		PlayerStats.COINS += 1;
		update_stat_vals()
		
	if event.is_action_pressed("use"):
		if InventoryManager.get_active_item_name() == "Slime Potion" && !PlayerStats.life_bar.is_full_health():
			var healValue = InventoryManager.get_active_item_stats()["AddHealth"]
			var hotbar = get_tree().get_nodes_in_group("UI")[0].get_node("CanvasLayer/UserInterface/Hotbar")
			var slot = hotbar.slots[PlayerInventory.active_item_slot_index]
			PlayerInventory.add_item_quantity(slot, -1)
			PlayerStats.life_bar.heal(healValue)
			spawn_heal_indicator("+" + str(healValue))
			hotbar.initialise_hotbar()

func _on_PlayerHurtBox_area_entered(area):
	audioPlayer.play_hurt()
	PlayerStats.life_bar.deal_damage(area.damage)
	PlayerStats.CURR_HEALTH = PlayerStats.life_bar.CURRENT_HEALTH
	spawn_receive_damage_indicator("-" + str(area.damage))

func _on_LifeBar_no_health():
	get_tree().paused = true
	audioPlayer.play_death()
	get_node("/root/UI").add_child(load("res://UI/GameOver.tscn").instance())
	
func _on_EnergyBar_got_stamina():
	PlayerStats.can_sprint = true

func _on_EnergyBar_no_stamina():
	audioPlayer.play_no_stamina()
	PlayerStats.can_sprint = false

func update_stat_vals():
	PlayerStats.UI.find_node("CoinCounter").get_node("Background").get_node("Number").text = str(PlayerStats.COINS);
	PlayerStats.UI.find_node("GemCounter").get_node("Background").get_node("Number").text = str(PlayerStats.GEMS);

func spawn_heal_indicator(heal):
	audioPlayer.play_heal()
	var heal_indicator = HealIndicator.instance()
	get_parent().add_child(heal_indicator)
	heal_indicator.set_value(heal)
	heal_indicator.global_position = Vector2(global_position.x, global_position.y - 20)
	
func spawn_receive_damage_indicator(damage):
	var receive_damage_indicator = ReceiveDamageIndicator.instance()
	get_parent().add_child(receive_damage_indicator)
	receive_damage_indicator.set_value(damage)
	receive_damage_indicator.global_position = global_position
