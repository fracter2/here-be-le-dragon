extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MultiplayerManager.local_joined.connect(request_respawn.bind(multiplayer.get_unique_id()))
	


@rpc("any_peer", "call_remote", "reliable")
func request_respawn(int id):
	
	
