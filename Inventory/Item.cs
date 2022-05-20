using Godot;
using System;

public class Item : Node2D
{
    public override void _Ready()
    {
        GetNode<TextureRect>("TextureRect").Texture = (Texture)GD.Load("res://Inventory/item_icons/item" + GD.Randi() % 6 + ".png");
    }
}
