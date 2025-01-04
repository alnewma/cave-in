class_name Survivor
extends CharacterBody2D

const SPEED = 30
@export var target_area : NodePath # area of assigned flag
@export var target_assignment : NodePath # assignment object within assigned flag
@export var target_usage : NodePath # temporary object to be used, ex. water hydrant
@onready var navigation_agent = $NavigationAgent2D
@onready var poly_point_gen = $PolygonRandomPointGenerator
@onready var animator = $AnimatedSprite2D
@onready var state_machine = $FiniteStateMachine
var player
var assigned_location = Vector2.ZERO : set = find_target_area

@export var survivor_type : survivor_types
enum survivor_types {
	GIRL,
	WOMAN,
	MAN,
	OLDWOMAN,
	OLDMAN
}

@export var health := 100  : set = _on_health_changed
@export var thirst := 100

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(_delta: float) -> void:
	var absVel = abs(velocity)
	var currentAnim = animator.get_animation()
	if absVel > Vector2(.1,.1) and currentAnim != "walk":
		animator.play("walk")
		if velocity.x < 0:
			animator.flip_h = true
		else:
			animator.flip_h = false
	elif absVel < Vector2(.1,.1) and currentAnim == "walk":
		animator.play("idle")

func approach_target():
	if assigned_location == Vector2.ZERO and not status_break:
		navigation_agent.target_position = player.global_position
	if global_position.distance_squared_to(navigation_agent.target_position) > 700:
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = dir * SPEED
		move_and_slide()
		return false
	else:
		velocity = Vector2.ZERO
		return true

func find_target_area(input_location):
	assigned_location = input_location
	state_machine.change_state(state_machine.movement)
	navigation_agent.target_position = input_location
	for item2 in get_tree().get_nodes_in_group("location_flag"):
		if item2.global_position == assigned_location:
			target_area = get_path_to(item2)

func get_point_in_target_area() -> Vector2:
	var point_within_location
	while true:
		var random_angle = randf_range(0,2*PI)
		var random_radius = randf_range(0,get_node(target_area).location_area_shape.shape.radius)
		point_within_location = Vector2(random_radius*cos(random_angle),random_radius*sin(random_angle)) + get_node(target_area).global_position
		var closest = NavigationServer2D.map_get_closest_point(get_tree().get_first_node_in_group("navigation_region").get_navigation_map(),point_within_location)
		if point_within_location.distance_to(closest) < .1:
			break
	return point_within_location
	#return poly_point_gen.get_random_point(get_node(target_area).location_area_shape.polygon) + get_node(target_area).global_position

signal survivor_clicked
signal survivor_mouse_entered
signal survivor_mouse_exited
func _on_interaction_area_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("object_select"):
		emit_signal("survivor_clicked",self)
func _on_interaction_area_mouse_entered():
	emit_signal("survivor_mouse_entered",self)
func _on_interaction_area_mouse_exited():
	emit_signal("survivor_mouse_exited",self)

@export var status_break = false

func status_check(): # check status when one decreases
	if thirst < 20 and not status_break:
		status_break = true
		take_status_break("thirst")

func take_status_break(status:String): # take break to move to status area
	state_machine.change_state(state_machine.movement)
	if status == "thirst":
		if target_assignment and self in get_node(target_assignment).assigned_survivors:
			get_node(target_assignment).assigned_survivors.erase(self)
		var hydrants = get_tree().get_nodes_in_group("hydrant")
		var highest_hydrant = 0
		for hydrant in hydrants:
			if hydrant.completion_status > highest_hydrant and hydrant.completion_status >= 20:
				highest_hydrant = hydrant.completion_status
				navigation_agent.target_position = hydrant.global_position
				target_usage = hydrant.get_path()
		if highest_hydrant == 0: # visit hydrant and pour water
			var highest_users = 0
			for hydrant in hydrants:
				if hydrant.using_survivors.size() <= highest_users:
					highest_users = hydrant.using_survivors.size()
					navigation_agent.target_position = hydrant.global_position
					target_usage = hydrant.get_path()
		#navigation_agent.target_position = input_location

func _on_thirst_timer_timeout():
	if thirst != 0:
		thirst -= 1
		status_check()

var returning_from_status_break = false
func _on_survivor_movement_state_actor_reached_target():
	if status_break:
		if get_node(target_usage).manual_depletion(30):
			print("drink completed")
			thirst = 100
			if self in get_node(target_usage).assigned_survivors:
				get_node(target_usage).assigned_survivors.erase(self)
			status_break = false
			returning_from_status_break = true
			navigation_agent.target_position = get_node(target_assignment).global_position
			# return to prior occupation
		else:
			# add to hydrant occupation
			if self not in get_node(target_usage).assigned_survivors:
				get_node(target_usage).assigned_survivors.append(self)
				state_machine.change_state(state_machine.activity)
			#print("waiting for progress")
			#var delay_timer = Timer.new()
			#delay_timer.wait_time = 3
			#delay_timer.autostart = true
			#delay_timer.connect("timeout",_on_survivor_movement_state_actor_reached_target)
			#delay_timer.connect("timeout",queue_free)
	elif returning_from_status_break:
		returning_from_status_break = false
		state_machine.change_state(state_machine.activity)
		if not self in get_node(target_assignment).assigned_survivors:
			get_node(target_assignment).assigned_survivors.append(self)
		#returned from water break, begin working on assignment

