//=============================================================================
// JazzBubble.
//=============================================================================
class JazzBubble expands JazzProjectile;

var float MagnitudeVel,Count,SmokeRate;
var vector InitialDir;
var bool bRing,bHitWater,bWaterStart;
// The maximum magnitude of the vertical wandering
var () float RanMagVer;
// The maximum magnitude of the horizontal wandering
var () float RanMagHor;

auto state Flying
{
/*	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
		
		if (!NewZone.bWaterZone || bHitWater) Return;

		bHitWater = True;
		Disable('Tick');
		w = Spawn(class'WaterRing',,,,rot(16384,0,0));
		w.DrawScale = 0.2;
		w.RemoteRole = ROLE_None;
		Velocity=0.6*Velocity;
	}*/

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		// Put other in a bubble
		if(JazzPlayer(Other) != None)
		{
			JazzPlayer(Other).Bubble();
			Destroy();
		}
		else if(JazzPawn(Other) != None)
		{
			JazzPawn(Other).Bubble();
			Destroy();
		}

	}
	
	simulated function Tick( float DeltaTime )
	{
		local vector VelMod;

		VelMod.X = 0;
		VelMod.Y = sin(FRand()*5)*(RanMagHor*Frand()-(RanMagHor/2));
		VelMod.Z = cos(FRand()*5)*(RanMagVer*Frand()-(RanMagVer/2));

		VelMod = VelMod >> Rotation;

		Velocity = Velocity + VelMod;
	}

	function BeginState()
	{
		initialDir = vector(Rotation);	
		Velocity = speed*initialDir;
		Acceleration = initialDir*50;
		PlaySound(SpawnSound, SLOT_None, 2.3);	
		PlayAnim( 'Armed', 0.2 );
		if (Region.Zone.bWaterZone)
		{
			bHitWater = True;
			Velocity=0.6*Velocity;
		}
	}
}

defaultproperties
{
}
