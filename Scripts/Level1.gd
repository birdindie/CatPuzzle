extends Spatial

# Variáveis exportadas para configuração do nível e quantidade de itens (maçãs)
export(int) var next_level := 1
export(int) var apples := 1 # Coleta o Item para seguir para o próximo NÍVEL
var apple_added := 0

# Timer para reiniciar o level e Label para exibir o tempo
var level_timer: Timer
var timer_label: Label
var seconds := 2 # Timer para mudança de Level

# Variáveis para controle de toque na tela / mouse
var pos1 := Vector2.ZERO # Posição inicial do toque ou clique

# Variável para movimentação da água
var water_height := 1.5

# Variáveis para tela de carregamento
var loading_screen_path = "res://Scenes/LoadingScreen.tscn"
var loading_screen = null
var progress_bar = null
var progress_timer = null

# Controle de música de fundo e som
var is_sound_on := true
onready var sound_toggle_button := $HUDPRINCIPAL/SoundToggleButton

func _ready():
	# Atualiza o label do nível na HUD
	var level_label = $HUDPRINCIPAL/CanvasLayer/Label 
	level_label.text = "Level: " + str(next_level)
	
	# Configura a visibilidade da água e ajusta o shader do fade
	$Water.visible = true
	var ratio = get_viewport().size.x / get_viewport().size.y
	var shader = $fade.material
	shader.set_shader_param("aspec_rato", ratio)	
	$fade.visible = true
	$fade/Anim.play("to_zero")
	
	# Cria e inicia o timer para reiniciar o level
	level_timer = Timer.new()
	level_timer.wait_time = 60  # MUDAR PARA 30 ou 60 SEGUNDOS
	level_timer.one_shot = true  # Dispara apenas uma vez
	level_timer.connect("timeout", self, "_on_Timer2_timeout")
	add_child(level_timer)
	level_timer.start()  # Inicia o temporizador

	# Referência ao label do timer na HUD
	timer_label = $HUDPRINCIPAL/CanvasLayer/TimerIcon/TimerLabel
		
	# Configura o som de fundo com base na variável global
	if Global.is_sound_on:
		MusicManager.play_music()
		sound_toggle_button.text = "ON"
	else:
		MusicManager.stop_music()
		sound_toggle_button.text = "OFF"

func _on_SoundToggleButton_pressed():
	MusicManager.toggle_music()
	if Global.is_sound_on:
		sound_toggle_button.text = "ON"
	else:
		sound_toggle_button.text = "OFF"

		
# INÍCIO - Movimentação com ScreenTouch / MOUSE
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			pos1 = event.position			
		else:
			calcul_swipe(event.position)
			
func calcul_swipe(pos2: Vector2) -> void:
	var pos = pos2 - pos1
	if pos.length() > 100:
		var a = rad2deg(pos.angle()) + 180
		var i = int(a / 90)
		match i:
			0:
				$player.extf_dir(Vector3.BACK)
			1:
				$player.extf_dir(Vector3.LEFT)
			2:
				$player.extf_dir(Vector3.FORWARD)
			3:
				$player.extf_dir(Vector3.RIGHT)
# FIM - Movimentação com ScreenTouch / MOUSE
	
func _process(_delta):
	# Atualiza o movimento da água e o ângulo da câmera
	$Water.translation.y = lerp($Water.translation.y, water_height, 0.15)
	$Cam/Camera.rotation_degrees.z = lerp($Cam/Camera.rotation_degrees.z, 0.0, 0.15)
	
	# Atualiza o label do timer com o tempo restante
	if level_timer and timer_label:
		var time_left = int(level_timer.time_left)
		timer_label.text = str(time_left)

func _on_Timer2_timeout():
	# Reinicia a cena atual quando o timer expira
	get_tree().reload_current_scene()
	
	# Atualiza a barra de progresso da tela de carregamento, se aplicável
	if progress_timer and progress_bar:
		var total_time = progress_timer.wait_time
		var elapsed_time = total_time - progress_timer.time_left
		progress_bar.value = (elapsed_time / total_time) * 100

func _on_loading_complete():
	# Quando o timer da tela de carregamento expira, remove a tela de carregamento
	loading_screen.queue_free()

# Morte do Player
func _on_DeathZones_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		$fade/Anim.play("to_black")
		print("Player entrou em uma área de morte!")
		# Aguarda 1 segundo antes de reiniciar a cena
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().reload_current_scene()

func _on_salvar_pressed():
	print("Salvo")
	# Carrega e instancia a tela de carregamento
	loading_screen = load(loading_screen_path).instance()
	get_tree().get_root().add_child(loading_screen)
	
	# Aguarda um frame para garantir que a tela de carregamento seja renderizada imediatamente
	yield(get_tree(), "idle_frame")
	
	# Acessa os nós da barra de progresso e do timer da tela de carregamento
	progress_bar = loading_screen.get_node("CanvasLayer/MarginContainer/ProgressBar")  # Ajuste o caminho se necessário
	progress_timer = loading_screen.get_node("CanvasLayer/MarginContainer/ProgressTimer")  # Ajuste o caminho se necessário
	
	# Conecta o sinal do temporizador ao método que finalizará o carregamento
	progress_timer.connect("timeout", self, "_on_loading_complete")
	
	# Inicia o temporizador da tela de carregamento
	progress_timer.start()
	
	# Realiza a duplicação e o salvamento do estado atual do jogo
	var new_scene_data = self.duplicate()
	var new_scene = PackedScene.new()
	# Ajusta o owner de cada nó e empacota a cena
	for c in new_scene_data.get_children():
		c.owner = new_scene_data
	new_scene.pack(new_scene_data)
	# Salva o novo PackedScene em um arquivo no diretório do usuário
	ResourceSaver.save("user://jogo_salvo.tscn", new_scene)

func _on_load_pressed():
	# Recarrega a cena atual
	var _err = get_tree().reload_current_scene()

# Water: Ajusta a altura e o intervalo do timer aleatoriamente
func _on_Timer_timeout():
	randomize()
	water_height = rand_range(2.0, 2.5)
	$Timer.wait_time = rand_range(0.1, 0.6)
	
func shake() -> void:
	$Cam/Camera.rotation_degrees.z = -3
	
# Passando de NÍVEL
func add_apple() -> void:				
	apple_added += 1				
	if apple_added == apples:				
		var file = File.new()
		if file.file_exists("res://Scenes/Level" + str(next_level) + ".tscn"):
			Global.current_level = next_level  # Atualiza o nível global
			yield(get_tree().create_timer(seconds), "timeout")
			var _err = get_tree().change_scene("res://Scenes/Level" + str(next_level) + ".tscn")
		else:
			print("Game Over")

func _on_home_pressed():
	# Volta para a tela inicial (Menu)
	var _err = get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_TextureButton_pressed():
	pass # Função reservada para futuros ajustes.
