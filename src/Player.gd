extends Actor

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AIR_RESISTANCE = 0.01
const JUMP_FORCE = 350

var motion = Vector2.ZERO
var x_input = 0
var attackTimer = 0

onready var animatedSprite = $AnimatedSprite


func apply_gravity(delta):
	motion.y += GRAVITY * delta

func move_right_and_left(delta):
	x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		animatedSprite.flip_h = x_input < 0
		
		animatedSprite.play("Run")
		
		
func handle_jump():
	if is_on_floor():  # Apply friction
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)	
			
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMP_FORCE
			
	else: # In the air
		if Input.is_action_just_released("jump") and motion.y < -JUMP_FORCE / 2:
			motion.y = - JUMP_FORCE / 2
			animatedSprite.play("Jump")
			
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
			
func handle_idle():
	if is_on_floor():
		if x_input == 0 and attackTimer == 0:
			animatedSprite.play("Idle")
			
func handle_attack():
	if Input.is_action_just_pressed("attack"):
		attackTimer = 16
		animatedSprite.play("Attack")
	if attackTimer > 0:
		attackTimer -= 1
			
func apply_motion():
	motion = move_and_slide(motion, Vector2.UP)

func _physics_process(delta):
	apply_gravity(delta)
	move_right_and_left(delta)
	handle_idle()
	handle_jump()
	handle_attack()
	
	apply_motion()
	
	
