extends CanvasLayer

@onready var wave_label: Label = $Control/MarginContainer/HBoxContainer/TopLeftContainer/WaveLabel
@onready var enemy_count_label: Label = $Control/MarginContainer/HBoxContainer/TopLeftContainer/EnemyCountLabel
@onready var wave_progress_bar: ProgressBar = $Control/MarginContainer/TopRightContainer/WaveProgressBar
@onready var coin_count_label: Label = $Control/MarginContainer/BottomRightContainer/CoinCountLabel
@onready var wave_timer: Timer = $WaveTimer
@onready var progress_bar_label: Label = $Control/MarginContainer/TopRightContainer/ProgressBarLabel


func _ready():
	$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	progress_bar_label.text = "Próxima Onda"
	progress_bar_label.add_theme_color_override("font_color", Color.WHITE)
	_apply_hud_style(wave_label, Color("#55aaff"))
	_apply_hud_style(enemy_count_label, Color("#ff5555"))
	_apply_progressbar_style(wave_progress_bar, Color("#80d9ff"))
	wave_progress_bar.custom_minimum_size = Vector2(500, 25)  # Ajuste conforme o desejado
	_apply_hud_style(coin_count_label, Color("#00ffcc"))
	wave_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	enemy_count_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	coin_count_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
func update_wave(wave: int) -> void:
	wave_label.text = "🌌 Onda: %d" % wave

func update_enemy_count(count: int) -> void:
	enemy_count_label.text = "👾 %d" % count

func update_timer(seconds: float, total_time: float) -> void:
	wave_progress_bar.value = ((total_time - seconds) / total_time) * 100

func update_coin_count(coin_count: int) -> void:
	coin_count_label.text = "⭐ Staris: %d" % coin_count

func _apply_hud_style(label: Label, base_color: Color):
	var style = StyleBoxFlat.new()
	style.bg_color = base_color.darkened(0.2)
	style.border_color = base_color.lightened(0.5)
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0, 0, 0, 0.6)
	style.shadow_size = 6
	style.anti_aliasing = true

	label.add_theme_stylebox_override("normal", style)
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color.WHITE)

func _apply_progressbar_style(progress_bar: ProgressBar, base_color: Color):
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color("#222222")
	bg_style.set_corner_radius_all(8)
	bg_style.set_border_width_all(2)
	bg_style.border_color = base_color.lightened(0.5)
	bg_style.shadow_color = Color(0, 0, 0, 0.6)
	bg_style.shadow_size = 4
	bg_style.anti_aliasing = true
	progress_bar.add_theme_stylebox_override("background", bg_style)

	var fg_style = StyleBoxFlat.new()
	fg_style.bg_color = base_color
	fg_style.set_corner_radius_all(8)
	progress_bar.add_theme_stylebox_override("fill", fg_style)

	progress_bar.max_value = 100
	progress_bar.value = 0
