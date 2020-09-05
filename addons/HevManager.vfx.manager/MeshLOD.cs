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
using System.Collections.Generic;

[Tool]
public class MeshLOD : Spatial
{

	static MeshInstance LOD0_Inst;
	static MeshInstance LOD1_Inst;
	static MeshInstance LOD2_Inst;
	static MeshInstance LOD3_Inst;

	static int LOD_Num = 0;
	static int LOD = 0;
	static int LODLast = 0;
	static float LODDistance = 0.0f;
	static float LODDistanceLast = 0.0f;
	
	private int _LOD_Preview = 0;
	[Export] 
	public int LOD_Preview 
	{ 
		get {	return _LOD_Preview; } 
		set { 	_LOD_Preview = value; 
				_Ready();
			}
	}

	[Export] public float LOD1_Dist { get; set; } = 1000.0f;
	[Export] public float LOD2_Dist { get; set; } = 2000.0f;
	[Export] public float LOD3_Dist { get; set; } = 3000.0f;

	void find_LODs() {
		Godot.Collections.Array childrens = this.GetChildren();
		foreach (Node child in childrens) {
			string name = child.Name;
			if( name.Contains("_LOD1") ) {
				LOD1_Inst = (MeshInstance)child;
			} else if( name.Contains("_LOD2") ) {
				LOD2_Inst = (MeshInstance)child;
			} else if( name.Contains("_LOD3") ) {
				LOD3_Inst = (MeshInstance)child;
			} else if( name.Contains("_LOD0") ) {
				LOD0_Inst = (MeshInstance)child;
			} else if( !name.Contains("_Coll") ) {
				//LOD0_Inst = (MeshInstance)child;
			}
		}
		LOD_Num = 4;
		if (LOD3_Inst == null) {
			LOD3_Inst = new MeshInstance();
			LOD_Num = 3;
		}
		if (LOD2_Inst== null) {
			LOD2_Inst = new MeshInstance();
			LOD_Num = 2;
		}
		if (LOD1_Inst == null) {
			LOD1_Inst = new MeshInstance();
			LOD_Num = 1;
		}
		if (LOD0_Inst == null) {
			LOD0_Inst = new MeshInstance();
			LOD_Num = 0;
		}
	}
	
	public void set_Distance( float _value ) {
		
		if ( LODDistance == _value) {
			return;
		}
		
		LODDistanceLast = LODDistance;
		LODDistance = _value;
		
		if (_value > LOD1_Dist && _value < LOD2_Dist) { //LOD1
			set_LOD(1);
		} else if (_value > LOD2_Dist && _value < LOD3_Dist) { //LOD2
			set_LOD(2);
		} else if (_value > LOD3_Dist) { //LOD3
			set_LOD(3);
		} else { //LOD0
			set_LOD(0);
		}
	}
	

	public void set_LOD( int _value ) {

		int a = Mathf.Clamp(_value,0,LOD_Num-1);
		if (a < 0) {
			return;
		}
		LODLast = LOD;
	
		switch (a) {
			case 0:
				LOD1_Inst.Visible = false;
				LOD2_Inst.Visible = false;
				LOD3_Inst.Visible = false;
				LOD0_Inst.Visible = true;
				break;
			case 1:
				LOD0_Inst.Visible = false;
				LOD2_Inst.Visible = false;
				LOD3_Inst.Visible = false;
				LOD1_Inst.Visible = true;
				break;
			case 2:
				LOD0_Inst.Visible = false;
				LOD1_Inst.Visible = false;
				LOD3_Inst.Visible = false;
				LOD2_Inst.Visible = true;
				break;
			case 3:
				LOD0_Inst.Visible = false;
				LOD1_Inst.Visible = false;
				LOD2_Inst.Visible = false;
				LOD3_Inst.Visible = true;
				break;
				
		}
		LOD = a;
	}
	
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		find_LODs();
		
		if (LOD_Preview < 0) {
			set_Distance(100.0f);
		} else {
			set_LOD(LOD_Preview);
		}
		GD.Print("Ready Set");
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }


	
}
