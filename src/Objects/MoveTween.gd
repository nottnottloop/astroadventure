extends Tween

onready var body = $".."
onready var sprite = $"../Body/Sprite"
onready var tween = $"."
onready var waypoints_obj = $"../Waypoints"
var waypoints = []
var waypoints_duration = []

var old_pos: Vector2
var new_pos: Vector2

var old_speed = 0

func _ready():
	waypoints = waypoints_obj.get_children()
#	tween.remove_all()
#	refresh_waypoints()

func refresh_waypoints():
	if "Boss" in body.name:
		body.position = get_node("/root/Level/BossSpawn").position
	for i in len(waypoints):
		var next = i + 1
		if next == len(waypoints):
			next = 0
		var duration = (waypoints[next].position - waypoints[i].position).length() / float(body.speed)
		waypoints_duration.push_back(duration)
		
	for i in len(waypoints):
		var arr = waypoints_duration.slice(0, i)
		var sum = 0
		for j in arr:
			sum += j
		var next = i + 1
		if next == len(waypoints):
			next = 0
		tween.interpolate_property(body, "position", waypoints[i].global_position, waypoints[next].global_position, waypoints_duration[i], Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, sum - waypoints_duration[i])
#		if (waypoints[next].position.x - waypoints[i].position.x) < 0:
#			tween.interpolate_property(sprite, "flip_h", !sprite.flip_h, !sprite.flip_h, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, sum - waypoints_duration[i])
	tween.start()
	
func _physics_process(delta):
	if body.speed != old_speed:
		tween.remove_all()
		refresh_waypoints()
	old_speed = body.speed
	if "Skull Red" in body.name or "Spike Ball" in body.name:
		return
	new_pos = body.global_position
	var flip = false
	if body.name == "White Scorpion4" or body.name == "White Scorpion5":
		flip = !flip
	if new_pos.x - old_pos.x < 0:
		sprite.set_flip_h(flip)
	else:
		sprite.set_flip_h(!flip)
	old_pos = new_pos
