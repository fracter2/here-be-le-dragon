extends Node


#var player_name: String = "Default Name"
var vehicle_name: String = "Default Name"

var color_primary: Color = Color("acacac")
var color_secondary: Color = Color("7dc899")

var flip_pitch: bool = false
var flip_yaw: bool = false
var flip_roll: bool = false

var flip_pitch_f: float: 
	get: return -1 if flip_pitch else 1
var flip_yaw_f: float: 
	get: return -1 if flip_yaw else 1
var flip_roll_f: float: 
	get: return -1 if flip_roll else 1
