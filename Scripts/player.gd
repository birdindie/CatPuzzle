extends StaticBody

var ext_dir := Vector3.ZERO
var dir := Vector3.ZERO
var old_dir := Vector3.ZERO
var is_moving := false
var is_rotating := false

var is_wall1 := false
var is_push1 := false
var is_wall2 := false
var is_push2 := false
var is_wall3 := false
var is_push3 := false


onready var particles = $EfeitoMorte/Particles  # Altere para o caminho do nó de partículas, se necessário

var rota_y := 0
var old_rota_y := 0

# Variáveis de gravidade
var gravity := -100.0 # Valor da gravidade
var velocity := Vector3.ZERO # Velocidade vertical do Player
var is_on_ground := false # Flag para verificar se o Player está no chão

var stop_sound: AudioStreamPlayer3D

func _ready():
	$AnimationTree.active = true
	stop_sound = $StopSound # Substitua `$StopSound` pelo caminho correto para o nó de áudio

# Movimentação do Player
func _physics_process(delta: float) -> void:
	dir = Vector3.ZERO

	# Verifica o pressionamento contínuo das teclas de movimento
	if Input.is_action_just_released("ui_up"):
		dir = Vector3.BACK
	elif Input.is_action_just_released("ui_down"):
		dir = Vector3.FORWARD
	elif Input.is_action_just_released("ui_left"):
		dir = Vector3.RIGHT
	elif Input.is_action_just_released("ui_right"):
		dir = Vector3.LEFT

	if ext_dir != Vector3.ZERO:
		dir = ext_dir
		ext_dir = Vector3.ZERO

	#  Criado LOOP para caminho dos INIMIGOS, no Script "EnemyL1"
	if dir != Vector3.ZERO:
#		print("Vector3"+str(dir)+",") 
		pass
		
	match dir:
		Vector3.BACK: rota_y = 0
		Vector3.FORWARD: rota_y = -180
		Vector3.RIGHT: rota_y = 90
		Vector3.LEFT: rota_y = -90

	if dir != Vector3.ZERO and dir != old_dir:
		old_dir = dir
		$ray1.translation = old_dir * 2 + Vector3.UP * 2.5
		$ray2.translation = old_dir * 4 + Vector3.UP * 2.5
		$ray3.translation = old_dir * 6 + Vector3.UP * 2.5
		$ray1.force_raycast_update()
		$ray2.force_raycast_update()
		$ray3.force_raycast_update()

	if dir != Vector3.ZERO:
		# RAY 1
		if $ray1.is_colliding():
			is_wall1 = $ray1.get_collider().is_in_group("wall")
			is_push1 = $ray1.get_collider().is_in_group("block")
		else:
			is_wall1 = false
			is_push1 = false

		# RAY 2
		if $ray2.is_colliding():
			is_wall2 = $ray2.get_collider().is_in_group("wall")
			is_push2 = $ray2.get_collider().is_in_group("block")
		else:
			is_wall2 = false
			is_push2 = false

		# RAY 3
		if $ray3.is_colliding():
			is_wall3 = true
		else:
			is_wall3 = false

		# Blocked
		if is_wall1:
			$AnimationTree.set("parameters/hurt/active", true)
			get_parent().shake()

		elif is_push1 and is_wall2:
			get_parent().shake()
			$AnimationTree.set("parameters/hurt/active", true)
		elif is_push1 and is_push2 and is_wall3:
			get_parent().shake()
			$AnimationTree.set("parameters/hurt/active", true)

		# Move
		elif not is_push1 and not is_wall1:
			movement(dir)
		elif is_push1 and not is_wall2 and not is_push2:
			$ray1.get_collider().set_dir(dir)
			movement(dir)
		elif is_push1 and is_push2 and not is_wall3:
			$ray1.get_collider().set_dir(dir)
			$ray2.get_collider().set_dir(dir)
			movement(dir)

	if rota_y != old_rota_y and not is_rotating:
		is_rotating = true
		$AnimationTree.set("parameters/walk/active", true)

		$tw_r.interpolate_property($pivot, "rotation_degrees:y", old_rota_y, rota_y, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$tw_r.start()
		yield($tw_r, "tween_completed")
		old_rota_y = rota_y
		is_rotating = false
	
	#IdleSom
	if dir == Vector3.ZERO and not is_moving and not stop_sound.playing:
		stop_sound.play()
	elif dir != Vector3.ZERO or is_moving:
		stop_sound.stop()

	# Aplicar gravidade
	apply_gravity(delta)

func apply_gravity(delta: float) -> void:
	if not is_on_ground:
		# Aumentar a velocidade vertical devido à gravidade
		velocity.y += gravity * delta
		translation.y += velocity.y * delta

	# Checar colisão com o chão usando o ray_down
	if $ray_down.is_colliding():
		is_on_ground = true
		velocity.y = 0 # Reseta a velocidade vertical ao tocar o chão
		# Ajusta a posição para que fique exatamente no chão
		translation.y = $ray_down.get_collision_point().y
	else:
		is_on_ground = false

func movement(vec: Vector3) -> void:
	if not is_moving:
		is_moving = true
		$AnimationTree.set("parameters/walk/active", true)
		$MoveParticles.emitting = true # Ativar partículas se o Player estiver tentando se mover

		var a := translation
		var b := a + vec * 2
		$tw_m.interpolate_property(self, "translation", a, b, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		$tw_m.start()
		yield($tw_m, "tween_all_completed")

		is_moving = false
		$MoveParticles.emitting = false # Desativa partículas se o Player estiver parado

func extf_dir(vec: Vector3) -> void:
	ext_dir = vec

	# EFEITO E MORTE DO PLAYER
func _on_EfeitoMorte_body_entered(body):
	if body.is_in_group("enemy"):
		particles.emitting = true  # Ativa o efeito de partículas
		$"../fade/Anim".play("to_black")
		yield(get_tree().create_timer(0.5), "timeout")
		hide()
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().reload_current_scene()

	elif body.is_in_group("gas"):
		particles.emitting = true  # Ativa o efeito de partículas
		$"../fade/Anim".play("to_black")
		yield(get_tree().create_timer(0.5), "timeout")
		hide()
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().reload_current_scene()

# PUSHABLEBOX
func _on_body_entered(body):
	if body.is_in_group("pushable"):  # Certifique-se de adicionar "pushable" ao grupo do objeto
		var push_force = 50  # Ajuste a força conforme necessário / PADRÃO 10
		var direction = (body.global_transform.origin - global_transform.origin).normalized()
		body.apply_impulse(Vector3.ZERO, direction * push_force)



