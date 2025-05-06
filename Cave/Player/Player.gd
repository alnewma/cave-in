extends CharacterBody2D

var can_be_controlled = true

var speed = 120
var health = 100 : set = _health_changed
@export var male = true
@export var attack_cooldown = 1.5
@export var attack_damage = 30

@onready var man = $man_sprite
@onready var woman = $woman_sprite
@onready var animation_tree = $AnimationTree
@onready var game_map = null
var in_main_game = false

func _ready():
	if get_parent().name == "GameMap":
		game_map = get_parent()
		in_main_game = true
	man.visible = male
	woman.visible = not male
	animation_tree.active = true
	# set variables from save data
	if in_main_game:
		global_position = GameHandler.save_game_instance.player_data.player_character_stats.global_position
	health = GameHandler.save_game_instance.player_data.player_character_stats.health

func _physics_process(delta):
	movement(delta)
	update_animation_parameters()

func _process(_delta):
	attack()

func movement(_delta):
	if dead:
		velocity = velocity.move_toward(Vector2.ZERO,_delta*250)
	if can_be_controlled:
		velocity = Vector2.ZERO
		if Input.is_action_pressed("move_down"):
			velocity += Vector2(0,1)
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-1,0)
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(1,0)
		if Input.is_action_pressed("move_up"):
			velocity += Vector2(0,-1)
		if velocity != Vector2.ZERO:
			velocity = speed * velocity.normalized()
		if velocity.dot(Vector2(cos(PI+attack_area.rotation),sin(PI+attack_area.rotation))) < 0:
			velocity *= .5
	move_and_slide()
	GameHandler.save_game_instance.player_data.player_character_stats.global_position = global_position

func update_animation_parameters():
	#if velocity.x != 0: # makes player face walking direction
		#animation_tree["parameters/Attack/blend_position"] = velocity.x
		#animation_tree["parameters/Death/blend_position"] = velocity.x
		#animation_tree["parameters/Idle/blend_position"] = velocity.x
		#animation_tree["parameters/Walk/blend_position"] = velocity.x
	# makes player face attack direction
	if can_be_controlled:
		animation_tree["parameters/Attack/blend_position"] = -cos(attack_area.rotation)
		animation_tree["parameters/Death/blend_position"] = -cos(attack_area.rotation)
		animation_tree["parameters/Idle/blend_position"] = -cos(attack_area.rotation)
		animation_tree["parameters/Walk/blend_position"] = -cos(attack_area.rotation)
	if health <= 0:
		animation_tree["parameters/conditions/is_attacking"] = false
		animation_tree["parameters/conditions/is_dead"] = true
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = false
	elif attacking_currently:
		animation_tree["parameters/conditions/is_attacking"] = true
		animation_tree["parameters/conditions/is_dead"] = false
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = false
	elif velocity != Vector2.ZERO:
		animation_tree["parameters/conditions/is_attacking"] = false
		animation_tree["parameters/conditions/is_dead"] = false
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = true
	elif velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/is_attacking"] = false
		animation_tree["parameters/conditions/is_dead"] = false
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_walking"] = false

@onready var attack_area = $attack_area
@onready var attack_cooldown_timer = $attack_cooldown
var on_attack_cooldown = false
@export var attacking_currently = false
var enemies_in_attack_radius = []
func attack():
	attack_area.rotation = attack_area.global_position.angle_to_point(get_global_mouse_position())+PI
	if not on_attack_cooldown:
		if Input.is_action_just_pressed("attack"):
			on_attack_cooldown = true
			attacking_currently = true
			attack_cooldown_timer.start(attack_cooldown)
			get_tree().create_timer(.6).connect("timeout",attack_deal_damage)
			get_tree().create_timer(.8).connect("timeout",_attack_ended)
func attack_deal_damage():
	if enemies_in_attack_radius.size() > 0:
		GameHandler.damage_target(self,enemies_in_attack_radius[0],attack_damage)
func _on_attack_cooldown_timeout():
	on_attack_cooldown = false
func _attack_ended():
	attacking_currently = false
func _on_attack_area_body_entered(body):
	if body.is_in_group("enemy") and not body in enemies_in_attack_radius:
		enemies_in_attack_radius.append(body)
func _on_attack_area_body_exited(body):
	enemies_in_attack_radius.erase(body)

func _health_changed(val):
	health = val
	if health <= 0:
		_player_died()
	GameHandler.save_game_instance.player_data.player_character_stats.health = val

var dead := false
func _player_died():
	if not dead:
		dead = true
		can_be_controlled = false
		if game_map:
			game_map.trigger_ending(game_map.ending_types.PLAYER_DEAD)

## Survivors Following Player Logic ##

var assigned_survivors = [] # survivors following player
var using_survivors = []

func set_assigned_survivors(value,add_or_erase : bool):
	_verify_self_array_existence()
	if add_or_erase: # adding
		if not value in assigned_survivors:
			assigned_survivors.append(value)
	else:
		if value in assigned_survivors:
			assigned_survivors.erase(value)
	GameHandler.save_game_instance.player_data.objective_data[name][0] = assigned_survivors.duplicate()

func set_using_survivors(value,add_or_erase : bool):
	_verify_self_array_existence()
	if add_or_erase: # adding
		if not value in using_survivors:
			using_survivors.append(value)
	else:
		if value in using_survivors:
			using_survivors.erase(value)
	GameHandler.save_game_instance.player_data.objective_data[name][1] = using_survivors.duplicate()
	
func _verify_self_array_existence():
	GameHandler.save_game_instance.player_data.objective_data.get_or_add(name,[assigned_survivors.duplicate(),using_survivors.duplicate()])
