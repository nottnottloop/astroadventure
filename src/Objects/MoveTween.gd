extends Tween

onready var body = $".."
onready var tween = $"."
onready var waypoints_obj = $"../Waypoints"
var waypoints = []
var waypoints_duration = []

func _ready():
	waypoints = waypoints_obj.get_children()
	for i in len(waypoints):
		var next = i + 1
		if next == len(waypoints):
			next = 0
		var duration = (waypoints[next].position - waypoints[i].position).length() / float(body.speed)
		waypoints_duration.push_back(duration)
		
	for i in len(waypoints):
		var arr = waypoints_duration.slice(0, i)
		print(arr)
		var sum = 0
		for j in arr:
			sum += j
		var next = i + 1
		if next == len(waypoints):
			next = 0
		tween.interpolate_property(body, "position", waypoints[i].global_position, waypoints[next].global_position, waypoints_duration[i], Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, sum - waypoints_duration[i])
	tween.start()
#func _physics_process(delta):
#	print(body.global_position)