var enemies_nearby : Array = []
func _on_danger_area_body_entered(body):
	print("enemy entered")
	if body.is_in_group("enemy") and not enemies_nearby.has(body):
		enemies_nearby.append(body)
		state_machine.change_state(state_machine.defense)

func _on_danger_area_body_exited(body):
	if body.is_in_group("enemy") and enemies_nearby.has(body):
		enemies_nearby.erase(body)

func _on_animated_sprite_2d_animation_finished():
	if animator.get_animation() == "attack":
		animator.play("idle")

func _on_health_changed(value):
	health = value
	if health <= 0:
		state_machine.change_state(state_machine.death)

enum remark_prompts {
	TOOL,
	HEALTH,
	THIRST,
	FOLLOWING,
	HAPPY,
	SAD,
	ENEMY
}

@onready var remark_box = $remark
@onready var remark_timer = $remark/remark_timer
var remark_empty = true
func _on_remark_timer_timeout() -> void:
	remark_box.text = ""
	remark_empty = true

func queue_remark(prompt : remark_prompts):
	if remark_empty:
		remark_timer.start(10)
		remark_box.text = remarks[survivor_type][prompt].pick_random()
		if prompt == remark_prompts.TOOL:
			for item in GameHandler.item_instances:
				if item[1] == self:
					remark_box.text.replace("XXXX",GameHandler.item_names[item[0]]) # if tool, replace placeholder with tool

var remarks = {
	survivor_types.OLDWOMAN : {
		remark_prompts.TOOL : [
			"I’ve got a XXXX",
			"I’ve found me a XXXX"
		],
		remark_prompts.HEALTH : [
			"I’m bleeding hard from that attack",
			"Lord please heal me fast!"
		],
		remark_prompts.THIRST : [
			"I’m parched!",
			"Oh, for a glass of water!"
		],
		remark_prompts.FOLLOWING : [
			"I’m trusting you to lead",
			"I’ll follow you"
		],
		remark_prompts.SAD : [
			"Get your heads straight!"
		],
		remark_prompts.HAPPY : [
			"Wouldn’t want any other group"
		],
		remark_prompts.ENEMY : [
			"Animal on the loose!",
			"That thing looks dangerous!"
		]
	},
	survivor_types.MAN : {
		remark_prompts.TOOL : [
			"I came across a XXXX",
			"Just a guy with his trusty XXXX"
		],
		remark_prompts.HEALTH : [
			"I’m not feeling too good",
			"I’m struggling to even walk"
		],
		remark_prompts.THIRST : [
			"I’m seriously thirsty",
			"I need some water soon"
		],
		remark_prompts.FOLLOWING : [
			"Oh boy, here we go",
			"Right after you"
		],
		remark_prompts.SAD : [
			"This is far from the dream team"
		],
		remark_prompts.HAPPY : [
			"Things could be worse, I guess"
		],
		remark_prompts.ENEMY : [
			"That thing doesn’t look friendly!",
			"Animal nearby!"
		]
	},
	survivor_types.OLDMAN : {
		remark_prompts.TOOL : [
			"I’m carrying a XXXX",
			"Scavenged myself a XXXX"
		],
		remark_prompts.HEALTH : [
			"Hope this cut is nothing...",
			"More scars for the collection"
		],
		remark_prompts.THIRST : [
			"Almost time for water",
			"Need to watch dehydration..."
		],
		remark_prompts.FOLLOWING : [
			"Teamwork is vital",
			"Stick together"
		],
		remark_prompts.SAD : [
			"Can’t say I’m pleased right now"
		],
		remark_prompts.HAPPY: [
			"We’re doing good so far"
		],
		remark_prompts.ENEMY : [
			"Get back!",
			"Watch out for that thing!"
		]
	},
	survivor_types.GIRL : {
		remark_prompts.TOOL : [
			"Check it out - a XXXX!",
			"Guess who found a XXXX!"
		],
		remark_prompts.HEALTH : [
			"That bite really hurts…",
			"It hurts to move my arm!"
		],
		remark_prompts.THIRST : [
			"I need some water",
			"I’m getting thirsty"
		],
		remark_prompts.FOLLOWING : [
			"Where are we going?",
			"Let’s go"
		],
		remark_prompts.SAD : [
			"This is awful"
		],
		remark_prompts.HAPPY: [
			"At least I have you guys"
		],
		remark_prompts.ENEMY : [
			"Big animal! Help!",
			"Oh no!"
		]
	},
}
