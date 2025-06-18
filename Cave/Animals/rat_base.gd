extends CharacterBody2D

@export var health = 80 : set = _on_health_changed
var state = states.WANDER
var SPEED = 35
@onready var detection_area = $detection_area/CollisionShape2D
@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D
@onready var death_timer = $death_timer

enum states {
	WANDER,
	FLEE,
	DEAD
}

func _ready():
	set_physics_process(false)
	await get_tree().process_frame
	set_physics_process(true)

var last_velocity : Vector2
func check_if_stuck(): # check if velocities are being mirrored
	if last_velocity * -1 - velocity < Vector2(.1,.1):
		return true
	else:
		last_velocity = velocity
		return false

var last_full_vector = Vector2.ZERO
func _physics_process(_delta):
	var dir
	match state:
		states.WANDER:
			nav_agent.target_position = wander_destination
			if global_position.distance_squared_to(wander_destination) > 50:
				if check_if_stuck() and not velocity == Vector2.ZERO:
					velocity = Vector2.ZERO
					wander_destination = global_position # resetting wander destination
				else:
					dir = to_local(nav_agent.get_next_path_position()).normalized()
					velocity = dir * SPEED
					move_and_slide()
		states.FLEE:
			if not get_last_slide_collision(): # if the rat isn't cornered/running into a wall
				var full_vector = Vector2.ZERO
				for survivor in targets_in_area:
					full_vector += survivor.global_position.direction_to(global_position)
				if full_vector != Vector2.ZERO:
					last_full_vector = full_vector
				else:
					full_vector = last_full_vector
				velocity = full_vector*SPEED
				move_and_slide()
			else:
				state = states.DEAD
				sprite.play("burrow")
		states.DEAD:
			pass
	var velN = velocity.length_squared()
	if state != states.DEAD:
		if velN > .01:
			sprite.play("walk")
			if velocity.x > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
		else:
			sprite.play("idle")

var wander_destination = Vector2.ZERO

@onready var wander_timer = $wander_timer
func _on_wander_timer_timeout():
	wander_destination = global_position + find_random_destination()
	wander_destination = NavigationServer2D.map_get_closest_point(get_tree().get_first_node_in_group("navigation_region").get_navigation_map(),wander_destination)
	wander_timer.start(randi_range(6,12))

func find_random_destination():
	var radius = randi_range(detection_area.shape.radius/2,detection_area.shape.radius)
	var angle = randf_range(0,2*PI)
	var new_position = Vector2(cos(angle)*radius,sin(angle)*radius)
	return new_position

var targets_in_area = []

func _on_detection_area_body_entered(body):
	if not body in targets_in_area:
		targets_in_area.append(body)
	update_flee_state()
func _on_detection_area_body_exited(body):
	if body in targets_in_area:
		targets_in_area.erase(body)
	update_flee_state()

@onready var flee_timer = $flee_timer
func update_flee_state():
	if state != states.DEAD:
		if targets_in_area.size() > 0:
			state = states.FLEE
			flee_cooldown = true
			flee_timer.start(3) # continue fleeing 3 seconds after leaving vicinity of survivor
		elif not flee_cooldown:
			state = states.WANDER

var flee_cooldown = false
func _on_flee_timer_timeout():
	flee_cooldown = false

@onready var movement_sound = $movement
func _on_health_changed(value):
	health = value
	if health <= 0:
		state = states.DEAD
		movement_sound.stop()
		AudioManager.play_effect(AudioManager.effects.RATSQUEAK)
		set_collision_layer_value(4,false)
		sprite.play("death")
		death_timer.start(20)

func _on_death_timer_timeout():
	var t = get_tree().create_tween()
	sprite.material = sprite.material.duplicate()
	t.tween_property(sprite.material,"shader_parameter/sensitivity",1,1)
	t.finished.connect(_delete)
func _delete():
	queue_free()

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "burrow":
		queue_free()
