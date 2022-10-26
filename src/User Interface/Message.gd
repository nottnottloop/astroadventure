extends Control

onready var scene_tree: = get_tree()
onready var message_layer = $"Message Layer"

func _ready():
	scene_tree.paused = true
	message_layer.visible = true
	
func _unhandled_input(event):
	if event.is_action_pressed("space"):
		message_layer.visible = false
		scene_tree.paused = false
		scene_tree.set_input_as_handled()
