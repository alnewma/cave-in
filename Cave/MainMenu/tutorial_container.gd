extends CenterContainer

@onready var animator = $AnimationPlayer

func _on_visibility_changed() -> void:
	if visible:
		animator.play("show_tutorial")
