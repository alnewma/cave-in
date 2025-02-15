extends AnimatedSprite2D

@onready var bot_rip = $"../ripple_bottom"
func _on_animation_finished() -> void:
	bot_rip.queue_free()
	queue_free()
