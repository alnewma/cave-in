extends "res://UI/interaction_base.gd"

@onready var title = $background/button_holder/title_holder/TitleBanner/Label
@onready var health_bar = $background/button_holder/status_holder2/VBoxContainer/health_status
@onready var thirst_bar = $background/button_holder/status_holder1/VBoxContainer/thirst_status
@onready var item_image = $background/item_holder/MarginContainer/VBoxContainer/item_image
@onready var handler = get_parent()

@onready var button_holder = $background/button_holder
@onready var item_button = $background/item_holder/item_button
@onready var item_holder = $background/item_holder

@onready var item_name = $background/item_holder/MarginContainer/VBoxContainer/item_name
@onready var take_button = $background/item_holder/MarginContainer/VBoxContainer/take_button
@onready var replace_button = $background/item_holder/MarginContainer/VBoxContainer/replace_button
@onready var replace_warning = $background/item_holder/MarginContainer/VBoxContainer/inv_scroll/VBoxContainer/replace_warning
var item_menu_nodes = []

@onready var replace_scoll_container = $background/item_holder/MarginContainer/VBoxContainer/inv_scroll

func _ready():
	item_menu_nodes = [item_name,take_button,replace_button]

func _on_visibility_changed():
	if handler != null:
		var survivor_name : String
		match get_parent().current_survivor.survivor_type:
			0: survivor_name = "Kate"
			1: pass # No survivor
			2: survivor_name = "Mace"
			3: survivor_name = "Ida"
			4: survivor_name = "Wesley"
		title.text = survivor_name
		health_bar.value = handler.current_survivor.health
		thirst_bar.value = handler.current_survivor.thirst
		print("refreshing textures")
		refresh_item_textures()

func refresh_item_textures():
	var survivor_item = null
	for item in GameHandler.save_game_instance.item_instances:
		if item[1] is Node2D and item[1] == handler.current_survivor:
			survivor_item = item[0]
	if survivor_item != null:
		item_image.texture = GameHandler.item_images[survivor_item]
		item_name.text = "Item: " + GameHandler.item_names[survivor_item]
		take_button.text = "Take Item"
		
	else:
		print("no texture")
		item_image.texture = null
		item_name.text = "No Item Equipped"
		take_button.text = ""
@onready var rect = item_button.get_rect()
#func _process(delta):
	#if rect.has_point(get_viewport().get_mouse_position()-(item_holder.position-item_button.position-Vector2(68.125,0))*scale):
		#self.inside = true
	#else:
		#self.inside = false

var inside = false : set = inside_change

func inside_change(value):
	if value != inside:
		inside = value
		if inside:
			print("inside changed: inside")
			item_image.visible = false
			for node in item_menu_nodes:
				node.visible = true
		else:
			print("inside changed: not inside")
			item_image.visible = true
			for node in item_menu_nodes:
				node.visible = false
			replace_scoll_container.visible = false

func _on_take_button_pressed():
	for item in GameHandler.save_game_instance.item_instances:
		if item[1] is Node2D and item[1] == handler.current_survivor:
			print("removing item from survivor")
			item[1] = get_tree().get_first_node_in_group("player")
	refresh_item_textures()

@onready var item_base = preload("res://UI/scroll_item.tscn")
func _on_replace_button_pressed():
	for node in item_menu_nodes:
		node.visible = false
	for child in replace_scoll_container.get_child(0).get_children():
		if child.is_in_group("scroll_item"):
			child.queue_free()
	replace_scoll_container.visible = true
	var player = get_tree().get_first_node_in_group("player")
	var items_found = 0
	for item in GameHandler.save_game_instance.item_instances:
		if item[1] is Node2D and item[1] == player:
			print("items found for player")
			items_found += 1
			var label = item_base.instantiate()
			label.text = GameHandler.item_names[item[0]]
			replace_scoll_container.get_child(0).add_child(label)
			label.connect("pressed",replace_item_clicked.bind(item[0]))
	if items_found == 0:
		replace_warning.show()
	else:
		replace_warning.hide()

func replace_item_clicked(pressed_item):
	_on_take_button_pressed()
	var player = get_tree().get_first_node_in_group("player")
	for item in GameHandler.save_game_instance.item_instances:
		if item[0] == pressed_item and item[1] is Node2D and item[1] == player:
			item[1] = handler.current_survivor
			break
	replace_scoll_container.visible = false
	for node in item_menu_nodes:
		node.visible = true
	print("refreshing texture after replace")
	refresh_item_textures()

func _on_item_holder_mouse_entered():
	inside = true

func _on_item_holder_mouse_exited():
	print("exited")
	print(item_holder.get_rect())
	print(get_local_mouse_position())
	if not Rect2(item_holder.position,item_holder.size).has_point(get_local_mouse_position()):
		inside = false
