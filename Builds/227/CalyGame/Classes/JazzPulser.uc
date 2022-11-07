//=============================================================================
// JazzPulser.
//=============================================================================
class JazzPulser expands Weapon;

var() int hitdamage;
var  float AltAccuracy;

var int	ShotCounter;
var	int ShotRepeatMax;

var float WeaponRepeatDelayTime;
var float WeaponRepeatDelayTimeMax;

/*
function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	// Weapon Power Level
	ShotRepeatMax = 3;
	WeaponRepeatDelayTimeMax = 0.7;
}

function PlayFiring()
{
	Owner.PlaySound(FireSound, SLOT_None,2.0*Pawn(Owner).SoundDampening);
}

// set which hand is holding weapon
function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = mesh'AutoMagL';
	else
		Mesh = mesh'AutoMagR';
}

///////////////////////////////////////////////////////
state NormalFire
{

function Fire( float Value )
{
	Log("JazzPulser) Fire");
	GotoState('NormalFire');
}

Begin:
	// Animation
	if (AnimSequence!='Shoot0') 
	{
		PlayAnim('Shoot',2.5, 0.02);
	}
	PlayAnim('Shoot0',0.26, 0.04);	
	
	// Fire Projectile
	bPointing=True;
	if ( Owner.bHidden )
		CheckVisibility();

	for (ShotCounter=0; ShotCounter<ShotRepeatMax; ShotCounter++)
	{
		if ( bInstantHit )
			TraceFire(0.0);
		else
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
		PlayFiring();	// Sound FX
		Sleep(0.1);
	}
	
	// Delay for next automatic firing
	WeaponRepeatDelayTime = LifeSpan;

	PlayAnim('Shoot2',0.8, 0.0);	
	Sleep(0.3);
	FinishAnim();
	
	Finish();		
	
	GoToState('Idle');
}

function Finish()
{
	if ( bChangeWeapon )
		GotoState('DownWeapon');
	else if ( PlayerPawn(Owner) == None )
		Super.Finish();
	else if ( (Pawn(Owner).Weapon != self) )
		GotoState('Idle');
	else if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 )
		Global.Fire(0);
	else if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 )
		Global.AltFire(0);
	else 
		GotoState('Idle');
}

state Idle
{
	function AnimEnd()
	{
		PlayIdleAnim();
	}

	function bool PutDown()
	{
		GotoState('DownWeapon');
		return True;
	}
	
	function Timer()
	{
		if (FRand()>0.8) PlayAnim('Twiddle',0.6,0.3);
		else if (AnimSequence == 'Twiddle') LoopAnim('Sway1',0.02, 0.3);
	}

Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	Disable('AnimEnd');
	LoopAnim('Sway1',0.02, 0.1);
	SetTimer(1.5,True);
	if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 ) Global.Fire(0.0);
	//if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 ) Global.AltFire(0.0);	
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z, OwnerVel;
	local Projectile da;
	local int OffsetMax;
	
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + /*CalcDrawOffset() +*/ FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, (3.5*FRand()-1<1));	
	
	// Randomize AdjustedAim depending on # of shots fired
	OffsetMax = ShotRepeatMax*100;
	AdjustedAim.Yaw += (frand()*OffsetMax)-OffsetMax/2;
	AdjustedAim.Pitch += (frand()*OffsetMax)-OffsetMax/2;
	
	da = Spawn(class'JazzPulserBullet',,, Start,AdjustedAim);
	
	// Add character's velocity to shots fired in X/Y plane
	//OwnerVel = Pawn(owner).Velocity;
	//OwnerVel = OwnerVel >> Rotation;
	
	//da.Velocity.X += OwnerVel.X;
	//da.Velocity.Y += OwnerVel.Y;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
}

function Fire( float Value )
{
	//Log("JazzPulser) Fire");
	GotoState('NormalFire');
}

*/

defaultproperties
{
     RefireRate=2.000000
     AltRefireRate=1.200000
     FireSound=Sound'AmbModern.OneShot.teleprt1'
     AltFireSound=Sound'AmbModern.OneShot.teleprt2'
     InventoryGroup=0
     PickupMessage="Jazz Pulser"
}
