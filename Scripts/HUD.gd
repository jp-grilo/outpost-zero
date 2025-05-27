extends CanvasLayer

@onready var wave_label = $HUDRoot/container/VBoxContainer/WaveLabel as Label
@onready var timer_label = $HUDRoot/container/VBoxContainer/TimerLabel as Label
@onready var enemy_count_label = $HUDRoot/container/VBoxContainer/EnemyCountLabel as Label
@onready var coin_count_label = $HUDRoot/container/VBoxContainer/CoinCountLabel as Label

func update_wave(wave: int) -> void:
	wave_label.text = "Onda: %d" % wave
	#print("🎯 HUD: Wave atualizada para:", wave)

func update_timer(seconds: float) -> void:
	timer_label.text = "Próxima wave em: %.1f s" % seconds
	#print("⏱ HUD: Timer atualizado para: %.1f" % seconds)

func update_enemy_count(count: int) -> void:
	enemy_count_label.text = "Inimigos vivos: %d" % count
	#print("👾 HUD: Contagem de inimigos atualizada para:", count)
	
func update_coin_count(coin_count: int) -> void:
	coin_count_label.text = "Moedas: %d" % coin_count
	
	#print("👾 HUD: Contagem de inimigos atualizada para:", count)
