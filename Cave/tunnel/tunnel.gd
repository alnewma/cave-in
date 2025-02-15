extends Node2D

@export var travel_duration = 15

func _ready():
	speech_setup()
	cutscene_setup()

## Interaction/Speech Code ##

@onready var interaction_menu = $interaction_UI_handler
@onready var man = $man_survivor
@onready var woman = $old_woman_survivor
@onready var oldman = $old_man_survivor
@onready var girl = $girl_survivor
@onready var survivors = [man,woman,oldman,girl]


func speech_setup():
	for object in survivors:
		object.survivor_clicked.connect(create_interaction_menu)
		object.survivor_mouse_entered.connect(survivor_mouse_entered)
		object.survivor_mouse_exited.connect(survivor_mouse_exited)

var survivors_within_mouse = []
func survivor_mouse_entered(survivor):
	survivors_within_mouse.append(survivor)
func survivor_mouse_exited(survivor):
	survivors_within_mouse.erase(survivor)

func create_interaction_menu(survivor):
	interaction_menu.change_page(interaction_menu.start_page,true)
	interaction_menu.current_survivor = survivor

## Cutscene Code ##

@onready var black = $fadeBlack

func cutscene_setup():
	set_backgrounds()
	set_survivors()
	tween_background()
	set_quakes()

func set_backgrounds():
	$CanvasModulate.show()
	black.fade_from_black()

func set_survivors():
	var survivor_instances = [$man_survivor,$old_man_survivor,$old_woman_survivor,$girl_survivor]
	var survivor_data = [GameHandler.player_data.survivor_data.ida,GameHandler.player_data.survivor_data.kate,GameHandler.player_data.survivor_data.mace,GameHandler.player_data.survivor_data.wesley]
	for survivor in survivor_instances:
		if not survivor.health > 0:
			survivor.queue_free()
		else:
			survivor.ending_sequence = true

@onready var boat = $boat
@onready var bg = $tunnel_background
@onready var progress_timer = $progress_timer
func tween_background():
	progress_timer.start(travel_duration/2)
	var tween = get_tree().create_tween()
	tween.tween_property(bg, "global_position", Vector2(bg.global_position.x,boat.global_position.y), travel_duration)

var progression = 0 # 0- start, 1- falling line, 2- blocked1 line, 3- blocked2 line
func _on_progress_timer_timeout() -> void:
	match progression:
		0:
			var current_survivors = get_tree().get_nodes_in_group("survivor")
			var speaking_survivor = current_survivors.pick_random()
			speaking_survivor.queue_remark(speaking_survivor.remark_prompts.FALLING)
			progression += 1
			progress_timer.start(travel_duration/2-2)
		1:
			var current_survivors = get_tree().get_nodes_in_group("survivor")
			var speaking_survivor = current_survivors.pick_random()
			speaking_survivor.queue_remark(speaking_survivor.remark_prompts.BLOCKED1)
			progression += 1
			progress_timer.start(2)
		2:
			var current_survivors = get_tree().get_nodes_in_group("survivor")
			var speaking_survivor = current_survivors.pick_random()
			speaking_survivor.queue_remark(speaking_survivor.remark_prompts.BLOCKED2)
			interaction_menu.reached_tunnel_end = true
			progression += 1
			progress_timer.start(60)
		3:
			var current_survivors = get_tree().get_nodes_in_group("survivor")
			var speaking_survivor = current_survivors.pick_random()
			speaking_survivor.queue_remark(speaking_survivor.remark_prompts.BLOCKED2)

@onready var rock_file = preload("res://tunnel/falling_rock.tscn")
@onready var r_timer1 = $rock_timer1
@onready var r_timer2 = $rock_timer2

@onready var player = $Player
@onready var gate = $tunnel_background/gate
	
func _spawn_rock():
	var rock_i = rock_file.instantiate()
	var target_invalid = true
	while target_invalid:
		var proposed_target = randi_range(38,159)
		proposed_target = Vector2(randi_range(27,53),proposed_target)
		rock_i.target = proposed_target
		var boat_rect = boat.get_rect()
		boat_rect.position += boat.global_position
		var boat_rect_high = boat_rect
		boat_rect_high.position += Vector2(0,10)
		var gate_rect = gate.get_rect()
		gate_rect.position += gate.global_position
		if not boat_rect.has_point(proposed_target) and not boat_rect_high.has_point(proposed_target) and not gate_rect.has_point(proposed_target):
			target_invalid = false
	#rock_i.target = Vector2(bg.get_used_cells().pick_random())*Vector2(12,12)+bg.global_position
	bg.add_child(rock_i)
	rock_i.global_position.y = 0


