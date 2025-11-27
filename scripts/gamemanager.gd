extends Node

func _ready():
	randomize()

var mapTileSize := Vector2(250, 250)

var mapTiles := [
	{
		"name": "grass",
		"imageSrc": "res://assets/levels/tiles/tileGrass_.png"
	},
	{
		"name": "destination",
		"imageSrc": "res://assets/levels/tiles/dileDestination.png"
	},
	{
		"name": "hay",
		"imageSrc": "res://assets/levels/tiles/tileHay.png"
	},
	{
		"name": "water",
		"imageSrc": "res://assets/levels/tiles/tileWater.png"
	},
	{
		"name": "mud",
		"imageSrc": "res://assets/levels/tiles/tileMud.png"
	}
]

var mapDimensions := Vector2(6, 8)

var slectedCowIdx := -1

enum directions {STANDING, UP, DOWN, LEFT, RIGHT}

var levels := {
	0: {
		"moveCount": 2,
		"cows": [Vector2(0, 0)],
		"map": [
			["", "", "", "", "hay", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "destination", "", ""],
			["", "", "", "", "", ""],
		]
	}
}
