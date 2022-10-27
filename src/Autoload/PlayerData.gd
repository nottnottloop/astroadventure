extends Node

onready var music = $"Current Music"
export var training_music = preload("res://Assets/Music/training.mp3")
export var level_1_music = preload("res://Assets/Music/level 1.mp3")
export var level_2_music = preload("res://Assets/Music/level 2.mp3")
export var level_3_music = preload("res://Assets/Music/level 3.mp3")
var current_music_id

signal health_updated
signal player_death
signal gun_picked_up
signal drug_time
signal boss_defeated

export var starting_health = 100
export var health: int = starting_health setget set_health
export var gun = "" setget set_gun
var previous_gun = ""
var guns_in_range = 0
var bullet_damage = 0
var fire_rate = 0.0
var bullet_speed = 0
var ahh_boost_speed: float = 0.0 setget set_ahh_boost_speed
export var speed_boost = Vector2(550.0, 0) setget set_speed_boost
var boss_defeated = false setget set_boss_defeated
var music_enabled = true
var sfx_enabled = true

onready var dead = $Dead
onready var portal_effect = $"Portal Effect"

func set_boss_defeated(value):
	print("woohoo! boss defeated")
	boss_defeated = value
	emit_signal("boss_defeated")

func _unhandled_input(event):
	if event.is_action_pressed("mute_sfx"):
		sfx_enabled = !sfx_enabled
	if event.is_action_pressed("mute_music"):
		music_enabled = !music_enabled
		if music_enabled:
			music.play()
		else:
			music.stop()

func set_speed_boost(value):
	speed_boost = Vector2(value, 0)

func set_ahh_boost_speed(value):
	ahh_boost_speed = value

func reset(portal=false):
	set_health(100)
	previous_gun = ""
	gun = ""
	guns_in_range = 0
	speed_boost = Vector2(550.0, 0)
	boss_defeated = false
	if portal:
		if sfx_enabled:
			portal_effect.play()

func start_boosting():
	emit_signal("drug_time")

func play_music(id):
	if current_music_id == id:
		return
	current_music_id = id
	if id == -1:
		music.stop()
		return
	if id == 0:
		music.set_stream(training_music)
	if id == 1:
		music.set_stream(level_1_music)
	if id == 2:
		music.set_stream(level_2_music)
	if id == 3:
		music.set_stream(level_3_music)
	music.play()
	
func set_health(value):
	health = value
	if health < 1:
		if sfx_enabled:
			dead.play()
		reset()
		emit_signal("player_death")
		self.set_health(starting_health)
		get_tree().reload_current_scene()
	emit_signal("health_updated")

func set_gun(value):
	previous_gun = gun
	if "AK" in value:
		gun = "AK"
		bullet_damage = 12
		fire_rate = 0.1
		#speed og 6000
		bullet_speed = 60
	if "Shotgun" in value:
		gun = "Shotgun"
		bullet_damage = 26
		fire_rate = 0.75
		#speed og 5000
		bullet_speed = 50
	if "Sniper" in value:
		gun = "Sniper"
		bullet_damage = 65
		fire_rate = 1.0
		#speed og 7000
		bullet_speed = 70
	print(gun + " picked up")
	emit_signal("gun_picked_up")

func reduce_guns_in_range():
	guns_in_range -= 1

func increase_guns_in_range():
	guns_in_range += 1
