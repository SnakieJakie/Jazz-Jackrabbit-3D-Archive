//=============================================================================
// Bfly1a.
//=============================================================================
class Bfly1a expands Actor;

#exec MESH IMPORT MESH=Bfly1a ANIVFILE=MODELS\Bfly1a_a.3d DATAFILE=MODELS\Bfly1a_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Bfly1a X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Bfly1a SEQ=All                      STARTFRAME=0 NUMFRAMES=147
#exec MESH SEQUENCE MESH=Bfly1a SEQ=Bfly1afly                STARTFRAME=0 NUMFRAMES=66
#exec MESH SEQUENCE MESH=Bfly1a SEQ=Bfly1aidle               STARTFRAME=66 NUMFRAMES=80
#exec MESH SEQUENCE MESH=Bfly1a SEQ=Bfly1astill              STARTFRAME=146 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Bfly1a MESH=Bfly1a
#exec MESHMAP SCALE MESHMAP=Bfly1a X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JBfly1a_01 FILE=Textures\Bfly1a_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Bfly1a NUM=1 TEXTURE=JBfly1a_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.Bfly1a'
}
