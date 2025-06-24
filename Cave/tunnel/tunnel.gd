extends Node2D

@export var travel_duration = 15
var spectator_mode = false
@onready var usage_prompt = $usage_holder/usage_prompt
@onready var playerUI = $interaction_UI_handler

func _ready():
	AudioManager.play_audio(AudioManager.songs.ENDSEND,false)
	AudioManager.play_effect(AudioManager.effects.TUNNELRUMBLING,0,0,0,Vector2.ZERO,0,2.2)
	speech_setup()
	cutscene_setup()
	usage_prompt.set_text("Go First")
	playerUI.show()

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
	interaction_menu.current_survivor = survivor
	interaction_menu.change_page(interaction_menu.start_page,true)

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
	var survivor_data = [GameHandler.save_game_instance.player_data.survivor_data.ida,GameHandler.save_game_instance.player_data.survivor_data.kate,GameHandler.save_game_instance.player_data.survivor_data.mace,GameHandler.save_game_instance.player_data.survivor_data.wesley]
	for survivor in survivor_instances:
		if not survivor.health > 0:
			survivor.queue_free()
		else:
			survivor.ending_sequence = true

@onready var boat = $boat
@onready var bg = $tunnel_background
@onready var progress_timer = $progress_timer
@onready var leave_area = $boat/leave_area
func tween_background():
	progress_timer.start(travel_duration/2)
	var tween = get_tree().create_tween()
	tween.tween_property(bg, "global_position", Vector2(bg.global_position.x,boat.global_position.y), travel_duration)

var bobbing = false
func _maintain_boat_bobbing():
	pass
	boat.global_position.y = 100+(sin(((Time.get_ticks_msec()/1000.0)*PI+PI/2))*.5)*.1375


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
			bobbing = true
			var current_survivors = get_tree().get_nodes_in_group("survivor")
			var speaking_survivor = current_survivors.pick_random()
			speaking_survivor.queue_remark(speaking_survivor.remark_prompts.BLOCKED2)
			interaction_menu.reached_tunnel_end = true
			var tween = get_tree().create_tween()
			tween.tween_property($FogLayer/ParallaxLayer/ColorRect,"modulate:a",0,1)
			tween.parallel().tween_property($FogLayer2/ParallaxLayer/ColorRect,"modulate:a",1,1)
			leave_area.get_node("CollisionShape2D").disabled = false
			$boat/engine/engineSound.stop()
			AudioManager.play_effect(AudioManager.effects.BOATENGINESTOP,0,0,0,$boat/engine.global_position,40)
			$boat/boat_water.play("water_stop")
			progression += 1
			progress_timer.start(60)
		3: # tunnel about to collapse
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
	if not last_rock_landed:
		r_timer1.start(randf_range(.01,2.5))
		_spawn_rock()

func _on_rock_timer_2_timeout() -> void:
	if not last_rock_landed:
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
	bobbing = false
	boat.global_position.y = 100
	bg.z_index = 0
	to_move = replace_sprite(player_dummy,player,true)
	player.speed = 0
	match survivor_chosen.name:
		"Player":
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
@onready var blocking_rocks = $tunnel_background/blocking_rocks
@onready var block_rock = preload("res://tunnel/block_rock.tscn")
@onready var pos1 = $tunnel_background/rock1
@onready var pos2 = $tunnel_background/rock2
@onready var pos3 = $tunnel_background/rock3
var dummies = []
func trigger_end():
	usage_prompt.hide()
	blocking_rocks.z_index = 2
	var tween = get_tree().create_tween()
	tween.tween_property(to_move,"global_position",exit_marker.global_position,1.5)
	to_move.play("run")
	if exit_marker.global_position.x-to_move.global_position.x < 0:
		to_move.flip_h = true
	await tween.finished
	to_move.stop()
	to_move.get_node("AnimationPlayer").play("exit")
	await get_tree().create_timer(1.1).timeout
	boat.z_index += 1
	for dummy in dummies:
		dummy.z_index += 1
	top_ripple.show()
	top_ripple.play("default")
	bottom_ripple.show()
	bottom_ripple.play("default")
	await get_tree().create_timer(.5).timeout
	$tunnel_background/gate/survivor_ripple.show()
	$tunnel_background/gate/survivor_ripple.play("default")
	await get_tree().create_timer(10).timeout
	get_node("playerStandIn").get_node("Camera2D").add_trauma(.35)
	await get_tree().create_timer(1).timeout
	get_node("playerStandIn").get_node("Camera2D").add_trauma(.45)
	var rock_inst = block_rock.instantiate()
	rock_inst.destination = pos1.global_position
	bg.add_child(rock_inst)
	await get_tree().create_timer(1).timeout
	rock_inst = block_rock.instantiate()
	rock_inst.connect("landed",rock2_land)
	rock_inst.frame = 1
	rock_inst.destination = pos2.global_position
	bg.add_child(rock_inst)
	await get_tree().create_timer(.75).timeout
	rock_inst = block_rock.instantiate()
	rock_inst.frame = 2
	rock_inst.destination = pos3.global_position
	bg.add_child(rock_inst)

