extends Control

@export var locked = true

@onready var fog = get_tree().get_first_node_in_group("fog_layer")

@onready var start_screen = $Base/start_text
@onready var logs_screen = $Base/logs_text
@onready var doors_screen = $Base/doors_text
@onready var log1_screen = $Base/log1_text
@onready var log2_screen = $Base/log2_text
@onready var log3_screen = $Base/log3_text
@onready var log4_screen = $Base/log4_text
@onready var password_screen = $Base/password_text
@onready var opened_screen = $Base/opened_text

func _ready():
	if GameHandler.events.BLAST_DOOR in GameHandler.save_game_instance.events_completed:
		completion_routine()

func hide_screens():
	var screens = [start_screen,logs_screen,doors_screen,log1_screen,log2_screen,log3_screen,log4_screen,password_screen,opened_screen]
	for screen in screens:
		screen.hide()

func open_computer():
	fog.hide()
	hide_screens()
	if locked:
		password_screen.show()
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

func _on_door_2_button_pressed(): # blast door opened
	hide_screens()
	opened_screen.show()
	completion_routine()

func completion_routine():
	GameHandler.save_game_instance.events_completed.append(GameHandler.events.BLAST_DOOR)
	if get_tree().get_first_node_in_group("blastdoor"):
		get_tree().get_first_node_in_group("blastdoor").queue_free()

func _on_back_button_d_pressed():
	hide_screens()
	doors_screen.show()
