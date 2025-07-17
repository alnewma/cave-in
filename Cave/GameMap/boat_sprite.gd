extends AnimatedSprite2D

@export var player_prompt : Control
var player_inside = false

@onready var splash_anim = $"../boatSplash"
@onready var engineSound = $boatEngineAudio
@onready var boat_obstacle = $"../../../NavigationNodes/NavigationRegion2D/NavigationObstacle2D"

func _physics_process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"): # start exit sequence
		queue_exit()
	if player_inside_to_leave and Input.is_action_just_pressed("interact"):
		exit_to_tunnel()
	

## Setting Boat Script ##

@onready var boat_blocker = $"../boatAreaBlocker/CollisionShape2D"
var queued = false
func queue_exit():
	if not queued:
		queued = true
		player_prompt.hide()
		boat_blocker.disabled = false
		var survivors = get_tree().get_nodes_in_group("survivor")
		var UIHandler = get_tree().get_first_node_in_group("interaction_UI_handler")
		# assign all survivors to follow player
		for survivor in survivors:
			UIHandler.current_survivor = survivor
			UIHandler.get_child(3).assign_survivor(get_tree().get_first_node_in_group("player"))
		# scoot boat animation
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUART)
		tween.connect("step_finished", on_tween_finished)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", global_position+Vector2(-13,0), 1)
		tween.tween_interval(.5)
		tween.chain().tween_property(self, "global_position", global_position+Vector2(-26,0), 1)
		tween.tween_interval(.5)
		tween.chain().tween_property(self, "global_position", global_position+Vector2(-39,0), 1.5)
		tween.set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(self, "scale", Vector2(.9,.9), .8).set_delay(.3)
		tween.set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "scale", Vector2(1,1), .5).set_delay(1.2)

var tween_finished_times = 0
func on_tween_finished(_tween_step):
	tween_finished_times += 1
	if tween_finished_times == 4:
		# handle boat avoidance removal
		boat_blocker.disabled = true
		boat_obstacle.affect_navigation_mesh = false # rebake nav region to stop avoiding boat
		boat_obstacle.carve_navigation_mesh = false
		boat_obstacle.get_parent().bake_navigation_polygon()
		# play splash animations
		await get_tree().create_timer(1).timeout
		play("default")
		await get_tree().create_timer(.2).timeout
		splash_anim.show()
		splash_anim.play("default")
		AudioManager.play_effect(AudioManager.effects.BOATSPLASH,0,0,0,global_position,125)
		# set leave detector to active
		$"../leave_area/CollisionShape2D".disabled = false

@onready var gate_sprite = $"../../gate/Sprite2D"
func _on_boat_area_body_entered(_body: Node2D) -> void:
	if not queued:
		if gate_sprite.frame == 1: # if gate is open
			player_prompt.visible = true
			player_inside = true

func _on_boat_area_body_exited(_body: Node2D) -> void:
	player_prompt.visible = false
	player_inside = false

@onready var trig_area = $boat_area/CollisionShape2D
@onready var col_area1 = $AnimatableBody2D/CollisionShape2D
@onready var col_area2 = $AnimatableBody2D/CollisionShape2D2
func _on_visibility_changed() -> void:
	if trig_area:
		if visible:
			trig_area.disabled = false
			col_area1.disabled = false
			col_area2.disabled = false
		else:
			trig_area.disabled = true
			col_area1.disabled = true
			col_area2.disabled = true

## Leaving Script ##

var player_inside_to_leave = false
func _on_leave_area_body_entered(_body: Node2D) -> void:
	if not leaving:
		player_prompt.visible = true
		player_inside_to_leave = true

func _on_leave_area_body_exited(_body: Node2D) -> void:
	player_prompt.visible = false
	player_inside_to_leave = false

@onready var black = $"../../../fadeBlack"
@onready var b_water = $boat_water
@onready var transition_bricks = $"../../../transitionBricks"

@onready var player_marker = $marker5
@onready var man_marker = $marker4
@onready var girl_marker = $marker3
@onready var old_woman_marker = $marker2
@onready var old_man_marker = $marker1

@onready var player_dummy = preload("res://Survivors/player_stand_in.tscn")
@onready var man_dummy = preload("res://Survivors/mace_stand_in.tscn")
@onready var girl_dummy = preload("res://Survivors/kate_stand_in.tscn")
@onready var old_man_dummy = preload("res://Survivors/wesley_stand_in.tscn")
@onready var old_woman_dummy = preload("res://Survivors/ida_stand_in.tscn")

var leaving = false
func exit_to_tunnel():
	if not leaving:
		leaving = true
		transition_bricks.show()
		player_prompt.hide()
		await black.fade_to_black()
		var player_instance = get_tree().get_first_node_in_group("player")
		player_instance.hide()
		player_instance.get_node("Camera2D").enabled = false
		player_instance.speed = 0
		var player_dum = player_dummy.instantiate()
		player_dum.get_node("light").energy = 1
		player_dum.get_node("light").texture_scale = 2
		add_child(player_dum)
		player_dum.global_position = player_marker.global_position
		var survivors = get_tree().get_nodes_in_group("survivor")
		for survivor in survivors:
			if survivor.health > 0:
				survivor.hide()
				match survivor.survivor_type:
					0:
						var dum = girl_dummy.instantiate()
						add_child(dum)
						dum.global_position = girl_marker.global_position
					1: pass
					2:
						var dum = man_dummy.instantiate()
						add_child(dum)
						dum.global_position = man_marker.global_position
					3:
						var dum = old_woman_dummy.instantiate()
						add_child(dum)
						dum.global_position = old_woman_marker.global_position
					4:
						var dum = old_man_dummy.instantiate()
						add_child(dum)
						dum.global_position = old_man_marker.global_position
		await get_tree().create_timer(.5).timeout
		black.fade_from_black()
		AudioManager.play_audio(AudioManager.songs.ENDSSTART)
		# boat movement
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "global_position", global_position+Vector2(-37,0), 5.2)
		tween.tween_interval(1.25)
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN)
		tween.chain().tween_property(self,"global_position", global_position+Vector2(-37,-110),12.68)
		await tween.step_finished
		await get_tree().create_timer(.25).timeout
		b_water.show()
		b_water.play("default")
		engineSound.play()
		await get_tree().create_timer(11).timeout
		await black.fade_to_black()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://tunnel/tunnel.tscn")
