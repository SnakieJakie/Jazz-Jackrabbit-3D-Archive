//=============================================================================
// JazzSign.
//=============================================================================
class JazzSign expands JazzGameObjects;

//
// Place a sign down and put this actor in or on it directly.
//
// (This could be modified for things other than signs, of course.)
//

var() string	SignText;

// Activate by Trigger?
//
event Trigger ( actor Other, pawn EventInstigator )
{
	if (JazzPlayer(EventInstigator) != None)
	{
		JazzPlayer(EventInstigator).NewTutorial(SignText,"",true);
	}
}

defaultproperties
{
     ActivationObject=True
     bHidden=True
     Style=STY_None
     CollisionHeight=30.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
