extends Sprite2D

signal cowMoving(value)
signal cowDespawned()

var positionOnMap: Vector2
var despawn := false

func moveCow(numTiles: int):
	cowMoving.emit(true)
	var positionTween = get_tree().create_tween()
	positionTween.tween_property(self, "position", positionOnMap * Gamemanager.mapTileSize, Gamemanager.moveSpeed * numTiles).set_trans(Tween.TRANS_LINEAR)
	await positionTween.finished
	cowMoving.emit(false)
	
	if despawn:
		cowDespawned.emit()
		queue_free()
