extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var explosionSound = $ExplosionSound

onready var timer = $Timer

signal explode(body)

func set_timer():
	timer.set_wait_time(.8)
	timer.start()

func _on_bomb_entered(body):
	if body.name == "Player" or body.name == "Pig":
		animatedSprite.play("Explosion")
		explosionSound.play()
		
		emit_signal("explode", body)
		set_timer()

func _on_Timer_timeout():
	queue_free()
