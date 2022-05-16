using Godot;
using System;

public class Main : Node {
    // Called when the node enters the scene tree for the first time.
    public override void _Ready() {
        var x = 0;
        while(x < 1)
            Console.WriteLine("Hello World" + ++x);
    }
}
