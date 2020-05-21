extends Node2D

func _ready():
	$Player.connect("attack", $Pig, "_on_pig_hit")
	
	if $Bombs:
		for bomb in $Bombs.get_children():
			bomb.connect("explode", $Player, "_on_entered_bomb")
			
	if $Pigs:
		for bomb in $Bombs.get_children():
			for pig in $Pigs.get_children():
				bomb.connect("explode", pig, "_on_entered_bomb")
	
	$Door.connect("leave_scene", $Player, "_on_leave_scene")	
