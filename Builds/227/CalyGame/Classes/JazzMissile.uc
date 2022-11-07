//=============================================================================
// JazzMissile.
//=============================================================================
class JazzMissile expands JazzProjectile;

var Actor LockedTarget;
var float MagnitudeVel,Count,SmokeRate;
var vector InitialDir;
var bool bRing,bHitWater,bWaterStart;
// The maximum magnitude of the vertical wandering
var () float RanMagVer;
// The maximum magnitude of the horizontal wandering
var () float RanMagHor;
// The amount of time a homing missile needs before it starts to track its target
var () float DumbTime;
// The maximum amount a homing missile can rotate in one tick
var () float MaxRotation;

// How long the missile has been alive
var float MissileLife;

Enum EDir
{
	Dir_Up,
	Dir_Left,
	Dir_Right,
	Dir_Down,
	Dir_None
};

function EDir NeedToTurnHorizontal(vector targ,out float OutRange)
{
	local int YawErr;

	DesiredRotation = Rotator(targ - location);
	DesiredRotation.Yaw = DesiredRotation.Yaw & 65535;
	YawErr = (DesiredRotation.Yaw - (Rotation.Yaw & 65535)) & 65535;
	if (YawErr > 1500 && YawErr < 65535/2)
	{
		OutRange = YawErr;
		return Dir_Right;
	}
	else if (YawErr < 64035 && YawErr > 65535/2)
	{
		OutRange = 65535 - YawErr;
		return Dir_Left;
	}

	return Dir_None;
}

function EDir NeedToTurnVertical(vector targ,out float OutRange)
{
	local int PitchErr;
	
	DesiredRotation = Rotator(targ - location);
	DesiredRotation.Pitch = DesiredRotation.Pitch & 65535;
	PitchErr = (DesiredRotation.Pitch - (Rotation.Pitch & 65535)) & 65535;
	if (PitchErr > 1500 && PitchErr < 65535/2)
	{
		OutRange = PitchErr;
		return Dir_Up;
	}
	else if (PitchErr < 64035 && PitchErr > 65535/2)
	{
		OutRange = 65535 - PitchErr;
		return Dir_Down;
	}

	return Dir_None;
}

simulated function PostBeginPlay()
{
	Count = -0.1;
	if (Level.bHighDetailMode) SmokeRate = 0.035;
	else SmokeRate = 0.15;
}

simulated function Tick(float DeltaTime)
{
	local JazzSmoke b;

	if (bHitWater)
	{
		Disable('Tick');
		Return;
	}
	Count += DeltaTime;
	if ( (Count>(SmokeRate+FRand()*(SmokeRate+0.035))) && (Level.NetMode!=NM_DedicatedServer) ) 
	{
		// FIXME: Change away from Smoke Puff
		b = Spawn(class'JazzSmoke');
		b.RemoteRole = ROLE_None;		
		Count=0.0;
	}
}

