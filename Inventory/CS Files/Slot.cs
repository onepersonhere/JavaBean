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

    Texture defaultTex = (Texture)GD.Load("res://Inventory/Images/item_slot_default_background.png");
    Texture emptyTex = (Texture)GD.Load("res://Inventory/Images/item_slot_empty_background.png");
    StyleBoxTexture defaultStyle = null;
    StyleBoxTexture emptyStyle = null;
    public override void _Ready()
    {
        
        defaultStyle = new StyleBoxTexture();
        emptyStyle = new StyleBoxTexture();
        defaultStyle.Texture = defaultTex;
        emptyStyle.Texture = emptyTex;
        if (GD.Randi() % 2 == 0) {
            item = (Item)itemScene.Instance();
            AddChild(item);
        }
        refreshStyle();
    }

    public void pickedFromSlot() {
        RemoveChild(item);
        Node inventory = FindParent("Inventory");
        inventory.AddChild(item);
        item = null;
        refreshStyle();
    }
    
    public void putIntoSlot(Item item) {
        this.item = item;
        this.item.Position = Vector2.Zero;
        Node inventory = FindParent("Inventory");
        inventory.RemoveChild(item);
        AddChild(item);
        refreshStyle();
    }

    public void refreshStyle() {
        if (item == null) {
            Set("custom_styles/panel", emptyStyle);
        } else {
            Set("custom_styles/panel", defaultStyle);
        }
    }
}
