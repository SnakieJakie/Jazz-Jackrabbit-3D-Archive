//=============================================================================
// BuyItemTrigger.
//=============================================================================
class BuyItemTrigger expands PurchaseBox;

var()	int		CostInMoney;
var()	int		CostInKeys;
var()	name	ThingToOpenEvent;	// Event of the object to open	(Object.Event)

var()	bool	ActivateByTouch;

var()	bool	ActivateOnce;


//
// If a player touches this, check how much money or whatnot they have and determine if they can 
// pass.
//
//
function Touch( actor Other )
{
	if (ActivateByTouch)
	{
		// Check if player
		if (JazzPlayer(Other) != None)
		{
			// UpdateDisplays
			if (CostInMoney>0)	JazzPlayer(Other).UpdateCarrot();
			if (CostInKeys>0)	JazzPlayer(Other).UpdateKeys();
		
			if 	(
				((CostInMoney<=0) || (JazzPlayer(Other).Carrots>=CostInMoney))
				&&
				((CostInKeys<=0) || (JazzPlayer(Other).Keys>=CostInKeys))
				)	
			{
				PerformSale(JazzPlayer(Other));
			}
		}
	}
}


function PerformSale ( JazzPlayer Other )
{
	local BuyItemWindow A;
	
	local SingleSparklies P;
	local JazzMoveControl C;
	local ParticleTrails T;

	// Just decrease money and keys here for now without any animation.
	//
	Other.Carrots -= CostInMoney;
	Other.Keys -= CostInKeys;

	// Open object focus
	//
	ForEach AllActors(class 'BuyItemWindow', A)
	{
		if ( A.Event == ThingToOpenEvent)
		{
			A.Open();

		// Send particle from the player to the box
		//
		P = spawn(class'SingleSparklies',,,Other.Location);
		P.MaxLifeSpan = 0;
		P.LifeSpan = 0;
		
		//T = spawn(class'SparkleTrail'
		
		C = spawn(class'JazzMoveControl');
		C.Start(P,A.Location,Other.Location);
		}
	}

	if (ActivateOnce)
		SetCollision(false);
		
}

defaultproperties
{
     ActivateByTouch=True
     ActivateOnce=True
     bHidden=True
     DrawType=DT_Sprite
     Style=STY_Normal
     Texture=Texture'Engine.S_Keypoint'
     Mesh=None
     bCollideActors=True
}