@onready var break_sprite = $boat/break
func rock2_land():
	break_sprite.show()
	break_sprite.play("default")
	push_characters_away(pos2.global_position)

var last_rock_landed = false
@onready var dark_cover = $darkness_cover
func rock3_land():
	last_rock_landed = true
	dark_cover.show()
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(dark_cover,"global_position",Vector2(0,0),1)

func replace_sprite(replacement_file,original,location:bool): # true:original loc, false:marker loc
	var man_inst = replacement_file.instantiate()
	man_inst.z_index = 3
	if location:
		man_inst.global_position = original.global_position
		dummies.append(man_inst)
	else:
		man_inst.global_position = exit_marker.global_position
	add_child(man_inst)
	original.hide()
	return man_inst

func _on_interaction_ui_handler_updated_conversation_flag() -> void:
	if GameHandler.save_game_instance.player_data.conversation_flags["ida_chosen"]:
		survivor_chosen = woman
	elif GameHandler.save_game_instance.player_data.conversation_flags["mace_chosen"]:
		survivor_chosen = man
	elif GameHandler.save_game_instance.player_data.conversation_flags["wesley_chosen"]:
		if GameHandler.save_game_instance.player_data.conversation_flags["kate_dead"]: # if wesley chosen and kate alive
			survivor_chosen = oldman                                # choose kate
		else:
			survivor_chosen = girl
	elif GameHandler.save_game_instance.player_data.conversation_flags["kate_chosen"]:
		survivor_chosen = girl

func _on_interaction_ui_handler_menu_closed() -> void:
	if to_move:
		trigger_end()
	elif surv_talked_to:
		usage_holder.show() # allow player to leave after talking

func push_characters_away(origin_position:Vector2):
	for dummy in dummies:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		var push_location = dummy.global_position + (dummy.global_position - origin_position).normalized()*3
		tween.tween_property(dummy,"global_position",push_location,.3)

func _on_light_area_area_entered(area: Area2D) -> void:
	rock3_land()

@export var player_prompt : Control
var player_inside = false
var started_self_exit = false
func _on_leave_area_body_entered(body: Node2D) -> void:
	player_prompt.show()
	player_inside = true
func _on_leave_area_body_exited(body: Node2D) -> void:
	player_prompt.hide()
	player_inside = false
func _physics_process(_delta):
	if bobbing:
		_maintain_boat_bobbing()
	if not started_self_exit and player_inside and usage_holder.visible and Input.is_action_just_pressed("interact"):
		started_self_exit = true
		player.can_be_controlled = false
		self.survivor_chosen = player
		player_prompt.hide()
		trigger_end()

@onready var st_timer = $stoneCrashAudioTimer
func _on_stone_crash_audio_timer_timeout() -> void:
	if not last_rock_landed:
		AudioManager.play_effect(AudioManager.effects.STONECRASH,0,0,0,Vector2.ZERO,0,2.5)
		st_timer.start(randi_range(1,5))

@onready var li_timer = $lightTimer
func _on_light_timer_timeout() -> void:
	$Player/light.energy = randf_range(.5,1)
	li_timer.start(randf_range(.5,1.5))

@onready var usage_holder = $usage_holder
var surv_talked_to = false
func _on_dialogue_page_survivor_talked_to_during_end() -> void:
	surv_talked_to = true
