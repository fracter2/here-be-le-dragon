extends MultiplayerSynchronizer


var input_pitch:float = 0
var input_barrel:float = 0
var input_yaw:float = 0
var input_thrust:float = 0
var input_forward:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		return
	
	if Input.is_action_just_pressed(&"flip_pitch"): Settings.flip_pitch = !Settings.flip_pitch
	
	input_pitch = Input.get_axis(&"pitch_down", &"pitch_up") * Settings.flip_pitch_f
	input_barrel = Input.get_axis(&"barrel_right", &"barrel_left") * Settings.flip_roll_f
	input_yaw = Input.get_axis(&"yaw_right", &"yaw_left") * Settings.flip_yaw_f
	input_thrust = Input.get_axis(&"thrust_down", &"thrust_up")
	input_forward = Input.get_axis(&"backward", &"forward")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"flip_pitch"): Settings.flip_pitch = !Settings.flip_pitch
	
	input_pitch = Input.get_axis(&"pitch_down", &"pitch_up") * Settings.flip_pitch_f
	input_barrel = Input.get_axis(&"barrel_right", &"barrel_left") * Settings.flip_roll_f
	input_yaw = Input.get_axis(&"yaw_right", &"yaw_left") * Settings.flip_yaw_f
	input_thrust = Input.get_axis(&"thrust_down", &"thrust_up")
	input_forward = Input.get_axis(&"backward", &"forward")