auto state Flying
{

/*	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local WaterRing w;
		
		if (!NewZone.bWaterZone || bHitWater) Return;

		bHitWater = True;
		Disable('Tick');
		w = Spawn(class'WaterRing',,,,rot(16384,0,0));
		w.DrawScale = 0.2;
		w.RemoteRole = ROLE_None;
		Velocity=0.6*Velocity;
		PlayAnim( 'Still', 3.0 );		
	}*/

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ((Other != instigator) && (JazzMissile(Other) == none)) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local int ChunkNumber;
	
		HurtRadius(Damage,200.0, 'exploded', MomentumTransfer, HitLocation );
		
		// CALYCHANGE - Reinstate with new explosion effect
		spawn(class'RedCircleLarge',,,HitLocation + HitNormal*16);
 		//spawn(class'SpriteBallExplosion',,,HitLocation + HitNormal*16);	
 		//if (bRing) Spawn(class'RingExplosion3',,,HitLocation + HitNormal*16,rotator(HitNormal));
 		
 		// Let's get thouse chunks that make explosions so fun to watch
 		for(ChunkNumber = Rand(4)+3; ChunkNumber > 0; ChunkNumber--)
 		{
 			// FIXME: Either make a new smoking chip, or remove the whole chip thing
 			// spawn(class'SmokingChip',,,HitLocation+HitNormal);
 		}
 		
 		Destroy();
	}
	
	simulated function Tick( float DeltaTime )
	{
		local vector VelMod;
		local vector RotMod,StraightVel;
		local rotator NewRotation;
		local EDir TurnDir;
		local float TurnRange;
		local JazzSmoke SmokePuff;
		
		// Super.Tick(DeltaTime);
		
		MissileLife += 1 * DeltaTime;
		
		if(LockedTarget != None)
		{
			if(MissileLife >= DumbTime)
			{
				
				// Get our rotation for modification
				NewRotation = Rotation;
			
				// Try to make the missile rotate towards the target
				TurnDir = NeedToTurnHorizontal(LockedTarget.Location,TurnRange);
				
				if(TurnDir != Dir_None)
				{
					if (TurnDir == Dir_Left)
					{
						if(TurnRange > MaxRotation)
						{
							NewRotation.Yaw -= MaxRotation*DeltaTime;
						}
						else
						{
							NewRotation.Yaw -= TurnDir*4*Deltatime;
						}
					}
					else
					{
						if(TurnRange > MaxRotation)
						{
							NewRotation.Yaw += MaxRotation*DeltaTime;
						}
						else
						{
							NewRotation.Yaw += TurnDir*4*Deltatime;
						}
					}
				}
				
				TurnDir = NeedToTurnVertical(LockedTarget.Location,TurnRange);
				
				if(TurnDir != Dir_None)
				{
					if (TurnDir == Dir_Up)
					{
						if ( TurnRange > MaxRotation)
						{
							NewRotation.Pitch += MaxRotation*DeltaTime;
						}
						else
						{
							NewRotation.Pitch += TurnRange*4*Deltatime;
						}
					}
					else
					{
						if ( TurnRange > MaxRotation)
						{
							NewRotation.Pitch -= MaxRotation*DeltaTime;
						}
						else
						{
							NewRotation.Pitch -= TurnRange*4*Deltatime;
						}
					}
				}
				
				// Get our velocity with out our rotation in affect
				VelMod = Velocity << Rotation;
				
				// Change the rotation of the missile
				SetRotation(NewRotation);				
				
				// Set the velocity equal to what it was before, but with our new rotation
				Velocity = VelMod >> Rotation;
				
				// Slightly less bouncing around
				VelMod.X = 0;
				VelMod.Y = sin(MissileLife)*((RanMagHor/2)*Frand()-(RanMagHor/4));
				VelMod.Z = cos(MissileLife)*((RanMagVer/2)*Frand()-(RanMagVer/4));
			}
			else
			{
				VelMod.X = 0;
				VelMod.Y = sin(MissileLife)*(RanMagHor*Frand()-(RanMagHor/2));
				VelMod.Z = cos(MissileLife)*(RanMagVer*Frand()-(RanMagVer/2));			
			}
		}
		else
		{
			// Lets try to make the missile kinda spin around
			VelMod.X = 0;
			VelMod.Y = sin(MissileLife)*(RanMagHor*Frand()-(RanMagHor/2));
			VelMod.Z = cos(MissileLife)*(RanMagVer*Frand()-(RanMagVer/2));
		}

		VelMod = VelMod >> Rotation;

		Velocity = Velocity + VelMod;
		
		// Add some smoke trails
		if (bHitWater)
		{
			Disable('Tick');
			Return;
		}
		Count += DeltaTime;
		if ( (Count>(SmokeRate+FRand()*(SmokeRate+0.035))) && (Level.NetMode!=NM_DedicatedServer) ) 
		{
			SmokePuff = Spawn(class'JazzSmoke');
			SmokePuff.RemoteRole = ROLE_None;		
			Count=0.0;
		}		
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
     RanMagVer=30.000000
     RanMagHor=30.000000
     DumbTime=1.500000
     MaxRotation=2000.000000
     speed=1300.000000
     Damage=20.000000
     MomentumTransfer=20000
     Mesh=Mesh'JazzObjectoids.rocket1'
}
