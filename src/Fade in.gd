extends ColorRect

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("fade_in")
