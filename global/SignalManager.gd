extends Node


# 按下发送按钮时候，发送消息给gpt
signal send_button_press(content :Array)
# 更新请求接口
signal update_current_preset(preset :Dictionary)
# 添加新的预设面板
signal add_new_preset_panel
# 改变当前角色形象
signal change_canvas(path :String)
