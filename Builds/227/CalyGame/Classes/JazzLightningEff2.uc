//=============================================================================
// JazzLightningEff2.
//=============================================================================
class JazzLightningEff2 expands JazzEffects;

var actor SpellFocus;

auto simulated State SpellEffect
{

simulated function Tick ( float DeltaTime )
{
	local float L;
	
	if (SpellFocus != None)
	{
		SetLocation(SpellFocus.Location);
		SetRotation(SpellFocus.Rotation);
	}
	
	if (LifeSpan<0.5)
		ScaleGlow=(LifeSpan/0.5);
	else
		ScaleGlow=1;
}

begin:
	LifeSpan = 1;
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=Mesh'UnrealI.spot'
     DrawScale=0.500000
     LightType=LT_Flicker
     LightEffect=LE_Rotor
     LightRadius=10
     LightCone=10
}
