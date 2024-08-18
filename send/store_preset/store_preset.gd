extends Control

@onready var presets_container: GridContainer = %PresetsContainer
const PRESET_PANEL = preload("res://send/store_preset/preset_panel.tscn")

func _ready() -> void:
	Globals.add_new_preset_panel.connect(_load_presets)
	_load_presets()

func _load_presets():
	for preset in Globals.presets:
		var preset_panel : PresetPanel = PRESET_PANEL.instantiate()
		preset_panel.label_name = preset
		preset_panel.preset = Globals.presets[preset]
		presets_container.add_child(preset_panel)
