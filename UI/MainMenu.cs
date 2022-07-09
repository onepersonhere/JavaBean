using Godot;
using System;

public class MainMenu : VideoPlayer {
	public async override void _Ready() {
		Autoplay = true;
		await ToSignal(GetTree().CreateTimer(0.1f), "timeout");
		GetNode<TextureRect>("../TextureRect").Hide();
	}
	
	private void OnLoginGuiInput(InputEvent @event) {
		if (@event.IsActionPressed("left_click")) {
			QueueFree();
			GetNode<MarginContainer>("../Main Menu").QueueFree();
			GetTree().ChangeScene("res://UI/Login.tscn");
		}
	}
	
	private void OnRegisterGuiInput(InputEvent @event) {
		if (@event.IsActionPressed("left_click")) {
			QueueFree();
			GetNode<MarginContainer>("../Main Menu").QueueFree();
			GetTree().ChangeScene("res://UI/Registration.tscn");
		}
	}
	
	private void _on_Register_mouse_entered() {
		GetNode<TextureRect>("../Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/Register").FlipV = true;
		GetNode<VideoPlayer>(".").Paused = true;
	}

	private void _on_Register_mouse_exited() {
		GetNode<TextureRect>("../Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/Register").FlipV = false;
		GetNode<VideoPlayer>(".").Paused = false;
	}

	private void _on_Login_mouse_entered() {
		GetNode<TextureRect>("../Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/Login").FlipV = true;
		GetNode<VideoPlayer>(".").Paused = true;
	}

	private void _on_Login_mouse_exited() {
		GetNode<TextureRect>("../Main Menu/HBoxContainer/VBoxContainer/VBoxContainer/Login").FlipV = false;
		GetNode<VideoPlayer>(".").Paused = false;
	}

	private void _on_MainMenu_finished() {
		GetNode<VideoPlayer>(".").Play();
	}

	private void _on_Options_pressed() {
		QueueFree();
		GetNode<MarginContainer>("../Main Menu").QueueFree();
		GetTree().ChangeScene("res://UI/Options.tscn");
	}
}
