extends CharacterBody2D


const SPEED: float = 50
var direction: float = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta) -> void:
	var collision: bool = is_on_wall()
	if collision:
		direction *= -1
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
		$Tete/CollisionShape2D.position.x *= -1
		$Carapace/CollisionShape2D.position.x *= -1
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED
	
	move_and_slide()
	

func _on_tete_body_entered(body: PhysicsBody2D) -> void:
	if "touche" in body:
		body.touche(1)
		$TimerIntouchable.start()
		intouchable()
		modulate.a = 0.5


func _on_carapace_body_entered(body: PhysicsBody2D) -> void:
	if "touche" in body:
		mort()
		$TimerIntouchable.stop()


func mort() -> void:
	$AudioStreamPlayer.play()
	intouchable()
	var tween: Tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "rotation", PI, 0.3)
	await tween.finished
	visible = false
	$AnimatedSprite2D.rotation = 0
	
	
	
func intouchable() -> void:
	$Tete/CollisionShape2D.set_deferred("disabled", true)
	$Carapace/CollisionShape2D.set_deferred("disabled", true)


func ressusciter() -> void:
	visible = true
	touchable()
	
	
func touchable() -> void:
	$Tete/CollisionShape2D.set_deferred("disabled", false)
	$Carapace/CollisionShape2D.set_deferred("disabled", false)
	
	
func _on_timer_intouchable_timeout() -> void:
	touchable()
	modulate.a = 1
