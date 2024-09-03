extends Node2D

@onready var dialogue_timer: Timer = $Dialogue_Timer
@onready var dialogue_node: Control = %Dialogue

@onready var animation_player: AnimationPlayer = $Grapic/Pet/AnimationPlayer

enum ThemeType {
	Base,Tiny_Swords,VPet,
}

@export var theme_type : ThemeType

var animation_list := []

func _ready() -> void:
	_initialize_window()
	dialogue_timer.timeout.connect(_on_dialogue_timer)
	
	if theme_type == ThemeType.Tiny_Swords:
		animation_list = animation_player.get_animation_list()
		animation_list.remove_at(animation_list.find('全局/idle'))
		animation_list.remove_at(animation_list.find('全局/RESET'))
		$StateChange.start()
		$StateChange.timeout.connect(_on_state_change)
	elif theme_type == ThemeType.VPet:
		animation_list = $Grapic/AnimatedSprite2D.sprite_frames.get_animation_names()
		$StateChange.start()
		$StateChange.timeout.connect(_on_state_change)

func _initialize_window() -> void:
	var window: Window = get_window()
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()

func set_dialogue_label(msg:String):
	%Dialogue.set_dialogue_label(msg)

# 20s内没有任何操作，自动隐藏对话节点 ； 有操作就重新记时
func start_hide_dialogue():
	dialogue_node.show()
	dialogue_timer.start(20)

func show_dialogue():
	dialogue_node.show()

func _on_dialogue_timer():
	dialogue_node.hide()

func _on_state_change():
	if theme_type == ThemeType.Tiny_Swords:
		var idx = randi_range(0,animation_list.size()-1)
		animation_player.play(animation_list[idx])
		
		await animation_player.animation_finished
		animation_player.play('全局/idle')
		$StateChange.start(randf_range(20,30))
	elif theme_type == ThemeType.VPet:
		var idx = randi_range(0,animation_list.size()-1)
		$Grapic/AnimatedSprite2D.play(animation_list[idx])
		
		await $Grapic/AnimatedSprite2D.animation_finished
		animation_player.play('default_happy_1')
