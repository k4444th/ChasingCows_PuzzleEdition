extends Node

func _ready():
	randomize()

var currentLevel: int

var moveSpeed := 0.5

var mapDimensions := Vector2(6, 8)

var mapTileSize := Vector2(250, 250)

var levelMenuDimensions := Vector2(4, 6)

var offset := {
	"cow": Vector2(0, -60),
	"hay": Vector2(0, -30),
	"destination": Vector2(0, 0),
	"rock": Vector2(0, -35),
}

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

var levels := {
	0: {
		"moveCount": 1,
		"cows": [Vector2(1, 3)],
		"map": [
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "destination", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
		]
	},
	1: {
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
	},
	2: {
		"moveCount": 5,
		"cows": [Vector2(0, 1), Vector2(5, 1)],
		"map": [
			["", "", "", "", "", ""],
			["", "", "hay", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "destination", "", "", "", ""],
			["", "", "", "hay", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
		]
	},
	3: {
		"moveCount": 5,
		"cows": [Vector2(0, 0), Vector2(5, 0)],
		"map": [
			["", "", "rock", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "", "", "", "", ""],
			["", "destination", "", "", "", ""],
			["", "", "", "", "hay", ""],
		]
	}
}
