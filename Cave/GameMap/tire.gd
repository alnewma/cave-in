extends "res://GameMap/interaction_object.gd"

@onready var sprite = $vehicle

func completion_routine():
		sprite.frame = 1
