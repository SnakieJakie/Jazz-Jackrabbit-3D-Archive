//=============================================================================
// Jazzweapfix.
//=============================================================================
class Jazzweapfix expands Actor;

#exec MESH IMPORT MESH=Jazzweapfix ANIVFILE=MODELS\Jazzweapfix_a.3d DATAFILE=MODELS\Jazzweapfix_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Jazzweapfix X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Jazzweapfix SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Jazzweapfix SEQ=Jazzweapfix              STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Jazzweapfix MESH=Jazzweapfix
#exec MESHMAP SCALE MESHMAP=Jazzweapfix X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JJazzweapfix_01 FILE=Textures\Jazzweapfix_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=Jazzweapfix NUM=1 TEXTURE=JJazzweapfix_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=Jazzweapfix
}

