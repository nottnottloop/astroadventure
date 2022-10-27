extends Node2D

onready var powerup = preload("res://src/Sounds/SFX/Drugs.tscn")
signal drug_time
export var speed_boost = 550.0

func _on_body_entered(body):
	if body.name == "Player":
		if PlayerData.sfx_enabled:
			var sound = powerup.instance()
			var current_speed = get_node("/root/Level/Player").speed.x
			sound.pitch_scale = 1.0 + ((-625.0 + current_speed) / 5500.0)
			get_node("/root/Level").add_child(sound)
		PlayerData.set_speed_boost(speed_boost)
		PlayerData.start_boosting()
		queue_free()
	
