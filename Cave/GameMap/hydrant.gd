extends "res://GameMap/interaction_object.gd"

@onready var barrel1 = $barrelSprite
@onready var barrel2 = $barrelSprite2

func _ready():
	completion_status_changed.connect(_update_barrels)
	_update_barrels()

func _update_barrels():
	var stat = completion_status
	if stat == 0:
		barrel1.visible = false
		barrel2.visible = false
	elif stat < 25 and stat > 0:
		barrel1.visible = true
		barrel1.frame = 0
		barrel2.visible = false
	elif stat >= 25 and stat < 50:
		barrel1.visible = true
		barrel1.frame = 1
		barrel2.visible = false
	elif stat >= 50 and stat < 75:
		barrel1.visible = true
		barrel1.frame = 1
		barrel2.visible = true
		barrel2.frame = 0
	elif stat >= 75:
		barrel1.visible = true
		barrel1.frame = 1
		barrel2.visible = true
		barrel2.frame = 1
