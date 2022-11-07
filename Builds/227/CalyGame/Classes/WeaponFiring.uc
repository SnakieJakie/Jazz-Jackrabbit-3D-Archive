//=============================================================================
// WeaponFiring.
//=============================================================================
class WeaponFiring expands Inventory;

var 	int		ShotCounter;
var		int 	ShotRepeatMax;

var 	float 	WeaponRepeatDelayTime;
var 	float 	WeaponRepeatDelayTimeMax;

var 	float 	WeaponReloadTime;

var 	bool 	BurstScatter;

var() 	class	ProjectileType;
var() 	float 	ProjectileSpeed;
var() 	bool 	bWarnTarget;

var 	vector 	CalcDrawOffset;
var 	vector 	FireOffset;

//
// These are the classes used by the JazzWeapon to fire from.
//
// Creation of a WeaponFiring actor activates the state automatically, firing the weapon from the owner's
// position.
//
// Since things like the JazzWeapon are really just one class, it would be difficult for anyone else to write
// code using them, and inherently hard to manage.
// 
// JazzWeapon contains a list of WeaponFiring actors to call based on a list of weapon cells, determined by
// the current cell in use by the player.  It's also possible to create a WeaponFiring actor to use.
//
//
///////////////////////////////////////////////////////

function Projectile ProjectileFire(class ProjClass, float ProjSpeed, bool bWarn, float AimError )
{
	local Vector Start, X,Y,Z, OwnerVel;
	local Projectile da;
	local int OffsetMax;
	local rotator AdjustedAim;
	
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + /*CalcDrawOffset() +*/ FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, (3.5*FRand()-1<1));	
	//AdjustedAim = rot(0,0,0);
	
	// Randomize AdjustedAim depending on # of shots fired
	if (BurstScatter)
	{
	OffsetMax = ShotRepeatMax*100;
	AdjustedAim.Yaw += (frand()*OffsetMax)-OffsetMax/2;
	AdjustedAim.Pitch += (frand()*OffsetMax)-OffsetMax/2;
	}
	
	da = Spawn(class<projectile>(ProjectileType),,, Start,AdjustedAim);
	
	// Add character's velocity to shots fired in X/Y plane
	//OwnerVel = Pawn(owner).Velocity;
	//OwnerVel = OwnerVel >> Rotation;
	
	//da.Velocity.X += OwnerVel.X;
	//da.Velocity.Y += OwnerVel.Y;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
}

function CheckVisibility()
{
	if( Owner.bHidden && (Pawn(Owner).Health > 0) && (Pawn(Owner).Visibility < Pawn(Owner).Default.Visibility) )
	{
		Owner.bHidden = false;
		Pawn(Owner).Visibility = Pawn(Owner).Default.Visibility;
	}
}

// Weapon Firing
//
state NormalFire
{

Begin:
	if ( Owner.bHidden )
		CheckVisibility();

	for (ShotCounter=0; ShotCounter<ShotRepeatMax; ShotCounter++)
	{
		ProjectileFire(ProjectileType, ProjectileSpeed, bWarnTarget, 0);
		//PlayFiring();	// Sound FX
		Sleep(0.1);
	}
	
	// Delay for next automatic firing
	WeaponRepeatDelayTime = LifeSpan;

	FinishAnim();
	
	Destroy();
}

defaultproperties
{
}
