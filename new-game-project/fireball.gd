extends Area2D
var screen_size
var speed = 2000

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
