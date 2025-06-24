extends AnimatedSprite2D

var effect_to_play
@export var wait_duration = -1.0

func _ready():
	if wait_duration < 0:
		wait_duration = .2 * randi_range(0,5)
	await get_tree().create_timer(wait_duration).timeout
	show()
	play("default")
	if effect_to_play:
		AudioManager.play_effect(effect_to_play,0,0,0,global_position)

func _on_animation_finished() -> void:
	queue_free()
