//=============================================================================
// JazzStoneShard.
//=============================================================================
class JazzStoneShard expands JazzProjectile;


simulated function Petrify(actor A)
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

simulated function HitWall( vector HitNormal, actor Wall )
{
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

simulated function Bump(actor Other)
{
	if(Pawn(Other) != None || JazzDecoration(Other) != None)
	{
		Petrify(Other);
		Destroy();
	}
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if ( ValidHit(Other) )
	if(Pawn(Other) != None || JazzDecoration(Other) != None)
	{
		Petrify(Other);
		Destroy();
	}
}

defaultproperties
{
     Physics=PHYS_Falling
     LifeSpan=8.000000
     AnimSequence=Pos3
     Mesh=Mesh'UnrealShare.BoulderM'
     DrawScale=0.200000
     bUnlit=False
     bBounce=True
}
