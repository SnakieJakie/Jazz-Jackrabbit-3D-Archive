//=============================================================================
// JazzWaterFountainSpray.
//=============================================================================
class JazzWaterFountainSpray expands JazzWaterFountain;

function PostBeginPlay()
{
	NoOwner = true;
	RandomizeTrailActorYaw = true;
	TrailAmount = 5;
	Activate(0.005);
}

auto state TrailOn
{
	function TrailActorFinish(actor Image)
	{
		local Rotator NewRot;
	
		NewRot = rot(0,0,0);
		NewRot.Yaw = FRand()*65536;
		
		Image.SetRotation(NewRot);
		Image.Velocity = (vect(1,0,0) << NewRot) * FRand()*30;
		Image.Velocity.Z += 150;
		
		SingleSparklies(Image).SkipPreBegin = true;
		SingleSparklies(Image).Drifting = 1;
		SingleSparklies(Image).MaxLifeSpan = 4;
		SingleSparklies(Image).LifeSpan = 4;
		SingleSparklies(Image).OwnerExists = false;
		SingleSparklies(Image).MaxDrawScale = 0.10;
	}
	
	function Tick(float DeltaTime)
	{
		Timer();
	}
Begin:
	NewEffect();
	Sleep(0.001);
	NewEffect();
}

defaultproperties
{
     TrailActor=Class'CalyGame.JazzWaterFountain'
}
