extends Node

@onready var sfx_timer = $sfx
@onready var music_timer = $music

func _on_sfx_timeout() -> void:
	sfx_timer.start(randi_range(2,20))
	if get_tree().get_first_node_in_group("player").global_position.y > -111: # outside
		AudioManager.play_effect(AudioManager.effects.CAVE_AMBIENT)

func _on_music_timeout() -> void:
	music_timer.start(randi_range(5*60,8*60))
	if get_tree().get_first_node_in_group("player").global_position.y > -111: # outside
		AudioManager.play_audio(AudioManager.songs.CAVE_AMBIENT)
