//=============================================================================
// JazzStone.
//=============================================================================
class JazzStone expands JazzProjectile;

var bool bCanHitOwner;


simulated function PostBeginPlay()
{
	local vector X,Y,Z;
	local rotator RandRot;

	Super.PostBeginPlay();
	
	GetAxes(Instigator.ViewRotation,X,Y,Z);
	
	Spawn(class'RockBall',self);
	
	Velocity = X * (Instigator.Velocity Dot X)*0.4 + Vector(Rotation) * Speed + FRand() * 100 * Vector(Rotation);
		
	Velocity.z += 210;
	
	SetTimer(2.5+FRand()*0.5,false);
	
	RandRot.Pitch = FRand() * 1400 - 700;
	RandRot.Yaw = FRand() * 1400 - 700;
	RandRot.Roll = FRand() * 1400 - 700;
	
	MaxSpeed = 1000;
	
	Velocity = Velocity >> RandRot;
	
	RandSpin(50000);	
	
	bCanHitOwner = False;
	
	if (Instigator.HeadRegion.Zone.bWaterZone)
	{
		Velocity=0.6*Velocity;			
	}	
}

simulated function Timer()
{
	Explosion(Location+Vect(0,0,1)*16);
}

simulated function Landed( vector HitNormal )
{
	HitWall( HitNormal, None );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if ( (ValidHit(Other)) || bCanHitOwner )
		Explosion(HitLocation);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	bCanHitOwner = True;
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	speed = VSize(Velocity);
	if ( Level.NetMode != NM_DedicatedServer )
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.5, speed/800) );
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	else if ( speed < 20 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
	}
}

///////////////////////////////////////////////////////
function Explosion(vector HitLocation)
{
	local int A;
	local rotator RandRot;
	local JazzStoneShard r;

	Petrify();
	
	for(A = 3+(FRand()*4); A > 0; A--)
	{
		r = spawn(class'JazzStoneShard');
		RandRot.Pitch = FRand() * 65535;
		RandRot.Yaw = FRand() * 65535;
		RandRot.Roll = FRand() * 65535;
		
		r.Velocity = vect(500,0,0) >> RandRot;
		
		r.RandSpin(5000);
	}
	
	spawn(class'StoneExplosion');
	
	Destroy();
}

simulated function Petrify()
{
	local actor A;
	
	foreach RadiusActors(class'actor',A,100)
	{
		if(JazzPawn(A) != None)
		{
			JazzPawn(A).Petrify();
		}
		else if(JazzDecoration(A) != None)
		{
			//JazzDecoration(A).Petrify();
		}
		else if(JazzPlayer(A) != None)
		{
			JazzPlayer(A).Petrify();
		}
	}
}

defaultproperties
{
     speed=400.000000
     Physics=PHYS_Falling
     AnimSequence=Pos1
     Mesh=Mesh'UnrealShare.BoulderM'
     DrawScale=0.300000
     AmbientGlow=255
     bUnlit=False
     LightType=LT_SubtlePulse
     LightEffect=LE_Rotor
     LightBrightness=100
     LightHue=187
     LightSaturation=65
     LightRadius=6
     LightPeriod=70
     LightPhase=70
     bBounce=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2335)
}
