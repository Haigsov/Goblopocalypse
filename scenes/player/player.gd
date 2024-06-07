extends CharacterBody2D


signal shoot

const START_SPEED : int = 200
const BOOST_SPEED : int = 300
var speed : int
var can_shoot:bool
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	speed = START_SPEED
	can_shoot = true

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction.normalized() * speed
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var direction = get_global_mouse_position() - position
		shoot.emit(position, direction)
		can_shoot = false
		$ShotTimer.start()

func _physics_process(_delta):
	get_input()
	move_and_slide()
	#print(velocity)
	
	# Limit the player movement to the window
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Player rotation
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	# Player Animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1

func boost():
	$BoostTimer.stop()
	speed = BOOST_SPEED

func _on_shot_timer_timeout():
	can_shoot = true


func _on_boost_timer_timeout():
	speed = START_SPEED
