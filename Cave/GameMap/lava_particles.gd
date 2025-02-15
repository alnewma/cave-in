extends CPUParticles2D

@onready var bubble = preload("res://GameMap/lava_bubble.tscn")
@onready var bubble_timer = $bubble_timer


func _on_bubble_timer_timeout() -> void:
	bubble_timer.start(randi_range(1,5))
	var inst = bubble.instantiate()
	inst.global_position = global_position + Vector2(randi_range(-105+8,105-8),randi_range(-16+8,16-8))
	get_tree().current_scene.add_child(inst)
