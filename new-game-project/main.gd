extends Node
@export var mob_scene: PackedScene
var score

func _ready() -> void:
	new_game()

func _process(delta: float) -> void:
	print(score)


func _on_player_hit() -> void:
	game_over()
func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$hud.show_game_over()
	$Music.stop()
	$DeathSound.play()
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$hud.update_score(score)
	$hud.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	# Add some randomness to the direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score +=1
	$hud.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()