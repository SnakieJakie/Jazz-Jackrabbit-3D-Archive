//=============================================================================
// ParticleColumnTrail.
//=============================================================================
class ParticleColumnTrail expands ParticleColumn;


auto state TrailOn
{
	// Draw Effect Again
	//
	function NewEffect()
	{
		local Actor Image;
		local SparkleTrail ST;
		
		if (Owner == None)
		Destroy();
		
		Image = spawn(class<actor>(TrailActor),Owner);
		
		if (RandomizeTrailActorFacing)
		{
			Image.SetRotation(RotRand(true));
		}
		
		spawn(class'CopyTrail',Image);
	}
}

defaultproperties
{
}
