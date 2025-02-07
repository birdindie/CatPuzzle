extends StaticBody  # Ou StaticBody, dependendo do tipo de nó

# Velocidade de movimento da plataforma
export var speed: float = 1.0
# Distância máxima de movimento vertical
export var max_distance: float = 2.0

# Variáveis para controle do movimento
var direction: int = 0
var start_position: Vector3
var traveled_distance: float = 0.0

func _ready():
	# Salva a posição inicial da plataforma
	start_position = global_transform.origin
	# Habilita a detecção de colisões com objetos do grupo "player"
	set_physics_process(false)  # Movimento só será processado quando necessário


func _on_Area_body_entered(body):
	# Verifica se o objeto que entrou pertence ao grupo "player"
	if body.is_in_group("player"):
		direction = 1  # Define a direção do movimento para cima
		set_physics_process(true)  # Habilita o movimento

func _on_Area_body_exited(body):
	# Verifica se o objeto que saiu pertence ao grupo "player"
	if body.is_in_group("player"):
		direction = -1  # Define a direção do movimento para baixo

func _physics_process(delta):
	if direction != 0:
		# Calcula o movimento com base na velocidade e direção
		var movement = speed * direction * delta
		global_transform.origin.y += movement
		traveled_distance += abs(movement)

		# Verifica se a plataforma atingiu a distância máxima
		if traveled_distance >= max_distance:
			direction = 0  # Para o movimento
			traveled_distance = 0.0
			global_transform.origin.y = clamp(
				global_transform.origin.y,
				start_position.y - max_distance,
				start_position.y + max_distance
			)

		# Desativa o movimento ao retornar à posição inicial
		if global_transform.origin.y == start_position.y:
			set_physics_process(false)
