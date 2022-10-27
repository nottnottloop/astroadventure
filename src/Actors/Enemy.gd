extends Node2D
class_name Enemy

export var speed = 230
onready var hurt = $"/root/PlayerData/Hurt"
onready var sprite = $Body/Sprite
onready var body = $Body
onready var tween = $MoveTween
onready var waypoints_obj = $Waypoints

export var damage_interval = 0.1
export var health: int = 0
export var attack_damage: int = 10
export var invincible: bool = false

var doing_damage = false
var damage_timer = damage_interval

var label_pos

func _physics_process(delta):
	if body.get_parent().name == "Boss":
		print(speed)
		if health <= 1500:
			speed = 256
		if health <= 1000:
			speed = 276
		if health <= 500:
			speed = 296
		if health <= 250:
			speed = 358
		if health <= 150:
			speed = 460
		if health <= 80:
			speed = 614
	if doing_damage and damage_timer < 0:
		if PlayerData.sfx_enabled:
			hurt.play()
		PlayerData.set_health(PlayerData.health - attack_damage)
		damage_timer = damage_interval
	else:
		damage_timer -= delta

func _ready():
	update_enemy_health(0)
	
func update_enemy_health(damage: int):
	health -= damage

func _on_enemy_body_entered(body):
	if body.name == "Player":
		doing_damage = true
		PlayerData.set_ahh_boost_speed(0.0)

func _on_enemy_body_exited(body):
	if body.name == "Player":
		doing_damage = false
		damage_timer = damage_interval
		PlayerData.set_ahh_boost_speed(0.0)

func damage():
	health -= PlayerData.bullet_damage
	if health <= 0 and !invincible:
		if body.get_parent().name == "Boss":
			PlayerData.set_boss_defeated(true)
		queue_free()
		
func flip_sprite():
	sprite.set_flip_h(!sprite.flip_h)
