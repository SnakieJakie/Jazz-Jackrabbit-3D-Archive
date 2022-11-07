//=============================================================================
// JazzArrowLightning.
//=============================================================================
class JazzArrowLightning expands JazzProjectile;


simulated event Tick (float DeltaTime)
{
	local rotator NewRotation;
	local int Tot,A,B;
	
	ScaleGlow = LifeSpan/Default.LifeSpan;
	DrawScale = LifeSpan/Default.LifeSpan*Default.DrawScale;
	
	if (Velocity.Z < 0)
	Velocity.Z -= ((10-Velocity.Z)*DeltaTime);
	else
	Velocity.Z -= ((10)*DeltaTime);
		
	// Arrow rotation
	//B = (abs(Velocity.Z) / (abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z)))*16535;
	B = (Velocity.Z) * 100 / 10;
	if (B<-16000) B =-16000;
	if (B>16000) B = 16000;
		
	NewRotation = Rotation;
	NewRotation.Pitch = B;
	SetRotation(NewRotation);
}

defaultproperties
{
     InitialVelocity=500.000000
     ImpactDamage=5
     ImpactDamageType=Energy
     ExplosionWhenHit=Class'CalyGame.SpritePoofieSmallBlue'
     RemoteRole=ROLE_DumbProxy
     LifeSpan=2.000000
     Mesh=Mesh'UnrealShare.plasmaM'
     DrawScale=0.800000
     bUnlit=False
     LightType=LT_Steady
     LightBrightness=200
     LightHue=153
     LightRadius=3
}
