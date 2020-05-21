extends Actor

const ACCELERATION = 512
const MAX_SPEED = 90
const FRICTION = 0.25
const AIR_RESISTANCE = 0.01
const JUMP_FORCE = 370

var motion = Vector2.ZERO
var x_input = 0
var attackTimer = 0
var dead = false
var attack_ready = false
var body_to_hit
var go = false
var leaving = false

var shake = false
var current_level = 1

onready var animatedSprite = $AnimatedSprite
onready var launchTimer = $LaunchTimer
onready var leaveTimer = $LeaveTimer
onready var deafTimer = $DeafTimer
onready var attackSound = $Sounds/AttackSound
onready var jumpSound = $Sounds/JumpSound
onready var runSound = $Sounds/RunSound
onready var tween = $Camera2D/Tween
onready var animationPlayer = $AnimationPlayer

signal attack(body)

func _ready():
	launchTimer.set_wait_time(1.2);
	launchTimer.start()
	animatedSprite.play("Door Out")

func shake_camera():
	animationPlayer.play("shake_camera")

func apply_gravity(delta):
	motion.y += GRAVITY * delta
	
func can_move():
	if go and not leaving:
		return true
	return false
	
func play_run_sound():
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			runSound.play()

func move_right_and_left(delta):
	x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if can_move() and x_input != 0 and attackTimer == 0 and not dead:
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
			jumpSound.play()
			
	else: # In the air
		if Input.is_action_just_released("jump") and motion.y < -JUMP_FORCE / 2:
			motion.y = - JUMP_FORCE / 2
			animatedSprite.play("Jump")
			
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
			
func handle_idle():
	if is_on_floor():
		if can_move() and x_input == 0 and attackTimer == 0 and not dead:
			animatedSprite.play("Idle")
			
func handle_attack():
	if can_move() and Input.is_action_just_pressed("attack") and not dead:
		attackTimer = 16
		animatedSprite.play("Attack")
		attackSound.play()
		shake_camera()
		
	if attackTimer > 0:
		attackTimer -= 1
			
func apply_motion():
	motion = move_and_slide(motion, Vector2.UP)
	
func set_deaf_timer(time):
	dead = true
	animatedSprite.play("Dead")
	shake_camera()
	
	deafTimer.set_wait_time(time)
	deafTimer.start()
	
func _on_pig_detector_entered(body):
	if body.name == "Pig":
		set_deaf_timer(2)
	
func _on_EnemyHit_detector_entered(body):
	if body.name == "Pig":
		attack_ready = true
		body_to_hit = body
		
func _on_EnemyHit_detector_exited(body):
	attack_ready = false

func handle_hit_enemy():
	if attack_ready and Input.is_action_just_pressed("attack"):
		emit_signal("attack", body_to_hit)	
		shake_camera()

func _on_entered_bomb(body):
	if body.name == "Player":
		set_deaf_timer(2)
		
func _on_deafTimer_timeout():
	get_tree().reload_current_scene()
	
func _on_leave_scene(body):
	print("LEAVE ", body.name)
	if body.name == "Player":
		leaving = true
		leaveTimer.set_wait_time(1.2);
		leaveTimer.start()
	
		animatedSprite.play("Door In")
	
func _physics_process(delta):
	apply_gravity(delta)
	move_right_and_left(delta)
	play_run_sound()
	handle_idle()
	handle_jump()
	handle_attack()
	handle_hit_enemy()
	
	apply_motion()


func _on_launch_timer_timeout():
	go = true

func _on_LeaveTimer_timeout():
	current_level +=1
	get_tree().change_scene("res://Scenes/Levels/Level"+str(current_level)+".tscn")
