extends CharacterBody2D

# Get references to main node and player node in the scene tree
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

# Preload the explosion and item scenes for instantiation
var explosion_scene = preload("res://scenes/explosion/explosion.tscn")
var item_scene = preload("res://scenes/item/item.tscn")

# Define a signal to emit when the player is hit
signal hit_player

# Variables to check whether Goblin has entered and is alive
var entered : bool
var alive : bool

# Goblin speed of movement
var speed : int = 100

# Keeps track of Goblin's direction
var direction : Vector2

# Probability for item drop
const DROP_CHANCE : float = 0.15

# Determines whether a Goblin is a special kind
var special_goblin_chance : float

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the game window's screen size
	var screen_size := get_viewport_rect()
	
	# Initialize state variables
	entered = false
	alive = true
	special_goblin_chance = randf()
	
	# Calculate the distance from the center of the screen to the Goblin's position
	var distance = screen_size.get_center() - position
	
	# Determine initial direction based on distance
	if abs(distance.x) > abs(distance.y):
		direction.x = distance.x
		direction.y = 0
	else:
		direction.x = 0
		direction.y = distance.y

# Called every physics frame. '_delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if alive:
		# Set the animation to "run"
		$AnimatedSprite2D.animation = "run"
		
		# Check if Goblin has entered the arena
		if entered:
			# Update direction towards the player
			direction = player.position - position
		
		# Normalize the direction
		direction = direction.normalized()
		
		# Increase speed if Goblin is special
		if special_goblin_chance <= 0.2:
			speed = 300
		
		# Set velocity based on speed and direction
		velocity = speed * direction
		
		# Move and slide the Goblin
		move_and_slide()
		
		# Flip the sprite based on movement direction
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0

# Function to handle Goblin's death
func die():
	alive = false
	
	# Stop animation and set to "dead"
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	
	# Disable collision shape
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
	# Check for item drop
	if randf() <= DROP_CHANCE:
		drop_item()
	
	# Instantiate and add explosion to the scene
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	main.add_child(explosion)
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS

# Function to drop an item
func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 2)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

# Called when the timer times out
func _on_timer_timeout():
	entered = true

# Called when another body enters this Area2D
func _on_area_2d_body_entered(_body):
	hit_player.emit()
