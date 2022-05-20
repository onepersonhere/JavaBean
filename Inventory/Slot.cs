using Godot;
using System;

public class Slot : Panel
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.
    PackedScene itemScene = (PackedScene)GD.Load("res://Inventory/Item.tscn");
    public Item item = null;
    public override void _Ready()
    {
        item = (Item)itemScene.Instance();
        AddChild(item);
    }

    public void pickedFromSlot() {
        RemoveChild(item);
        Node inventory = FindParent("Inventory");
        inventory.AddChild(item);
        item = null;
    }
    
    public void putIntoSlot(Item item) {
        this.item = item;
        Node inventory = FindParent("Inventory");
        inventory.RemoveChild(item);
        AddChild(item);
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
