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

extends MeshInstance
class_name MeshInstaceLOD

var LOD0_Inst
var LOD1_Inst
var LOD2_Inst
var LOD3_Inst

var LOD_Num
export (int,-1,3) var LOD_Preview: int=0 setget set_LOD_Preview
export (float, 1.0,10000.0,0.01) var LOD1_Dist: float = 1000.0 setget set_LOD1_Dist
export (float, 1.0,10000.0,0.01) var LOD2_Dist: float = 2000.0 setget set_LOD2_Dist
export (float, 1.0,10000.0,0.01) var LOD3_Dist: float = 3000.0 setget set_LOD3_Dist


var LOD: int = 0
var LODLast: int = 0
var LODDistance: float = 0.0
var LODDistanceLast: float = 0.0

func set_LOD_Preview(value: int):
	LOD_Preview = value
	
func set_LOD1_Dist(value: float):
	LOD1_Dist = value
	
func set_LOD2_Dist(value: float):
	LOD2_Dist = value
	
func set_LOD3_Dist(value: float):
	LOD3_Dist= value


func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = find_node_by_name(child, name)
		if(found): return found
	return null

func find_LODs():
	for child in self.get_children():
		if( "_LOD1" in child.get_name()):
			LOD1_Inst = child
		elif( "_LOD2" in child.get_name()):
			LOD2_Inst = child
		elif( "_LOD3" in child.get_name()):
			LOD3_Inst = child
		elif!( "_Col" in child.get_name()):
			LOD0_Inst = child
			
	LOD_Num = 4
	if !LOD3_Inst:
		LOD3_Inst = MeshInstance.new()
		LOD_Num = 3
	if !LOD2_Inst:
		LOD2_Inst = MeshInstance.new()
		LOD_Num = 2
	if !LOD1_Inst:
		LOD1_Inst = MeshInstance.new()
		LOD_Num = 1
	if !LOD0_Inst:
		LOD0_Inst = MeshInstance.new()
		LOD_Num = 0
		
	print(LOD_Preview)

# Called when the node enters the scene tree for the first time.
func _ready():
	find_LODs()
	
	if LOD_Preview < 0:
		set_Distance(self.global_transform.origin.distance_to( get_tree().get_viewport().get_camera().get_global_transform().origin))
	else:
		set_LOD(LOD_Preview)

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
	else:
		set_LOD(0)
	

func set_LOD(value: int):
	var a = clamp(value,0,LOD_Num-1)
	if a < 0:
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

