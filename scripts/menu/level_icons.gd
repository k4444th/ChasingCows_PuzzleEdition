extends Node2D

var buttonScene := load("res://scenes/menu/level_button.tscn")

@onready var viewport: Viewport = get_viewport()

func setup():
	viewport.size_changed.connect(setScale)
	setScale()
	showLevelIcons()

func setScale():
	var containerSize = get_parent().size
	var costumScale = containerSize.x / ((Gamemanager.levelMenuDimensions.x + 0.5) * Gamemanager.mapTileSize.x)
	
	if containerSize.y * 0.75 < Gamemanager.levelMenuDimensions.y * Gamemanager.mapTileSize.y * costumScale:
		costumScale = containerSize.y / ((Gamemanager.levelMenuDimensions.x + 5) * Gamemanager.mapTileSize.y)
	
	position = Vector2(containerSize.x / 2 - ((Gamemanager.levelMenuDimensions.x / 2) * Gamemanager.mapTileSize.x) * costumScale, containerSize.y / 2 - ((Gamemanager.levelMenuDimensions.y / 2) * Gamemanager.mapTileSize.y) * costumScale)
	scale = Vector2(costumScale, costumScale)

func showLevelIcons():
	for level in Gamemanager.levels:
		var buttonInstance = buttonScene.instantiate()
		buttonInstance.position.x = (level % int(Gamemanager.levelMenuDimensions.x)) * Gamemanager.mapTileSize.x * 1.2
		buttonInstance.position.y = floor(level / Gamemanager.levelMenuDimensions.x) * Gamemanager.mapTileSize.x * 1.2
		add_child(buttonInstance)
		buttonInstance.setLevel(level)
