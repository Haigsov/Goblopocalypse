extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var item_scene = preload("res://scenes/item/item.tscn")

signal hit_player

# checks whether Goblin has entered
var entered : bool
var alive: bool
# goblin speed of movement
var speed : int = 100
# keeps track of goblin's direction
var direction : Vector2

func _ready():
	# shows game window's screen size
	var screen_size := get_viewport_rect()
	# specifies that goblin still hasn't entered the visible game window
	entered = false
	alive = true
	# sees the (x,y) difference between centre of screen and where goblin is
	var distance = screen_size.get_center() - position
	# checks if it need to move horizontally or vertically
	if abs(distance.x) > abs(distance.y):
		direction.x = distance.x
		direction.y = 0
	else:
		direction.x = 0
		direction.y = distance.y
		
func _physics_process(_delta):
	if alive:
		$AnimatedSprite2D.animation = "run"
		# checks whether goblin has entered the arena or not
		if entered:
			# sets direction where player currently
			direction = player.position - position
		# makes sure it normalizes the speed
		direction = direction.normalized()
		velocity = speed * direction
		move_and_slide()
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	

func die():
	alive = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	drop_item()



func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func _on_timer_timeout():
	entered = true


func _on_area_2d_body_entered(_body):
	hit_player.emit()
