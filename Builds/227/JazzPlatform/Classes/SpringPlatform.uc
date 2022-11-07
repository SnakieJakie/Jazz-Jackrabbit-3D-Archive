//=============================================================================
// SpringPlatform.
//=============================================================================
class SpringPlatform expands JazzMotionObjects;

// The location the platform is supposed to take
var vector Origin;

// The rate at which the platform will move back to it's wanted location
var () float Movement;

// The rate at which the platform's velocity will slow down
var () float SlowDown;

// Various variables about bouncing and movement
var () float Resist;

// The velocity at which it launches an object
var () float Launch;

var bool bJustDown;
var actor Stander;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Origin = Location;
}

event Tick(float DeltaTime)
{
	if (Location != Origin)
	{
		if(Location.Z > Origin.Z)
		{
			Velocity.Z -= Movement*DeltaTime*((Location.Z-Origin.Z)/7);

			if(bJustDown)
			{
				foreach BasedActors(class'Actor',Stander)
				{
					Stander.Velocity.Z += Launch;
					Stander.SetPhysics(PHYS_Falling);
					log("Attempting to launch actor: " $ Stander);
				}
			}
		}
		else if (Location.Z < Origin.Z)
		{
			Velocity.Z += Movement*DeltaTime*((Origin.Z-Location.Z)/7);
		}
		
		if(Velocity.Z > 0 && !bJustDown)
		{
			bJustDown = true;
		}
		
		Velocity /= SlowDown;
	}
}

event Bump(Actor Other)
{
	Velocity.Z += (Other.Velocity.Z*Other.Mass)/Mass * Resist;
	bJustDown = false;
}

defaultproperties
{
     Movement=100.000000
     SlowDown=1.100000
     Resist=1.700000
     Launch=1100.000000
     Physics=PHYS_Projectile
     DrawType=DT_Mesh
     DrawScale=7.000000
     CollisionRadius=50.000000
     CollisionHeight=40.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
