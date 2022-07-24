extends 'res://addons/gut/test.gd'

var world = load("res://World/World.tscn")
var _world = null
var player = load("res://Characters/MainCharacter.tscn")
var _player = null
var enemy = load("res://Enemies/Bat.tscn")
var _enemy = null
var UI = load("res://UI/UI.tscn")
var _UI = null

func before_each():
	_world = world.instance()
	_UI = UI.instance()
	_player = player.instance()
	_enemy = enemy.instance()
	
	get_node("/root").add_child(_UI)
	PlayerStats.UI_created()
	
	get_node("/root").add_child(_world)
	get_node("/root/World/YSort").add_child(_player)
	get_node("/root/World/YSort/Enemies").add_child(_enemy)

func after_each():
	_world.queue_free()
	_UI.queue_free()

func test_receive_damage():
	var damage = load("res://Hitboxes and Hurtboxes/Hitbox.tscn").instance()
	var dmg_amt = 10
	damage.damage = dmg_amt
	# get player's current health
	_player._on_PlayerHurtBox_area_entered(damage)
	assert_eq(PlayerStats.CURR_HEALTH, 90);

func test_give_damage():
	var damage = _player.get_node("HitBoxDirection/SwordHitBox")
	var before_hit = _enemy.get_node("Stats").health
	_enemy._on_Bat_HurtBox_area_entered(damage)
	var after_hit = _enemy.get_node("Stats").health
	
	assert_true(before_hit > after_hit)

func test_damage_changed():
	# may not pass due to the change in the position of the default items?
	var before_val = PlayerStats.DAMAGE
	PlayerInventory.active_item_scroll_up()
	var after_val = PlayerStats.DAMAGE
	# based on current default inventory (Inventory is not defaut)
	assert_almost_eq(before_val, after_val, 10)

# Edge cases
func test_distance_to_receive_damage():
	get_tree().paused = false
	var before_hit = _enemy.get_node("Stats").health
	
	_player.set_position(Vector2(_enemy.position.x + 16, _enemy.position.y));
	fake_click("move_left")
	fake_click("right_click")
	
	var after_hit = _enemy.get_node("Stats").health
	assert_eq(before_hit, after_hit)
	
	before_hit = _enemy.get_node("Stats").health
	# yield(get_tree().create_timer(1), "timeout")
	
	_player.set_position(Vector2(_enemy.position.x + 15, _enemy.position.y));
	fake_click("move_left")
	fake_click("right_click")
	
	after_hit = _enemy.get_node("Stats").health
	assert_true(before_hit > after_hit)

func test_distance_to_give_damage():
	pass

func test_death_screen():
	var damage = load("res://Hitboxes and Hurtboxes/Hitbox.tscn").instance()
	var dmg_amt = 100
	damage.damage = dmg_amt
	# get player's current health
	_player._on_PlayerHurtBox_area_entered(damage)
	assert_not_null(get_node("/root/UI/GameOver"))

func test_enemy_death():
	var damage = _player.get_node("HitBoxDirection/SwordHitBox")
	for i in range(100):
		_enemy._on_Bat_HurtBox_area_entered(damage)
	yield(get_tree().create_timer(1), "timeout")
	assert_false(is_instance_valid(_enemy))

func test_enemy_ai():
	get_tree().paused = false
	_player.set_position(Vector2(_enemy.position.x + 112, _enemy.position.y));
	yield(get_tree().create_timer(3), "timeout")
	assert_almost_eq(_player.get_position(), _enemy.get_position(), Vector2(10, 5))

func fake_click(evv):
	var ev = InputEventAction.new()
	ev.action = evv
	ev.pressed = true
	Input.parse_input_event(ev)
