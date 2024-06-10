extends CharacterBody2D

# Signal emitted when the player shoots
signal shoot

# Constants for player movement and shooting
const START_SPEED : int = 200
const BOOST_SPEED : int = 300
const NORMAL_SHOT : float = 0.5
const FAST_SHOT : float = 0.1

# Variables for player state
var speed : int
var can_shoot : bool
var screen_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the screen size
	screen_size = get_viewport_rect().size
	# Initialize player state
	reset()

# Function to reset the player's state
func reset():
	# Set player position to the center of the screen
	position = screen_size / 2
	# Set player speed to the start speed
	speed = START_SPEED
	# Set shot timer wait time to normal shot speed
	$ShotTimer.wait_time = NORMAL_SHOT
	# Allow the player to shoot
	can_shoot = true

# Function to handle player input
func get_input():
	# Get input direction based on arrow keys or WASD keys
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Calculate velocity based on input direction and speed
	velocity = input_direction.normalized() * speed
	
	# Check if the left mouse button is pressed and the player can shoot
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		# Calculate direction from player to mouse position
		var direction = get_global_mouse_position() - position
		# Emit the shoot signal with position and direction
		shoot.emit(position, direction)
		# Prevent the player from shooting again immediately
		can_shoot = false
		# Start the shot timer
		$ShotTimer.start()

# Called every physics frame. '_delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Handle player input
	get_input()
	# Move the player based on velocity
	move_and_slide()
	
	# Limit the player movement to the screen boundaries
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Player rotation based on mouse position
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	# Player animation based on movement
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1

# Function to boost the player's speed
func boost():
	$BoostTimer.start()
	speed = BOOST_SPEED

# Function to enable quick firing
func quick_fire():
	$QuickFireTimer.start()
	$ShotTimer.wait_time = FAST_SHOT

# Function called when the shot timer times out
func _on_shot_timer_timeout():
	# Allow the player to shoot again
	can_shoot = true

# Function called when the boost timer times out
func _on_boost_timer_timeout():
	# Reset the player's speed to the start speed
	speed = START_SPEED

# Function called when the quick fire timer times out
func _on_quick_fire_timer_timeout():
	# Reset the shot timer wait time to normal shot speed
	$ShotTimer.wait_time = NORMAL_SHOT
