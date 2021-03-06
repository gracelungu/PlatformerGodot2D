extends Control
const sauvegard = preload("res://src/Save.gd")

func _ready():
	$"Menu/CenterRow/Buttons/Menu Button".connect("pressed", self, "_on_start_pressed")
	$"Menu/CenterRow/Buttons/Continue Button".connect("pressed", self, "_on_continue_pressed")

func _on_start_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")


func _on_continue_pressed():
	var data = sauvegard.load()
	print(data)
	if data:
		if data.level:
			if data.level > 8:
				return get_tree().change_scene("res://Scenes/Levels/Level1.tscn")
			get_tree().change_scene("res://Scenes/Levels/Level"+str(data.level)+".tscn")
		else:
			get_tree().change_scene("res://Scenes/Levels/Level1.tscn")
	else:
		get_tree().change_scene("res://Scenes/Levels/Level1.tscn")

#if last level
	var level = data.level - 1;
	get_tree().change_scene("res://Scenes/Levels/Level"+str(level)+".tscn")
