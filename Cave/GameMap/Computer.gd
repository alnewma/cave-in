extends Sprite2D

@export var player_prompt : Control
@export var computer_screen : Control
var player_inside = false

func _on_timer_timeout():
	if frame == 0:
		frame = 1
	else:
		frame = 0

func _on_computer_area_body_entered(_body):
	player_prompt.visible = true
	player_inside = true

func _on_computer_area_body_exited(_body):
	player_prompt.visible = false
	player_inside = false

func _physics_process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		if not computer_screen.visible:
			computer_screen.open_computer()
