extends MarginContainer

@onready var text_label = $Label
@onready var timer = $Timer
@export var character_time = .02

var text_to_display = "March 8th, 2025 – Highway Tunnel 47, Northern Rockies\n\nMassive landslides have caused a tunnel collapse,\ncrushing an unknown number of vehicles and passengers.\n\nRescue services estimate 3 days before breakthrough\nbut expect no survivors."
var characters_displayed = 0

func start_displaying():
	timer.start(character_time)

func display_more():
	text_label.text += text_to_display[characters_displayed]
	if text_to_display[characters_displayed] == '\n' and text_to_display[characters_displayed-1] == '\n':
		return character_time * 40
	else:
		return character_time

func _on_timer_timeout() -> void:
	if characters_displayed != text_to_display.length():
		timer.start(display_more())
		characters_displayed += 1
