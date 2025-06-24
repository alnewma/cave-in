extends CenterContainer

@export var button_text : String = ""
@onready var button_node = $NinePatchRect/Button

func _ready():
	if button_text != "":
		button_node.get_node("Label").text = button_text
