extends AnimatedSprite2D

@onready var barrel_timer = $Timer

func _ready():
	barrel_timer.start(randi_range(3,6))

func _on_timer_timeout():
	play("default")
	barrel_timer.start(randi_range(3,6))
