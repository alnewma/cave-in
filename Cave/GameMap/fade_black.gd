extends CanvasLayer

@export var tunnel = false
@onready var rect = $blackRect
var fog_rect
func _ready():
	if not tunnel or tunnel:
		fog_rect = $"../FogLayer/ParallaxLayer/ColorRect"

func fade_to_black():
	var tween = get_tree().create_tween()
	tween.tween_property(rect,"modulate:a",1,1)
	if not tunnel:
		tween.parallel().tween_property(fog_rect,"modulate:a",0,1)
	await tween.finished
	return true

func fade_from_black():
	var tween = get_tree().create_tween()
	tween.tween_property(rect,"modulate:a",0,1)
	if not tunnel:
		tween.parallel().tween_property(fog_rect,"modulate:a",1,1)
	await tween.finished
	return true
