extends Area2D

var bodies_inside = []

func _on_body_entered(body: Node2D) -> void:
	bodies_inside.append(body)

func _on_body_exited(body: Node2D) -> void:
	bodies_inside.erase(body)
