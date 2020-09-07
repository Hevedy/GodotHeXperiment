# GodotHeXperiment
New techs workbench


Setup:

1.) In Blender create a collection to be your mesh group, and name it after the name of your mesh.
2.) Inside it add up 4 different meshes and add the suffix "_LODx" where x is the number from 0 to 3.
3.) Export the group/collection as glTF 2.0 and import it to godot.
4.) The root of the group must have as parent the script MeshLOD_GD
5.) Add in the scene a new LODManager_GD node to manage them all at runtime.
6.) Profit