//=============================================================================
// BuyItemWindow.
//=============================================================================
class BuyItemWindow expands PurchaseBox;

var 	float		TimeToNoBox;		// Animation Delay for Opening
var() 	sound		OpenSound;
var()	class		Sparkles;


// Open Purchase Box
//
function Open()
{
	GotoState('Opened');
}

// Close Purchase Box
//
function Close()
{
	GotoState('Closed');
}


// Purchase box begins life closed
//
auto state Closed
{

function BeginState()
{
ScaleGlow = 1;
AmbientGlow = 255;
}

}


// Purchase box begins life closed
//
state Opened
{

event Tick ( float DeltaTime )
{
	if (TimeToNoBox>0)
	{
		Log("OpenTick");
	
		TimeToNoBox -= DeltaTime;
	
		if (TimeToNoBox<0)
		{
			// Create Sparkle Effect
			if (Sparkles != None)
			spawn(class<actor>(Sparkles),Self);
			
			// Destroy
			Destroy();
		}
	
		ScaleGlow = TimeToNoBox/2;
		AmbientGlow = TimeToNoBox*255;
	}
}

function BeginState()
{
ScaleGlow = 1;
AmbientGlow = 255;
}

Begin:
	TimeToNoBox = 2;
	PlaySound(OpenSound);
}

defaultproperties
{
     OpenSound=Sound'JazzSounds.Interface.menuhit'
     Sparkles=Class'CalyGame.ParticleFadeUp'
     DrawScale=2.000000
     ScaleGlow=0.100000
     CollisionRadius=66.000000
     CollisionHeight=66.000000
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
