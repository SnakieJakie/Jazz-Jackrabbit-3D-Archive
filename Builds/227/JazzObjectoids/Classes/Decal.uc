class Decal expands JazzMeshes;

var() texture		RandomDecals[10];		//User's Textures
var int			RandDecals;			//Holder for Rand()
var float Time;

var bool  bHitWater;					//Water contact


#exec MESH IMPORT MESH=Decal ANIVFILE=MODELS\Decal_a.3d DATAFILE=MODELS\Decal_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Decal X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Decal SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Decal SEQ=Decal                    STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Decal MESH=Decal
#exec MESHMAP SCALE MESHMAP=Decal X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JDecal_01 FILE=Textures\Decal_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=Decal NUM=1 TEXTURE=JDecal_01

/*
auto state Decal
{
	function HitWall(vector HitNor,actor HitActor)
	{
		if (Level.NetMode != NM_StandAlone)
		{
			Destroy();
			return;
		}
		if (LevelInfo(HitActor) != none)
		{
			DrawType=DT_Mesh;	//Landing Conversion
//			DrawType=DT_Sprite; //Useful if swapped with DT_Mesh, kinda like solid snowfall
			DrawScale=0.2;		//Sets LAND size
//			SetRotation(rotator(HitNor));	//Enable if mesh imported vertically
			SetPhysics(PHYS_None);
		}
		else
			Destroy();
	}

	function Landed(vector HitNor)
	{
		HitWall(HitNor,None);
	}

	function Timer()	//Fade Away
	{
		if (Level.NetMode == NM_Standalone)
		{
			if (Physics != PHYS_None)
				DrawScale=0.05;		//Sets FALL size
			Time-=0.005;
			if (Time <= 0.0)
			{
				if (ScaleGlow == 1.0)
					ScaleGlow = 0.8;
				ScaleGlow -= 0.004;
				if (ScaleGlow < 0.004)
					Destroy();
			}
		}
	}
	
//Water Contact===============================================================
	simulated function ZoneChange( Zoneinfo NewZone )	//Creates 'WaterRing' and Destroy()'s the Decal when entering waterzone
	{
		local WaterRing WR;
		
		if (NewZone.bWaterZone || bHitWater)
		{
			bHitWater = True;
			WR = Spawn(class'WaterRing',,,,rot(16384,0,0));		//Spawn WaterRing
			WR.DrawScale = 0.2;
			WR.RemoteRole = ROLE_None;
			Destroy();
		}
	}
//============================================================================

Begin:
	Time = 1.0;		//Initialize fade Timer
	RandDecals=Rand(10);  //Randomize
	Skin=RandomDecals[RandDecals];
	Texture=RandomDecals[RandDecals];
	DrawType=DT_Sprite;	//Falling sprite
	SetPhysics(PHYS_Falling);
	bBounce = true;		// Bounce on fast contact
	SetTimer(0.1,True);	//Initialize Timer
}
*/

defaultproperties
{
}
