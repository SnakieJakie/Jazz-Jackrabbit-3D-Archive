//=============================================================================
// IckyCarrot.
//=============================================================================
class IckyCarrot expands Jazz3Carrot;

// Orange Carrot		Common
// -------------
//
// Increases Player's Health
// -10 HP
//
var(JazzCarrot) int		PoisonDamage;
var(JazzCarrot) float	PoisonTime;

/*
function DoPickupEffect( pawn Other )
{
	//
	// Is a player?
	//
	Other.TakeDamage(PoisonDamage,None,self.Location,vect(0,0,0),'Touched');
	if (JazzPlayer(Other)!=None)
	{	
		JazzPlayer(Other).PoisonTime = PoisonTime;
	}
}
*/

defaultproperties
{
     PoisonDamage=10
     PoisonTime=20.000000
     Sprite=Texture'JazzArt.Item.Carrot3'
     Texture=Texture'JazzArt.Item.Carrot3'
     Skin=Texture'JazzArt.Item.Carrot3'
}
