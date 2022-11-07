//=============================================================================
// JazzWeaponLevelUp.
//=============================================================================
class JazzWeaponLevelUp expands JazzEffects;

var() 	sound		LevelUpSound;

var		float		HalfLife;


//
// Special effect when the player's weapon increases in power.
//
// Play this effect around the Owner.  (Assumed to be the player in question.)
//

function PreBeginPlay ()
{
	local ParticleTrails P;

	// Oops, no owner set.
	//
	if (Owner==None)
		Destroy();
		
	HalfLife = Default.LifeSpan/2;

	// Pickup Special Effect
	P = Spawn(class'CircularColumn',Owner);
	P.Activate(0.1,3);
}


function Tick ( float DeltaTime )
{
	local float Temp;
	SetLocation(Owner.Location);

 	if (LifeSpan > HalfLife)
 	{
 		Temp = Default.LifeSpan - LifeSpan;
 	
		LightRadius = Temp*50/HalfLife;
 	}
 	else
 	{
		LightRadius = LifeSpan*50/HalfLife;
 	}
}

defaultproperties
{
     LevelUpSound=Sound'JazzSpeech.Jazz.cool'
     LifeSpan=3.000000
     DrawType=DT_None
     LightType=LT_SubtlePulse
     LightEffect=LE_FastWave
     LightBrightness=153
     LightHue=204
     LightSaturation=204
}
