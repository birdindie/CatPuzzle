extends Spatial

func _ready():
	pass
	
func _process(delta):
	$Pas.rotate(Vector3(0,0,1), PI * 1 * delta)
	$CataventoMotor.rotate(Vector3(0,0,1), PI * 1 * delta)
	pass
