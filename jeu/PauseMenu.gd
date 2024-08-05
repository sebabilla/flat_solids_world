extends CanvasLayer

var en_pause: bool = false

func _process(_delta) -> void:
	if not en_pause:
		show()
		afficher_texte()
		en_pause = true
		
	if Input.is_action_just_pressed("Quitter"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("action1"):
		hide()
		en_pause = false
		get_tree().paused = false
		get_parent().charger_niveau()
		
		
func afficher_texte() -> void:
	if Globals.victoire:
		Globals.victoire = false
		Globals.temps_total += %UI.temps_restant()
		$RichTextLabel.text = "[center][font_size=30]Bravo![/font_size]\n\n[font_size=20]Attempts : " + str(Globals.essais) + "\nTotal time : " + str(int(Globals.temps_total)) + "s[/font_size][/center]"
		$Gagne.play()		
		await $Gagne.finished
		Globals.niveau_actuel = 1
		Globals.temps_total = 0
		Globals.essais = 1
	else:
		$Perdu.play()
		$RichTextLabel.text = "[center][font_size=30]Continue?[/font_size]\n\n[font_size=20][b]Flat Solids World[/b] by Seb46 for [b]IcoJam 2024[/b].[/font_size]\n [font_size=18] MIT License\nRestriction: [i]use of geometric shapes[/i], theme: [i]Patterns[/i]. [/font_size]\n\n[font_size=16]Sprites: I made them from cube, cone, icosahedron, prism, antiprism, and pyramid blueprints.\nSound effects: adapted from LaSonothèque of Joseph Sardin, CC0.\nMusic: [b]Uppon la mi re[/b] by Thomas Preston played by Michael Schopen, CC BY-NC-ND 3.0.[/font_size][/center]"
		await $Perdu.finished
	pass
