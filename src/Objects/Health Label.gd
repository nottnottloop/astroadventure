extends Label

const LABEL_TEXT = "Health: %s"
onready var label: Label = $"."
export var monster_name: String
var path

func _ready():
	path = "/root/Level/" + monster_name
	if !has_node(path) or monster_name == "":
		queue_free()
		return
	label.text = LABEL_TEXT % get_node(path).health
	
func _physics_process(delta):
	if has_node(path):
		label.text = LABEL_TEXT % get_node(path).health
	else:
		queue_free()
