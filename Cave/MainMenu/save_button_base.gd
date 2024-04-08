extends Button

@export var save_file_name : String

func _ready():
	text = save_file_name.get_slice(".",0)
