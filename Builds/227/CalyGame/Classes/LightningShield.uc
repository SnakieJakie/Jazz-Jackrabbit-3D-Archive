//=============================================================================
// LightningShield.
//=============================================================================
class LightningShield expands JazzShield;

simulated function ShieldTouch( actor Other )
{
	Log("ShieldTouch) "$Other);
	// Remove projectiles
	//
	if (JazzProjectile(Other) != None)
	{
		JazzProjectile(Other).ImpactDamage -= 10;
		
		// Shield Dissipate Projectile Effect
		//
		
		
		//
		if (JazzProjectile(Other).ImpactDamage<=0)
		JazzProjectile(Other).Explode(Location,Location);
	}
		
	
}

// Shield Down Effect
//
simulated state Die
{
	simulated function Tick ( float DeltaTime )
	{
		Super.Tick(DeltaTime);
		ScaleGlow = LifeSpan;
	}

Begin:
	Style = STY_Translucent;
	
	LifeSpan = 1;
}

defaultproperties
{
     ShieldDuration=6.000000
     Style=STY_Modulated
     Mesh=Mesh'UnrealI.spot'
     CollisionRadius=50.000000
     CollisionHeight=80.000000
     bCollideWorld=False
     bProjTarget=True
}
