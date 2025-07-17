extends Node2D
@onready var rocks_texture = preload("res://ArtAssets/falling_rocks.png")
@onready var fall_sprite = $falling_rock
@onready var frame = randi_range(0,8)
@onready var smoke = $smoke
@onready var ripple = $ripple

func _ready() -> void:
	fall_sprite.frame = frame
	var tween = get_tree().create_tween()
	fall_sprite.offset.y = -200
	tween.tween_property(fall_sprite,"offset:y",fall_sprite.offset.y+200,1.5)
	if Geometry2D.is_point_in_polygon(global_position,get_tree().get_first_node_in_group("water_area").polygon):
		tween.finished.connect(_splash)
	else:
		tween.finished.connect(_shatter)

func _shatter():
	for i in 9:
		var fragment = Sprite2D.new()
		fragment.hframes = 12
		fragment.vframes = 12
		fragment.texture = rocks_texture
		@warning_ignore("integer_division")
		fragment.frame = (i / 3 * 12) + (i % 3) + (36 * (frame/4) + 3 * (frame % 4))
		fragment.position = square[i] * Vector2(4,4)
		add_child(fragment)
		# play explosion
		AudioManager.play_effect(AudioManager.effects.ROCKFALL,0,0,0,global_position,75,1.5)
		smoke.show()
		smoke.play("default")
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(fragment,"position",square[i].normalized()*Vector2(12,12),.25)
		tween.parallel().tween_property(fragment,"scale",Vector2.ZERO,.75)
		tween.finished.connect(queue_free)
	fall_sprite.hide()

func _splash():
	var boat_polygon = get_node("../interaction_objects/buildboat/boatSprite/boatPolygon")
	if Geometry2D.is_point_in_polygon(global_position-boat_polygon.global_position,boat_polygon.polygon): #don't splash if on boat
		_shatter()
	else:
		@warning_ignore("integer_division")
		var starting_percent = frame/4 * 25 + 25
		fall_sprite.material.set("shader_parameter/percentage",starting_percent*.01)
		get_tree().create_tween().tween_property(fall_sprite.material,"shader_parameter/percentage",(starting_percent-25)*.01,.1)
		ripple.play("default")
		ripple.show()
		AudioManager.play_effect(AudioManager.effects.STONESPLASH,0,0,0,global_position,100,.5)

var square = {
	0 : Vector2(-1,-1),
	1 : Vector2(0,-1),
	2 : Vector2(1,-1),
	3 : Vector2(-1,0),
	4 : Vector2(0,0),
	5 : Vector2(1,0),
	6 : Vector2(-1,1),
	7 : Vector2(0,1),
	8 : Vector2(1,1),
}


func _on_ripple_animation_finished() -> void:
	queue_free()
