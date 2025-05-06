extends CharacterBody2D

@export var health = 60 : set = _on_health_changed
var state = states.WANDER
var SPEED = 35
@onready var detection_area = $detection_area/CollisionShape2D
@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D
@onready var attack_timer = $attack_timer
@onready var death_sprite = $death_sprite
@onready var death_timer = $death_timer
@export var attack_cooldown_duration = 4
@export var attack_damage = 20

enum states {
	WANDER,
	ATTACK,
	DEAD
}

func _ready():
	_on_wander_timer_timeout()
	set_physics_process(false)
	await get_tree().process_frame
	set_physics_process(true)

func _physics_process(_delta):
	var dir
	match state:
		states.WANDER:
			nav_agent.target_position = wander_destination
			if global_position.distance_squared_to(wander_destination) > 50:
				dir = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = dir * SPEED
				move_and_slide()
		states.ATTACK:
			if attack_target:
				if global_position.distance_squared_to(attack_target.global_position) < 50:
					attempt_attack()
				else:
					nav_agent.target_position = attack_target.global_position
					dir = to_local(nav_agent.get_next_path_position()).normalized()
					velocity = dir * SPEED
					move_and_slide()
		states.DEAD:
			pass
	var velN = velocity.normalized()
	if velN.y > .5:
		sprite.play("down")
		death_sprite.frame = 0
	elif velN.y < -.5:
		sprite.play("up")
		death_sprite.frame = 8
	elif velN.x < 0:
		sprite.play("left")
		death_sprite.frame = 12
	else:
		sprite.play("right")
		death_sprite.frame = 4

var wander_destination = Vector2.ZERO

@onready var wander_timer = $wander_timer
func _on_wander_timer_timeout():
	wander_destination = global_position + find_random_destination()
	wander_timer.start(randi_range(6,12))

func find_random_destination():
	var radius = randi_range(detection_area.shape.radius/2,detection_area.shape.radius)
	var angle = randf_range(0,2*PI)
	var new_position = Vector2(cos(angle)*radius,sin(angle)*radius)
	return new_position


var attack_target
var targets_in_area = []

func _on_detection_area_body_entered(body):
	if not body in targets_in_area:
		targets_in_area.append(body)
	update_attack_state()
func _on_detection_area_body_exited(body):
	if body in targets_in_area:
		targets_in_area.erase(body)
	update_attack_state()

func update_attack_state():
	if state != states.DEAD:
		if targets_in_area.size() > 0:
			state = states.ATTACK
			attack_target = targets_in_area[0]
		else:
			state = states.WANDER

var attack_cooldown = false
func attempt_attack():
	if not attack_cooldown:
		attack_cooldown = true
		attack_timer.start(attack_cooldown_duration)
		attack()
func _on_attack_timer_timeout():
	attack_cooldown = false

func attack():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite,"offset",sprite.offset+Vector2(0,11),.3)
	await tween.finished
	GameHandler.damage_target(self,attack_target,attack_damage)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(sprite,"offset",sprite.offset+Vector2(0,-11),.4)

func _on_health_changed(value):
	health = value
	if health <= 0:
		state = states.DEAD
		set_collision_layer_value(4,false)
		if death_sprite.frame == 0 or death_sprite.frame == 8:
			death_sprite.position = Vector2(0,0)
			death_sprite.offset = Vector2(0,-24)
			var tween = get_tree().create_tween()
			tween.tween_property(death_sprite,"offset",Vector2(0,-12),.6)
		else:
			death_sprite.position = Vector2(0,0)
			death_sprite.offset = Vector2(0,-32)
			var tween = get_tree().create_tween()
			tween.tween_property(death_sprite,"offset",Vector2(0,-8),.6)
		death_sprite.visible = true
		sprite.visible = false
		death_timer.start(20)

func _on_death_timer_timeout():
	queue_free()
