//=============================================================================
// grassplat.
//=============================================================================
class grassplat expands JazzMeshes;

#exec MESH IMPORT MESH=grassplat ANIVFILE=MODELS\grassplat_a.3d DATAFILE=MODELS\grassplat_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=grassplat X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=grassplat SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=grassplat SEQ=grassplat                STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=grassplat MESH=grassplat
#exec MESHMAP SCALE MESHMAP=grassplat X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jgrassplat_01 FILE=Textures\grassplat_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=grassplat NUM=0 TEXTURE=Jgrassplat_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.grassplat'
}
