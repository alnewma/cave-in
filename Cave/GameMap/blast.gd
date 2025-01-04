extends "res://GameMap/interaction_object.gd"

@onready var sprite1 = $blast
@onready var gas_sprite = $gas
@onready var gas_coll = $gas_can/CollisionShape2D

func completion_routine():
		sprite1.visible = true

func ready_status_changed():
	_update_gas()

func _update_gas():
	var stat = completion_status
	# handle hiding vs showing
	if stat == 0:
		gas_sprite.hide()
	else:
		gas_sprite.show()

	# handle animation frames
	if stat >= 75:
		gas_sprite.frame = 3
	elif stat >= 50:
		gas_sprite.frame = 2
	elif stat >= 25:
		gas_sprite.frame = 1
	else:
		gas_sprite.frame = 0
		
	# handle collision shape
	if stat >= 75:
		gas_coll.disabled = false
	else:
		gas_coll.disabled = true
