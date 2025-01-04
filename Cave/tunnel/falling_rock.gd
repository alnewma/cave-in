extends StaticBody2D

@onready var stone_sprite_top = $top_rock
@onready var stone_sprite_bottom = $bottom_rock
var target = Vector2.ZERO
@onready var ripple = $ripple

func _ready() -> void:
	# set sprites
	var stone_choice = randi_range(0,8)
	if stone_choice >= 4 and stone_choice != 8:
		stone_choice += 4
	elif stone_choice == 8:
		stone_choice += 8
	stone_sprite_top.frame = stone_choice
	stone_sprite_bottom.frame = stone_choice + 4
	
	
	# set position
	global_position.x = target.x

var target_reached = false
func _process(delta: float) -> void:
	if not target_reached:
		if global_position.y >= target.y: # hide stone if reached target
			target_reached = true
			global_position = target
			stone_sprite_bottom.hide()
			ripple.show()
			z_index = 0
			ripple.play("default")
			await get_tree().create_timer(.025).timeout
			stone_sprite_top.hide()
		else:
			move_and_collide(Vector2.DOWN*4) # otherwise keep moving down

func _on_ripple_animation_finished() -> void:
	queue_free()
