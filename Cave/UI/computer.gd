extends Control

@export var locked = true :
	set(value):
		locked = value
		if not locked:
			hide_screens()
			start_screen.show()

@onready var fog = get_tree().get_first_node_in_group("fog_layer")

@onready var password_entry = $Base/password_text/body

@onready var start_screen = $Base/start_text
@onready var logs_screen = $Base/logs_text
@onready var doors_screen = $Base/doors_text
@onready var log1_screen = $Base/log1_text
@onready var log2_screen = $Base/log2_text
@onready var log3_screen = $Base/log3_text
@onready var log4_screen = $Base/log4_text
@onready var password_screen = $Base/password_text
@onready var opened_screen = $Base/opened_text
@onready var unpowered_screen = $Base/unpowered_text

func _ready():
	if GameHandler.events.BLAST_DOOR in GameHandler.save_game_instance.events_completed:
		completion_routine(1)

func hide_screens():
	AudioManager.play_effect(AudioManager.effects.COMPUTERCLICK,0,0,0,Vector2.ZERO,0,.1)
	var screens = [start_screen,logs_screen,doors_screen,log1_screen,log2_screen,log3_screen,log4_screen,password_screen,opened_screen,unpowered_screen]
	for screen in screens:
		screen.hide()

func open_computer():
	fog.hide()
	AudioManager.play_effect(AudioManager.effects.COMPUTERBUZZ,0,0,0,Vector2.ZERO,0,.3)
	get_tree().get_first_node_in_group("player").can_be_controlled = false
	hide_screens()
	if locked:
		password_screen.show()
		password_entry.grab_focus()
	else:
		start_screen.show()
	show()

func _on_back_button_pressed():
	hide_screens()
	start_screen.show()

func _on_logs_button_pressed():
	hide_screens()
	logs_screen.show()

func _on_door_button_pressed():
	hide_screens()
	doors_screen.show()

func _on_logs_button_1_pressed():
	hide_screens()
	log1_screen.show()

func _on_logs_button_2_pressed():
	hide_screens()
	log2_screen.show()

func _on_logs_button_3_pressed():
	hide_screens()
	log3_screen.show()
	
func _on_logs_button_4_pressed():
	hide_screens()
	log4_screen.show()

func _on_back_button_l_pressed():
	hide_screens()
	logs_screen.show()

func _on_exit_button_pressed():
	fog.show()
	visible = false
	get_tree().get_first_node_in_group("player").can_be_controlled = true
	AudioManager.stop_effect(AudioManager.effects.COMPUTERBUZZ,0)

func _on_door_2_button_pressed(): # blast door open screen
	hide_screens()
	if GameHandler.events.GENERATOR in GameHandler.save_game_instance.events_completed:
		opened_screen.show()
		completion_routine()
	else:
		unpowered_screen.show()

func completion_routine(already_completed = 0):
	if not already_completed and get_tree().get_first_node_in_group("blastdoor"):
		AudioManager.play_effect(AudioManager.effects.METALDOOR,0,0,0,get_tree().get_first_node_in_group("blastdoor").global_position,500)
	if not GameHandler.events.BLAST_DOOR in GameHandler.save_game_instance.events_completed:
		GameHandler.save_game_instance.events_completed.append(GameHandler.events.BLAST_DOOR)
	if get_tree().get_first_node_in_group("blastdoor"):
		get_tree().get_first_node_in_group("blastdoor").queue_free()

func _on_back_button_d_pressed():
	hide_screens()
	doors_screen.show()

func _on_body_text_changed(_new_text: String) -> void:
	AudioManager.play_effect(AudioManager.effects.TYPE)

func _on_body_text_submitted(new_text: String) -> void:
	if new_text == "Snowball":
		AudioManager.play_effect(AudioManager.effects.SINGLECORRECT)
		var computer = get_tree().get_first_node_in_group("computer")
		computer.player_completed = true
		computer.completion_status = 100
	else:
		AudioManager.play_effect(AudioManager.effects.SINGLEERROR)
