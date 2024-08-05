extends Area2D

const SPEED: float = 100.0
var direction: int = -1
var virage: bool = false


func _process(delta) -> void:
	$AnimatedSprite2D.position.x += direction * SPEED * delta
	$CollisionShape2D.position.x += direction * SPEED * delta
	if abs($AnimatedSprite2D.position.x) > 300 and not virage:
		direction *= -1
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
		virage = true
		$TimerVirage.start()


func _on_body_entered(body: PhysicsBody2D) -> void:
	if "touche" in body:
		body.touche(1)


func _on_timer_virage_timeout() -> void:
	virage = false
