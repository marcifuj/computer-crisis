extends Control

@onready var status_label = $CenterContainer/Content/Status

func _ready():
    $CenterContainer/Content/StartButton.pressed.connect(_on_start_pressed)
    $CenterContainer/Content/ContinueButton.pressed.connect(_on_continue_pressed)
    $CenterContainer/Content/LearnButton.pressed.connect(_on_learn_pressed)
    $CenterContainer/Content/SettingsButton.pressed.connect(_on_settings_pressed)

func _on_start_pressed():
    status_label.text = "El modo historia estará disponible en la siguiente fase."

func _on_continue_pressed():
    status_label.text = "No hay una partida guardada todavía."

func _on_learn_pressed():
    get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")

func _on_settings_pressed():
    status_label.text = "La configuración estará disponible en una fase posterior."
