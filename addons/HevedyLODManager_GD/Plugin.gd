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

tool
extends EditorPlugin

export(float) var LOD_DistanceMax := 1000.0 setget set_LODDistanceMax

var thread
var threadTerminated: bool = false

var PlayerCamEditor
var LODNodesListEditor = []
var LODsEditorSet: bool = false
var LODDistanceMax

func set_LODDistanceMax(value : float) -> void:
	LOD_DistanceMax = value

func isThreadTerminated():
	return threadTerminated

func get_editor_spatial_viewport():
	var viewports = find_nodes_of_type(get_editor_interface().get_editor_viewport(), Viewport)
	for viewport in viewports:
		if viewport.get_camera() and viewport.size.length() > 0:
			return viewport

static func find_nodes_of_type(root : Node, type) -> Array:
	var found_nodes := []
	for node in root.get_children():
		if node is type:
			found_nodes.append(node)
		found_nodes += find_nodes_of_type(node, type)
	return found_nodes

func PostLoad():
	pass
	#print(get_editor_spatial_viewport())
	#print(get_tree())
	#print("Scene Tree ------------")
	#print(get_tree().get_edited_scene_root())
	#print("Scene Interface ------------")
	#print(get_editor_interface().get_edited_scene_root())
	#_editor_function()

func _enter_tree():
	connect("scene_changed", self, "_on_Scene_Changed")
	print("Hevedy Editor LOD Manager Start")
	if Engine.is_editor_hint():
		pass
		##call_deferred("PostLoad")

func _on_Scene_Changed(scene):
	if Engine.is_editor_hint():
		threadTerminated = true
		if thread:
			var result = thread.wait_to_finish()
		print("Scene Switch")
		_editor_function(scene)
	else:
		pass
	#PostLoad()

func _exit_tree():
	print("Hevedy Editor LOD Manager End")
	if Engine.is_editor_hint():
		threadTerminated = true
		if thread:
			var result = thread.wait_to_finish()

#func forward_spatial_gui_input(camera, event):
#func update_overlays():
	

func _editor_function(scene):
	LODNodesListEditor.clear()
	PlayerCamEditor = get_editor_spatial_viewport().get_camera()
	var children_of_bindings = scene.get_parent().get_child(0).get_children()
	for child in children_of_bindings:
		print(child)
		if child is MeshLOD_GD:
			print(child)
			LODNodesListEditor.insert(LODNodesListEditor.size(),child)
	
	if LODNodesListEditor.size() > 0:
		if is_instance_valid(PlayerCamEditor):
			LODsEditorSet = true
		else:
			LODsEditorSet = false
	else:
		LODsEditorSet = false
		
	if LODsEditorSet:
		LODDistanceMax = max(100.0, LOD_DistanceMax)
		threadTerminated = false
		threadTerminated = false
		thread = Thread.new()
		thread.start(self, "_editorTick_function")
	else:
		threadTerminated = true
		

func _editorTick_function(_userdata):
	while(true):
		if isThreadTerminated():
			return
		var camLoc
		if is_instance_valid(PlayerCamEditor):
			camLoc = PlayerCamEditor.get_global_transform().origin
		else:
			camLoc = Vector3.ZERO
		for child in LODNodesListEditor:
			var dist = clamp(child.global_transform.origin.distance_to( camLoc ),0.0,LODDistanceMax)
			#print(dist)
			if child.LODDistance == dist:
				continue
			child.LODDistanceLast = child.LODDistance
			child.LODDistance = dist
			if dist > child.LOD1_Dist and dist < child.LOD2_Dist: #LOD1
				child.set_LOD(1)
			elif dist > child.LOD2_Dist and dist < child.LOD3_Dist: #LOD2
				child.set_LOD(2)
			elif dist > child.LOD3_Dist: #LOD3
				child.set_LOD(3)
			else: #LOD0
				child.set_LOD(0)
			#child.set_Distance(dist)
