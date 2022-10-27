extends StaticBody2D

func _ready():
	PlayerData.connect("boss_defeated", self, "delete")

func delete():
	var tilemap = get_node("/root/Level/TileMap")
	tilemap.set_cell(215, 1, -1)
	tilemap.set_cell(216, 1, -1)
	tilemap.set_cell(216, 0, -1)
	tilemap.set_cell(217, 0, -1)
	queue_free()
