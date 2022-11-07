//=============================================================================
// JazzWaterFountain.
//=============================================================================
class JazzWaterFountain expands ParticleTrails;

function PostBeginPlay()
{
	NoOwner = true;
	RandomizeTrailActorYaw = true;
	Activate(0.2);
}

auto state TrailOn
{
	function TrailActorFinish(actor Image)
	{
		Image.Velocity = vect(0,0,-100);
		
		SingleSparklies(Image).Drifting = 0.5;
		SingleSparklies(Image).MaxLifeSpan = 3;
		SingleSparklies(Image).LifeSpan = 3;
		SingleSparklies(Image).OwnerExists = false;
	}
}

defaultproperties
{
     TrailActor=Class'CalyGame.SpritePoofieOval'
     RandomizeTrailActorYaw=True
     TrailRandomRadius=0.200000
     bHidden=True
     RemoteRole=ROLE_DumbProxy
     DrawType=DT_Sprite
     Texture=Texture'JazzArt.Particles.Jazzp8'
}
