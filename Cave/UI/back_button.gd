extends MarginContainer

@export var previous_page : NodePath

func _on_back_button_pressed():
	var previous_page_node = get_node(previous_page)
	previous_page_node.get_parent().change_page(previous_page_node)
