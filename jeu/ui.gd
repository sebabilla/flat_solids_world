extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("maj_ui", maj_ui)
	Globals.connect("reset_code_joueur", initialiser_code_joueur)
	reset_ui()
	
	
func _process(_delta) -> void:
	$Temps.text = "Level " + str(Globals.niveau_actuel) + "/" + str(Globals.NB_NIVEAU) + ", attempts : " + str(Globals.essais) + ", time : " + str(int($TimerNiveau.time_left))


func maj_pyramide_de_vie() -> void:
	for n: int in range(Globals.pv):
		$PyramideDeVie.get_child(n).modulate = Globals.ROSE
	for n: int in range(Globals.pv, Globals.MAX_PV):
		$PyramideDeVie.get_child(n).modulate = Globals.ROSE_PALE
		
		
func initialiser_code_joueur() -> void:
	var taille: int = Globals.code.size()
	for n: int in range(taille):
		$CodeJoueur.get_child(n).modulate = Globals.GRIS
		$CodeJoueur.get_child(n).visible = true
	for n: int in range(taille, 5):
		$CodeJoueur.get_child(n).visible = false
		
		
func maj_code_joueur() -> void:
	for n: int in range(Globals.code_joueur.size()):
		$CodeJoueur.get_child(n).modulate = Globals.code_joueur[n]
		
		
func maj_ui() -> void:
	maj_pyramide_de_vie()
	maj_code_joueur()


func reset_ui() -> void:
	maj_ui()
	initialiser_code_joueur()
	Globals.temps_total += $TimerNiveau.time_left
	$TimerNiveau.start()
	
	
func temps_restant() -> float:
	return $TimerNiveau.time_left
		

func _on_timer_niveau_timeout() -> void:
	Globals.temps_total += $TimerNiveau.wait_time
	Globals.pv = 0
