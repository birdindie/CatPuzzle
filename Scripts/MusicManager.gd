extends Node

onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	# Garante que a música comece se o som estiver ativo
	if Global.is_sound_on:
		play_music()

func play_music():
	if music_player.stream != null and not music_player.playing and Global.is_sound_on:
		music_player.play()

func stop_music():
	if music_player.playing:
		music_player.stop()

func toggle_music():
	Global.is_sound_on = !Global.is_sound_on
	if Global.is_sound_on:
		play_music()
	else:
		stop_music()
