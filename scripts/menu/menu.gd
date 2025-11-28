extends MarginContainer

var defaultMargin: int = 20

@onready var viewport: Viewport = get_viewport()
@onready var levelIconsNode: Node2D = $LevelIcons
@onready var backButtonNode: TextureButton = $VBoxContainer/HBoxContainerTop/TextureButton

func _ready() -> void:
	viewport.size_changed.connect(setSafeAreaMargins)
	setSafeAreaMargins()
	levelIconsNode.setup()

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


func _on_texture_button_button_down() -> void:
	backButtonNode.position.y -= 10

func _on_texture_button_button_up() -> void:
	backButtonNode.position.y += 10
