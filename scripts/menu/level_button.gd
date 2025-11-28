extends TextureButton

var levelIdx: int
var levelScene: PackedScene = preload("res://scenes/level/level.tscn")

@onready var labelNode: Label = $LevelNumber

func setLevel(idx: int):
	levelIdx = idx
	labelNode.text = str(idx + 1)

func _on_pressed() -> void:
	Gamemanager.currentLevel = levelIdx
	get_tree().change_scene_to_packed(levelScene)
