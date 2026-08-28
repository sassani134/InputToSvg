extends Control

const JOY_DEADZONE := 0.25		# Valeur recommandée (entre 0.2 et 0.3)

@onready var texture_rect: TextureRect = $CenterContainer/TextureRect
@onready var label: Label = $CenterContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	# ----- Clavier -----
	if event is InputEventKey:
		var key_event := event as InputEventKey
		var key: Key = key_event.keycode          # ou .physical_keycode
		#print("Touche : ", key)
		label.text = "Touche : " + str(key)
		print(str(FindSvgInput.get_svg_for_key(key)))
		texture_rect.texture = load(FindSvgInput.get_svg_for_key(key))
		
		# Exemple : if key == KEY_SPACE: ...

	# ----- Souris -----
	elif event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		var button: MouseButton = mouse_event.button_index
		#print("Bouton souris : ", button)
		label.text ="Bouton souris : " + str(button)
		# Exemple : if button == MOUSE_BUTTON_LEFT: ...

	# ----- Manette - Boutons -----
	elif event is InputEventJoypadButton:
		var joy_button_event := event as InputEventJoypadButton
		var button: JoyButton = joy_button_event.button_index
		#print("Bouton manette : ", button)
		label.text = "Bouton manette : "+ str(button)
		# Exemple : if button == JOY_BUTTON_A: ...

	# ----- Manette - Axes (sticks, gâchettes…) -----
	# need deadzone
	elif event is InputEventJoypadMotion:
		var motion := event as InputEventJoypadMotion
		
		# On ignore les petits mouvements dans la deadzone
		if abs(motion.axis_value) < JOY_DEADZONE:
			return
		
		var axis: JoyAxis = motion.axis
		var value: float = motion.axis_value
		
		#print("Axe : ", axis, " → ", value)
		label.text = "Axe manette : "+ str(axis) + " = "+ str(value)
		# Exemple : if axis == JOY_AXIS_LEFT_X: ...
