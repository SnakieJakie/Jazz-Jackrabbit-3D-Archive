//=============================================================================
// JazzIceGrenade.
//=============================================================================
class JazzIceGrenade expands JazzProjectile;

var bool bCanHitOwner;

var actor EffectFocus;


simulated function PostBeginPlay()
{
	local vector X,Y,Z;
	local rotator RandRot;

	Super.PostBeginPlay();
	
	GetAxes(Instigator.ViewRotation,X,Y,Z);
	
	Velocity = (Vector(Rotation) * InitialVelocity);
	//Velocity = X * (Instigator.Velocity Dot X)*0.4 + Vector(Rotation) * Speed + FRand() * 100 * Vector(Rotation);
		
	Velocity.z += 210;
	
	SetTimer(2.5+FRand()*0.5,false);
	
	MaxSpeed = 1000;
	
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
	{
		EffectFocus = Other;
		Explosion(HitLocation);
	}
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

	// Freeze In Radius 
	Freeze();

	// Create Ice Spike
	if (EffectFocus != None)
	spawn(class'IceSpike',,,EffectFocus.Location-vect(0,0,20));		
	else
	spawn(class'IceSpike',,,HitLocation-vect(0,0,20));		
	
	// Do icy explosion
	PlayHitExplosion();
	
	Destroy();
}

simulated function Freeze()
{
	local actor A;
	
	foreach RadiusActors(class'actor',A,100)
	{
		A.Velocity = vect(0,0,0);
		A.Acceleration = vect(0,0,0);
	
		if(JazzPawn(A) != None)
		{
			JazzPawn(A).Freeze(5);
		}
		else if(JazzDecoration(A) != None)
		{
			//JazzDecoration(A).Petrify();
		}
		else if(JazzPlayer(A) != None)
		{
			JazzPlayer(A).Freeze(5);
		}
	}
}

defaultproperties
{
     InitialVelocity=800.000000
     ImpactDamage=5
     ImpactDamageType=Cold
     RadialDamage=10
     RadialDamageType=Ice
     RadialDamageRadius=100.000000
     ExplosionWhenHit=Class'CalyGame.SpritePoofie'
     Physics=PHYS_Falling
     Texture=Texture'JazzObjectoids.Skins.Jicebomb_01'
     Mesh=Mesh'JazzObjectoids.icebomb'
     DrawScale=0.250000
     AmbientGlow=255
     LightType=LT_SubtlePulse
     LightBrightness=102
     LightHue=153
     LightSaturation=153
     LightRadius=4
     bBounce=True
     bFixedRotationDir=True
}
