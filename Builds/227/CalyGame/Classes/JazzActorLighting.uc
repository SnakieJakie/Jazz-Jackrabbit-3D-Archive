//=============================================================================
// JazzActorLighting.
//=============================================================================
class JazzActorLighting expands JazzEffects;

var() float MaxRadius;

// Test lighting - use subclass for specific effect
// 

function PreBeginPlay ()
{
	LifeSpan = 2;
}

event Tick ( float DeltaTime )
{
	SetLocation(Owner.Location);
	LightRadius = MaxRadius*(LifeSpan/2);
}

defaultproperties
{
     MaxRadius=20.000000
     DrawType=DT_None
     LightType=LT_Steady
     LightEffect=LE_Rotor
     LightBrightness=255
     LightSaturation=153
}
