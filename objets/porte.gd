extends StaticBody2D

signal tentative_rate

func afficher_code() -> void:
	for triangle: int in range(Globals.code.size()):
		var t: Sprite2D = $CodeTriangles.get_child(triangle)
		t.visible = true
		t.modulate = Globals.code[triangle]
		
		
func nettoyer_code() -> void:
	for triangle: int in range(5):
		var t: Sprite2D = $CodeTriangles.get_child(triangle)
		t.visible = false
		t.modulate = Globals.GRIS
		
		
func ouvrir_porte() -> void:
	nettoyer_code()
	$AudioStreamPlayer.play()
	var tween: Tween = create_tween()
	var ouverture: float = global_position.y - 200
	tween.tween_property(self, "global_position:y", ouverture, 2)
	
	
func tremblement_porte(n: int) -> void:
	var tween: Tween = create_tween()
	var actuel: float = global_position.y
	var cible: float = actuel - 7 - (7 * n)
	tween.tween_property(self, "global_position:y", cible, 0.2)
	tween.tween_property(self, "global_position:y", actuel, 0.2)
	await tween.finished
	$AudioStreamPlayer2.play()


func _on_interaction_joueur_body_entered(_body: PhysicsBody2D) -> void:
	var juste:int = Globals.verifier_nombre()
	tremblement_porte(juste)
	if juste == Globals.code.size():
		if Globals.verifier_quali():
			$InteractionJoueur/CollisionShape2D.queue_free()
			ouvrir_porte()
			return
	tentative_rate.emit()
			
