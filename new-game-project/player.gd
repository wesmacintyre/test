extends Area2D
signal hit
@export var speed = 500 # how fast the player moves, which is pixels/sec
@export var Bullet : PackedScene
@export var Fireball: PackedScene

var screen_size  # size of the game window
var facing_direction = Vector2.UP 

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

		
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed("shoot_fireball"):
		shoot_fireball()
		
	if velocity.length() > 0:
		facing_direction = velocity.normalized()
		velocity = velocity.normalized() * speed
		$BulletSpawn.rotation = facing_direction.angle()
		$FireballSpawn.rotation = facing_direction.angle()
		$AnimatedSprite2D.play() # The $ is shortahnd for the function get_node()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0	
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	# Reset the player's position when starting a new game. 
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func shoot():
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.transform = $BulletSpawn.global_transform

func shoot_fireball():
	var f = Fireball.instantiate()
	owner.add_child(f)
	f.transform = $FireballSpawn.global_transform
