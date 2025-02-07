extends CanvasLayer

export(Texture) var empty_cursor = null
export(Texture) var default_cursor = null

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)

func _process(_delta):
	$CursoMouse.global_position = $CursoMouse.get_global_mouse_position()
