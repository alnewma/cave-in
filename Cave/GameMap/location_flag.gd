extends AnimatedSprite2D

@onready var peri = $location_perimeter
@onready var location_area = $location_area
@onready var location_area_shape = $location_area/CollisionShape2D
var being_interacted_with = false : 
	set = _started_interacted

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

func _started_interacted(value):
	being_interacted_with = value
	if being_interacted_with:
		peri.show()
		var tween = get_tree().create_tween()
		tween.tween_property(peri, "modulate", Color("ffffff33"), .75)
	else:
		peri.hide()
		peri.modulate = Color("ffffff00")


func _on_location_area_body_entered(body: Node2D) -> void:
	if flag_placed:
		# register player as near each assignment within flag
		for object in get_tree().get_nodes_in_group("interaction_object"):
			if object.overlaps_area(location_area):
				object.flags_through_which_player_is_nearby.append(self)
		# pulse ring visibility
		if not being_interacted_with:
			peri.show()
			var tween = get_tree().create_tween()
			tween.tween_property(peri, "modulate", Color("ffffff33"), 1)
			if being_interacted_with:
				return
			tween.tween_property(peri, "modulate", Color("ffffff00"), 1)
			await tween.finished # check at various stages and inturript if being interacted with
			peri.modulate = Color("ffffff33")
			if being_interacted_with:
				return
			peri.hide()

func _on_location_area_body_exited(body: Node2D) -> void:
	if flag_placed:
		# deregister player as near each assignment within flag
		for object in get_tree().get_nodes_in_group("interaction_object"):
			if object.overlaps_area(location_area):
				object.flags_through_which_player_is_nearby.erase(self)
