using Godot;
using System;

public class Chest : StaticBody2D {
    private bool Bool = false;
    private bool Played = false;
    private bool Opened = false;
    public override void _Ready()
    {
        
    }

    private void _on_Area2D_body_entered(Node body) {
        if (body.Name.Equals("Player")) {
            Bool = true;
        }
    }

    private void _on_Area2D_body_exited(Node body) {
        if (body.Name.Equals("Player")) {
            Bool = false;
        }
    }

    public override void _Input(InputEvent @event) {
        if (@event.IsActionPressed("interact") && Bool && !Played) {
            GetNode<AnimatedSprite>("AnimatedSprite").Frame = 1;
            Played = true;
            
            if (!Opened) {
                Opened = true;
                dropItems();
            }
        }
        else if (@event.IsActionPressed("interact") && Bool && Played) {
            GetNode<AnimatedSprite>("AnimatedSprite").Frame = 0;
            Played = false;
        }
    }

    private void dropItems() {
        Area2D ItemDropArea = GetNode<Area2D>("ItemDropArea");
        var scene = GD.Load<PackedScene>("res://Inventory/Items/ItemDrop.tscn");
        KinematicBody2D item = (KinematicBody2D)scene.Instance();
        item.Position = new Vector2 ((float)GD.RandRange(-25, 25), (float)GD.RandRange(0, 25));
        ItemDropArea.AddChild(item);
    }

    
}
