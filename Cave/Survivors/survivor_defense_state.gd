class_name SurvivorDefenseState
extends State

@export var actor: Survivor

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	movement_cooldown = true
	get_tree().create_timer(3).connect("timeout",_end_movement_cooldown)
	actor.queue_remark(actor.remark_prompts.ENEMY)

func _exit_state() -> void:
	set_physics_process(false)

var movement_cooldown = false # survivor won't leave defense state for a couple seconds after entering
func _end_movement_cooldown():
	movement_cooldown = false

func handle_enemies():
	if actor.enemies_nearby.size() > 0:
		match actor.survivor_type:
			actor.survivor_types.GIRL:
				run_from_enemies()
			actor.survivor_types.WOMAN:
				fight_enemies()
			actor.survivor_types.MAN:
				fight_enemies()
			actor.survivor_types.OLDWOMAN:
				fight_enemies()
			actor.survivor_types.OLDMAN:
				run_from_enemies()
	elif not movement_cooldown:
		actor.state_machine.change_state(actor.state_machine.movement)
	else:
		# out of range of enemy after running. Slowly move away until movement cooldown elapses
		var original_vector = actor.velocity
		actor.velocity = original_vector * Vector2(.2,.2) 
		actor.move_and_slide()
		actor.velocity = original_vector

func _physics_process(_delta):
	handle_enemies()

var run_cooldown = false # survivor won't try running again soon after being forced to fight
func _end_run_cooldown():
	run_cooldown = false

func run_from_enemies():
	# get closest enemy
	var closest_distance = INF
	for enemy in actor.enemies_nearby:
		if actor.global_position.distance_squared_to(enemy.global_position) < closest_distance:
			closest_distance = actor.global_position.distance_squared_to(enemy.global_position)
	# run from first enemy to get nearby
	if not actor.get_last_slide_collision() and not run_cooldown:
		# if the survivor isn't cornered/running into a wall
		var full_vector = Vector2.ZERO
		for enemy in actor.enemies_nearby:
			full_vector += enemy.global_position.direction_to(actor.global_position)
		actor.velocity = full_vector*actor.SPEED
		actor.move_and_slide()
	else: # hide and fight if enemy is too close
		if closest_distance < 400:
			if not run_cooldown:
				run_cooldown = true
				get_tree().create_timer(5).connect("timeout",_end_run_cooldown)
			fight_enemies()
		elif not run_cooldown:
			actor.velocity = Vector2.ZERO
		else:
			fight_enemies()
	
var target_enemy = null
func fight_enemies():
	if target_enemy == null:
		target_enemy = actor.enemies_nearby[0]
	if target_enemy.state == target_enemy.states.DEAD and target_enemy in actor.enemies_nearby:
		actor.enemies_nearby.erase(target_enemy) # remove dead target from list
		target_enemy = null
		return
	if target_enemy.global_position.distance_squared_to(actor.global_position) > 100: # get closer enemy if target is too far away
		for enemy in actor.enemies_nearby:
			if target_enemy.global_position.distance_squared_to(actor.global_position) > enemy.global_position.distance_squared_to(actor.global_position):
				target_enemy = enemy
	var velocity_multiplier = Vector2(.01,.01)
	if target_enemy.global_position.distance_squared_to(actor.global_position) < 100:
		attempt_attack()
	else:
		velocity_multiplier = actor.SPEED
	actor.velocity = velocity_multiplier * actor.global_position.direction_to(target_enemy.global_position)
	actor.move_and_slide()

var attack_cooldown = false
func attempt_attack():
	if not attack_cooldown:
		attack_cooldown = true
		get_tree().create_timer(2).connect("timeout",attack_cooldown_timer_timeout)
		get_tree().create_timer(.6).connect("timeout",attack_damage)
		actor.animator.play("attack")
func attack_damage():
	if target_enemy != null:
		print("damaging")
		print(target_enemy.name)
		print(target_enemy.states.keys()[target_enemy.state])
		GameHandler.damage_target(actor,target_enemy,20)

func attack_cooldown_timer_timeout():
	attack_cooldown = false
