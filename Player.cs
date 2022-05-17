using Godot;
using System;

public class Player : KinematicBody2D
{
    [Export]
    private int Speed = 100;
    public override void _Ready() {
        
    }
    public override void _Process(float delta) {
        var velocity = Vector2.Zero; // The player's movement vector (0,0)
		
		if (Input.IsActionPressed("move_right")) velocity.x++;
		if (Input.IsActionPressed("move_left")) velocity.x--;
		if (Input.IsActionPressed("move_up")) velocity.y--;
		if (Input.IsActionPressed("move_down")) velocity.y++;
		
		var animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");

        if(velocity.Length() > 0) {
            velocity = velocity.Normalized() * Speed;
            animatedSprite.Play();
        } else {
            animatedSprite.Stop();
        }

        Position += velocity * delta;
        Position = new Vector2(
            x: Mathf.Clamp(Position.x, 0, GetViewportRect().Size.x),
            y: Mathf.Clamp(Position.y, 0, GetViewportRect().Size.y)
        );

        if (velocity.x != 0) {
			animatedSprite.Animation = "walk";
			animatedSprite.FlipV = false;
			animatedSprite.FlipH = velocity.x < 0;
		} else if (velocity.y != 0) {
			animatedSprite.Animation = "walk";
			animatedSprite.FlipV = velocity.y > 0;
		}
        
    }
}
