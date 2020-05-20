extends Node2D

func _ready():
	$Player.connect("attack", $Pig, "_on_pig_hit")
	$Bomb.connect("explode", $Player, "_on_entered_bomb")	
	$Bomb.connect("explode", $Pig, "_on_entered_bomb")	
