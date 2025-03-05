extends Sprite2D

var destination : Vector2

signal landed

@onready var splash = $AnimatedSprite2D

func _ready() -> void:
	global_position = destination + Vector2(0,-100)
	material["shader_parameter/percentage"] = 1.0
	if frame == 2:
		$Area2D.monitorable = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", destination-Vector2(0,7), .75)
	tween.chain().tween_property(self.material,"shader_parameter/percentage",.7,.15)
	tween.parallel().tween_property(self,"global_position",destination,.15)
	await get_tree().create_timer(.7).timeout
	emit_signal("landed")
	splash.show()
	splash.play("default")


func _on_animated_sprite_2d_animation_finished() -> void:
	splash.queue_free()
