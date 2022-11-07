//=============================================================================
// SparkleColumn.
//=============================================================================
class SparkleColumn expands JazzEffects;

var float ZHeight;

event Tick (float DeltaTime)
{
	local rotator NewRotation;
	local vector NewLocation;
	
	//Log("SparkleColumn) "$NewRotation.Yaw$" "$Location$" "$Owner.Location);

	NewRotation = Rotation;
	NewRotation.Yaw += 60000*DeltaTime;
	SetRotation(NewRotation);
	
	ZHeight += 20*DeltaTime;
	
	if (Owner != None) 
	{
	NewLocation = vect(30,0,0);
	NewLocation.Z = ZHeight;
	SetLocation(Owner.Location + (NewLocation >> Rotation));
	}
	
	// ScaleDown
	//
	DrawScale = 1*(LifeSpan/4);
	
}

defaultproperties
{
     LifeSpan=4.000000
     Style=STY_Translucent
     Sprite=Texture'UnrealShare.SKEffect.Skj_a09'
     Texture=Texture'UnrealShare.SKEffect.Skj_a09'
     DrawScale=0.500000
     ScaleGlow=0.500000
}
