extends Node


# 按下发送按钮时候，发送消息给gpt
signal send_button_press(content :Array)
# 更新请求接口
signal update_current_preset(presets :Dictionary)

signal add_new_preset_panel

signal change_canvas(path :String)
