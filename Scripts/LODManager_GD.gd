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
extends Spatial
class_name LODManager_GD

export(float) var LOD_DistanceMax := 10000.0 setget set_LODDistanceMax

var thread
var threadTerminated: bool = false

#func _notification(what : int) -> void:

func _ready() -> void:
	threadTerminated = false
	thread = Thread.new()
	thread.start(self, "_thread_function")


##func _process(delta : float) -> void:
##	pass
	

func set_LODDistanceMax(value : float) -> void:
	LOD_DistanceMax = value

func isThreadTerminated():
	return threadTerminated

func _thread_function(_userdata):
	var LODNodesList = []
	var lodDistanceMax = max(100.0, LOD_DistanceMax)
	var playerCam = get_tree().get_root().get_viewport().get_camera() #get_tree().get_root().get_node("Main/Player")
	var playerLoc
	if playerCam:
		playerLoc = playerCam.get_global_transform().origin
	else:
		playerLoc = Vector3.ZERO
	#TODO Hex level LOD manager by areas and areas with LODs
	var children_of_bindings = get_tree().get_root().get_child(0).get_children() #get_tree().get_root().get_child( get_tree().get_root().get_child_count()-1 )
	for child in children_of_bindings:
		if child is MeshLOD_GD: #child.get_class() == "MeshLOD_GD":
			LODNodesList.insert(LODNodesList.size(),child)
	
	while(true):
		if( isThreadTerminated() ):
			return
		playerLoc = playerCam.get_global_transform().origin
		for child in LODNodesList:
			var dist = clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax)
			#print(dist)
			child.set_Distance(dist)

# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	threadTerminated = true
	if thread:
		var result = thread.wait_to_finish()
