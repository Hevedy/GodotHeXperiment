#==============================================================================
# Godot HeXperiment by Hevedy
# <https://github.com/Hevedy/GodotHeXperiment>
# Godot HeXperiment MPL 2.0 Source Code
# Copyright (C) 2020 Hevedy <https://github.com/Hevedy>.
# This file is part of the Godot HeXperiment MPL 2.0 Source Code.
# Godot HeXperiment MPL 2.0 Source Code is free software:
# you can redistribute it and/or modify it under the terms of the
# Mozilla Public License 2.0 as published by the Mozilla Foundation,
# either version 2 of the License, or (at your option) any later version.
# Godot HeXperiment MPL 2.0 Source Code is distributed in the hope
# that it will be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the Mozilla Public License 2.0 for more details.
# You should have received a copy of the Mozilla Public License 2.0
# along with Godot HeXperiment MPL 2.0 Source Code.
# If not, see <https://www.mozilla.org/en-US/MPL/2.0/>.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#==============================================================================

extends Spatial

onready var LOD0_Inst: MeshInstance
onready var LOD1_Inst: MeshInstance
onready var LOD2_Inst: MeshInstance
onready var LOD3_Inst: MeshInstance

export (int,1,4) var LOD_Num: int=1 setget set_LOD_Num
export (int,-1,3) var LOD_Preview: int=0 setget set_LOD_Preview
export (float, 1.0,10000.0,0.01) var LOD1_Dist: float = 1000.0 setget set_LOD1_Dist
export (float, 1.0,10000.0,0.01) var LOD2_Dist: float = 2000.0 setget set_LOD2_Dist
export (float, 1.0,10000.0,0.01) var LOD3_Dist: float = 3000.0 setget set_LOD3_Dist
export (Mesh) var LOD0_Mesh: Mesh setget set_LOD0_Mesh
export (Mesh) var LOD1_Mesh: Mesh setget set_LOD1_Mesh
export (Mesh) var LOD2_Mesh: Mesh setget set_LOD2_Mesh
export (Mesh) var LOD3_Mesh: Mesh setget set_LOD3_Mesh


var LOD: int = 0
var LODLast: int = 0
var LODDistance: float = 0.0
var LODDistanceLast: float = 0.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func set_LOD_Preview(value: int):
	LOD_Preview = value

func set_LOD_Num(value: int):
	LOD_Num = value
	
func set_LOD1_Dist(value: float):
	LOD1_Dist = value
	
func set_LOD2_Dist(value: float):
	LOD2_Dist = value
	
func set_LOD3_Dist(value: float):
	LOD3_Dist= value
	
# Set LODs
func set_LOD0_Mesh(value: Mesh):
	LOD0_Mesh= value
	
func set_LOD1_Mesh(value: Mesh):
	LOD1_Mesh= value
	
func set_LOD2_Mesh(value: Mesh):
	LOD2_Mesh= value
	
func set_LOD3_Mesh(value: Mesh):
	LOD3_Mesh= value

func find_LODs():
	for child in self.get_children():
		if( "_LOD1" in child.get_name()):
			LOD1_Inst = child
		elif( "_LOD2" in child.get_name()):
			LOD2_Inst = child
		elif( "_LOD3" in child.get_name()):
			LOD3_Inst = child
		else:
			LOD0_Inst = child

# Called when the node enters the scene tree for the first time.
func _ready():
	LOD0_Inst = MeshInstance.new()
	LOD1_Inst = MeshInstance.new()
	LOD2_Inst = MeshInstance.new()
	LOD3_Inst = MeshInstance.new()
	LOD0_Inst.mesh = LOD0_Mesh.new()
	LOD1_Inst.mesh = LOD1_Mesh.new()
	LOD2_Inst.mesh = LOD2_Mesh.new()
	LOD3_Inst.mesh = LOD3_Mesh.new()
	
	add_child(LOD0_Inst)
	add_child(LOD1_Inst)
	add_child(LOD2_Inst)
	add_child(LOD3_Inst)
	
	if LOD_Preview < 0:
		set_Distance(self.global_transform.origin.distance_to( get_tree().get_root().get_node("Main/Player").get_global_transform().origin ))
	else:
		set_LOD(LOD_Preview)
	#pass # Replace with function body.

func set_Distance(value:float):
	if LODDistance == value:
		return
	
	LODDistanceLast = LODDistance
	LODDistance = value
	
	if value > LOD1_Dist and value < LOD2_Dist: #LOD1
		set_LOD(1)
	elif value > LOD2_Dist and value < LOD3_Dist: #LOD2
		set_LOD(2)
	elif value > LOD3_Dist: #LOD3
		set_LOD(3)
	else: #LOD0
		set_LOD(0)
	

func set_LOD(value: int):
	var a = clamp(value,0,LOD_Num-1)
	if( LOD == a ):
		return
	
	LODLast = LOD
	match a:
		0:
			LOD1_Inst.visible = false
			LOD2_Inst.visible = false
			LOD3_Inst.visible = false
			LOD0_Inst.visible = true
		1:
			LOD0_Inst.visible = false
			LOD2_Inst.visible = false
			LOD3_Inst.visible = false
			LOD1_Inst.visible = true
		2:
			LOD0_Inst.visible = false
			LOD1_Inst.visible = false
			LOD3_Inst.visible = false
			LOD2_Inst.visible = true
		3:
			LOD0_Inst.visible = false
			LOD1_Inst.visible = false
			LOD2_Inst.visible = false
			LOD3_Inst.visible = true
			
	LOD = a

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
