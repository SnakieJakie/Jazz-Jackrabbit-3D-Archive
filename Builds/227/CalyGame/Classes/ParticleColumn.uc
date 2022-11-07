//=============================================================================
// ParticleColumn.
//=============================================================================
class ParticleColumn expands ParticleTrails;


auto state TrailOn
{
	// Draw Effect Again
	//
	function NewEffect()
	{
		local Actor Image;
		
		if (Owner == None)
		Destroy();
		
		Image = spawn(class<actor>(TrailActor),Owner);
		
		if (RandomizeTrailActorFacing)
		{
			Image.SetRotation(RotRand(true));
		}
	}
}

defaultproperties
{
     TrailActor=Class'CalyGame.SparkleColumn'
     RandomizeTrailActorFacing=True
     RemoteRole=ROLE_DumbProxy
}
