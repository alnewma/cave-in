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
@onready var soft_collisions = $softCollisions
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

@onready var game_map = null
var in_main_game = false

func _ready():
	if get_parent().name == "GameMap":
		game_map = get_parent()
		in_main_game = true
	player = get_tree().get_nodes_in_group("player")[0]
	animator.play("idle")
	# set variables from save data
	if in_main_game:
		global_position = GameHandler.get_survivor_data_from_object(self).global_position
		## assignment deferred so that assigned_location setter is called after location flags are ready
		#assigned_location = GameHandler.get_survivor_data_from_object(self).assigned_location
		set_deferred("assigned_location",GameHandler.get_survivor_data_from_object(self).assigned_location)
		#target_area = NodePath(GameHandler.get_survivor_data_from_object(self).target_area)
		target_assignment = NodePath(GameHandler.get_survivor_data_from_object(self).target_assignment)
		target_usage = NodePath(GameHandler.get_survivor_data_from_object(self).target_usage)
	health = GameHandler.get_survivor_data_from_object(self).health
	thirst = GameHandler.get_survivor_data_from_object(self).thirst
	set_up_remark_system()

func _physics_process(delta: float) -> void:
	var absVel = abs(velocity)
	var currentAnim = animator.get_animation()
	if absVel > Vector2(.1,.1):
		if currentAnim != "walk":
			animator.play("walk")
		GameHandler.get_survivor_data_from_object(self).global_position = global_position
		if velocity.x < 0:
			animator.flip_h = true
		else:
			animator.flip_h = false
	elif absVel < Vector2(.1,.1) and currentAnim == "walk" and !soft_collisions.colliding:
		animator.play("idle")
	if state_machine.state != state_machine.defense and state_machine.state != state_machine.death:
		velocity = soft_collisions.get_soft_collisions_push_vector(delta)/5
		if velocity != Vector2.ZERO:
			move_and_slide()

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
	GameHandler.get_survivor_data_from_object(self).assigned_location = assigned_location
	state_machine.change_state(state_machine.movement)
	navigation_agent.target_position = input_location
	var found_flag = false
	for item2 in get_tree().get_nodes_in_group("location_flag"):
		if item2.global_position == assigned_location:
			target_area = get_path_to(item2)
			found_flag = true
			break
	if not found_flag:
		target_area = get_path_to(self)
	GameHandler.get_survivor_data_from_object(self).target_area = target_area
	## for debugging location assignments
	#print(str(get_tree().get_nodes_in_group("location_flag").size()) + " flags cross-checked")
	#print(name + " assigned, area/node in data is: " + str(GameHandler.get_survivor_data_from_object(self).target_area))
	#print("area/node in game is " + str(target_area))
	#print("assigned location is " + str(assigned_location))

func get_point_in_target_area() -> Vector2:
	var point_within_location
	if target_area:
		while true and get_node(target_area):
			var random_angle = randf_range(0,2*PI)
			var random_radius
			if get_node(target_area) == self: # wandering near self during game start
				random_radius = randf_range(0,68.36)
			else: # usual wandering near flag
				random_radius = randf_range(0,get_node(target_area).location_area_shape.shape.radius)
			point_within_location = Vector2(random_radius*cos(random_angle),random_radius*sin(random_angle)) + get_node(target_area).global_position
			var closest = NavigationServer2D.map_get_closest_point(get_tree().get_first_node_in_group("navigation_region").get_navigation_map(),point_within_location)
			if point_within_location.distance_to(closest) < .1:
				break
	else:
		printerr("no target area for survivor wandering")
	if point_within_location:
		return point_within_location
	else: return Vector2.ZERO
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
	#if thirst < -999 and not status_break: # deprecated feature: automatic water drinking
		#status_break = true
		#take_status_break("thirst")
	if thirst < 40:
		if target_assignment != NodePath("") and get_node(target_assignment).is_in_group("hydrant"):
			if get_node(target_assignment).manual_depletion(30): # try to drink from hydrant
				queue_remark(remark_prompts.WATER)
				thirst = 100

func take_status_break(status:String): # take break to move to status area
	state_machine.change_state(state_machine.movement)
	if status == "thirst":
		queue_remark(remark_prompts.WATER)
		if target_assignment:
			get_node(target_assignment).set_assigned_survivors(get_path(),false)
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

@onready var thirst_timer = $thirst_timer
func _on_thirst_timer_timeout():
	#print("assigned location for " + name + ": " + str(assigned_location)) 
	if thirst != 0:
		thirst -= 1
		if thirst == 40:
			queue_remark(remark_prompts.THIRST)
		status_check()
	GameHandler.get_survivor_data_from_object(self).thirst = thirst
	thirst_timer.start(randi_range(4,5))

