//=============================================================================
// HealthCarrot.
//=============================================================================
class HealthCarrot expands JazzCarrotBase;

// Orange Carrot		Common
// -------------
//
// Increases Player's Health
// +8 HP
//
var(JazzCarrot) int	HealingAmount;

function DoPickupEffect( pawn Other )
{
	//Log("HealthCarrot) PickUp");

	// Is a player?
	if (JazzPlayer(Other)!=None)
	{	
		JazzPlayer(Other).AddHealth(HealingAmount);
		JazzPlayer(Other).EatFood(false);
	}
	else
	if (JazzPawnAI(Other)!=None)
	{
		JazzPawnAI(Other).Health += HealingAmount;
		if (JazzPawnAI(Other).Health > JazzPawnAI(Other).Default.Health)
		JazzPawnAI(Other).Health = JazzPawnAI(Other).Default.Health;
		//Log("JazzPawnAI) Picked Up Health");
	}
}


////////////////////////////////////////////////////////////////////////////////////////
// Desirability of the Item
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	// Health Desirability
	if (Bot.Default.Health<=0)							// Bot has no health
	return (-1);
	else
	return ((1-float(Bot.Health) / float(Bot.Default.Health))*150);	// Bot 0-150 Desirability
}

defaultproperties
{
     HealingAmount=8
     PlayerViewScale=3.000000
     PickupViewMesh=Mesh'JazzObjectoids.Carrotdown'
     PickupViewScale=3.000000
     PickupSound=Sound'JazzSounds.Items.carrotmunch'
     Texture=None
     Mesh=Mesh'JazzObjectoids.Carrotdown'
     DrawScale=1.500000
     CollisionHeight=60.000000
}
