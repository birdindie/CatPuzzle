extends Control

func _ready():
	ajusta_hud_para_tela()
	get_viewport().connect("size_changed", self, "ajusta_hud_para_tela")  # Conexão correta para Godot 3.6

func ajusta_hud_para_tela():
	var screen_size = get_viewport_rect().size
	var base_size = Vector2(1920, 1080)  # Resolução de referência
	var scale_factor = screen_size / base_size

	for child in get_children():
		if child is Control:
			child.rect_min_size *= scale_factor  # Ajusta tamanho mínimo do Control
