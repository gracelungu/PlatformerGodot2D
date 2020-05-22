extends Actor

const helper = preload("res://src/Helper.gd")

onready var pig = $Pig
onready var animatedSprite = $AnimatedSprite
onready var attackSound = $AttackSound

const SPEED = 3500
const FRICTION = 0.02
const ACCELERATION = 2000

var count = 0
var motion = Vector2.ZERO
var direction = -1
var in_body = false
var player_hit = false

func apply_gravity(delta):
	motion.y += GRAVITY * delta
	
func is_on_wall():
	if is_on_wall():
		motion.x *= -1
		direction *= -1
	
func flip_on_direction_change():
	if direction > 0:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false

func handle_body_entered_or_exited(body):
	var body_direction = body.position.x > get_position().x
	
	if body.name == "Player":
		animatedSprite.play("Run")
		
		if body_direction:
			direction = 1
			motion.x = ACCELERATION * get_physics_process_delta_time()
		else:
			direction = -1
			motion.x = -(ACCELERATION * get_physics_process_delta_time())
	
func _on_body_entered(body):
	in_body = true
	handle_body_entered_or_exited(body)

func _on_body_exited(body):
	if body.name == "Player":
		motion.x = 0
		in_body = false
		player_hit = false

func _on_hit_detector_entered(body):
	if body.name == "Player":
		player_hit = true
		animatedSprite.play("Attack")
		attackSound.play()

func _on_hit_detector_exited(body):
	if body.name == "Player":
		player_hit = false
	
func handle_idle():
	if not in_body and not player_hit:
		animatedSprite.play("Idle")
		
func eliminate_current_pig(body):
	if helper.is_pig(body.name):
		body.queue_free()

func _on_pig_hit(body):
	eliminate_current_pig(body)

func _on_entered_bomb(body):
	eliminate_current_pig(body)

func _physics_process(delta): 
	move_and_slide(motion)
	apply_gravity(delta)
	handle_idle()
	flip_on_direction_change()

