//=============================================================================
// CopyTrail.
//=============================================================================
class CopyTrail expands ParticleTrails;


auto state TrailOn
{
	// Draw Effect Again
	//
	function NewEffect()
	{
		local Actor Image;

		if ((Owner == None) || (Owner.Name == 'None'))
		Destroy();

		Image = spawn(class<actor>(TrailActor),Owner);

		Image.DrawScale 	= Owner.DrawScale;
		Image.DrawType 		= Owner.DrawType;
		Image.AnimSequence 	= Owner.AnimSequence;
		Image.AnimRate 		= Owner.AnimRate;
		Image.AnimFrame 	= Owner.AnimFrame;
		Image.Skin 			= Owner.Skin;
		Image.Sprite 		= Owner.Sprite;
		Image.Texture 		= Owner.Texture;
		Image.Mesh 			= Owner.Mesh;
		Image.LifeSpan		= 1;
		Image.SetLocation( Owner.Location );
		
		if (RandomizeTrailActorFacing)
		{
			Image.SetRotation(RotRand(true));
		}
	}
}

defaultproperties
{
     TrailActor=Class'CalyGame.JazzPlayerTrailImage'
}
