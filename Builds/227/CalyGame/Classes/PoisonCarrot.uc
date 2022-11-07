//=============================================================================
// PoisonCarrot.
//=============================================================================
class PoisonCarrot expands JazzCarrotBase;

// Orange Carrot		Common
// -------------
//
// Increases Player's Health
// -10 HP
//
var(JazzCarrot) int		PoisonDamage;
var(JazzCarrot) float	PoisonTime;


function DoPickupEffect( pawn Other )
{
	//
	// Is a player?
	//
	Other.TakeDamage(PoisonDamage,None,self.Location,vect(0,0,0),'Touched');
	if (JazzPlayer(Other)!=None)
	{	
		JazzPlayer(Other).PoisonTime = PoisonTime;
		JazzPlayer(Other).EatFood(true);
	}
}

////////////////////////////////////////////////////////////////////////////////////////
// Base function that determines the desirability of an item for a 'bot' (Thinker)
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	// Occasionally a thinker may desire to grab this if its wander desire is low)
	return (frand()*10-8);
}

defaultproperties
{
     PoisonDamage=10
     PoisonTime=20.000000
     PickupSound=None
     DrawType=DT_Sprite
     Sprite=Texture'JazzArt.Item.Carrot3'
     Texture=Texture'JazzArt.Item.Carrot3'
}
