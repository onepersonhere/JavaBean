using Godot;
using System;

public class Item : Node2D
{
    public override void _Ready()
    {
        GetNode<TextureRect>("TextureRect").Texture = (Texture)GD.Load("res://Inventory/Icons/item" + GD.Randi() % 2 + ".png");
    }
}
