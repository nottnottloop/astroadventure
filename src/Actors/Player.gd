extends Actor

var AKBullet = preload("res://src/Objects/AK Bullet.tscn")
var ShotgunBullet = preload("res://src/Objects/Shotgun Bullet.tscn")
var SniperBullet = preload("res://src/Objects/Sniper Bullet.tscn")
var currentBullet

onready var AK = preload("res://src/Objects/AK.tscn")
onready var Shotgun = preload("res://src/Objects/Shotgun.tscn")
onready var Sniper = preload("res://src/Objects/Sniper.tscn")
onready var ak_shoot = preload("res://src/Sounds/SFX/AK Shoot.tscn")
onready var shotgun_shoot = preload("res://src/Sounds/SFX/Shotgun Shoot.tscn")
onready var sniper_shoot = preload("res://src/Sounds/SFX/Sniper Shoot.tscn")

onready var _collision_box = $CollisionShape2D3
onready var _animated_sprite = $AnimatedSprite
onready var _gun = $Gun
onready var _jumpcast = $JumpCast
onready var _platcast = $PlatCast
onready var _gun_eject_left = $GunEjectLeft
onready var _gun_eject_right = $GunEjectRight
onready var _gun_shoot_left = $GunShootLeft
onready var _gun_shoot_right = $GunShootRight

onready var jet = $Jet
onready var gun_pickup = $"Pickup Gun"


const HANG_TIME = 2
var _jump_timer = 0.0
var _gravity_enabled = true
var _boosting = false
var _boost_timer = 0
var _can_jump = false
var _time_since_last_shot = 100.0
var _time_since_start = 0.0

var _can_moonwalk = true

export var jump_forever_cheat = false
export var super_jump_cheat = false

#!!!!!!!!!!!!!!
#reference - Better Jumping in Unity With Four Lines of Code - https://www.youtube.com/watch?v=7KiK0Aqtmzc
const FALL_MULTIPLIER = 2.5;

func _ready():
	if super_jump_cheat:
		speed.y = 3000.0
		
	PlayerData.connect("gun_picked_up", self, "on_gun_pickup")
	PlayerData.connect("drug_time", self, "on_drug_time")

func _physics_process(_delta):
#	print(velocity)
#	print(_jump_timer)
#	print("Jump: " + str(_can_jump))
#	print("Moonwalk: " + str(_can_moonwalk))
#	print("Gravity: " + str(_gravity_enabled))
	_time_since_start += _delta
	_time_since_last_shot += _delta
	if _boosting:
		_boost_timer += _delta
		if _boost_timer >= 3:
			speed -= PlayerData.speed_boost
			_boost_timer = 0
			_boosting = false
	
	#time since start to prevent jumping after message
	if _jumpcast.is_colliding() and _time_since_start > 0.2 or jump_forever_cheat:
		_can_jump = true
		_can_moonwalk = true
	if _platcast.is_colliding():
		_can_moonwalk = false
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed)
	var result = move_and_slide(velocity, FLOOR_NORMAL)
	# i have to do this shit otherwise the player gets stuck on enemies...
	if result == Vector2(0.0, 0.0) and direction.x != 0.0:
		position.x += direction.x * 5
	velocity.y = result.y
	if Input.is_action_just_pressed("shoot"):
		shoot_gun()
#!!!!!!!!!!CREDIT YOUR SOURCES
# reference - Better Jumping in Unity With Four Lines of Code - https://www.youtube.com/watch?v=7KiK0Aqtmzc
	#going up
	if velocity.y < 0 and _jump_timer < HANG_TIME and not _can_jump or not _can_moonwalk and _jump_timer < HANG_TIME:
		#og fall_multiplier - 1
		velocity += Vector2.UP * (-gravity / 2.0) * _delta
		_jump_timer += _delta
	#going down
	if velocity.y >= 0 or _jump_timer > HANG_TIME:
		_jump_timer = 0
		_gravity_enabled = true
		velocity += Vector2.DOWN * gravity * (FALL_MULTIPLIER - 1) * _delta
	if !is_on_floor() and Input.is_action_pressed("jump"):
		_animated_sprite.play("jet")
	if direction.x == 1.0:
		if is_on_floor():
			_animated_sprite.play("walk")
		_animated_sprite.set_flip_h(false)
		_gun.set_flip_h(false)
		_gun.offset = Vector2(0, 0)
	elif direction.x == -1.0:
		if is_on_floor():
			_animated_sprite.play("walk")
		_animated_sprite.set_flip_h(true)
		_gun.set_flip_h(true)
		_gun.offset = Vector2(-325.0, 0)
	if is_on_floor() and direction.x == 0:
		_animated_sprite.play("stay")
	if is_on_floor():
		jet.stop()
		_jump_timer = 0.0

