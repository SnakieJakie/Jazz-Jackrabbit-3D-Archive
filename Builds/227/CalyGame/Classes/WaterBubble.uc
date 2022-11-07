//=============================================================================
// WaterBubble.
//=============================================================================
class WaterBubble expands JazzEffects;

//
// Bubble that comes out of Jazz while underwater and drifts upward for a short period of time. 
//
//

function PreBeginPlay ()
{
	DrawScale = FRand()*0.1;
}

function Tick ( float DeltaTime )
{
	Velocity.Z += 20*DeltaTime;
	Velocity   += VRand()*10*DeltaTime;
	
	ScaleGlow = (LifeSpan / Default.LifeSpan);
	
	if (Region.Zone.bWaterZone != true)
	Destroy();
}

function ZoneChange ( ZoneInfo NewZone )
{
	if (NewZone.bWaterZone != true)
	{
		Destroy();
	}
}

event HitWall( vector HitNormal, actor HitWall )
{
	Destroy();
}

defaultproperties
{
     Physics=PHYS_Projectile
     RemoteRole=ROLE_AutonomousProxy
     LifeSpan=5.000000
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.Bubble'
     bCollideWorld=True
}
