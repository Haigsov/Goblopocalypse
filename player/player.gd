extends CharacterBody2D


@export var MAX_SPEED = 400
@export var ACCELERATION = 1000
@export var FRICTION = 800

var input = Vector2.ZERO

func _physics_process(delta):
	player_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input.normalized()


func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(input * ACCELERATION * delta)
	move_and_slide()
	

func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)

func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
