extends Node2D

func _ready() -> void:
	set_survivors()
	tween_background()

func set_survivors():
	var survivor_instances = [$man_survivor,$old_man_survivor,$old_woman_survivor,$girl_survivor]
	var survivor_data = [GameHandler.player_data.survivor_data.ida,GameHandler.player_data.survivor_data.kate,GameHandler.player_data.survivor_data.mace,GameHandler.player_data.survivor_data.wesley]
	for survivor in survivor_instances:
		if not survivor.health > 0:
			survivor.queue_free()

@onready var boat = $boat
@onready var bg = $tunnel_background
func tween_background():
	var tween = get_tree().create_tween()
	tween.tween_property(bg, "global_position", Vector2(bg.global_position.x,boat.global_position.y), 15)

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
