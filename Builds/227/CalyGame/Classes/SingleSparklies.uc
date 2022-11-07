//=============================================================================
// SingleSparklies.
//=============================================================================
class SingleSparklies expands JazzEffects;

var() bool		OwnerExists;
var() vector	LastOwnerLocation;
var() float		Drifting;	// 0 - No drift down				1 - Falling Speed

var   	float	MaxLifeSpan;
var		float	MaxDrawScale;
var		bool	SkipPreBegin;
//
// Note: Sparklies with an owner will follow the owner's motion to maintain the same hit 
// location and not disappear inside them (hopefully).
//
// Hence an explosion centered on an enemy with one of these will follow the enemy and not
// look stupid (hopefully).
//

function PreBeginPlay()
{
	if (Owner != None)
	{
		LastOwnerLocation = Owner.Location;
		OwnerExists = true;
	}
	
	if (!SkipPreBegin)
	{
		MaxLifeSpan = Default.LifeSpan;
		MaxDrawScale = Default.DrawScale;
	}
}

event Tick (float DeltaTime)
{
	local vector	NewLocation;

	if (MaxLifeSpan>0)
	{
	ScaleGlow = LifeSpan/MaxLifeSpan;
	DrawScale = LifeSpan/MaxLifeSpan*MaxDrawScale;
	}
	
	if (OwnerExists)
	{
		if (Owner==None)
		Destroy();
		
		SetLocation(Location + (Owner.Location - LastOwnerLocation));
		LastOwnerLocation = Owner.Location;
		SetRotation(Owner.Rotation);
		
	}
	
	if (Drifting>0)
	{
		NewLocation = Location;
		NewLocation += Velocity*DeltaTime;
		SetLocation(NewLocation);
		Velocity.Z -= Drifting*100*DeltaTime;
	}
}

simulated function HitWall (vector HitNormal, actor Wall)
{	
	if (Drifting>0)
	{
		Destroy();
	}
}

defaultproperties
{
     LifeSpan=1.000000
     Style=STY_Translucent
     Sprite=Texture'UnrealShare.SKEffect.Skj_a04'
     Texture=Texture'UnrealShare.SKEffect.Skj_a04'
     DrawScale=0.500000
}
