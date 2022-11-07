//=============================================================================
// HoverPlatform.
//=============================================================================
class HoverPlatform expands JazzMotionObjects;

// The location the platform is supposed to take
var vector Origin;

// The rate at which the platform will move back to it's wanted location
var () float Movement;

// The rate at which the platform's velocity will slow down
var () float SlowDown;

// Various variables about bouncing and movement
var () bool bZBounce;
var () float ZResist;
var () bool bXBounce;
var () float XResist;
var () bool bYBounce;
var () float YResist;

// For floating on the Y axis
var (Bobbing) bool bEnable;
var (Bobbing) float Period;
var (Bobbing) float Magnitude;

var float Dummy;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Origin = Location;
}

event Tick(float DeltaTime)
{
	if (Location != Origin)
	{
		if(bZBounce)
		{
			if(Location.Z > Origin.Z)
			{
				Velocity.Z -= Movement*DeltaTime*((Location.Z-Origin.Z)/7);
			}
			else if (Location.Z < Origin.Z)
			{
				Velocity.Z += Movement*DeltaTime*((Origin.Z-Location.Z)/7);
			}
		}
		
		if(bXBounce)
		{
			if(Location.X > Origin.X)
			{
				Velocity.X -= Movement*DeltaTime*((Location.X-Origin.X)/7);
			}
			else if (Location.X < Origin.X)
			{
				Velocity.X += Movement*DeltaTime*((Origin.X-Location.X)/7);
			}
		}
		
		if(bYBounce)
		{
			if(Location.Y > Origin.Y)
			{
				Velocity.Y -= Movement*DeltaTime*((Location.Y-Origin.Y)/7);
			}
			else if (Location.Z < Origin.Z)
			{
				Velocity.Y += Movement*DeltaTime*((Origin.Y-Location.Y)/7);
			}
		}
	}
	
	Velocity /= SlowDown;
	
	if(bEnable)
	{
		Dummy += (1/Period) * DeltaTime;
		
		if(Dummy > 2*Pi)
		{
			Dummy = 0;
		}
		
		Origin.Z += sin(Dummy) * Magnitude;
	}
}

event Bump(Actor Other)
{
	if(bZBounce)
	{
		Velocity.Z += (Other.Velocity.Z*Other.Mass)/Mass * ZResist;
	}
	
	if(bXBounce)
	{
		Velocity.X += (Other.Velocity.X*Other.Mass)/Mass * XResist;	
	}
	
	if(bYBounce)
	{
		Velocity.Y += (Other.Velocity.Y*Other.Mass)/Mass * YResist;	
	}
}

defaultproperties
{
     Movement=25.000000
     SlowDown=1.070000
     bZBounce=True
     ZResist=1.000000
     XResist=1.000000
     YResist=1.000000
     Period=0.700000
     magnitude=0.700000
     bCollideWhenPlacing=True
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
