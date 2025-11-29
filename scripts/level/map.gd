extends Node2D

signal cowMoved(moveCount: int)

var menuScene: PackedScene = preload("res://scenes/menu/menu.tscn")

var tileScene := load("res://scenes/level/tile.tscn")
var cowScene := load("res://scenes/level/cow.tscn")
var hayScene := load("res://scenes/level/hay.tscn")
var rockScene := load("res://scenes/level/rock.tscn")
var destinationScene := load("res://scenes/level/destination.tscn")

var grassTextures: Array = [
	load("res://assets/level/tiles/tileGrass0.png"),
	load("res://assets/level/tiles/tileGrass1.png"),
	# load("res://assets/level/tiles/tileGrass2.png")
]

var cowsStart: Array
var mapStart: Array
var moveCount: int
var cowMoving: bool

@onready var grassNode: Node2D = $Grass
@onready var obstaclesNode: Node2D = $Obstacles
@onready var cowsNode: Node2D = $Cows

@onready var viewport: Viewport = get_viewport()

func setLevel():
	copyLevel(Gamemanager.levels[Gamemanager.currentLevel])
	viewport.size_changed.connect(setScale)
	setScale()
	spawnGrass()
	spawnCows()
	spawnObstacles()

func setScale():
	var containerSize = get_parent().size
	var costumScale = containerSize.x / ((Gamemanager.mapDimensions.x + 0.5) * Gamemanager.mapTileSize.x)
	
	if containerSize.y * 0.75 < Gamemanager.mapDimensions.y * Gamemanager.mapTileSize.y * costumScale:
		costumScale = containerSize.y / ((Gamemanager.mapDimensions.x + 5) * Gamemanager.mapTileSize.y)
	
	position = Vector2(containerSize.x / 2 - ((Gamemanager.mapDimensions.x / 2) * Gamemanager.mapTileSize.x) * costumScale, containerSize.y / 2 - ((Gamemanager.mapDimensions.y / 2) * Gamemanager.mapTileSize.y) * costumScale)
	scale = Vector2(costumScale, costumScale)
	
func spawnGrass():
	for row in range(Gamemanager.mapDimensions.x):
		for col in range(Gamemanager.mapDimensions.y):
			var tileInstance = tileScene.instantiate()
			tileInstance.texture = grassTextures[randi() % grassTextures.size()]
			tileInstance.position.x = row * Gamemanager.mapTileSize.x
			tileInstance.position.y = col * Gamemanager.mapTileSize.y
			grassNode.add_child(tileInstance)

func spawnCows():
	for cow in cowsStart:
		var cowInstance = cowScene.instantiate()
		cowInstance.positionOnMap = cow
		cowInstance.position.x = cow[0] * Gamemanager.mapTileSize.x
		cowInstance.position.y = cow[1] * Gamemanager.mapTileSize.y
		cowInstance.connect("cowMoving", setCowMoving)
		cowInstance.connect("cowDespawned", checkForLevelEnding)
		cowsNode.add_child(cowInstance)

func spawnObstacles():
	for row in range(Gamemanager.mapDimensions.y):
		for col in range(Gamemanager.mapDimensions.x):
			var obstacleInstance: Sprite2D = null
			
			if mapStart[row][col] == "hay":
				obstacleInstance = hayScene.instantiate()
			elif  mapStart[row][col] == "destination":
				obstacleInstance = destinationScene.instantiate()
			elif  mapStart[row][col] == "rock":
				obstacleInstance = rockScene.instantiate()
			
			if obstacleInstance:
				obstacleInstance.positionOnMap = Vector2(col, row)
				obstacleInstance.obstacleType = mapStart[row][col]
				obstacleInstance.position.x = col * Gamemanager.mapTileSize.x
				obstacleInstance.position.y = row * Gamemanager.mapTileSize.y
				obstaclesNode.add_child(obstacleInstance)

func moveCow(startPos: Vector2, direction: Vector2):
	if !cowMoving:
		var cowNodes = cowsNode.get_children()
		
		for cowNode in cowNodes:
			var cowRect = Rect2(cowNode.global_position, Gamemanager.mapTileSize)
			if cowRect.has_point(startPos):
				var distanceTiles := 0
				var positionFound := false
				
				while !positionFound:
					cowNode.positionOnMap += direction
					distanceTiles += 1
					
					if cowNode.positionOnMap.x < 0 or cowNode.positionOnMap.x > Gamemanager.mapDimensions.x - 1:
						cowNode.positionOnMap.x = clamp(cowNode.positionOnMap.x, 0, Gamemanager.mapDimensions.x - 1)
						distanceTiles -= 1
						positionFound = true
					if cowNode.positionOnMap.y < 0 or cowNode.positionOnMap.y > Gamemanager.mapDimensions.y - 1:
						cowNode.positionOnMap.y = clamp(cowNode.positionOnMap.y, 0, Gamemanager.mapDimensions.y - 1)
						distanceTiles -= 1
						positionFound = true
					
					for otherCowsNode in cowNodes:
						if cowNode != otherCowsNode and cowNode.positionOnMap == otherCowsNode.positionOnMap:
							cowNode.positionOnMap -= direction
							distanceTiles -= 1
							positionFound = true
					
					for obstacleNode in obstaclesNode.get_children():
						if cowNode.positionOnMap == obstacleNode.positionOnMap:
							match obstacleNode.obstacleType:
								"hay":
									cowNode.positionOnMap -= direction
									distanceTiles -= 1
								"rock":
									cowNode.positionOnMap -= direction
									distanceTiles -= 1
									obstacleNode.positionOnMap += direction
									
									if obstacleNode.positionOnMap.x < 0 or obstacleNode.positionOnMap.x > Gamemanager.mapDimensions.x - 1:
										obstacleNode.positionOnMap.x = clamp(obstacleNode.positionOnMap.x, 0, Gamemanager.mapDimensions.x - 1)
									if obstacleNode.positionOnMap.y < 0 or obstacleNode.positionOnMap.y > Gamemanager.mapDimensions.y - 1:
										obstacleNode.positionOnMap.y = clamp(obstacleNode.positionOnMap.y, 0, Gamemanager.mapDimensions.y - 1)
									
									for otherCowsNode in cowNodes:
										if otherCowsNode.positionOnMap == obstacleNode.positionOnMap:
											obstacleNode.positionOnMap -= direction
									for otherObstacleNode in obstaclesNode.get_children():
										if obstacleNode != otherObstacleNode and otherObstacleNode.positionOnMap == obstacleNode.positionOnMap:
											obstacleNode.positionOnMap -= direction
									
									if distanceTiles <= 0:
										obstacleNode.move()
										moveCount -= 1
										cowMoved.emit(moveCount)
										
								"destination":
									cowNode.despawn = true
							
							positionFound = true
				
				if distanceTiles > 0:
					moveCount -= 1
					cowMoved.emit(moveCount)
					cowNode.moveCow(distanceTiles, direction)

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
	mapStart = level["map"]
	moveCount = level["moveCount"]
	cowsStart = level["cows"]

func setCowMoving(value: bool):
	cowMoving = value
	
	if value == false:
		for obstacleNode in obstaclesNode.get_children():
			if obstacleNode.obstacleType == "rock":
				obstacleNode.move()

func checkForLevelEnding():
	if !cowsNode.get_child_count() > 1:
		await get_tree().create_timer(0.5).timeout
		Gamemanager.currentLevel += 1
		if Gamemanager.currentLevel < len(Gamemanager.levels):
			get_tree().reload_current_scene()
		else: 
			get_tree().change_scene_to_packed(menuScene)
