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

const Postprocess = preload("Postprocess.gd")

var project_settings := "rendering/quality/postprocess/"

func _enter_tree() -> void:
	name = "HevedyPostprocessPlugin"
	
	add_custom_type("HevPostprocess", "Spatial", Postprocess, preload("Postprocess.svg"))
	
	create_project_setting(project_settings+"g_quality", 0.1, TYPE_REAL, "The postprocess quality.")
	
	print("Hevedy Postprocess Plugin has been activated.")

func _exit_tree() -> void:
	remove_custom_type("HevPostprocess")
	print("Hevedy Postprocess Plugin has been deactivated.")

func create_project_setting(setting : String, default, type : int, hint : String) -> void:
	if not ProjectSettings.has_setting(setting):
		ProjectSettings.set_setting(setting, default)
		ProjectSettings.add_property_info({
			name = setting,
			type = type,
			hint = PROPERTY_HINT_NONE,
			hint_string = hint
		})
