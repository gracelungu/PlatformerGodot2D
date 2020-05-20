extends Node2D

func _ready():
	$Player.connect("attack", $Pig, "_on_pig_hit")
	
