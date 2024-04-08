class_name SurvivorDefenseState
extends State

@export var actor: Survivor

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

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
	else:
		actor.state_machine.change_state(actor.state_machine.movement)

func _physics_process(_delta):
	handle_enemies()

func run_from_enemies():
	if not actor.get_last_slide_collision(): # if the survivor isn't cornered/running into a wall
		var full_vector = Vector2.ZERO
		for enemy in actor.enemies_nearby:
			full_vector += enemy.global_position.direction_to(actor.global_position)
		actor.velocity = full_vector*actor.SPEED
		actor.move_and_slide()
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
