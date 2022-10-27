extends Area2D

export var next_level: PackedScene
export var final_level: bool = false

func _on_Portal_area_entered(area):
	if final_level:
		PlayerData.play_music(-1)
	get_tree().change_scene_to(next_level)
	PlayerData.reset(true)
