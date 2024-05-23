extends Node2D


## The main screen the app uses.


func _ready() -> void:
	_initialize_window()
	

func _initialize_window() -> void:
	# You don't need to change all of these settings via a function during
	# runtime since you can set them from the settings menu at Project ->
	# Project Settings -> Window.
	var window: Window = get_window()
	# Setting the viewport width and height from the project settings still
	# displays the boot splash, which is undesirable for a transparent app.
	# To avoid this, set the viewport width and height from the project
	# settings to 0, and then use the two functions provided below. You can
	# read the documentation for these functions to learn about what they do.
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()
#	window.always_on_top = true
#	window.borderless = true
	# Enabling Per Pixel Transparency -> Allowed through code doesn't work, as
	# the global variables ProjectSettings contain aren't updated when changed.
	# Make sure to enable it via the Project Settings menu.
#	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed",
#			true)
#	window.transparent = true
	# If you have multiple windows in your project, you can
	# modify the additional viewports' settings from the inspector.
#	window.transparent_bg = true
