extends Node2D

@onready var des1 = $destination1

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = des1.global_position
