extends Camera2D

onready var menu_canvas = $"../Menu/Menu"
onready var credits_canvas = $"../Menu/Credits"
onready var text_layer = $"../TextLayer"
onready var opening = $"../Opening"
onready var title = $"../Title"
#42.632 technically
const LENGTH_OF_TITLE = 42.620
onready var start = $"../Menu/Menu/VBoxContainer/Start"
onready var tutorial = $"../Menu/Menu/VBoxContainer/Tutorial"
onready var credits = $"../Menu/Menu/VBoxContainer/Credits"
onready var back = $"../Menu/Credits/Back"
onready var quit = $"../Menu/Menu/VBoxContainer/Quit"

onready var first_level = "res://src/Levels/Level 1.tscn"
onready var first_tutorial_level = "res://src/Levels/Tutorial 1.tscn"

var text = []

#const START = 283.0
#const END = -4437.0
const ASCEND_START_TIME = 26.2
const TEXT_INTERVAL = ASCEND_START_TIME / 5.0

var title_timer = 0
var text_timer = 0
var text_index = 0
var ascend = false
var ascend_skipped = false
var title_play = false

#camera final position 344, -4588.557

func _ready():
	menu_canvas.visible = false
	credits_canvas.visible = false
	start.connect("pressed", self, "start")
	tutorial.connect("pressed", self, "tutorial")
	credits.connect("pressed", self, "credits")
	back.connect("pressed", self, "back")
	quit.connect("pressed", self, "quit")
	text = text_layer.get_children()
	text.pop_front()
#	opening.seek(24.5)

func _physics_process(delta):
	print(text_index)
	text_timer += delta
	if text_timer >= TEXT_INTERVAL and !ascend and !title_play:
		text_index += 1
		if text_index > 5:
			text_index = 0
		text[text_index-1].visible = false
		text[text_index].visible = true
		text_timer = 0
	if opening.get_playback_position() >= ASCEND_START_TIME:
		ascend = true
		text[4].visible = false
	if opening.get_playback_position() >= 37.7:
		ascend = false
	if opening.get_playback_position() >= 39.2 and !title_play:
		title_play()
	if title_play:
		title_timer += delta
		if title_timer >= LENGTH_OF_TITLE:
			reset()
			get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_cancel") and not ascend_skipped and not title_play:
		ascend = false
		ascend_skipped = true
		title_play()
		self.position.y = -4588.557
	if ascend and not ascend_skipped:
		self.position += Vector2.UP * 7.05
#	if Input.is_action_pressed("ui_up"):
#		self.position += Vector2.UP * 10
#	if Input.is_action_pressed("ui_down"):
#		self.position += Vector2.DOWN * 10

func reset():
	text_index = 0
	title_timer = 0
	text_timer = 0
	text_index = 0
	ascend = false
	title_play = false
	ascend_skipped = false
	
func title_play():
	opening.playing = false
	title.playing = true
	title_play = true
	menu_canvas.visible = true
		
func start():
	title.stop()
	get_tree().change_scene(first_level)
	
func tutorial():
	title.stop()
	get_tree().change_scene(first_tutorial_level)

func credits():
	menu_canvas.visible = false
	credits_canvas.visible = true

func back():
	menu_canvas.visible = true
	credits_canvas.visible = false

func quit():
	get_tree().quit()
