extends CharacterBody2D


const SPEED = 120
var health = 100
@export var male = true
@export var attack_cooldown = 1.5
@export var attack_damage = 30

@onready var man = $man_sprite
@onready var woman = $woman_sprite
@onready var animation_tree = $AnimationTree
func _ready():
	man.visible = male
	woman.visible = not male
	animation_tree.active = true

func _physics_process(delta):
	movement(delta)
	update_animation_parameters()

func _process(_delta):
	attack()

func movement(_delta):
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
		velocity = SPEED * velocity.normalized()
	if velocity.dot(Vector2(cos(PI+attack_area.rotation),sin(PI+attack_area.rotation))) < 0:
		velocity *= .5
	move_and_slide()

func update_animation_parameters():
	#if velocity.x != 0: # makes player face walking direction
		#animation_tree["parameters/Attack/blend_position"] = velocity.x
		#animation_tree["parameters/Death/blend_position"] = velocity.x
		#animation_tree["parameters/Idle/blend_position"] = velocity.x
		#animation_tree["parameters/Walk/blend_position"] = velocity.x
	# makes player face attack direction
	animation_tree["parameters/Attack/blend_position"] = -cos(attack_area.rotation)
	animation_tree["parameters/Death/blend_position"] = -cos(attack_area.rotation)
	animation_tree["parameters/Idle/blend_position"] = -cos(attack_area.rotation)
	animation_tree["parameters/Walk/blend_position"] = -cos(attack_area.rotation)
	if health <= 0:
		animation_tree["parameters/conditions/is_attacking"] = false
		animation_tree["parameters/conditions/is_dead"] = true
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = false
	elif currently_attacking:
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
@export var currently_attacking = false
var enemies_in_attack_radius = []
func attack():
	attack_area.rotation = attack_area.global_position.angle_to_point(get_global_mouse_position())+PI
	if not on_attack_cooldown:
		if Input.is_action_just_pressed("attack"):
			on_attack_cooldown = true
			currently_attacking = true
			attack_cooldown_timer.start(attack_cooldown)
			get_tree().create_timer(.6).connect("timeout",attack_deal_damage)
func attack_deal_damage():
	if enemies_in_attack_radius.size() > 0:
		GameHandler.damage_target(self,enemies_in_attack_radius[0],attack_damage)
func _on_attack_cooldown_timeout():
	on_attack_cooldown = false
func _on_attack_area_body_entered(body):
	if body.is_in_group("enemy") and not body in enemies_in_attack_radius:
		enemies_in_attack_radius.append(body)
func _on_attack_area_body_exited(body):
	enemies_in_attack_radius.erase(body)
