extends Node2D

@onready var dialogue_timer: Timer = $Dialogue_Timer
@onready var dialogue_node: Control = %Dialogue
@onready var pet: Sprite2D = $Grapic/Pet

@onready var animation_player: AnimationPlayer = $Grapic/Pet/AnimationPlayer

@export var isCanSwitch : bool

var animation_list := []

func _ready() -> void:
	_initialize_window()
	dialogue_timer.timeout.connect(_on_dialogue_timer)
	
	if isCanSwitch:
		animation_list = animation_player.get_animation_list()
		animation_list.remove_at(animation_list.find('tiny_swords/idle'))
		animation_list.remove_at(animation_list.find('tiny_swords/RESET'))
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
	var idx = randi_range(0,animation_list.size()-1)
	animation_player.play(animation_list[idx])
	
	await animation_player.animation_finished
	animation_player.play('tiny_swords/idle')
	$StateChange.start(randf_range(20,30))
