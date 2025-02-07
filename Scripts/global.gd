extends Node

var audio_enabled = true  # Estado global do áudio

var current_level: int = 1  # Armazena o Level atual

var is_sound_on: bool = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("save"):
		var new_scene_data = self.duplicate()
		var new_scene = PackedScene.new()		
		for c in new_scene_data.get_children():
			c.owner = new_scene_data
			new_scene.pack(new_scene_data)
			ResourceSaver.save("user://jogo_salvo.tscn", new_scene)
			get_tree().reload_current_scene()
#
#	if Input.is_action_just_released("load"):
		var file = File.new()  # Cria uma instância da classe File
		if file.file_exists("user://jogo_salvo.tscn"):
			var _saved_scene = load("user://jogo_salvo.tscn")  # Carrega a cena
			if _saved_scene is PackedScene:  # Verifica se o arquivo carregado é uma cena válida
				var instance = _saved_scene.instance()  # Instancia a cena
				get_tree().get_root().add_child(instance)  # Adiciona a cena instanciada ao SceneTree#				
				get_tree().change_scene_to(_saved_scene)  # Define a cena atual
#				get_tree().set_current_scene(instance) # ANTIGO
