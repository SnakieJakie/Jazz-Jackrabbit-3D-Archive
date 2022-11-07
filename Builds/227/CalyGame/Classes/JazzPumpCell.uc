//=============================================================================
// JazzPumpCell.
//=============================================================================
class JazzPumpCell expands JazzWeaponCell;

// The projectile
var JazzPump JPump;


//////////////////////////////////////////////////////////////////////////////////////
// Normal Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state FireStateJazz			// Jazz Jackrabbit's Weapon
{
	function Fire( float Value)
	{
		JPump.Pump(8);
	}
	
	event Tick(float DeltaTime)
	{
		if(JPump == None || JPump.bDestroyed)
		{
			GotoState('','Leave');
		}
	}
	
	Leave:
		MainFireDelay(0.25);	// Main reload 0.25 seconds
		GotoState('Idle');	
		
	Begin:		
}

function Fire( float Value )
{
	AimError = 0;
	JPump = JazzPump(ProjectileFire(class'JazzPump', 800, true));
	
	GotoState('FireStateJazz');
}

//DEVCHANGE
///////////////////////////////////////////////////////////////////////////////////////
// Rate Weapon Cell														AI
///////////////////////////////////////////////////////////////////////////////////////
//
function float	RateCell ()
{
	// Override this function in subclasses
	return (1);
}

defaultproperties
{
     WeaponCapable(1)=255
     PickupMessage="Pump Cell"
     PlayerViewScale=0.300000
     PickupViewScale=0.300000
     Icon=Texture'JazzArt.Weapons.WMedieval'
     Texture=Texture'JazzArt.Effects.NLava1'
     DrawScale=0.300000
}
