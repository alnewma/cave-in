extends CanvasLayer

func _ready():
	pause_setup()

func pause_setup():
	notes.text = GameHandler.player_data.player_character_stats.notes
	for item in GameHandler.player_data.player_character_stats.inventory:
		var item_button = inventory_item.instantiate()
		item_button.texture = get(item)
		inventory_grid.add_child(item_button)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = not visible

var inventory_item = preload("res://UI/inventory_item.tscn")
@onready var inventory_grid = $background/inventory_container/GridContainer
@onready var exit_button = $background/VBoxContainer/exit_button
@onready var exit_timer = $background/VBoxContainer/exit_button/exit_timer
var exit_started = false
func _on_exit_button_pressed():
	if exit_started:
		get_tree().quit()
	else:
		exit_started = true
		exit_timer.start(3)
		exit_button.text = "Are you sure?"

func _on_exit_timer_timeout():
	exit_started = false
	exit_button.text = "Exit Game"

var menu_scene = load("res://MainMenu/main_menu.tscn")
func _on_quit_button_pressed():
	get_tree().change_scene_to_packed(menu_scene)

func _on_save_button_pressed():
	GameHandler.save_data()

func _on_resume_button_pressed():
	visible = false

@onready var notes = $background/notes_edit
func _on_notes_edit_text_changed():
	GameHandler.player_data.player_character_stats["notes"] = notes.text