var returning_from_status_break = false
func _on_survivor_movement_state_actor_reached_target():
	if status_break and target_usage:
		if get_node(target_usage) and target_assignment:
			if get_node(target_usage).manual_depletion(30):
				print(name + ": drink completed")
				thirst = 100
				get_node(target_usage).set_assigned_survivors(get_path(),false)
				status_break = false
				returning_from_status_break = true
				navigation_agent.target_position = get_node(target_assignment).global_position
				# return to prior occupation
			else:
				# add to hydrant occupation
				if get_path() not in get_node(target_usage).assigned_survivors:
					get_node(target_usage).set_assigned_survivors(get_path(),true)
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
		get_node(target_assignment).set_assigned_survivors(get_path(),true)
		print("returned from water break")
		#returned from water break, begin working on assignment

var enemies_nearby : Array = []
func _on_danger_area_body_entered(body):
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
	#print("hurt " + str(health))
	GameHandler.get_survivor_data_from_object(self).health = value
	if health <= 0:
		#print("dead")
		remark_box.hide()
		state_machine.change_state(state_machine.death)
	elif health <= 40:
		queue_remark(remark_prompts.HEALTH)

func _on_survivor_death_state_death() -> void:
	match survivor_type:
		survivor_types.GIRL:
			GameHandler.save_game_instance.player_data.conversation_flags["kate_dead"] = true
		survivor_types.MAN:
			GameHandler.save_game_instance.player_data.conversation_flags["mace_dead"] = true
		survivor_types.OLDWOMAN:
			GameHandler.save_game_instance.player_data.conversation_flags["ida_dead"] = true
		survivor_types.OLDMAN:
			GameHandler.save_game_instance.player_data.conversation_flags["wesley_dead"] = true
	if (GameHandler.save_game_instance.player_data.conversation_flags["kate_dead"] # all dead
	and GameHandler.save_game_instance.player_data.conversation_flags["mace_dead"]
	and GameHandler.save_game_instance.player_data.conversation_flags["ida_dead"]
	and GameHandler.save_game_instance.player_data.conversation_flags["wesley_dead"]):
		game_map.trigger_ending(game_map.ending_types.SURVIVORS_DEAD)

@onready var interaction_shape = $interaction_area/CollisionShape2D
func _on_visibility_changed() -> void:
	if interaction_shape:
		if not visible:
			interaction_shape.disabled = true
		else:
			interaction_shape.disabled = false

enum remark_prompts {
	TOOL,
	HEALTH,
	THIRST,
	FOLLOWING,
	HAPPY,
	SAD,
	ENEMY,
	WATER,
	FALLING,
	BLOCKED1,
	BLOCKED2,
	BLOCKED3,
	GUARDING,
	GAS,
	HIDING,
	SCAVENGING,
	NEARBYLOWHEALTH,
	NEARBYDEATH,
	NEARBYBODY,
	COMPUTERSTART,
	COMPUTERFINISH,
	WORKTHIRST,
	DRILLINSIDE,
	DRILLOUTSIDE,
	PLAYERLOW,
	PLAYERDEATH,
}

@onready var remark_box = $remark
@onready var remark_timer = $remark/remark_timer

func set_up_remark_system():
	emotion_timer.start(randi_range(30,180))

var remark_empty = true
func _on_remark_timer_timeout() -> void:
	remark_box.text = ""
	remark_empty = true

var ending_sequence = false
func queue_remark(prompt : remark_prompts, custom_string_insert = ""):
	if remark_empty and not ending_sequence and remark_timer:
		remark_empty = false
		remark_timer.start(10)
		## Specific Tags ##
		if custom_string_insert != "":
			var specific_tag = "<" + custom_string_insert + ">"
			var temp_options = []
			for remark in remarks[survivor_type][prompt]: # only use remarks that have no tag or that tag
				if not "<" in remark or specific_tag in remark:
					while ">" in remark: # remove tags from remark
						var pos = remark.find(">")
						remark = remark.erase(0,pos+1)
					temp_options.append(remark)
			remark_box.text = temp_options.pick_random()
		else:
			remark_box.text = remarks[survivor_type][prompt].pick_random()
		## Customizable Remarks ##
		if custom_string_insert != "":
			if "XXXX" in remark_box.text:
				remark_box.text = remark_box.text.replace("XXXX",custom_string_insert)
	elif ending_sequence and (prompt == remark_prompts.FALLING or prompt == remark_prompts.BLOCKED1 or prompt == remark_prompts.BLOCKED2):
		remark_timer.start(10)
		remark_box.text = remarks[survivor_type][prompt].pick_random() # ending lines

