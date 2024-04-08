extends "res://GameMap/interaction_object.gd"

@onready var sprite = $Cycle

func _ready():
	completion_status_changed.connect(_update_sprite)
	_update_sprite()

func _update_sprite():
	var stat = completion_status
	if stat == 100:
		sprite.frame = 1
		give_item([GameHandler.items.ENGINE,GameHandler.items.PROPELLER])
	else:
		sprite.frame = 0
