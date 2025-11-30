extends Node2D

signal cowMoving(value)
signal cowDespawned()

@onready var shadowNode: Sprite2D = $Shadow
@onready var cowNode: AnimatedSprite2D = $Cow

var positionOnMap: Vector2
var despawn := false

func _ready() -> void:
	shadowNode.self_modulate.a = 0.25
	cowNode.animation = "right"

func moveCow(numTiles: int, direction: Vector2):
	if direction.x > 0:
		cowNode.animation = "right"
	if direction.x < 0:
		cowNode.animation = "left"
	if direction.y > 0:
		cowNode.animation = "front"
	if direction.y < 0:
		cowNode.animation = "back"
	
	cowMoving.emit(true)
	var positionTween = get_tree().create_tween()
	positionTween.tween_property(self, "position", positionOnMap * Gamemanager.mapTileSize + Gamemanager.offset["cow"], Gamemanager.moveSpeed * numTiles).set_trans(Tween.TRANS_LINEAR)
	await positionTween.finished
	cowMoving.emit(false)
	cowNode.animation = "right"
	
	if despawn:
		cowDespawned.emit()
		queue_free()
