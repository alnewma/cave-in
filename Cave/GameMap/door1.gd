extends Node2D

@onready var des1 = $destination1

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_tree().create_tween().tween_property(body.get_node("light"),"texture_scale",1,.1)
		body.global_position = des1.global_position
