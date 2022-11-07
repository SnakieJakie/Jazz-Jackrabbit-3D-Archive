//=============================================================================
// JazzWeapon2.
//=============================================================================
class JazzWeapon2 expands JazzMeshes;

#exec MESH IMPORT MESH=JazzWeapon2 ANIVFILE=MODELS\JazzWeapon2_a.3d DATAFILE=MODELS\JazzWeapon2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=JazzWeapon2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=JazzWeapon2 SEQ=All                      STARTFRAME=0 NUMFRAMES=10
#exec MESH SEQUENCE MESH=JazzWeapon2 SEQ=Weaponanim               STARTFRAME=0 NUMFRAMES=9
#exec MESH SEQUENCE MESH=JazzWeapon2 SEQ=Weaponidle               STARTFRAME=9 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=JazzWeapon2 MESH=JazzWeapon2
#exec MESHMAP SCALE MESHMAP=JazzWeapon2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JJazzWeapon2_01 FILE=Textures\JazzWeapon2_01.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=JJazzWeapon2_02 FILE=Textures\JazzWeapon2_02.PCX GROUP=Skins FLAGS=2	//Material #3

#exec MESHMAP SETTEXTURE MESHMAP=JazzWeapon2 NUM=0 TEXTURE=JJazzWeapon2_01
#exec MESHMAP SETTEXTURE MESHMAP=JazzWeapon2 NUM=2 TEXTURE=JJazzWeapon2_02

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.Jazzweapon2'
}
