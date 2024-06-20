extends Node2D

@onready var des = $Marker2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("survivor"):
		body.global_position = des.global_position
