//=============================================================================
// Turtle1.
//=============================================================================
class Turtle1 expands JazzPawnAI;

#exec MESH IMPORT MESH=turtle1 ANIVFILE=MODELS\turtle_a.3d DATAFILE=MODELS\turtle_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=turtle1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Turtle1 SEQ=All                      STARTFRAME=0 NUMFRAMES=117
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlehide               STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlewalk               STARTFRAME=60 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleRunslow            STARTFRAME=89 NUMFRAMES=16
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleRunfast            STARTFRAME=105 NUMFRAMES=12

#exec MESHMAP NEW   MESHMAP=turtle1 MESH=turtle1
#exec MESHMAP SCALE MESHMAP=turtle1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jturtle_01 FILE=Textures\turtle_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=turtle1 NUM=0 TEXTURE=Jturtle1_01
#exec MESHMAP SETTEXTURE MESHMAP=turtle1 NUM=1 TEXTURE=Jturtle1_01

/////////////////////////////////////////////////////////////////////////////////////
// 																	ANIMATIONS
/////////////////////////////////////////////////////////////////////////////////////
//
// Waiting animation
//
function PlayWaiting()
{
	LoopAnim('turtle1',0.9);
}

// Slow walk Animation
//
function PlaySlowWalk()
{
	LoopAnim('turtle1',0.9);
}

// Normal walk Animation
function PlayWalking()
{
	LoopAnim('turtle1',0.9);
}

defaultproperties
{
     WaitStyle=WAT_LoneWanderer
     CombatStyle=COM_Rusher
     WalkingSpeed=200.000000
     RushSpeed=200.000000
     FindFriendDesire=6
     WanderDesire=8
     WanderRange=1000.000000
     WaitingDesire=3
     ScoreForDefeating=100
     ExperienceForDefeating=10
     DeathEffect=Class'JazzContent.ParticleExplosion'
     JumpOnDamage=50
     JumpOnTakeDamage=True
     ToucherDamage=10
     ToucherTakeDamage=True
     EnergyDamage=2.000000
     FireDamage=2.000000
     SharpPhysicalDamage=0.000000
     BluntPhysicalDamage=2.000000
     DropItemDead=Class'JazzContent.JazzItemLevel1'
     bFreezeable=True
     bBurnable=True
     bPetrify=True
     GroundSpeed=50.000000
     Health=50
     AnimSequence=turtle1
     AnimRate=0.200000
     DrawType=DT_Mesh
     Skin=Texture'JazzEnemy.Skins.Jturtle1_01'
     Mesh=Mesh'JazzEnemy.turtle1'
     DrawScale=2.000000
     CollisionRadius=60.000000
     CollisionHeight=60.000000
}