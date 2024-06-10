extends Node2D

# Exported variable to set the bullet scene from the editor
@export var bullet_scene : PackedScene

# Function to handle player shooting
func _on_player_shoot(pos, dir):
	# Instantiate a bullet from the bullet scene
	var bullet = bullet_scene.instantiate()
	
	# Add the bullet to the current node as a child
	add_child(bullet)
	
	# Set the bullet's position to the given position
	bullet.position = pos
	
	# Set the bullet's direction to the normalized given direction
	bullet.direction = dir.normalized()
	
	# Add the bullet to the 'bullets' group
	bullet.add_to_group("bullets")
