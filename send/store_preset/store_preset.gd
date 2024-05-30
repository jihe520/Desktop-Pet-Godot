extends Control

@onready var presets_container: GridContainer = %PresetsContainer

func _ready() -> void:
	Globals.add_new_preset_button.connect(_change_type_load_presets)
	_load_presets(Globals.presets)

func _change_type_load_presets(preset :Dictionary):
	_load_presets({preset['name']:preset})

func _load_presets(presets :Dictionary):
	for preset in presets.values():
		var button := Button.new()
		button.text = preset['name']
		button.pressed.connect(_select_presets.bind(preset))
		presets_container.add_child(button)

func _select_presets(preset :Dictionary):
	Globals.current_preset = preset
	Globals.update_request.emit(preset)
