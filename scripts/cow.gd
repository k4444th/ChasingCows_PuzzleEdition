extends Sprite2D

signal cowMoving(value)

var positionOnMap: Vector2

func moveCow(numTiles: int):
	cowMoving.emit(true)
	var positionTween = get_tree().create_tween()
	positionTween.tween_property(self, "position", positionOnMap * Gamemanager.mapTileSize, Gamemanager.moveSpeed * numTiles).set_trans(Tween.TRANS_LINEAR)
	await positionTween.finished
	cowMoving.emit(false)