func _on_rock_timer_1_timeout() -> void:
	r_timer1.start(randf_range(.01,2.5))
	_spawn_rock()

func _on_rock_timer_2_timeout() -> void:
	r_timer2.start(randf_range(.01,2.5))
	_spawn_rock()

@onready var q_timer = $quake_timer
func set_quakes():
	q_timer.start(randf_range(6.5,10))
func _on_quake_timer_timeout() -> void:
	q_timer.start(randf_range(6.5,10))
	player.get_node("Camera2D").add_trauma(.35)


func _on_interaction_ui_handler_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.

## Escape Code ##

@onready var player_dummy = preload("res://Survivors/player_stand_in.tscn")
@onready var man_dummy = preload("res://Survivors/mace_stand_in.tscn")
@onready var old_man_dummy = preload("res://Survivors/wesley_stand_in.tscn")
@onready var old_woman_dummy = preload("res://Survivors/ida_stand_in.tscn")
@onready var girl_dummy = preload("res://Survivors/kate_stand_in.tscn")

@onready var exit_marker = $tunnel_background/exit_marker

var survivor_chosen : set = _move_survivor

var to_move = null
func _move_survivor(survivor_instance):
	survivor_chosen = survivor_instance
	player.get_node("Camera2D").enabled = false
	to_move = replace_sprite(player_dummy,player,true)
	player.speed = 0
	match survivor_chosen.name:
		"Player":
			to_move.global_position = exit_marker.global_position
			replace_sprite(man_dummy,man, true)
			replace_sprite(old_man_dummy,oldman, true)
			replace_sprite(old_woman_dummy,woman, true)
			replace_sprite(girl_dummy,girl, true)
		"man_survivor":
			to_move = replace_sprite(man_dummy,man, false)
			replace_sprite(old_man_dummy,oldman, true)
			replace_sprite(old_woman_dummy,woman, true)
			replace_sprite(girl_dummy,girl, true)
		"old_man_survivor":
			to_move = replace_sprite(old_man_dummy,oldman, false)
			replace_sprite(man_dummy,man, true)
			replace_sprite(old_woman_dummy,woman, true)
			replace_sprite(girl_dummy,girl, true)
		"old_woman_survivor":
			to_move = replace_sprite(old_woman_dummy,woman, false)
			replace_sprite(man_dummy,man, true)
			replace_sprite(old_man_dummy,oldman, true)
			replace_sprite(girl_dummy,girl, true)
		"girl_survivor":
			to_move = replace_sprite(girl_dummy,girl, false)
			replace_sprite(old_woman_dummy,woman, true)
			replace_sprite(man_dummy,man, true)
			replace_sprite(old_man_dummy,oldman, true)

@onready var top_ripple = $tunnel_background/ripple_top
@onready var bottom_ripple = $tunnel_background/ripple_bottom
var dummies = []
func trigger_end():
	to_move.stop()
	to_move.get_node("AnimationPlayer").play("exit")
	await get_tree().create_timer(.9).timeout
	boat.z_index += 1
	for dummy in dummies:
		dummy.z_index += 1
	top_ripple.show()
	top_ripple.play("default")
	bottom_ripple.show()
	bottom_ripple.play("default")

func replace_sprite(replacement_file,original,location:bool): # true:original loc, false:marker loc
	var man_inst = replacement_file.instantiate()
	if location:
		man_inst.global_position = original.global_position
		dummies.append(man_inst)
	else:
		man_inst.global_position = exit_marker.global_position
	add_child(man_inst)
	original.hide()
	return man_inst


func _on_interaction_ui_handler_updated_conversation_flag() -> void:
	if GameHandler.player_data.conversation_flags["ida_chosen"]:
		survivor_chosen = woman
	elif GameHandler.player_data.conversation_flags["mace_chosen"]:
		survivor_chosen = man
	elif GameHandler.player_data.conversation_flags["wesley_chosen"]:
		if GameHandler.player_data.conversation_flags["kate_dead"]: # if wesley chosen and kate alive
			survivor_chosen = oldman                                # choose kate
		else:
			survivor_chosen = girl
	elif GameHandler.player_data.conversation_flags["kate_chosen"]:
		survivor_chosen = girl

func _on_interaction_ui_handler_menu_closed() -> void:
	if to_move:
		trigger_end()
