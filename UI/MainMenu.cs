using Godot;
using System;

public class MainMenu : ColorRect {
	public override void _Ready() {
		
	}
	public override void _Process(float delta) {
		
	}
	
	private void OnNewGameGuiInput(InputEvent @event) {
		if (@event.IsActionPressed("left_click"))
			Hide();
	}
	
	private void OnContinueGuiInput(InputEvent @event) {
		if (@event.IsActionPressed("left_click"))
			Hide();
	}
	
	private void _on_Continue_mouse_entered() {
		GetNode<TextureRect>("Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/Continue").FlipV = true;
	}

	private void _on_Continue_mouse_exited() {
		GetNode<TextureRect>("Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/Continue").FlipV = false;
	}

	private void _on_NewGame_mouse_entered() {
		GetNode<TextureRect>("Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/NewGame").FlipV = true;
	}

	private void _on_NewGame_mouse_exited() {
		GetNode<TextureRect>("Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/NewGame").FlipV = false;
	}
}
