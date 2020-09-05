//==============================================================================
// Godot HeXperiment by Hevedy
// <https://github.com/Hevedy/GodotHeXperiment>
// Godot HeXperiment MPL 2.0 Source Code
// Copyright (C) 2020 Hevedy <https://github.com/Hevedy>.
// This file is part of the Godot HeXperiment MPL 2.0 Source Code.
// Godot HeXperiment MPL 2.0 Source Code is free software:
// you can redistribute it and/or modify it under the terms of the
// Mozilla Public License 2.0 as published by the Mozilla Foundation,
// either version 2 of the License, or (at your option) any later version.
// Godot HeXperiment MPL 2.0 Source Code is distributed in the hope
// that it will be useful, but WITHOUT ANY WARRANTY; without even the
// implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the Mozilla Public License 2.0 for more details.
// You should have received a copy of the Mozilla Public License 2.0
// along with Godot HeXperiment MPL 2.0 Source Code.
// If not, see <https://www.mozilla.org/en-US/MPL/2.0/>.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//==============================================================================

using Godot;
using System;
//using MeshLOD;

[Tool]
public class WorldManager : Spatial
{
	static Thread thread;
	static bool threadTerminated = false;

	[Export] public float LOD_DistanceMax { get; set; } = 100000.0f;

	private void StartThread() {
		if( thread != null) {
			threadTerminated = true;
		}
		thread = new Thread();
		threadTerminated = false;
		thread.Start(this,"LodThread");
	}

	private void StopThread() {
		threadTerminated = true;
	}
/*
	var LODNodesList = []
	var lodDistanceMax = max(100.0, LOD_DistanceMax)
	var playerCam = get_tree().get_viewport().get_camera() #get_tree().get_root().get_node("Main/Player")
	var playerLoc = playerCam.get_global_transform().origin
	#TODO Hex level LOD manager by areas and areas with LODs
	var children_of_bindings = get_node("parent").get_children()
	for child in children_of_bindings:
		if child.get_class() == "MeshInstaceLOD":
			#child.set_Distance(clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax))
			LODNodesList.insert(LODNodesList.size(),child)
	
	while(!isThreadTerminated()):
		playerLoc = playerCam.get_global_transform().origin
		for child in LODNodesList:
			pass
			#child.set_Distance(clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax))
	#print("I'm a thread! Userdata is: ")
*/

	private void ThreadLoop() {

		float lodDistanceCap = Mathf.Max(100.0f, LOD_DistanceMax);
		var playerCam = GetTree().Root.GetViewport().GetCamera();//GetViewport().GetCamera();
		Vector3 playerDist;
		Godot.Collections.Array childrens = GetNode("parent").GetChildren();
		Godot.Collections.Array<MeshLOD> LODArray = new Godot.Collections.Array<MeshLOD>();
		foreach (var child in childrens) {
			if( child is MeshLOD ) {
				LODArray.Add( (MeshLOD)child );
			}
		}
		while(true) {
			if(threadTerminated) {
				break;
			}
			playerDist = playerCam.GlobalTransform.origin;
			foreach (MeshLOD lod in LODArray) {
				lod.set_Distance(Mathf.Min(lod.GlobalTransform.origin.DistanceTo(playerDist),lodDistanceCap));
			}

		}
	}


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		StartThread();
	}

	//  // Called every frame. 'delta' is the elapsed time since the previous frame.
	//  public override void _Process(float delta)
	//  {
	//      
	//  }

	public override void _ExitTree()
	{
		StopThread();
		//base._ExitTree();
	}
}
