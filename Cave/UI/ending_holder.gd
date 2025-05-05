extends Control

@onready var container = $CenterContainer/VBoxContainer
@onready var tween : Tween = null
func add_text(text_to_add : String, spawn_return_button = false):
	if not tween:
		tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_QUAD)
	var label_instance = Label.new()
	label_instance.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_instance.theme = load("res://UI/label_theme.tres")
	label_instance.text = text_to_add
	label_instance.modulate.a = 0
	container.add_child(label_instance)
	tween.tween_property(label_instance,"modulate:a",1,3)
	if spawn_return_button:
		returnButton.show()
		tween.tween_property(returnButton,"modulate:a",1,3)

var menu_scene = load("res://MainMenu/main_menu.tscn")
@onready var returnButton = $returnContainer/returnButton

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_packed(menu_scene)
