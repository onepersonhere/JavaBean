using Godot;
using System;

public class MainMenu : VideoPlayer {
	public override void _Ready() {
		
	}
	public override void _Process(float delta) {
		
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
			GetTree().ChangeScene("res://World/World.tscn");
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
}
