extends Node2D

onready var backgroundMusic = $BackgroundMusic

func _ready():
	backgroundMusic.play()


func _on_BackgroundMusic_finished():
	backgroundMusic.play()