func eject_gun():
	if PlayerData.sfx_enabled:
		gun_pickup.play()
	_time_since_last_shot = 100
	var gun_to_eject
	if PlayerData.previous_gun == "":
		return
	elif PlayerData.previous_gun == "AK":
		gun_to_eject = AK
	elif PlayerData.previous_gun == "Shotgun":
		gun_to_eject = Shotgun
	elif PlayerData.previous_gun == "Sniper":
		gun_to_eject = Sniper
	var ejected_gun = gun_to_eject.instance()
	if !_animated_sprite.flip_h:
		ejected_gun.position = _gun_eject_left.global_position
	else:
		ejected_gun.position = _gun_eject_right.global_position
	get_node("/root/Level").add_child(ejected_gun)

func shoot_gun():
	if _time_since_last_shot < PlayerData.fire_rate or !PlayerData.gun:
		return
	_time_since_last_shot = 0
	var new_bullet = currentBullet.instance()
	get_node("/root/Level").add_child(new_bullet)
	if !_animated_sprite.flip_h:
		new_bullet.velocity = Vector2(PlayerData.bullet_speed, 0)
	else:
		new_bullet.velocity = Vector2(-PlayerData.bullet_speed, 0)
	if _animated_sprite.flip_h:
		new_bullet.global_position = _gun_shoot_left.global_position
		new_bullet.get_node("Sprite").set_flip_h(true)
	else:
		new_bullet.global_position = _gun_shoot_right.global_position
	var shoot
	if PlayerData.gun == "AK":
		shoot = ak_shoot.instance()
		new_bullet.global_position += Vector2(0, -9)
	elif PlayerData.gun == "Shotgun":
		shoot = shotgun_shoot.instance()
		new_bullet.global_position += Vector2(0, -4)
	else:
		shoot = sniper_shoot.instance()
	if PlayerData.sfx_enabled:
		get_node("/root/Level").add_child(shoot)
	
func on_gun_pickup():
	
	eject_gun()
	if PlayerData.gun == "AK":
		_gun.texture = load("res://Assets/2DWeaponPack/Sprites/AK-47/ak-47.png")
		currentBullet = AKBullet
	elif PlayerData.gun == "Shotgun":
		_gun.texture = load("res://Assets/2DWeaponPack/Sprites/Sawed_off/sawed_off.png")
		currentBullet = ShotgunBullet
	elif PlayerData.gun == "Sniper":
		_gun.texture = load("res://Assets/2DWeaponPack/Sprites/PSL/psl.png")
		currentBullet = SniperBullet
	
		
func on_drug_time():
	_boosting = true
	speed += PlayerData.speed_boost
	
func get_direction() -> Vector2:
	var jump_dir = 0.0
	if Input.is_action_pressed("jump") and _can_jump or velocity.y < 0 and _can_moonwalk:
		jump_dir = -1.0
		if Input.is_action_pressed("jump"):
			if PlayerData.sfx_enabled:
				jet.play()
			_can_jump = false
			_can_moonwalk = false
		else:
			_can_moonwalk = false
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		jump_dir
	)
	
func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = ((speed.x + PlayerData.ahh_boost_speed) * direction.x)
	if direction.y == -1.0 and _jump_timer < HANG_TIME:
		new_velocity.y = calculate_jump_velocity()
		_gravity_enabled = false
	if _gravity_enabled:
		new_velocity.y += gravity * get_physics_process_delta_time()
	return new_velocity

func calculate_jump_velocity():
	return (speed.y * 0.75) * -1.0

#otherwise the enemy sticks to the player?
func _on_EnemyCollider_body_entered(body):
	if body.name == "EnemyBody":
		#print("asssssssss")
		if get_direction().x == 0.0:
			return
		if get_direction().x == 1.0:
			self.position.x += 3.0
		if get_direction().x == -1.0:
			self.position.x += -3.0
