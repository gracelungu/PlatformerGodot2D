extends Node2D

func _ready():
	$Player.connect("attack", $Pig, "_on_pig_hit")
	
	$Bomb.connect("explode", $Player, "_on_entered_bomb")	
	$Bomb.connect("explode", $Pig, "_on_entered_bomb")
	
	$Door.connect("leave_scene", $Player, "_on_leave_scene")	
