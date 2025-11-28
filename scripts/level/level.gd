extends MarginContainer

var defaultMargin: int = 20

var length: int = 50
var startPos: Vector2
var currentPos: Vector2
var swiping := false
var threshold: int = 10

@onready var viewport: Viewport = get_viewport()
@onready var mapNode: Node2D = $Map
@onready var progressBarNode: ProgressBar = $VBoxContainer/HBoxContainerBottom/VBoxContainer/ProgressBar
@onready var moveCounterNode: HBoxContainer = $VBoxContainer/HBoxContainerBottom/MoveCounter
@onready var backButtonNode: TextureButton = $VBoxContainer/HBoxContainerTop/BackButton
@onready var resetButtonNode: TextureButton = $VBoxContainer/HBoxContainerTop/ResetButton

var menuScene: PackedScene = preload("res://scenes/menu/menu.tscn")

func _ready() -> void:
	viewport.size_changed.connect(setSafeAreaMargins)
	setSafeAreaMargins()
	mapNode.setLevel()
	progressBarNode.max_value = Gamemanager.levels[Gamemanager.currentLevel]["moveCount"]
	mapNode.connect("cowMoved", updateProgressBar)
	moveCounterNode.get_child(0).text = str(Gamemanager.levels[Gamemanager.currentLevel]["moveCount"])
	moveCounterNode.get_child(2).text = str(Gamemanager.levels[Gamemanager.currentLevel]["moveCount"])
	resetButtonNode.disabled = true

func setSafeAreaMargins():
	var rect = DisplayServer.get_display_safe_area()
	var screenSize = DisplayServer.screen_get_size()

	var aspectX = size.x / screenSize.x
	var aspectY = size.y / screenSize.y
	
	var margins = {
		"left": rect.position.x * aspectX + defaultMargin,
		"top": rect.position.y * aspectY + defaultMargin,
		"right": (screenSize.x - (rect.position.x + rect.size.x)) * aspectX + defaultMargin,
		"bottom": (screenSize.y - (rect.position.y + rect.size.y)) * aspectY + defaultMargin
	}

	add_theme_constant_override("margin_left", margins.left)
	add_theme_constant_override("margin_top", margins.top)
	add_theme_constant_override("margin_right", margins.right)
	add_theme_constant_override("margin_bottom", margins.bottom)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			swiping = true
			startPos = event.position
		else:
			swiping = false
	
	if event is InputEventMouseMotion and swiping:
		currentPos = event.position
		if startPos.distance_to(currentPos) >= length:
			if abs(startPos.y - currentPos.y) <= threshold:
				mapNode.moveCow(startPos, Vector2(1 if startPos.x < currentPos.x else -1, 0))
				swiping = false
			elif abs(startPos.x - currentPos.x) <= threshold:
				mapNode.moveCow(startPos, Vector2(0, 1 if startPos.y < currentPos.y else -1))
				swiping = false

func updateProgressBar(movesLeft: int):
	var valueTween = get_tree().create_tween()
	valueTween.tween_property(progressBarNode, "value", movesLeft, 0.25)
	await valueTween.finished
	moveCounterNode.get_child(0).text = str(movesLeft)
	
	if progressBarNode.value < progressBarNode.max_value:
		resetButtonNode.disabled = false

func _on_reset_button_button_down() -> void:
	resetButtonNode.position.y -= 10

func _on_reset_button_button_up() -> void:
	resetButtonNode.position.y += 10
	
func _on_reset_button_pressed() -> void:
	mapNode.resetGame(Gamemanager.levels[Gamemanager.currentLevel])
	moveCounterNode.get_child(0).text = str(Gamemanager.levels[Gamemanager.currentLevel]["moveCount"])
	var valueTween = get_tree().create_tween()
	valueTween.tween_property(progressBarNode, "value", Gamemanager.levels[Gamemanager.currentLevel]["moveCount"], 0.25)
	resetButtonNode.disabled = true
	mapNode.cowMoving = false

func _on_back_button_button_down() -> void:
	backButtonNode.position.y -= 10

func _on_back_button_button_up() -> void:
	backButtonNode.position.y += 10

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(menuScene)
