extends Control

func _ready() -> void:
	if get_parent().tunnel_scene:
		$background/button_holder/assign_button.hide()
