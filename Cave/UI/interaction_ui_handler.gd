extends CanvasLayer

@onready var start_page = $interaction_page
@onready var speech_page = $dialogue_page
@onready var status_page = $status_page
@onready var location_page = $location_page
@onready var assignment_page = $assignment_page

@export var tunnel_scene = false
var reached_tunnel_end = false

signal updated_conversation_flag
signal menu_closed

var current_survivor : Node
var page_list : Array

func _ready():
	page_list = [start_page,speech_page,status_page,location_page,assignment_page]
	for node in get_tree().get_nodes_in_group("button"):
		if node.is_in_group("button"):
			node.pressed.connect(_on_button_pressed.bind(node.get_node("Label").text))
	hide_pages()

func hide_pages():
	for page in page_list:
		page.visible = false

func change_page(page,_opening = false):
	hide_pages()
	#positions menu at mouse, removed because menu too big to be practical
	#if opening == true:
		#offset = get_viewport().get_mouse_position()
		#if offset.x > get_viewport().content_scale_size.x - start_page.get_node("background").size.x*scale.x:
			#offset.x = get_viewport().content_scale_size.x - start_page.get_node("background").size.x*scale.x
		#if offset.y > get_viewport().content_scale_size.y - start_page.get_node("background").size.y*scale.y:
			#offset.y = get_viewport().content_scale_size.y - start_page.get_node("background").size.y*scale.y
	page.visible = true

func _on_button_pressed(source_text):
	match source_text:
		"Speak":
			change_page(speech_page)
		"Status":
			change_page(status_page)
		"Assign":
			change_page(location_page)
		"Close":
			hide_pages()
			emit_signal("menu_closed")
