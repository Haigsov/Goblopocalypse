extends CharacterBody2D

# checks whether Goblin has entered
var entered : bool
# goblin speed of movement
var speed : int = 100
# keeps track of goblin's direction
var direction : Vector2

func _ready():
	# shows game window's screen size
	var screen_size := get_viewport_rect()
	# specifies that goblin still hasn't entered the visible game window
	entered = false
	# sees the (x,y) difference between centre of screen and where goblin is
	var distance = screen_size.get_center() - position
	if abs(distance.x) > abs(distance.y):
		direction.x = distance.x
		direction.y = 0
	else:
		direction.x = 0
		direction.y = distance.y
		
func _physics_process(_delta):
	direction = direction.normalized()
	velocity = speed * direction
	move_and_slide()
	