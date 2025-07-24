extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _player_colors_changed(color:Color, as_primary:bool):
	var player: Helicopter = get_heli_of_id(multiplayer.get_unique_id())
	if player == null: 
		print("no vehicle found")
		return
	
	player.sync_colors.rpc(%ColorPrimary.color, %ColorSecondary.color)

func _player_custom_name_changed(new_text:String):
	var player: Helicopter = get_heli_of_id(multiplayer.get_unique_id())
	if player == null: 
		print("no vehicle found")
		return
	
	player.sync_name.rpc(new_text)

func get_heli_of_id(id:int) -> Helicopter:
	for child in get_children():
		if child is Helicopter:
			if child.player_id == id: return child
	
	return null
