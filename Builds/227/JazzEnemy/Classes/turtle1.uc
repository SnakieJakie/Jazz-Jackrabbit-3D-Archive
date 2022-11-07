//=============================================================================
// turtle1.
//=============================================================================
class turtle1 expands JazzPawnAI;

#exec MESH IMPORT MESH=turtle1 ANIVFILE=MODELS\turtle_a.3d DATAFILE=MODELS\turtle_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=turtle1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Turtle1 SEQ=All                      STARTFRAME=0 NUMFRAMES=310
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlehide               STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlewalk               STARTFRAME=60 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleRun                STARTFRAME=89 NUMFRAMES=16
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtleidle               STARTFRAME=105 NUMFRAMES=70
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleStill              STARTFRAME=175 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlehit                STARTFRAME=176 NUMFRAMES=38
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleUnhide             STARTFRAME=214 NUMFRAMES=96

#exec MESHMAP NEW   MESHMAP=turtle1 MESH=turtle1
#exec MESHMAP SCALE MESHMAP=turtle1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jturtle1_01 FILE=Textures\turtle_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=turtle1 NUM=0 TEXTURE=Jturtle_01
#exec MESHMAP SETTEXTURE MESHMAP=turtle1 NUM=1 TEXTURE=Jturtle_01


/////////////////////////////////////////////////////////////////////////////////////
// 																	ANIMATIONS
/////////////////////////////////////////////////////////////////////////////////////
//
// Waiting animation
//
function PlayWaiting()
{
	LoopAnim('turtleidle',0.9);
	GroundSpeed = WalkingSpeed;
}

// Slow walk Animation
//
function PlaySlowWalk()
{
	LoopAnim('turtlewalk',1.0);
	GroundSpeed = WalkingSpeed;
}

// Normal walk Animation
function PlayWalking()
{
	LoopAnim('turtlewalk',1.0);
	GroundSpeed = WalkingSpeed;
}

// Running Animation
function PlayRunning()
{
	LoopAnim('turtlerun',1.1);
	GroundSpeed = RushSpeed;
}

// Play Hit (Damage)
function PlayHit(float Damage, vector HitLocation, name damageType, float MomentumZ)
{
	GotoState('HitAnimation');
}

/////////////////////////////////////////////////////////////////////////////////////
// Override Action														STATES
/////////////////////////////////////////////////////////////////////////////////////
//
//
//
state HitAnimation
{
Begin:
	IgnoreAllDecisions = true;
	Acceleration = vect(0,0,0);
	PlayAnim('turtleHit');

	FinishAnim();
	IgnoreAllDecisions = false;
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// Override Action														STATES
/////////////////////////////////////////////////////////////////////////////////////
//
//
//
state AfraidOfTarget
{

Begin:
	Log("TurtleHideInShell) "$Self);


	// Afraid: Hide in shell for a brief period of time.
	//
	IgnoreAllDecisions = true;
	PlayAnim('turtleHide');
	Sleep(0.1);
	StateBasedInvulnerability = true;
	FinishAnim();

	// Todo: Make the turtle temporarily indestructable while in his shell.
	// 
	Sleep(6);
	
	// Turtle emerges again from his shell.
	// 
	PlayAnim('turtleUnhide');
	Sleep(0.2);
	StateBasedInvulnerability = false;
	FinishAnim();

	// Make the current target the AfraidTarget.
	//
	//CurrentTarget = AfraidTarget;
	Enemy = None;		// Forgets the player who attacked him.
	AfraidTarget = None;
	IgnoreAllDecisions = false;

	GotoState('Decision');
}

defaultproperties
{
     Courage=COU_Timid
     Intelligence=INT_Instinct
     WaitStyle=WAT_LoneWanderer
     CombatStyle=COM_Rusher
     WalkingSpeed=90.000000
     RushSpeed=250.000000
     ScoreForDefeating=100
     ExperienceForDefeating=10
     DeathEffect=Class'JazzContent.ParticleExplosion'
     JumpOnDamage=50
     JumpOnTakeDamage=True
     ToucherDamage=10
     ToucherTakeDamage=True
     WaterDamage=0.750000
     SoundDamage=0.750000
     SharpPhysicalDamage=0.150000
     DropItemDead=Class'JazzContent.JazzItemLevel1'
     bFreezeable=True
     bBurnable=True
     bPetrify=True
     VoicePack=Class'CalyGame.VoiceTurtle'
     SightRadius=500.000000
     Health=50
     AnimSequence=turtle1
     DrawType=DT_Mesh
     Texture=Texture'JazzEnemy.Skins.Jturtle1_01'
     Mesh=Mesh'JazzEnemy.turtle1'
     DrawScale=0.800000
     CollisionRadius=31.000000
     CollisionHeight=31.000000
}
