extends Area2D

@onready var surv = get_parent()

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.health <= 0 and randi()%2 == 0:
		surv.queue_remark(surv.remark_prompts.NEARBYBODY,GameHandler.get_survivor_name_from_object(body))
