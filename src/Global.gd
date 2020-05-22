extends Node2D

func _ready():
	if $Pigs:
		for pig in $Pigs.get_children():
			$Player.connect("attack", pig, "_on_pig_hit")
	
	if $Bombs:
		for bomb in $Bombs.get_children():
			bomb.connect("explode", $Player, "_on_entered_bomb")
			bomb.connect("player_can_hit_bomb", $Player, "_on_player_can_hit_bomb")
			$Player.connect("bomb_was_hit", bomb, "_on_bomb_was_hit")
			
	if $Pigs:
		for bomb in $Bombs.get_children():
			for pig in $Pigs.get_children():
				bomb.connect("explode", pig, "_on_entered_bomb")
	
	if $Door:
		$Door.connect("leave_scene", $Player, "_on_leave_scene")	
