extends Control

@onready var presets_container: GridContainer = %PresetsContainer
const PRESET_PANEL = preload("res://send/store_preset/preset_panel.tscn")

func _ready() -> void:
	Globals.add_new_preset_panel.connect(_load_presets)
	_load_presets()

func _load_presets():

		# 清除现有的预设面板
	for child in presets_container.get_children():
		if child is PresetPanel:
			child.queue_free()

	for preset in Globals.presets:
		var preset_panel : PresetPanel = PRESET_PANEL.instantiate()
		preset_panel.panel_type = PresetPanel.PanelType.PresetType
		preset_panel.label_name = preset
		preset_panel.preset = Globals.presets[preset]
		presets_container.add_child(preset_panel)
