extends AnimatedSprite2D

func _ready():
	var wait_duration = .2 * randi_range(0,5)
	await get_tree().create_timer(wait_duration).timeout
	show()
	play("default")

func _on_animation_finished() -> void:
	queue_free()
