extends Node2D

@onready var des2 = $destination2

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = des2.global_position
	elif body.is_in_group("survivor"):
		survivors_inside.append(body)
		set_process(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("survivor") and survivors_inside.has(body):
		survivors_inside.erase(body)
		body.modulate.a = 1
		if survivors_inside.size() == 0:
			set_process(false)

var survivors_inside = []
func _process(_delta):
	for body in survivors_inside:
		body.modulate.a = pow(-(global_position.y-body.global_position.y)/17.0,3)
