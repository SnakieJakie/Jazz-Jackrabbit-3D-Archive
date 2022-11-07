//=============================================================================
// Bfly2.
//=============================================================================
class Bfly2 expands Actor;

#exec MESH IMPORT MESH=Bfly2 ANIVFILE=MODELS\Bfly2_a.3d DATAFILE=MODELS\Bfly2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Bfly2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Bfly2 SEQ=All                      STARTFRAME=0 NUMFRAMES=147
#exec MESH SEQUENCE MESH=Bfly2 SEQ=Bfly2fly                 STARTFRAME=0 NUMFRAMES=66
#exec MESH SEQUENCE MESH=Bfly2 SEQ=Bfly2idle                STARTFRAME=66 NUMFRAMES=80
#exec MESH SEQUENCE MESH=Bfly2 SEQ=Bfly2still               STARTFRAME=146 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Bfly2 MESH=Bfly2
#exec MESHMAP SCALE MESHMAP=Bfly2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JBfly2_01 FILE=Textures\Bfly2_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Bfly2 NUM=1 TEXTURE=JBfly2_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.Bfly2'
}
