extends CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start emitting particles when the node is ready
	emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# If the particles are not emitting, free the node from the scene tree
	if !emitting:
		queue_free()
