extends Control

const JOY_DEADZONE := 0.25		# Valeur recommandée (entre 0.2 et 0.3)

@onready var texture_rect: TextureRect = $CenterContainer/TextureRect
@onready var label: Label = $CenterContainer/Label

var joy_num := 0
var cur_joy := -1
var axis_value := 0.0
@onready var joypad_name: RichTextLabel = $DeviceInfo/JoyName # remove
@onready var joypad_number: SpinBox = $DeviceInfo/JoyNumber # remove

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	for joypad in Input.get_connected_joypads():
		print_rich("Found joypad #%d: [b]%s[/b] - %s" % [joypad, Input.get_joy_name(joypad), Input.get_joy_guid(joypad)])



func _unhandled_input(event: InputEvent) -> void:
	# ----- Keyboard -----WORK
	if event is InputEventKey:
		var key_event := event as InputEventKey
		var key: Key = key_event.keycode          # or .physical_keycode
		texture_rect.texture = load(FindSvgInput.get_svg_for_key(key)) as Texture2D

		


		# Exemple : if key == KEY_SPACE: ...

	# ----- Mouse -----
	elif event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		var button: MouseButton = mouse_event.button_index
		# label.text ="Bouton souris : " + str(button)
		texture_rect.texture = load(FindSvgInput.get_svg_for_mouse_button(button)) as Texture2D
		# Exemple : if button == MOUSE_BUTTON_LEFT: ...

	# ----- Manette - Boutons -----
	elif event is InputEventJoypadButton:
		var joy_button_event := event as InputEventJoypadButton
		var button: JoyButton = joy_button_event.button_index
		
		texture_rect.texture = load(FindSvgInput.get_svg_for_joy_button(Input.get_joy_name(0), button)) as Texture2D

	# ----- Manette - Axes (sticks, gâchettes…) -----
	elif event is InputEventJoypadMotion:
		var motion := event as InputEventJoypadMotion
		
		# On ignore les petits mouvements dans la deadzone
		if abs(motion.axis_value) < JOY_DEADZONE:
			return
		
		var axis: JoyAxis = motion.axis
		var value: float = motion.axis_value

		texture_rect.texture = load(FindSvgInput.get_svg_for_joy_axis(Input.get_joy_name(0),axis ,value)) as Texture2D


# ----------------------------------
# From Joypad Godot demo
# Called whenever a joypad has been connected or disconnected.
func _on_joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected:
		print_rich("[color=green][b]+[/b] Found newly connected joypad #%d: [b]%s[/b] - %s[/color]" % [device_id, Input.get_joy_name(device_id), Input.get_joy_guid(device_id)])
	else:
		print_rich("[color=red][b]-[/b] Disconnected joypad #%d.[/color]" % device_id)

	if device_id == cur_joy:
		# Update current joypad label.
		if connected:
			set_joypad_name(Input.get_joy_name(device_id), Input.get_joy_guid(device_id))
		else:
			clear_joypad_name()

func set_joypad_name(joy_name: String, joy_guid: String) -> void:
	# Make the GUID clickable (and point to Godot's game controller database for easier lookup).
	joypad_name.set_text("%s\n[color=#fff9][url=https://github.com/godotengine/godot/blob/master/core/input/gamecontrollerdb.txt]%s[/url][/color]" % [joy_name, joy_guid])

	# Make the rest of the UI appear as enabled.
	for node: CanvasItem in [$JoypadDiagram, $Axes, $Buttons, $Vibration, $VBoxContainer]:
		node.modulate.a = 1.0

func clear_joypad_name() -> void:
	joypad_name.set_text("[i]No controller detected at ID %d.[/i]" % joypad_number.value)

	# Make the rest of the UI appear as disabled.
	for node: CanvasItem in [$JoypadDiagram, $Axes, $Buttons, $Vibration, $VBoxContainer]:
		node.modulate.a = 0.5
