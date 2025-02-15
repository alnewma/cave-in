extends AnimatedSprite2D

func _on_visibility_changed() -> void:
	if not visible:
		$StaticBody2D/CollisionShape2D.disabled = true
	else:
		$StaticBody2D/CollisionShape2D.disabled = false
