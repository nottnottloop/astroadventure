extends Actor

onready var hitsound = preload("res://src/Sounds/SFX/Hitsound.tscn")

func _physics_process(delta):
	var result = move_and_collide(velocity)
	if result:
		if result.get_collider().get_parent() is Enemy and result.get_collider().get_collision_layer() == 2:
			if PlayerData.sfx_enabled:
				var sound = hitsound.instance()
				get_node("/root/Level").add_child(sound)
			result.get_collider().get_parent().damage()
		queue_free()
