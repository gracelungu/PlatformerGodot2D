extends AnimatedSprite

export var is_leave_door : bool

onready var door = $"."
onready var timer = $Timer

signal leave_scene(body)

func _ready():
	timer.set_wait_time(2.3)
	
	if !is_leave_door:
		door.play("Opening")
		timer.start()

func _on_door_entered(body):
	if is_leave_door:
		timer.start()
		door.play("Opening")
		emit_signal("leave_scene", body)

func _on_Timer_timeout():
	door.play("Closing")
