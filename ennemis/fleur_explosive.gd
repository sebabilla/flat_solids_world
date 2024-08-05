extends RigidBody2D

var joueur: CharacterBody2D = null


func _ready() -> void:
	ressusciter()


func _on_detection_joueur_body_entered(body: PhysicsBody2D) -> void:
	joueur = body
	$AnimationPlayer.play("compte_a_rebours")
	
	
func degats() -> void:
	var distance: float = global_position.distance_to(joueur.global_position)
	if distance < 128:
		joueur.touche(1)
		
		
func mort() -> void:
	visible = false
	$DetectionJoueur/CollisionShape2D.set_deferred("disabled", true)

func ressusciter() -> void:
	visible = true
	$DetectionJoueur/CollisionShape2D.set_deferred("disabled", false)
	$AntiprismeFleur.frame = 0
	$AntiprismeFleur.scale = Vector2(1, 1)
