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

#tool
extends Spatial
class_name LODManager_GD

export(float) var LOD_DistanceMax := 1000.0 setget set_LODDistanceMax

var thread
var threadTerminated: bool = false

var PlayerCamEditor
var LODNodesListEditor = []
var LODsEditorSet: bool = false

#func _notification(what : int) -> void:

func _ready() -> void:
	if not Engine.is_editor_hint():
		print("HEV LODs Executed (In-Game)")
		threadTerminated = false
		thread = Thread.new()
		thread.start(self, "_thread_function")
	else:
		print("HEV LODs Executed (In-Editor)")
		LODsEditorSet = false
		##_editor_function()
		#thread = Thread.new()
		#thread.start(self, "_thread_function")

func forward_spatial_input_event(camera, event):
	print(camera)

func _process(delta : float) -> void:
	if Engine.is_editor_hint():
		#PlayerCamEditor = get_tree().root.get_child(0).get_viewport().get_camera()
		#PlayerCamEditor = get_tree().get_edited_scene_root().get_parent().get_camera()
		#print(PlayerCamEditor.trans)
		#print(PlayerCamEditor)
		if not LODsEditorSet:
			#_editor_function()
			pass
		else:
			#print(PlayerCamEditor.get_camera_transform().origin)
			pass
			#_editorTick_function()
	

func set_LODDistanceMax(value : float) -> void:
	LOD_DistanceMax = value

func isThreadTerminated():
	return threadTerminated

func _thread_function(_userdata):
	var LODNodesList = []
	var lodDistanceMax = max(100.0, LOD_DistanceMax)
	var playerCam = get_tree().get_root().get_viewport().get_camera() #get_tree().get_root().get_node("Main/Player")
	var playerLoc
	if is_instance_valid(playerCam):
		playerLoc = playerCam.get_global_transform().origin
	else:
		playerLoc = Vector3.ZERO
	#TODO Hex level LOD manager by areas and areas with LODs
	#get_tree().get_root().get_child( get_tree().get_root().get_child_count()-1 )
	var children_of_bindings = get_tree().get_root().get_child(0).get_children() #get_tree().get_root().get_child( get_tree().get_root().get_child_count()-1 )
	#print(get_tree().get_root().get_child(0).get_children())
	#print(get_tree().get_root().get_node(get_tree().get_root().get_child(0).name)) #get_nodes_in_group("MeshLOD")
	#print(get_tree().root.get_child_count())
	for child in children_of_bindings:
		if child is MeshLOD_GD: #child.get_class() == "MeshLOD_GD":
			#print("Node Found")
			#child.set_Distance(clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax))
			LODNodesList.insert(LODNodesList.size(),child)
	
	while(true):
		if isThreadTerminated():
			return
		if is_instance_valid(playerCam):
			playerLoc = playerCam.get_global_transform().origin
		else:
			playerLoc = Vector3.ZERO
		for child in LODNodesList:
			var dist = clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax)
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

func _editor_function():
	LODNodesListEditor.clear()
	PlayerCamEditor = get_tree().root.get_camera()
	var children_of_bindings = get_tree().get_edited_scene_root().get_parent().get_child(0).get_children()
	for child in children_of_bindings:
		print(child)
		if child is MeshLOD_GD: #child.get_class() == "MeshLOD_GD":
			#child.set_Distance(clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax))
			LODNodesListEditor.insert(LODNodesListEditor.size(),child)
	
	if LODNodesListEditor.size() > 0:
		if is_instance_valid(PlayerCamEditor):
			LODsEditorSet = true
		else:
			LODsEditorSet = false
	else:
		LODsEditorSet = false
		#print("Nodes Not Found")

func _editorTick_function():
	var lodDistanceMax = max(100.0, LOD_DistanceMax)
	var playerCam = get_tree().get_edited_scene_root().get_viewport().get_camera() #get_tree().get_root().get_node("Main/Player")
	var playerLoc
	if is_instance_valid(playerCam):
		playerLoc = playerCam.get_global_transform().origin
	else:
		playerLoc = Vector3.ZERO
	for child in LODNodesListEditor:
		var dist = clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax)
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

func _enter_tree():
	print("Enter Tree")
	#print(get_tree().get_edited_scene_root())
	#print(get_tree().root)
	#print(get_tree().root.get_children())
	#print(get_tree().get_edited_scene_root().get_parent().get_children())
	#print(get_tree().get_edited_scene_root().get_parent().get_child(0).get_children())

# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	if not Engine.is_editor_hint():
		threadTerminated = true
		if thread:
			var result = thread.wait_to_finish()
