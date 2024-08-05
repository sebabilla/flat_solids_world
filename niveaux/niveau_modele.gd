extends Node2D
class_name  NiveauModele

signal niveau_suivant

func _ready() -> void:
	$AireVictoire/CollisionShape2D.disabled = true
	$TimerAireVictoire.start()
	Globals.position_depart = $PositionDeDepart.global_position
	reset_niveau()
	
	
func charger_porte() -> void:
	$Porte.nettoyer_code()
	$Porte.afficher_code()


func charger_fragments() -> void:		
	# fragments dispersés
	var nombre: int = $Fragments.get_child_count()
	var couleurs: Array[Color] = []
	
	# choisir une couleur pour chaque fragment
	for couleur: Color in Globals.code:
		couleurs.append(couleur)
	for n: int in range(nombre - couleurs.size()):
		couleurs.append(Globals.couleur_aleatoire())
	if couleurs.size() != nombre:
		push_error("erreur d'appariement fragments / couleurs")
	couleurs.shuffle()
		
	#attribuer sa couleur à chaque enfant
	for n: int in range(nombre):
		$Fragments.get_child(n).attribuer_couleur(couleurs[n])
		
		
func ressusciter_ennemis() -> void:
	for ennemi: Node2D in $Ennemis.get_children():
		if "ressusciter" in ennemi:
			ennemi.ressusciter()
			
			
func reset_niveau() -> void:
	charger_porte()
	charger_fragments()
	ressusciter_ennemis()
	

func _on_porte_tentative_rate() -> void:
	reset_niveau()


func _on_aire_victoire_body_entered(body: PhysicsBody2D) -> void:
	if body.peut_toucher:
		body.intouchable()
		niveau_suivant.emit()


func _on_timer_aire_victoire_timeout() -> void:
	$AireVictoire/CollisionShape2D.disabled = false
