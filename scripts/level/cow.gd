extends Control

signal cowMoving(value)
signal cowDespawned()

var positionOnMap: Vector2
var despawn := false

@onready var buttNode: AnimatedSprite2D = $Butt
@onready var hatNode: AnimatedSprite2D = $Hat

func _ready() -> void:
	buttNode.animation = "default"
	hatNode.animation = "default"

func moveCow(numTiles: int, direction: Vector2):
	if direction.x > 0:
		rotation_degrees = -90
	if direction.x < 0:
		rotation_degrees = 90
	if direction.y > 0:
		rotation_degrees = 0
	if direction.y < 0:
		rotation_degrees = 180
	
	buttNode.animation = "wiggle"
	hatNode.animation = "blink"
	cowMoving.emit(true)
	var positionTween = get_tree().create_tween()
	positionTween.tween_property(self, "position", positionOnMap * Gamemanager.mapTileSize, Gamemanager.moveSpeed * numTiles).set_trans(Tween.TRANS_LINEAR)
	await positionTween.finished
	cowMoving.emit(false)
	rotation_degrees = 0
	buttNode.animation = "default"
	hatNode.animation = "default"
	
	if despawn:
		cowDespawned.emit()
		queue_free()
