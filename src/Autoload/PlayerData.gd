extends Node

signal health_updated
signal player_death
signal gun_picked_up

export var health: int = 100 setget set_health
export var gun = "" setget set_gun
var previous_gun = ""
var guns_in_range = 0
var bullet_damage = 0
var fire_rate = 0.0
var bullet_speed = 0

func reset():
	previous_gun = ""
	gun = ""
	guns_in_range = 0
	
func set_health(value):
	health = value
	if health < 1:
		emit_signal("player_death")
		self.set_health(100)
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
