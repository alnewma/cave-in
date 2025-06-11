extends CenterContainer

@onready var animator = $AnimationPlayer

func _on_visibility_changed() -> void:
	if visible:
		animator.play("show_tutorial")

func _play_photo_sound1():
	AudioManager.play_effect(AudioManager.effects.PHOTO1)
func _play_photo_sound2():
	AudioManager.play_effect(AudioManager.effects.PHOTO2)
