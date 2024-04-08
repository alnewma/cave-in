extends AnimatedSprite2D

@onready var peri = $location_perimeter
@onready var location_area_shape = $location_area/CollisionShape2D

signal flag_clicked
signal flag_mouse_entered
signal flag_mouse_exited

var flag_placed = false
var flag_name = ""

func _ready():
	frame = randi_range(0,4)

func _on_interaction_area_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("object_select") and flag_placed:
		get_viewport().set_input_as_handled()
		emit_signal("flag_clicked",self)
		peri.visible = true

func _on_interaction_area_mouse_entered():
	if flag_placed:
		emit_signal("flag_mouse_entered",self)
func _on_interaction_area_mouse_exited():
	if flag_placed:
		emit_signal("flag_mouse_exited",self)
