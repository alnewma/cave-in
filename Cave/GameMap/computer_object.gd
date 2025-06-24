extends "res://GameMap/interaction_object.gd"

func completion_routine():
	if not is_node_ready():
		await ready
	get_tree().get_first_node_in_group("computer_ui").locked = false
	for surv in assigned_survivors:
		if randi()%2==0:
			var survnode = get_node(surv)
			survnode.queue_remark(survnode.remark_prompts.COMPUTERFINISH)

var player_completed = false
var sfx_cooldown = false
func _completion_status_update() -> void:
	if completion_status == 100:
		if not player_completed:
			AudioManager.stop_effect(AudioManager.effects.ERROR)
			AudioManager.play_effect(AudioManager.effects.CORRECTPASSWORD,0,0,0,global_position)
	elif not sfx_cooldown:
		sfx_cooldown = true
		AudioManager.play_effect(AudioManager.effects.ERROR,0,0,0,global_position)
		get_tree().create_timer(1.25).timeout.connect(_end_sfx_cooldown)

func _end_sfx_cooldown():
	sfx_cooldown = false
