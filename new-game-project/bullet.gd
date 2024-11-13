extends Area2D
var screen_size
var speed = 800

# Called when the node enters the scene tree for the first tim

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
