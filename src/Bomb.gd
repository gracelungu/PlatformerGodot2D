extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var explosionSound = $ExplosionSound

onready var timer = $Timer

signal explode(body)
signal player_can_hit_bomb(body)

func set_timer():
	timer.set_wait_time(.8)
	timer.start()

func _on_bomb_entered(body):
	if body.name == "Player" or body.name == "Pig":
		animatedSprite.play("Explosion")
		explosionSound.play()
		
		emit_signal("explode", body)
		set_timer()
		
func _on_player_hit_detector_entered(body):
	if body.name == "Player":
		emit_signal("player_can_hit_bomb", self)

func _on_player_can_hit_bomb_exited(body):
	if body.name == "Player":
		emit_signal("player_can_hit_bomb", self)
		
func _on_bomb_was_hit(bomb_name):
	if bomb_name == self.name:
		print("REceived")
		animatedSprite.play("Explosion")
		explosionSound.play()
		set_timer()
	
func _on_Timer_timeout():
	queue_free()

