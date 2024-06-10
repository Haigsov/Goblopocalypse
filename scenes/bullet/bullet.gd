extends Area2D

# Speed of the entity
var speed : int = 500

# Direction of movement as a 2D vector
var direction : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the position based on speed, direction, and time elapsed
	position += speed * direction * delta

# Called when the despawn timer times out
func _on_despawn_timer_timeout():
	# Free the node from the scene tree
	queue_free()

# Called when another body enters this Area2D
func _on_body_entered(body):
	# Check if the body that entered is named "World"
	if body.name == "World":
		# Free the node from the scene tree
		queue_free()
	else:
		# Check if the body has an 'alive' property and it is true
		if body.alive:
			# Call the 'die' method on the body to handle its destruction
			body.die()
			# Free the node from the scene tree
			queue_free()
