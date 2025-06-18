extends CanvasLayer

func _ready():
	pause_setup()

func pause_setup():
	notes.text = GameHandler.save_game_instance.player_data.player_character_stats.notes
	var player = get_tree().get_first_node_in_group("player")
	for item in inventory_grid.get_children(): # clear out inventory before reinstancing
		item.queue_free()
	for item in GameHandler.save_game_instance.item_instances:
		if item[1] is Node2D and item[1] == player:
			var item_button = inventory_item.instantiate()
			item_button.get_node("item_image").texture = GameHandler.item_images_small[item[0]]
			item_button.get_node("item_name").text = GameHandler.item_names[item[0]]
			inventory_grid.add_child(item_button)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var gameMap = get_tree().current_scene
		if not gameMap.spectator_mode:
			AudioManager.play_effect(AudioManager.effects.BOOKCLOSE)
			visible = not visible

var inventory_item = preload("res://UI/inventory_item.tscn")
@onready var inventory_grid = $background/inventory_container/GridContainer
@onready var exit_button = $background/right_container/VBoxContainer/exit_button
@onready var exit_timer = $background/right_container/VBoxContainer/exit_button/exit_timer
var exit_started = false
func _on_exit_button_pressed():
	if exit_started:
		get_tree().quit()
	else:
		exit_started = true
		AudioManager.play_effect(AudioManager.effects.CLICK)
		exit_timer.start(3)
		exit_button.text = "Are you sure?"

func _on_exit_timer_timeout():
	exit_started = false
	exit_button.text = "Exit Game"

var menu_scene = load("res://MainMenu/main_menu.tscn")
func _on_quit_button_pressed():
	AudioManager.play_effect(AudioManager.effects.CLICK)
	get_tree().change_scene_to_packed(menu_scene)

func _on_save_button_pressed():
	AudioManager.play_effect(AudioManager.effects.CLICK)
	GameHandler.save_game_instance.write_data()

func _on_resume_button_pressed():
	AudioManager.play_effect(AudioManager.effects.BOOKCLOSE)
	visible = false

@onready var notes = $background/right_container/notes_edit
func _on_notes_edit_text_changed():
	GameHandler.save_game_instance.player_data.player_character_stats["notes"] = notes.text

func _on_visibility_changed() -> void:
	if visible:
		AudioManager.play_effect(AudioManager.effects.BOOKOPEN)
		pause_setup()
