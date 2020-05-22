extends Control
const sauvegard = preload("res://src/Save.gd")

func _ready():
	$"Menu/CenterRow/Buttons/Menu Button".connect("pressed", self, "_on_start_pressed")
	$"Menu/CenterRow/Buttons/Continue Button".connect("pressed", self, "_on_continue_pressed")

func _on_start_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")


func _on_continue_pressed():
	var data = sauvegard.load()
	if data:
		if data.level:
			get_tree().change_scene("res://Scenes/Levels/Level"+str(data.level)+".tscn")
		else:
			get_tree().change_scene("res://Scenes/Levels/Level1.tscn")
	else:
		get_tree().change_scene("res://Scenes/Levels/Level1.tscn")
