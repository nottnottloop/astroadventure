extends Node2D

signal drug_time

func _on_body_entered(body):
	emit_signal("drug_time")
	queue_free()
