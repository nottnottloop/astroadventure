extends Area2D

var _can_pickup = false

func _physics_process(delta):
#	print(_can_pickup)
	if Input.is_action_just_pressed("interact"):
		if _can_pickup and PlayerData.guns_in_range == 1:
			PlayerData.set_gun(get_parent().name)
			var string = "/root/Level/" + get_parent().name
			get_node(string).queue_free()

func _on_Area2D_body_entered(body):
		_can_pickup = true
		PlayerData.increase_guns_in_range()

func _on_Area2D_body_exited(body):
		_can_pickup = false
		PlayerData.reduce_guns_in_range()
