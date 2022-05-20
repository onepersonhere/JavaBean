using Godot;
using System;

public class Item : Node2D
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        if(GD.Randi() % 2 == 0) {
            GetNode<TextureRect>("TextureRect").Texture = (Texture)GD.Load("res://Inventory/item_icons/item" + GD.Randi() % 6 + ".png");
        } else {
            GetNode<TextureRect>("TextureRect").Texture = null;
        }
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
