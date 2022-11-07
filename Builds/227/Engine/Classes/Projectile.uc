//=============================================================================
// Projectile.
//
// A delayed-hit projectile moves around for some time after it is created.
// An instant-hit projectile acts immediately. 
//=============================================================================
class Projectile expands Actor
	abstract
	intrinsic;

#exec Texture Import File=Textures\S_Camera.pcx Name=S_Camera Mips=Off Flags=2

//-----------------------------------------------------------------------------
// Projectile variables.

// Motion information.
var() float    Speed;               // Initial speed of projectile.
var() float    MaxSpeed;            // Limit on speed of projectile (0 means no limit)

// Damage attributes.
var() float    Damage;         
var() int	   MomentumTransfer; // Momentum imparted by impacting projectile.

// Projectile sound effects
var() sound    SpawnSound;		// Sound made when projectile is spawned.
var() sound	   ImpactSound;		// Sound made when projectile hits something.
var() sound    MiscSound;		// Miscellaneous Sound.

var() float		ExploWallOut;	// distance to move explosions out from wall

//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;
		
	return false;
}

//==============
// Touching
simulated singular function Touch(Actor Other)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, TestLocation;
	
	if ( Other.IsA('BlockAll') )
	{
		HitWall( Normal(Location - Other.Location), Other);
		return;
	}
	if ( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
	{
		//get exact hitlocation
	 	HitActor = Trace(HitLocation, HitNormal, Location, OldLocation, true);
		if (HitActor == Other)
		{
			if ( (Pawn(Other) != None) 
				&& !Pawn(Other).AdjustHitLocation(HitLocation, Velocity) )
					return;
			ProcessTouch(Other, HitLocation); 
		}
		else 
			ProcessTouch(Other, Other.Location + Other.CollisionRadius * Normal(Location - Other.Location));
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	//should be implemented in subclass
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	if ( Role == ROLE_Authority )
	{
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');

		MakeNoise(1.0);
	}
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

defaultproperties
{
     MaxSpeed=2000.000000
     bDirectional=True
     bNetTemporary=True
     Physics=PHYS_Projectile
     LifeSpan=140.000000
     DrawType=DT_Mesh
     Texture=Texture'Engine.S_Camera'
     bGameRelevant=True
     SoundVolume=0
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=True
     bCollideWorld=True
     NetPriority=6.000000
}
