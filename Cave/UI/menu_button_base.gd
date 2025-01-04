extends CenterContainer

@export var button_text : String = ""
@onready var button_node = $NinePatchRect/Button

func _ready():
	if button_text != "":
		button_node.get_node("Label").text = button_text


func _on_button_pressed(extra_arg_0: String) -> void:
	pass # Replace with function body.
