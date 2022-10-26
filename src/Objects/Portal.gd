extends Area2D

export var next_level: PackedScene

func _on_Portal_area_entered(area):
	get_tree().change_scene_to(next_level)
