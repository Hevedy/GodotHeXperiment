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

export(float, 0, 2) var CA_Intensity := 0.5 setget set_ca_intensity
export(float, 0, 2) var CA_Saturation := 0.5 setget set_ca_saturation

export(float) var LOD_DistanceMax := 10000.0 setget set_LODDistanceMax

var canvas : MeshInstance
var material := preload("Postprocess.tres").duplicate() as ShaderMaterial

var thread
var threadTerminated: bool = false

#func _notification(what : int) -> void:


func _ready() -> void:
	threadTerminated = false
	thread = Thread.new()
	thread.start(self, "_thread_function")
	
	if get_child_count() > 0 and get_child(0).owner == null:
		remove_child(get_child(0))
	
	var mesh := QuadMesh.new()
	mesh.size = Vector2(2, 2)
	mesh.custom_aabb = AABB(Vector3(1,1,1) * -300000, Vector3(1,1,1) * 600000)
	
	canvas = MeshInstance.new()
	canvas.name = "Postprocess"
	canvas.mesh = mesh
	canvas.material_override = material
	add_child(canvas)
	
	material.setup_local_to_scene()
	
	set_ca_intensity(CA_Intensity)
	set_ca_saturation(CA_Saturation)


func _process(delta : float) -> void:
	material.set_shader_param("G_Quality", ProjectSettings.get_setting("rendering/quality/postprocess/g_quality"))

func set_ca_intensity(value : float) -> void:
	CA_Intensity = value
	material.set_shader_param("CA_Intensity", CA_Intensity)
	if canvas:
		canvas.visible = CA_Intensity != 0

func set_ca_saturation(value : float) -> void:
	CA_Saturation = value
	material.set_shader_param("CA_Saturation", CA_Saturation)
	if canvas:
		canvas.visible = CA_Saturation != 0
	

func set_LODDistanceMax(value : float) -> void:
	LOD_DistanceMax = value


func _thread_function(userdata):
	var LODNodesList = []
	var lodDistanceMax = max(100.0, LOD_DistanceMax)
	var playerCam = get_tree().get_root().get_node("Main/Player")
	var playerLoc = playerCam.get_global_transform().origin
	var children_of_bindings = get_node("parent").get_children()
	for child in children_of_bindings:
		if child.get_class() == "Node":
			child.set_Distance(clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax))
			LODNodesList.insert(LODNodesList.size(),child)
	
	# Print the userdata ("Wafflecopter")
	while(!isThreadTerminated()):
		playerLoc = playerCam.get_global_transform().origin
		for child in LODNodesList:
			child.set_Distance(clamp(child.global_transform.origin.distance_to( playerLoc ),0.0,lodDistanceMax))
	#print("I'm a thread! Userdata is: ")

func isThreadTerminated():
	return threadTerminated

# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	threadTerminated = true
	thread.wait_to_finish()
