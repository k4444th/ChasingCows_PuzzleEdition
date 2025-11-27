extends Node2D

signal cowMoved(moveCount: int)

var tileScene := load("res://scenes/tile.tscn")
var cowScene := load("res://scenes/cow.tscn")
var hayScene := load("res://scenes/hay.tscn")
var destinationScene := load("res://scenes/destination.tscn")

var grassTextures: Array = [
	load("res://assets/levels/tiles/tileGrass0.png"),
	load("res://assets/levels/tiles/tileGrass1.png"),
	# load("res://assets/levels/tiles/tileGrass2.png")
]

var cows: Array
var tiles: Array
var moveCount: int
var speed := 0.5

@onready var grassNode: Node2D = $Grass
@onready var obstaclesNode: Node2D = $Obstacles
@onready var cowsNode: Node2D = $Cows

@onready var viewport: Viewport = get_viewport()

func setLevel(level: Dictionary):
	copyLevel(level)
	viewport.size_changed.connect(setScale)
	setScale()
	spawnGrass()
	spawnCows()
	spawnObstacles()

func setScale():
	var containerSize = get_parent().size
	var costumScale = containerSize.x / ((Gamemanager.mapDimensions.x + 0.5) * Gamemanager.mapTileSize.x)
	scale = Vector2(costumScale, costumScale)
	position = Vector2(Gamemanager.mapTileSize.x / 4 * costumScale, containerSize.y / 2 - ((Gamemanager.mapDimensions.y / 2) * Gamemanager.mapTileSize.y) * costumScale)

func spawnGrass():
	for row in range(Gamemanager.mapDimensions.x):
		for col in range(Gamemanager.mapDimensions.y):
			var tileInstance = tileScene.instantiate()
			tileInstance.texture = grassTextures[randi() % grassTextures.size()]
			tileInstance.position.x = row * Gamemanager.mapTileSize.x
			tileInstance.position.y = col * Gamemanager.mapTileSize.y
			grassNode.add_child(tileInstance)

func spawnCows():
	for cow in cows:
		var cowInstance = cowScene.instantiate()
		cowInstance.position.x = cow[0] * Gamemanager.mapTileSize.x
		cowInstance.position.y = cow[1] * Gamemanager.mapTileSize.y
		cowsNode.add_child(cowInstance)

func spawnObstacles():
	for row in range(Gamemanager.mapDimensions.y):
		for col in range(Gamemanager.mapDimensions.x):
			var obstacleInstance: Sprite2D = null
			
			if tiles[row][col] == "hay":
				obstacleInstance = hayScene.instantiate()
			elif  tiles[row][col] == "destination":
				obstacleInstance = destinationScene.instantiate()
			
			if obstacleInstance:
				obstacleInstance.position.x = col * Gamemanager.mapTileSize.x
				obstacleInstance.position.y = row * Gamemanager.mapTileSize.y
				obstaclesNode.add_child(obstacleInstance)
	tiles[0][0] = "hay"

func moveCow(startPos: Vector2, direction: Vector2):
	moveCount -= 1
	cowMoved.emit(moveCount)

	var cowNodes = cowsNode.get_children()

	for cowIndex in cowNodes.size():
		var cow = cowNodes[cowIndex]
		var cowRect = Rect2(cow.global_position, Gamemanager.mapTileSize)
		if cowRect.has_point(startPos):
			var distanceTiles := 0
			var currentCowCoords = (cow.position / Gamemanager.mapTileSize).floor()

			while true:
				currentCowCoords += direction
				if currentCowCoords.x < 0 or currentCowCoords.x >= Gamemanager.mapDimensions.x:
					break
				if currentCowCoords.y < 0 or currentCowCoords.y >= Gamemanager.mapDimensions.y:
					break

				var tileValue = tiles[currentCowCoords.y][currentCowCoords.x]
				if tileValue == "":
					if !cows.has(currentCowCoords):
						distanceTiles += 1
						continue
					else:
						break
				if tileValue == "destination":
					distanceTiles += 1
					break
				break

			cows[cowIndex] = cows[cowIndex] + distanceTiles * direction
			var destinationPos = cow.position + direction * Gamemanager.mapTileSize * distanceTiles
			var tween = get_tree().create_tween()
			tween.tween_property(cow, "position", destinationPos, speed * distanceTiles).set_trans(Tween.TRANS_QUAD)

func resetGame(level):
	copyLevel(level)
	deleteCows()
	deleteObstacles()
	spawnCows()
	spawnObstacles()

func deleteCows():
	for cow in cowsNode.get_children():
		cow.queue_free()

func deleteObstacles():
	for obstacle in obstaclesNode.get_children():
		obstacle.queue_free()

func copyLevel(level):
	tiles = []
	for row in level["map"]:
		tiles.append(row.duplicate())
	moveCount = level["moveCount"]
	cows = []
	for cow in level["cows"]:
		cows.append(cow)
