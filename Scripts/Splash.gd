extends Control  # Mantemos como Control para gerenciar elementos UI

# Tempo de exibição da splash screen (em segundos)
const SPLASH_DURATION = 3.0  

var progress_bar  # Barra de fundo da progressão
var progress_fill # Barra de preenchimento

func _ready():
	# Criar a imagem de fundo da Splash Screen
	var splash_image = TextureRect.new()
	splash_image.texture = load("res://Ui/Img/Splash.png")  # Caminho correto da imagem
	splash_image.rect_min_size = get_viewport_rect().size
	splash_image.rect_size = get_viewport_rect().size
	splash_image.rect_position = Vector2.ZERO
	splash_image.expand = true
	splash_image.stretch_mode = TextureRect.STRETCH_SCALE
	add_child(splash_image)

	# Criar a barra de fundo
	progress_bar = NinePatchRect.new()
	progress_bar.texture = load("res://Ui/Img/barra_fundo.png")  # Textura do fundo
	progress_bar.rect_min_size = Vector2(get_viewport_rect().size.x * 0.5, 30)  # Largura 50% da tela, altura 30px
	progress_bar.rect_position = Vector2(
		(get_viewport_rect().size.x - progress_bar.rect_min_size.x) / 2,  # Centraliza no eixo X
		get_viewport_rect().size.y * 0.9  # Posição 90% para baixo na tela
	)
	add_child(progress_bar)

	# Criar a barra de preenchimento
	progress_fill = NinePatchRect.new()
	progress_fill.texture = load("res://Ui/Img/barra_preenchimento.png")  # Textura do preenchimento
	progress_fill.rect_min_size = Vector2(0, 30)  # Começa vazia
	progress_fill.rect_position = progress_bar.rect_position  # Alinha com a barra
	add_child(progress_fill)

	# Iniciar o preenchimento da barra
	start_progress_bar()

func start_progress_bar():
	# Tempo para cada 1% da barra
	var step_time = SPLASH_DURATION / 100.0
	for i in range(101):
		# Atualiza o preenchimento da barra com base no progresso
		progress_fill.rect_min_size.x = (progress_bar.rect_min_size.x * i) / 100.0  # Aumenta a largura
		yield(get_tree().create_timer(step_time), "timeout")  # Espera um pouco antes de aumentar

	# Quando atingir 100%, muda para a cena
	_change_scene()

func _change_scene():
	var scene_path = "res://Scenes/Menu.tscn"  # Ajuste o caminho se necessário
	if ResourceLoader.exists(scene_path):  
		get_tree().change_scene(scene_path)  # Troca para a cena Menu
	else:
		print("Erro: Cena não encontrada em", scene_path)
