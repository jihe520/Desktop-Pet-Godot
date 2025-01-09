<h1 align="center">🐶 Godog 🐶</h1>
<h2 align="center">AI Godot Desktop Pet</h2>

[简体中文](README.md) / English

## 👋 Introduction

🚀 🚀 🚀 A desktop AI pet powered by a large language model and made with Godot. This project aims to provide a versatile and rich desktop AI pet. You can use it as a foundation to create your own unique pet image and character behavior.

- Using Godot: lightweight, simple development, provides animation, control UI framework, etc.
- Compatible with many large language models
- Pre-made character feature with multiple appearances
- Supports multi-modal capabilities
- Easy to build your own AI desktop pet on this basis

![](/img/example.png)

## 📙 User Manual

### ⬇️ Installation

Download: Check `release`

### 🔑 Usage
1. Click `Edit Preset`, fill in the name and API Key, and click **Save (Modify)**
2. Click `Store Preset` and select the preset you just added
3. Start the conversation

> [!Caution]
> Currently, only OpenAI's vision capability (VISION) is supported. It is recommended to use the **gpt-4o** model.
> You can use other models, but multi-modal capabilities are not supported.

### ⌨️ Shortcuts
- **Right-click** on the character area to pop up the dialog box
- When the focus is on the character window, press **ESC** to close the software

## 🚦 Development Plan

- [ ] Add support for multiple languages
- [ ] Add more personalized character animations, mechanisms, events
- [ ] Add support for more models
- [ ] Add support for Markdown syntax rendering in the dialog box
- [ ] Add multi-modal capabilities such as voice, file upload, etc.
- [ ] Add more presets
- [ ] Add more character theme settings for easy import

## 🐶 Developing Your Own Desktop Pet

With Godot's lightweight and easy-to-learn nature, you can easily create your own unique desktop pet image.

### 🐾 Steps

1. Prepare a set of character frames: You can check [itch.io](https://itch.io/game-assets), choose a set you like and download it, **be mindful of copyright if not for personal use**.
2. Godot! Start! [Download](https://godotengine.org/download/windows/)
3. Review and learn the official documentation: Don’t be afraid, Godot is simple. Check out [Animation](https://docs.godotengine.org/en/4.2/tutorials/animation/index.html).
4. Development (continue...)

5. [Export](https://docs.godotengine.org/en/4.x/tutorials/export/index.html)

### 🏗️ Project Structure

```css
- root(Window)
	- Globals(Node)
	- App(Node)
	- Canvas(Node2D) - Character part
		- Graphic(Node2D) - Display area and character management
		- Dialogue(Control) - Dialog display
	- Send(Window) - Send message
		- TabContainer(TabContainer)
		- Dialog tab(Control)
		- Store preset(Control)
		- Edit preset(Control)
			- Model(PanelContainer)
			- Parameters(PanelContainer)
```

### 🔊 Notes

> [!Caution]
> 1. The Godot version used for development is 4.3 stable, Godot4 should work as well (not tested)
> 2. Remember to scale the imported character assets appropriately and adjust the display area (ClickPolygon) size
> 3. In the upper right corner of Godot, select **Compatibility Mode**

## 🤝 Contributions

The project is currently under development and has many bugs that I am working to fix.
Any contributions are welcome, even small ones.
Adding character assets, etc.

## ©️ License

You can use any code snippet from the project, but you cannot directly package and sell the complete project.
Additionally, pay attention to the copyright information of some assets used in the project.

## ❤️ Acknowledgements

Thanks to the following open-source projects and amazing assets, without which this project would not exist:

- [ChatGPT-stream-for-Godot-4](https://github.com/oceanbuilders/ChatGPT-stream-for-Godot-4) - Support for stream output
- [godot-click-through-transparent-window](https://github.com/atadenizoktay/godot-click-through-transparent-window) - Transparent window
- [tech-dungeon-roguelite](https://trevor-pupkin.itch.io/tech-dungeon-roguelite) - Character assets
- [tiny-swords](https://pixelfrog-assets.itch.io/tiny-swords) - Character assets
- [dino-characters](https://arks.itch.io/dino-characters) - Character assets
- [VPet](https://github.com/LorisYounger/VPet) - Character assets
