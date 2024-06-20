extends "res://GameMap/interaction_object.gd"

@onready var sprite = $Cycle

func completion_routine():
	_update_sprite()

func _update_sprite():
	var stat = completion_status
	if stat == 100:
		sprite.frame = 1
	else:
		sprite.frame = 0
