extends Node2D

export var music_id: int

func _ready():
	PlayerData.play_music(music_id)
