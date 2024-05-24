extends CharacterBody2D


@export var speed:int = 400
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	var position = screen_size / 2
	
	

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction.normalized() * speed

#func _input(event):
   ## Mouse in viewport coordinates.
	#if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
#
   ## Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)

func _physics_process(delta):
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
