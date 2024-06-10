extends Node2D

# Variables to track the game's state
var max_enemies : int
var difficulty : float
var lives : int
var wave : int

# Constant to define the difficulty multiplier
const DIFF_MULTIPLIER : float = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start a new game
	new_game()
	# Connect the Game Over button to the new_game function
	$GameOver/Button.pressed.connect(new_game)

# Function to start a new game
func new_game():
	# Initialize game state variables
	lives = 3
	wave = 1
	difficulty = 10.0
	$EnemySpawner/Timer.wait_time = 1.0
	# Reset the game
	reset()

# Function to reset the game state
func reset():
	# Set the maximum number of enemies based on the difficulty
	max_enemies = int(difficulty)
	# Reset the player
	$Player.reset()
	# Remove all enemies, items, and bullets from the scene
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("items", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	# Update the HUD with the current game state
	$HUD/LivesLabel.text = "X " + str(lives)
	$HUD/EnemiesLabel.text = "X " + str(max_enemies)
	$HUD/WavesLabel.text = "Wave: " + str(wave)
	# Hide the Game Over screen
	$GameOver.hide()
	# Pause the game and start the restart timer
	get_tree().paused = true
	$RestartTimer.start()

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if the current wave is completed
	if is_wave_completed():
		# Move to the next wave
		wave += 1
		# Adjust the difficulty and spawn rate
		if $EnemySpawner/Timer.wait_time > 0.25:
			$EnemySpawner/Timer.wait_time -= 0.05
		difficulty *= DIFF_MULTIPLIER
		# Pause the game and start the wave over timer
		get_tree().paused = true
		$WaveOverTimer.start()

# Function called when the enemy spawner emits the hit_p signal (player hit by enemy)
func _on_enemy_spawner_hit_p():
	print("hit player")
	# Decrease the number of lives and update the HUD
	lives -= 1
	$HUD/LivesLabel.text = "X " + str(lives)
	# Pause the game
	get_tree().paused = true
	# Check if the player has run out of lives
	if lives <= 0:
		# Show the Game Over screen
		$GameOver/WavesSurvivedLabel.text = "WAVES SURVIVED: " + str(wave - 1)
		$GameOver.show()
	else:
		# Start the wave over timer
		$WaveOverTimer.start()

# Function called when the wave over timer times out
func _on_wave_over_timer_timeout():
	# Reset the game state for the next wave
	reset()

# Function called when the restart timer times out
func _on_restart_timer_timeout():
	# Resume the game
	get_tree().paused = false

# Function to check if the current wave is completed
func is_wave_completed():
	var all_dead = true
	# Get a list of all enemies in the scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	# Check if all enemies have spawned
	if enemies.size() == max_enemies:
		# Check if any enemies are still alive
		for e in enemies:
			if e.alive:
				all_dead = false
				return all_dead
		return all_dead
	else:
		return false