@onready var emotion_timer = $remark/emotion_timer
func _on_emotion_timer_timeout() -> void:
	emotion_timer.start(randi_range(30,180))
	var convo_happiness = GameHandler.get_survivor_data_from_object(self).conversation_happiness
	if convo_happiness < 0: # sad
		queue_remark(remark_prompts.SAD)
	elif convo_happiness > 0: # happy
		queue_remark(remark_prompts.HAPPY)

## Audio ##

func _on_animated_sprite_2d_frame_changed() -> void:
	if animator.animation == "walk" and (animator.frame == 0 or animator.frame == 3):
		_play_footstep()

func _play_footstep():
	for area in get_tree().get_nodes_in_group("footstep_area"):
		if self in area.bodies_inside:
			match area.name:
				"dirt":
					AudioManager.play_effect(AudioManager.effects.DIRT,0,0,0,global_position)
				"asphalt":
					AudioManager.play_effect(AudioManager.effects.ASPHALT,0,0,0,global_position)
				"tile":
					AudioManager.play_effect(AudioManager.effects.TILE,0,0,0,global_position)
				"stone":
					AudioManager.play_effect(AudioManager.effects.STONE,0,0,0,global_position)
				"metal":
					AudioManager.play_effect(AudioManager.effects.METAL,0,0,0,global_position)

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
		],
		remark_prompts.WATER : [
			"Gonna pump some water for myself",
			"I’ll be back- need water"
		],
		remark_prompts.FALLING : [
			"Lord, this tunnel’s crumbling fast"
		],
		remark_prompts.BLOCKED1 : [
			"I suppose this is the end"
		],
		remark_prompts.BLOCKED2 : [
			"The end is blocked off!"
		],
		remark_prompts.BLOCKED3 : [
			"Oh lord, this is it"
		],
		remark_prompts.GUARDING : [
			"I’ve got this",
			"I’ll keep us safe"
		],
		remark_prompts.GAS : [
			"Guess the devil’s tryna rush me home"
		],
		remark_prompts.HIDING : [
			"Not messin’ around here any longer",
			"High time to run"
		],
		remark_prompts.SCAVENGING : [
			"This oughta be good",
			"This is looking fine!"
		],
		remark_prompts.NEARBYLOWHEALTH : [
			"You better watch out hon!",
			"Save yourself XXXX!"
		],
		remark_prompts.NEARBYDEATH : [
			"Stay with us XXXX! C’mon",
			"Father, come down!"
		],
		remark_prompts.NEARBYBODY : [
			"Oh lord, XXXX",
			"There’s no more hurting now",
			"<Kate>Rest now, child"
		],
		remark_prompts.COMPUTERSTART : [
			"Just like my ol’ typewriter!"
		],
		remark_prompts.COMPUTERFINISH : [
			"Well I’ll be!"
		],
		remark_prompts.WORKTHIRST : [
			"So thirsty I can hardly work"
		],
		remark_prompts.DRILLINSIDE : [
			"That’s coming from WAY down below",
			"Best be wary of that noise"
		],
		remark_prompts.DRILLOUTSIDE : [
			"Just keep movin’ girl",
			"These rocks got no manners!"
		],
		remark_prompts.PLAYERLOW : [
			"You’re getting battered!",
			"You better watch out hon!"
		],
		remark_prompts.PLAYERDEATH : [
			"Don’t you leave us!"
		],
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
		],
		remark_prompts.WATER : [
			"Alright, water break",
			"Can’t keep working without water"
		],
		remark_prompts.FALLING : [
			"We've got mere minutes..."
		],
		remark_prompts.BLOCKED1 : [
			"Looks like the sewer exit"
		],
		remark_prompts.BLOCKED2 : [
			"The landslide covered the exit!"
		],
		remark_prompts.BLOCKED3 : [
			"Last chance to get out"
		],
		remark_prompts.GUARDING : [
			"I’ll keep an eye out",
			"Watching out"
		],
		remark_prompts.GAS : [
			"Now we’re cooking with gas!"
		],
		remark_prompts.HIDING : [
			"This is too much",
			"I’m getting away"
		],
		remark_prompts.SCAVENGING : [
			"Please have something good",
			"Maybe I’ll find dynamite...",
			"I’ll pick this clean"
		],
		remark_prompts.NEARBYLOWHEALTH : [
			"Get away from that thing XXXX!",
			"You look hurt!"
		],
		remark_prompts.NEARBYDEATH : [
			"XXXX! No!",
			"This can’t be happening... XXXX!"
		],
		remark_prompts.NEARBYBODY : [
			"Get up XXXX. Please.",
			"<Wesley>This part of his plan?",
			"XXXX..."
		],
		remark_prompts.COMPUTERSTART : [
			"Let’s try brute force, I guess"
		],
		remark_prompts.COMPUTERFINISH : [
			"Snowball!? What a dumb password"
		],
		remark_prompts.WORKTHIRST : [
			"So thirsty. Body shutting down"
		],
		remark_prompts.DRILLINSIDE : [
			"That sound’s new...",
			"Did we do that?"
		],
		remark_prompts.DRILLOUTSIDE : [
			"Woah, that’s not good!",
			"Watch out for rocks!"
		],
		remark_prompts.PLAYERLOW : [
			"That looks like it hurts",
			"You look super hurt!"
		],
		remark_prompts.PLAYERDEATH : [
			"Come on, stay with me!"
		],
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
		],
		remark_prompts.WATER : [
			"Let’s get some water",
			"Headed to the pump"
		],
		remark_prompts.FALLING : [
			"We need to move it"
		],
		remark_prompts.BLOCKED1 : [
			"The tunnel stops here"
		],
		remark_prompts.BLOCKED2 : [
			"We need to get through somehow"
		],
		remark_prompts.BLOCKED3 : [
			"We need to move NOW!"
		],
		remark_prompts.GUARDING : [
			"Nothing’s getting past me",
			"I’ll stand guard"
		],
		remark_prompts.GAS : [
			"Stand back from this"
		],
		remark_prompts.HIDING : [
			"Cover for me!",
			"Get back!"
		],
		remark_prompts.SCAVENGING : [
			"This’ll do",
			"We can use parts of this"
		],
		remark_prompts.NEARBYLOWHEALTH : [
			"XXXX! Get out of there!",
			"Hang in there XXXX, I’m coming!"
		],
		remark_prompts.NEARBYDEATH : [
			"No, no, no–Goddammit",
			"Oh, hell. XXXX!"
		],
		remark_prompts.NEARBYBODY : [
			"I should’ve stopped this...",
			"You didn’t deserve this XXXX",
			"We can cry later"
		],
		remark_prompts.COMPUTERSTART : [
			"This is more your domain"
		],
		remark_prompts.COMPUTERFINISH : [
			"Great. Now back to work"
		],
		remark_prompts.WORKTHIRST : [
			"We need water to work well"
		],
		remark_prompts.DRILLINSIDE : [
			"Hope that’s not trouble",
			"Figure out what that is"
		],
		remark_prompts.DRILLOUTSIDE : [
			"This shortens our time frame!",
			"Don’t get distracted"
		],
		remark_prompts.PLAYERLOW : [
			"I’ll cover for you, get back!",
			"Get out of there!"
		],
		remark_prompts.PLAYERDEATH : [
			"I should’ve been faster..."
		],
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
		],
		remark_prompts.WATER : [
			"I’m getting water",
			"Water pump time!"
		],
		remark_prompts.FALLING : [
			"The ceiling is gonna fall soon!"
		],
		remark_prompts.BLOCKED1 : [
			"It doesn’t go on!"
		],
		remark_prompts.BLOCKED2 : [
			"How are we gonna get through?"
		],
		remark_prompts.BLOCKED3 : [
			"The ceiling is falling down!"
		],
		remark_prompts.GUARDING : [
			"Don’t leave for long",
			"I’ll yell if something comes"
		],
		remark_prompts.GAS : [
			"We’re pouring it out?"
		],
		remark_prompts.HIDING : [
			"Run!",
			"Get away!",
			"Hide!"
		],
		remark_prompts.SCAVENGING : [
			"I’m checking for useful stuff",
			"I’ll take it apart"
		],
		remark_prompts.NEARBYLOWHEALTH : [
			"Are you okay XXXX?",
			"<Wesley><Mace>Stop! Don’t hurt him!",
			"<Ida>Stop! Don't hurt her!"
		],
		remark_prompts.NEARBYDEATH : [
			"XXXX? XXXX!",
			"<Wesley><Mace>Help him!",
			"<Ida>Help her!",
			"No! No!!"
		],
		remark_prompts.NEARBYBODY : [
			"I’ll be okay XXXX. I promise.",
			"I don’t get it. I just don’t"
		],
		remark_prompts.COMPUTERSTART : [
			"I just try random words?"
		],
		remark_prompts.COMPUTERFINISH : [
			"Finally! My fingers hurt"
		],
		remark_prompts.WORKTHIRST : [
			"Ugh. I can’t move without water"
		],
		remark_prompts.DRILLINSIDE : [
			"Um. What was that?",
			"Is that a monster!?"
		],
		remark_prompts.DRILLOUTSIDE : [
			"Is the ceiling going to fall!?",
			"I don’t like that!"
		],
		remark_prompts.PLAYERLOW : [
			"Run away!",
			"Someone! Help!"
		],
		remark_prompts.PLAYERDEATH : [
			"Get up! Get up!"
		],
	},
}
