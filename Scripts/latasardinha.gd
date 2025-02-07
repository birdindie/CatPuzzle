extends Area

onready var particles = $Particles  # Altere para o caminho do nó de partículas, se necessário
onready var som_coleta = $SomColeta

func _on_latasardinha_body_entered(body):
	if body.is_in_group("player"):			
		som_coleta.play()  # Toca o som de coleta
		particles.emitting = true  # Ativa o efeito de partículas
		yield(get_tree().create_timer(0.2), "timeout")  # Pausa antes de remover o item
		queue_free()			
		get_parent().add_apple()
