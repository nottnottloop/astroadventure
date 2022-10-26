extends Node2D
class_name Enemy

export var speed = 230
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
	if doing_damage and damage_timer < 0:
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

func _on_enemy_body_exited(body):
	if body.name == "Player":
		doing_damage = false
		damage_timer = damage_interval

func damage():
	health -= PlayerData.bullet_damage
	if health <= 0 and !invincible:
		queue_free()
		
func flip_sprite():
	sprite.set_flip_h(!sprite.flip_h)
