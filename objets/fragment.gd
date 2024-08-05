extends Area2D

var couleur: Color = Color(1, 1, 1)
var speed: int = randi_range(1, 3)


func _process(delta) -> void:
	rotation += speed * delta


func attribuer_couleur(c: Color) -> void:
	couleur = c
	$TriangleBlanc.modulate = couleur
	activer()


func _on_body_entered(body: PhysicsBody2D) -> void:
	if "touche" in body:
		$AudioStreamPlayer.play()
		Globals.maj_code_joueur(couleur)
		desactiver()
		


func desactiver() -> void:
	$CollisionPolygon2D.set_deferred("disabled", true)
	var position_depart: Vector2 = $TriangleBlanc.global_position
	var position_finale: Vector2 = $TriangleBlanc.global_position - Vector2(150, 200)
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property($TriangleBlanc, "scale", Vector2(0.1, 0.1), 0.3)
	tween.tween_property($TriangleBlanc, "global_position", position_finale, 0.3).from(position_depart)	
	await tween.finished
	visible = false	
	$TriangleBlanc.scale = Vector2(1, 1)
	$TriangleBlanc.global_position = position_depart
	
	
func activer() -> void:
	visible = true
	$CollisionPolygon2D.set_deferred("disabled", false)

