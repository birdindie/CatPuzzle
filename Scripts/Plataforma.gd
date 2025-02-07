extends RigidBody

export var delay_before_fall: float = 0.5  # Tempo antes da queda
export var delay_before_destruction: float = 1.0  # Tempo antes de destruir a plataforma

func _ready():
	mode = MODE_STATIC  # Inicializa como estático para impedir a queda
	
	# Verifica se o sinal já está conectado antes de conectar
	if not $Detector.is_connected("body_entered", self, "_on_Detector_body_entered"):
		$Detector.connect("body_entered", self, "_on_Detector_body_entered")

func _on_Detector_body_entered(body):
	if body.is_in_group("player"):  # Verifica se o corpo pertence ao grupo "player"
		yield(get_tree().create_timer(delay_before_fall), "timeout")  # Espera pelo tempo definido
		print("Colisão detectada com o player!")
		mode = MODE_RIGID  # Altera para modo dinâmico para iniciar a queda
		# Inicia o temporizador para destruir após a queda
		yield(get_tree().create_timer(delay_before_destruction), "timeout")
		queue_free()  # Destroi a plataforma
