extends VBoxContainer

onready var current_language = TranslationServer.get_locale()

func _ready() -> void:
	$btn_en.connect("pressed", self, "on_button_pressed", ["en_US"])
	$btn_es.connect("pressed", self, "on_button_pressed", ["es_ES"])
	$btn_de.connect("pressed", self, "on_button_pressed", ["de_DE"])
	
func on_button_pressed(language) -> void:
	TranslationServer.set_locale(language)
	current_language = language
