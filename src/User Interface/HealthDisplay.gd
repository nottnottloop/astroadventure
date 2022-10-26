extends Control

onready var label: Label = $CanvasLayer/Label
onready var red = $CanvasLayer/White/Red
const TO_FORMAT = "Health: %s"

func _ready():
	PlayerData.connect("health_updated", self, "on_health_update")
	on_health_update()

func on_health_update():
	label.text = TO_FORMAT % PlayerData.health
	red.margin_right = (PlayerData.health / 100.0) * 237
