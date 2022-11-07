//=============================================================================
// JazzArrow.
//=============================================================================
class JazzArrow expands JazzProjectile;


//////////////////////////////////////////////////////////////////////////////////////
// Base Jazz weapon projectile attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//

// Trail rate should be 0.2

/////////////////////////////////////////////////////
auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( ValidHit(Other) )
		{
			hitdamage = ImpactDamage;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), ImpactDamageType );

			Explode(HitLocation,Normal(Velocity));
		}
	}
	
	simulated event Tick (float DeltaTime)
	{
		local rotator NewRotation;
		local int Tot,A,B;
	
		if (Velocity.Z < 0)
		Velocity.Z -= ((100-Velocity.Z)*DeltaTime);
		else
		Velocity.Z -= ((100)*DeltaTime);
		
		// Arrow rotation
		//B = (abs(Velocity.Z) / (abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z)))*16535;
		B = (Velocity.Z) * 100 / 10;
		if (B<-16000) B =-16000;
		if (B>16000) B = 16000;
		
		NewRotation = Rotation;
		NewRotation.Pitch = B;
		SetRotation(NewRotation);
	}

Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}

defaultproperties
{
     InitialVelocity=800.000000
     ImpactDamage=20
     ImpactDamageType=Sharp
     ExplosionWhenHit=Class'CalyGame.SpritePoofie'
     SpawnSound=Sound'JazzSounds.Weapons.fireshot'
     Mesh=Mesh'UnrealShare.ArrowM'
     DrawScale=2.000000
     ScaleGlow=2.000000
     AmbientGlow=255
     bUnlit=False
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     LightType=LT_Flicker
     LightBrightness=51
     LightHue=19
     LightRadius=5
}
