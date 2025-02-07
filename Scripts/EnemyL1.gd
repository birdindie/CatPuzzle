extends Spatial
# CAMINHO criado pelo PLAYER "print("Vector3"+str(dir)+",")"
var loop = [
	Vector3(1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(0, 0, -1),
	Vector3(0, 0, -1),
	Vector3(0, 0, -1),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(0, 0, 1),
	Vector3(0, 0, 1),
	Vector3(0, 0, 1),
	Vector3(1, 0, 0),
	Vector3(0, 0, 1),
	Vector3(1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(0, 0, -1),
	Vector3(1, 0, 0),
]

var id := 0

func _ready():	
	pass 

func _process(_delta):
	$Enemy1L1/pivot/body/Bacteria1_Anim/AnimationPlayer.play("OlhosAction")
	pass
	
# SIGNALS / Ativa o LOOP de movimento do INIMIGO
func _on_TimerLoop_timeout():
	$Enemy1L1.extf_dir(loop[id])
	
	id+=1
	if id == loop.size():
		id=0

