extends Control

const COMPONENTS = {
    "CPU": {
        "title": "CPU",
        "description": "Es el componente que ejecuta instrucciones y realiza operaciones necesarias para que funcionen los programas.",
        "visual_title": "EJECUCIÓN DE INSTRUCCIONES",
        "visual_flow": "PROGRAMA\n↓\nCPU\n↓\nRESULTADO"
    },
    "RAM": {
        "title": "RAM",
        "description": "Es una memoria que almacena temporalmente los datos y programas que el computador está utilizando.",
        "visual_title": "MEMORIA DE TRABAJO",
        "visual_flow": "PROGRAMA\n↓\nRAM\n↓\nCPU"
    },
    "CACHE": {
        "title": "CACHÉ",
        "description": "Es una memoria pequeña y rápida que ayuda a la CPU a acceder rápidamente a datos que necesita con frecuencia.",
        "visual_title": "ACCESO RÁPIDO",
        "visual_flow": "CPU\n↓\nCACHÉ\n↓\nDATOS FRECUENTES"
    },
    "STORAGE": {
        "title": "ALMACENAMIENTO",
        "description": "Guarda información de manera persistente, incluso cuando el computador se apaga.",
        "visual_title": "INFORMACIÓN PERSISTENTE",
        "visual_flow": "ARCHIVOS\n↓\nSSD / ALMACENAMIENTO"
    },
    "BUS": {
        "title": "BUS",
        "description": "Permite la comunicación y transferencia de información entre diferentes componentes del computador.",
        "visual_title": "COMUNICACIÓN",
        "visual_flow": "CPU ↔ RAM\n↕\nALMACENAMIENTO"
    }
}

var discovered: Dictionary = {}
var selected_component: String = ""

@onready var progress_label: Label = $MainContent/TopBar/Progress
@onready var component_buttons: Dictionary = {
    "CPU": $MainContent/Body/ComponentPanel/ComponentContent/ComponentList/CPUButton,
    "RAM": $MainContent/Body/ComponentPanel/ComponentContent/ComponentList/RAMButton,
    "CACHE": $MainContent/Body/ComponentPanel/ComponentContent/ComponentList/CacheButton,
    "STORAGE": $MainContent/Body/ComponentPanel/ComponentContent/ComponentList/StorageButton,
    "BUS": $MainContent/Body/ComponentPanel/ComponentContent/ComponentList/BusButton
}
@onready var selected_name: Label = $MainContent/Body/InfoPanel/InfoContent/SelectedName
@onready var description_label: Label = $MainContent/Body/InfoPanel/InfoContent/Description
@onready var visual_title: Label = $MainContent/Body/InfoPanel/InfoContent/VisualTitle
@onready var visual_flow: Label = $MainContent/Body/InfoPanel/InfoContent/VisualFlow
@onready var hint_label: Label = $MainContent/Body/InfoPanel/InfoContent/Hint
@onready var completion_panel: PanelContainer = $CompletionPanel

func _ready():
    for component_id in component_buttons:
        component_buttons[component_id].pressed.connect(_on_component_selected.bind(component_id))

    $MainContent/TopBar/BackButton.pressed.connect(_on_back_pressed)
    $MainContent/Body/InfoPanel/InfoContent/FinishTutorialButton.pressed.connect(_on_finish_tutorial_pressed)
    $CompletionPanel/CompletionContent/ReturnMenuButton.pressed.connect(_on_back_pressed)

    _update_progress()
    _show_empty_state()

func _on_component_selected(component_id: String):
    selected_component = component_id
    discovered[component_id] = true

    var component = COMPONENTS[component_id]
    selected_name.text = component.title
    description_label.text = component.description
    visual_title.text = component.visual_title
    visual_flow.text = component.visual_flow
    hint_label.text = "Componente descubierto. Explora los demás para completar el tutorial."

    _update_button_states()
    _update_progress()
    _animate_info_panel()

    _update_finish_button()

func _update_finish_button():
    var finish_button: Button = $MainContent/Body/InfoPanel/InfoContent/FinishTutorialButton
    finish_button.visible = discovered.size() == COMPONENTS.size()
    finish_button.disabled = discovered.size() != COMPONENTS.size()

func _update_progress():
    progress_label.text = "COMPONENTES DESCUBIERTOS   %d / %d" % [discovered.size(), COMPONENTS.size()]

func _update_button_states():
    for component_id in component_buttons:
        var button: Button = component_buttons[component_id]

        if component_id == selected_component:
            button.self_modulate = Color(0.35, 0.9, 1.0, 1.0)
        elif discovered.has(component_id):
            button.self_modulate = Color(0.55, 1.0, 0.7, 1.0)
        else:
            button.self_modulate = Color.WHITE

func _show_empty_state():
    selected_name.text = "SELECCIONA UN COMPONENTE"
    description_label.text = "Explora los componentes para descubrir qué función cumple cada uno. No hay respuestas correctas o incorrectas en este tutorial."
    visual_title.text = "EXPLORA EL COMPUTADOR"
    visual_flow.text = "CPU  ↔  RAM\n↕       ↕\nCACHÉ  BUS\n     ↕\nALMACENAMIENTO"
    hint_label.text = "Selecciona un componente para comenzar."
    _update_button_states()

func _animate_info_panel():
    var info_panel = $MainContent/Body/InfoPanel
    info_panel.modulate = Color(0.65, 0.9, 1.0, 0.75)
    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(info_panel, "modulate", Color.WHITE, 0.25)

func _on_finish_tutorial_pressed():
    completion_panel.visible = true
    $CompletionPanel/CompletionContent/CompletionTitle.text = "¡TUTORIAL COMPLETADO!"
    $CompletionPanel/CompletionContent/CompletionMessage.text = "Ya exploraste CPU, RAM, caché, almacenamiento y bus. Ahora puedes volver al menú."

func _on_back_pressed():
    get_tree().change_scene_to_file("res://scenes/main/main.tscn")

