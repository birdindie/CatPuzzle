extends StaticBody

var dir = Vector3.ZERO
var is_moving := false

# Tempo total da explosão em segundos
var explosion_time := 60.0
# Variável que guarda o tempo restante
var time_left := explosion_time

# Nó Area para detecção de colisões (já existente)
onready var area = $Area
# Label que exibirá o timer na tela (certifique-se de que o Label está na cena e com o mesmo nome)
onready var timer_label = $HUDTNT/TNT_Icon_Container/ViewportContainer/TimerLabel
# Nó de partículas de explosão (criado conforme o passo anterior)
onready var explosion_particles = $Explosion

func _ready():	
	# Certifica que as partículas não estão emitindo ao iniciar
	explosion_particles.emitting = false

func _process(delta):
	# Verifica e atualiza a movimentação
	if dir != Vector3.ZERO:
		movement(dir)
		
	# Atualiza o timer na tela
	if time_left > 0:
		time_left -= delta
		# Atualiza o texto do label para mostrar o tempo restante com uma casa decimal
		timer_label.text = String(round(time_left * 1) / 1.0)
	
	# Quando o tempo acabar, destrói o objeto
	if time_left <= 0:
		queue_free()

func set_dir(vec:Vector3) -> void:
	dir = vec

func movement(vec:Vector3) -> void:
	if is_moving == false:
		is_moving = true
		var a := translation
		var b := a + vec * 2
		$tw_m.interpolate_property(self, "translation", a, b, 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		$tw_m.start()
		yield($tw_m, "tween_all_completed")
		dir = Vector3.ZERO
		
		if $ray_down.is_colliding() == false:
			var c = b + Vector3.DOWN * 2
			$tw_m.interpolate_property(self, "translation", b, c, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
			$tw_m.start()
			$MeshInstance.translation.y += -0.1
		
		is_moving = false

# Sinal de colisão da Área de detecção
func _on_Area_body_entered(body: Node) -> void:		
	if body.is_in_group("gas"):

		# Ativa as partículas de explosão
		explosion_particles.emitting = true

		# Destroi o objeto atingido
		body.queue_free()

		# (Opcional) Caso queira aguardar um breve tempo para exibir a explosão antes de destruir a dinamite
		yield(get_tree().create_timer(0.4), "timeout")

		# Destroi a dinamite
		queue_free()
			
# Ativa Animação da TNT para o player
func _on_AreaAnim_body_entered(body):			
	if body.is_in_group("player"):
		$AreaAnim/AtivaTNT/tnt/AnimationPlayer.play("Start")

