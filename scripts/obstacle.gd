extends Sprite2D

var positionOnMap: Vector2
var obstacleType: String

func move():
	var positionTween = get_tree().create_tween()
	positionTween.tween_property(self, "position", positionOnMap * Gamemanager.mapTileSize, Gamemanager.moveSpeed).set_trans(Tween.TRANS_LINEAR)
