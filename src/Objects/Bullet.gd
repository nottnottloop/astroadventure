extends Actor

func _physics_process(delta):
	var result = move_and_collide(velocity)
	if result:
		if result.get_collider().get_parent() is Enemy:
			result.get_collider().get_parent().damage()
		queue_free()
