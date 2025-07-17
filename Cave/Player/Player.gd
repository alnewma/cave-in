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
		if not GameHandler.player_typing:
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
			AudioManager.play_effect(AudioManager.effects.WOOSH,0,0,.3)
			_handle_attack_effect()
			get_tree().create_timer(.6).connect("timeout",attack_deal_damage)
			get_tree().create_timer(.8).connect("timeout",_attack_ended)
@onready var attack_effect = $attackEffect
func _handle_attack_effect():
	attack_effect.rotation_degrees = attack_area.rotation_degrees-45
	attack_effect.play("default")
	attack_effect.show()
func attack_deal_damage():
	if enemies_in_attack_radius.size() > 0:
		GameHandler.damage_target(self,enemies_in_attack_radius[0],attack_damage)
		match enemies_in_attack_radius[0].get_meta("enemy_type"):
			"spider":
				AudioManager.play_effect(AudioManager.effects.SPIDER_PUNCH)
			"bat":
				AudioManager.play_effect(AudioManager.effects.BAT_PUNCH)
			"dog":
				AudioManager.play_effect(AudioManager.effects.DOG_PUNCH)
			"rat":
				AudioManager.play_effect(AudioManager.effects.DOG_PUNCH)
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
	_adjust_effects_for_health()
	if health <= 0:
		_player_died()
	GameHandler.save_game_instance.player_data.player_character_stats.health = val

var current_light_tween
var current_low_pass_tween
var current_reverb_tween
@onready var tweens = [current_light_tween,current_low_pass_tween,current_reverb_tween]
var in_critical_state_effects = false
func _adjust_effects_for_health():
	if in_main_game:
		var light = $light
		if health <= 30 and health > 0: # currently doesn't apply effects if dead
			if not in_critical_state_effects:
				in_critical_state_effects = true
				for t in tweens:
					if t:
						t.stop()
				current_light_tween = get_tree().create_tween().tween_property(light,"color",Color("ffc9c993"),.25)
				var low_pass_filter = AudioServer.get_bus_effect(0,0)
				var reverb_filter = AudioServer.get_bus_effect(0,1)
				current_low_pass_tween = get_tree().create_tween().tween_property(low_pass_filter,"cutoff_hz",1000,.25)
				current_reverb_tween = get_tree().create_tween().tween_property(reverb_filter,"wet",.2,.25)
				if not heartbeat_player.playing:
					heartbeat_player.play()
		elif in_critical_state_effects:
			in_critical_state_effects = false
			for t in tweens:
				if t:
					t.stop()
			current_light_tween = get_tree().create_tween().tween_property(light,"color",Color("ffffff93"),2)
			var low_pass_filter = AudioServer.get_bus_effect(0,0)
			var reverb_filter = AudioServer.get_bus_effect(0,1)
			current_low_pass_tween = get_tree().create_tween().tween_property(low_pass_filter,"cutoff_hz",20500,2)
			current_reverb_tween = get_tree().create_tween().tween_property(reverb_filter,"wet",0.0,2)

var taking_damage = false : set = _on_taking_damage
var last_damage_taken_time = 0
func _on_taking_damage(value):
	if value:
		last_damage_taken_time = Time.get_ticks_msec()
	
func _on_healing_timer_timeout() -> void:
	pass
	if Time.get_ticks_msec() - last_damage_taken_time > 5000: # if 5 seconds has passed since last hit
		if health <= 30:
			health += 1

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


## Audio ##

var nearby_enemies = []
func _on_aggro_range_body_entered(body: Node2D) -> void:
	nearby_enemies.append(body)
	if nearby_enemies.size() == 1:
		AudioManager.pause_audio()
		# play combat music or make louder if already has streamer
		if AudioManager.search_effect(AudioManager.effects.DRUMS) > 0:
			AudioManager.increase_effect(AudioManager.effects.DRUMS,0)
		else:
			AudioManager.play_effect(AudioManager.effects.DRUMS)
func _on_aggro_range_body_exited(body: Node2D) -> void:
	nearby_enemies.erase(body)
	if nearby_enemies.size() == 0:
		# deafen combat music
		AudioManager.deafen_effect(AudioManager.effects.DRUMS,-15)
		var start_time = Time.get_ticks_msec()
		var grace_period_duration = 5 # seconds after no enemy with quieter combat music
		while Time.get_ticks_msec() - start_time < int(grace_period_duration * 1000):
			if nearby_enemies.size() != 0:
				return
			await Engine.get_main_loop().process_frame  # Wait 1 frame before checking again
		AudioManager.stop_effect(AudioManager.effects.DRUMS)
		var silence_duration = 3 # seconds
		start_time = Time.get_ticks_msec() # if nearby enemies stays 0 for 5 seconds, resume music
		while Time.get_ticks_msec() - start_time < int(silence_duration * 1000):
			if nearby_enemies.size() != 0:
				return
			await Engine.get_main_loop().process_frame  # Wait 1 frame before checking again
		AudioManager.resume_audio()

func play_footstep():
	for area in get_tree().get_nodes_in_group("footstep_area"):
		if self in area.bodies_inside:
			match area.name:
				"dirt":
					AudioManager.play_effect(AudioManager.effects.DIRT)
				"asphalt":
					AudioManager.play_effect(AudioManager.effects.ASPHALT)
				"tile":
					AudioManager.play_effect(AudioManager.effects.TILE)
				"stone":
					AudioManager.play_effect(AudioManager.effects.STONE)
				"metal":
					AudioManager.play_effect(AudioManager.effects.METAL)

@onready var heartbeat_player = $heartbeat_player
func _on_heartbeat_player_finished() -> void:
	if health <= 30:
		heartbeat_player.play()
