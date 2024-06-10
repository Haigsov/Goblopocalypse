extends Node2D

var max_enemies : int
var difficulty : float
var lives : int
var wave : int

const DIFF_MULTIPLIER : float = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$GameOver/Button.pressed.connect(new_game)

func new_game():
	lives = 3
	wave = 1
	difficulty = 10.0
	$EnemySpawner/Timer.wait_time = 1.0
	reset()

func reset():
	max_enemies = int(difficulty)
	$Player.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("items", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	$HUD/LivesLabel.text = "X " + str(lives)
	$HUD/EnemiesLabel.text = "X " + str(max_enemies)
	$HUD/WavesLabel.text = "Wave: " + str(wave)
	$GameOver.hide()
	get_tree().paused = true
	$RestartTimer.start()


func _process(_delta):
	if is_wave_completed():
		wave += 1
		#adjust difficulty
		if $EnemySpawner/Timer.wait_time > 0.25:
			$EnemySpawner/Timer.wait_time -= 0.05
		difficulty *= DIFF_MULTIPLIER
		get_tree().paused = true
		$WaveOverTimer.start()

func _on_enemy_spawner_hit_p():
	print("hit player")
	lives -= 1
	$HUD/LivesLabel.text = "X " + str(lives)
	get_tree().paused = true
	if lives <= 0:
		$GameOver/WavesSurvivedLabel.text = "WAVES SURVIVED: " + str(wave - 1)
		$GameOver.show()
	else:
		$WaveOverTimer.start()

func _on_wave_over_timer_timeout():
	reset()

func _on_restart_timer_timeout():
	get_tree().paused = false

func is_wave_completed():
	var all_dead = true
	var enemies = get_tree().get_nodes_in_group("enemies")
	# check if all enemies have spawned first
	if enemies.size() == max_enemies:
		for e in enemies:
			if e.alive:
				all_dead = false
				return all_dead
		return all_dead
	else:
		return false

