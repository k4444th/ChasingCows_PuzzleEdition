extends Node2D

var positionOnMap: Vector2
var obstacleType: String

@onready var shadowNode: Sprite2D = $Shadow

func _ready() -> void:
	shadowNode.self_modulate.a = 0.25

func move():
	var positionTween = get_tree().create_tween()
	positionTween.tween_property(self, "position", positionOnMap * Gamemanager.mapTileSize + Gamemanager.offset[obstacleType], Gamemanager.moveSpeed).set_trans(Tween.TRANS_LINEAR)
