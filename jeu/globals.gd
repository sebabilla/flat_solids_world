extends Node

signal maj_ui
signal reset_code_joueur

# joueur
var essais: int = 1
var temps_total: float = 0
const MAX_PV: int = 4
var pv: int = MAX_PV:
	set(n):
		if n >= pv:
			pv = min(n, MAX_PV)
		if n < pv:
			pv = n
		if n <= 0:
			essais += 1
			get_tree().paused = true
		maj_ui.emit()
var position_depart: Vector2 = Vector2.ZERO


# niveau
var victoire: bool = false
const NB_NIVEAU: int = 5
var niveau_actuel: int = 0:
	set(n):
		if n < 0:
			niveau_actuel = 0
		elif n > NB_NIVEAU:
			victoire = true
			get_tree().paused = true
		else:
			niveau_actuel = n
			

# couleurs pour le code
const ROUGE: Color = Color(0.937, 0.522, 0.490)
const JAUNE: Color = Color(1, 0.929, 0.671)
const VERT: Color = Color(0, 0.58, 0.478)
const BLEU: Color = Color(0.553, 0.576, 0.784)

func couleur_aleatoire() -> Color:
	var choix: int = randi_range(0, 3)
	match choix:
		0:
			return ROUGE
		1:
			return JAUNE
		2:
			return VERT
		3:
			return BLEU
		_:
			push_error("choix_de_couleur_impossible")
			return GRIS


# codes
var code: Array[Color] = []
var code_joueur: Array[Color] = []:
	set(a):
		code_joueur = a
		if a == []:
			reset_code_joueur.emit()

func maj_code_joueur(couleur: Color) -> void:
	code_joueur.append(couleur)
	if code_joueur.size() > code.size():
		code_joueur.pop_front()
	maj_ui.emit()
	
func verifier_nombre()-> int:
	var juste: int = 0
	if code.size() != code_joueur.size():
		return 0
	for n in range(code_joueur.size()):
		if code[n] == code_joueur[n]:
			juste += 1
	return juste
	
func verifier_quali()-> bool:
	return code == code_joueur


# autres couleurs
const GRIS: Color = Color(0.537, 0.533, 0.502)
const ROSE_PALE: Color = Color(0.871, 0.744, 0.800)
const ROSE: Color = Color(0.871, 0.51, 0.655)



