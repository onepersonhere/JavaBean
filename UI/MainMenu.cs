using Godot;
using System;

public class MainMenu : VideoPlayer {
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
		GetNode<VideoPlayer>(".").Paused = true;
	}

	private void _on_Continue_mouse_exited() {
		GetNode<TextureRect>("Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/Continue").FlipV = false;
		GetNode<VideoPlayer>(".").Paused = false;
	}

	private void _on_NewGame_mouse_entered() {
		GetNode<TextureRect>("Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/NewGame").FlipV = true;
		GetNode<VideoPlayer>(".").Paused = true;
	}

	private void _on_NewGame_mouse_exited() {
		GetNode<TextureRect>("Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/NewGame").FlipV = false;
		GetNode<VideoPlayer>(".").Paused = false;
	}

	private void _on_MainMenu_finished() {
		GetNode<VideoPlayer>(".").Play();
	}
}
