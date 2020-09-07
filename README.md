# GodotHeXperiment 
New techs workbench by Hevedy under MPL 2.0 


## Setup:  

1. Copy the folder <addons/HevedyLODManager_GD> into the same folder in your project.
2. Copy the files <Scripts/LODManager_GD.gd> and <Scripts/MeshLOD_GD.gd> into your project <Scripts/> folder.
2. In Blender create a collection to be your mesh group, and name it after the name of your mesh. 
3. Inside it add up 4 different meshes and add the suffix "_LODx" where x is the number from 0 to 3. 
4. Export the group/collection as glTF 2.0 and import it to godot. 
5. The root of the each group must have as parent the script MeshLOD_GD. 
6. Add in the scene a new single LODManager_GD node to manage them all at runtime. 
7. Profit. 

## Info:  

The addon/plugin manages the LODs in editor. 
The LODManager_GD manages the LODs in runtim in-game.