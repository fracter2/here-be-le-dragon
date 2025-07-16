extends MultiplayerSynchronizer

var flip_pitch: float = -1
var input_pitch:float = 0
var input_barrel:float = 0
var input_yaw:float = 0
var input_thrust:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		return
	
	if Input.is_action_just_pressed(&"flip_pitch"): flip_pitch = flip_pitch * -1
	input_pitch = Input.get_axis(&"pitch_down", &"pitch_up") * flip_pitch
	input_barrel = Input.get_axis(&"barrel_right", &"barrel_left")
	input_yaw = Input.get_axis(&"yaw_right", &"yaw_left")
	input_thrust = Input.get_axis(&"thrust_down", &"thrust_up")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"flip_pitch"): flip_pitch = flip_pitch * -1
	input_pitch = Input.get_axis(&"pitch_down", &"pitch_up") * flip_pitch
	input_barrel = Input.get_axis(&"barrel_right", &"barrel_left")
	input_yaw = Input.get_axis(&"yaw_right", &"yaw_left")
	input_thrust = Input.get_axis(&"thrust_down", &"thrust_up")
