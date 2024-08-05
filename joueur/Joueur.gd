extends CharacterBody2D

signal tombe_dans_trou
signal lancer_musique()

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -500.0
var peut_toucher: bool = true
var inactif: bool = false
var premiere_action: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	reset_position()


func _physics_process(delta: float) -> void:
	if not premiere_action:
		if Input.is_anything_pressed():
			premiere_action = true
			lancer_musique.emit()
		pass
		
	if Input.is_action_just_pressed("Quitter"):
		get_tree().quit()
		
	if not is_on_floor():
		if global_position.y > 600:
			velocity.y = 0
			if Globals.pv > 2: 
				reset_position()
				tombe_dans_trou.emit()
			touche(2)
		else:
			velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("action1"):
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.pause()
		elif not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play()

	var direction: float = Input.get_axis("gauche", "droite")
	if direction and not inactif:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
func touche(degats: int) -> void:
	if peut_toucher:
		Globals.pv -= degats
		intouchable()
		$AudioStreamPlayer.play()
	
	
func touchable() -> void:
	peut_toucher = true
	modulate.a = 1
	
	
func intouchable() -> void:
	peut_toucher = false
	modulate.a = 0.5
	$TimerIntouchable.start()
	
	
func reset_position() -> void:
	global_position = Globals.position_depart


func _on_timer_intouchable_timeout() -> void:
	touchable()
