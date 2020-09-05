#if TOOLS
using Godot;
using System;

[Tool]
public class HevManager : EditorPlugin
{
	public override void _EnterTree()
	{
		// Initialization of the plugin goes here.
		/*
		var script = GD.Load<Script>("MeshLOD.cs");
		var texture = GD.Load<Texture>("MeshLOD_Icon.png");
		AddCustomType("MeshLOD", "Spatial", script, texture);
		script = GD.Load<Script>("WorldManager.cs");
		texture = GD.Load<Texture>("WorldManager_Icon.png");
		AddCustomType("WorldManager", "Spatial", script, texture);

		GD.Print("Hevedy Manager Enabled");*/
	}

	public override void _ExitTree()
	{
		/*
		RemoveCustomType("MeshLOD");
		RemoveCustomType("WorldManager");
		// Clean-up of the plugin goes here.
		GD.Print("Hevedy Manager Disabled");*/
	}
}
#endif
