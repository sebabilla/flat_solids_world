extends Node

var niveau0: PackedScene = preload("res://niveaux/niveau_0.tscn")
var niveau1: PackedScene = preload("res://niveaux/niveau_1.tscn")
var niveau2: PackedScene = preload("res://niveaux/niveau_2.tscn")
var niveau3: PackedScene = preload("res://niveaux/niveau_3.tscn")
var niveau4: PackedScene = preload("res://niveaux/niveau_4.tscn")
var niveau5: PackedScene = preload("res://niveaux/niveau_5.tscn")

func _ready()-> void:
	charger_niveau()
	$PauseMenu.hide()
	
	
func charger_niveau()-> void:
	transition(0, 1)
	$Joueur.inactif = true
	
	if $PorteNiveau.get_child_count() > 0:
		var vieux_niveau: Node2D = $PorteNiveau.get_child(0)
		vieux_niveau.queue_free()
		await vieux_niveau.tree_exited
		
	var nouveau_niveau: Node2D
	match Globals.niveau_actuel:
		0:
			if tirage(3):
				nouveau_niveau = niveau0.instantiate()
		1:
			if tirage(3):
				nouveau_niveau = niveau1.instantiate()
		2:
			if tirage(4):
				nouveau_niveau = niveau2.instantiate()
		3:
			if tirage(4):
				nouveau_niveau = niveau3.instantiate()
		4:
			if tirage(5):
				nouveau_niveau = niveau4.instantiate()
		5:
			if tirage(5):
				nouveau_niveau = niveau5.instantiate()
		_:
			push_error("Le niveau à charger n'existe pas.")
	$PorteNiveau.add_child(nouveau_niveau)	
	nouveau_niveau.niveau_suivant.connect(passer_au_niveau_suivant)	
	
	$Joueur.reset_position()
	Globals.pv = Globals.MAX_PV
	Globals.code_joueur = []
	$UI.reset_ui()
	
	transition(1, 0)
	$Joueur.inactif = false
	

func tirage(n: int) -> bool:
	if n < 1 or n > 5:
		push_error("Le nombre de couleurs tirées pour le code est impossible.")
		return false
		
	if Globals.niveau_actuel == 0:
		Globals.code = [Globals.VERT, Globals.ROUGE, Globals.BLEU]
		return true
	
	Globals.code.clear()
	for i in n:
		var couleur: Color = Globals.couleur_aleatoire()
		Globals.code.append(couleur)
	return true
				

func _on_joueur_tombe_dans_trou() -> void:
	if $PorteNiveau.get_child(0):
		$PorteNiveau.get_child(0).reset_niveau()
	Globals.code_joueur = []


func passer_au_niveau_suivant() -> void:
	Globals.niveau_actuel += 1
	charger_niveau()
	
	
func transition(alpha1: int, alpha2: int) -> void:
	$Transition/ColorRect.show()
	var tween: Tween = create_tween()
	tween.tween_property($Transition/ColorRect, "color:a", alpha2, 0.4).from(alpha1)
	await tween.finished
	$Transition/ColorRect.hide()
	

func _on_joueur_lancer_musique() -> void:
	$UpponLaMiRe.play()
