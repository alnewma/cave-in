extends Node2D

@onready var des2 = $destination2

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = des2.global_position
