extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AppSettings.set_from_config()
