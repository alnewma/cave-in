extends "res://GameMap/interaction_object.gd"

@onready var sprite1 = $blast
@onready var gas_sprite = $gas
@onready var gas_coll = $gas_can/CollisionShape2D
@onready var animation_explode = $explosionAnim

func completion_routine():
		sprite1.visible = true
		animation_explode.show()
		animation_explode.play()
		AudioManager.play_effect(AudioManager.effects.EXPLOSIONCLOSE,0,0,0,global_position,250,2)
		AudioManager.play_effect(AudioManager.effects.EXPLOSIONFAR,0,0,0,Vector2.ZERO,0,2)
		get_tree().get_first_node_in_group("player").get_node("Camera2D").add_trauma(.35)

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


func _on_explosion_anim_animation_finished() -> void:
	if animation_explode:
		animation_explode.queue_free()
