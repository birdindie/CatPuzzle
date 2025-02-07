extends Spatial

func _ready():
	pass
	
func _process(delta):
	$BaseGiratoria.rotate(Vector3(0,1,0), PI * 0.2 * delta)
#	$CataventoMotor.rotate(Vector3(0,0,1), PI * 1 * delta)
	
# Morte do Player
func _on_DeathGuicho_body_entered(body):	
	if body.is_in_group("player"):
		$fade/Anim.play("to_black")	
		print("Player entrou em uma área de morte!")			  
		# Adiciona um timer antes de reiniciar a cena
		yield(get_tree().create_timer(1.0), "timeout") # Aguardar 2 segundos
		# Reiniciar a cena		
		get_tree().reload_current_scene()

