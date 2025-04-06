extends Control

var fps_label  # Referência ao Label que exibirá o FPS

func _ready():
	ajusta_hud_para_tela()
	get_viewport().connect("size_changed", self, "ajusta_hud_para_tela")  # Conexão correta para Godot 3.6
	fps_label = $FPSLabel  # Referência ao Label que exibirá o FPS
	fps_label.text = "FPS: 0"  # Inicializa o texto do FPS

func _process(_delta):
	# Atualiza o FPS a cada frame
	var fps = Engine.get_frames_per_second()
	fps_label.text = "FPS: %d" % fps

func ajusta_hud_para_tela():
	var screen_size = get_viewport_rect().size
	var base_size = Vector2(1920, 1080)  # Resolução de referência
	var scale_factor = screen_size / base_size

	for child in get_children():
		if child is Control:
			child.rect_min_size *= scale_factor  # Ajusta tamanho mínimo do Control
