//=============================================================================
// BlueWater.
//=============================================================================
class BlueWater expands JazzWaterZone;

var() name	ColorChange;

//
// Special colored water zone which changes a player that falls into it.
//
//

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	local byte ColorChangeVal;

	Super.ActorEntered(Other);
	
	// Color Change
	if (JazzPlayer(Other) != None)
	{
		switch (ColorChange)
		{
			case 'Blue':
				ColorChangeVal = 1;
			break;

			case 'Green':
				ColorChangeVal = 2;
			break;
		
			case 'Yellow':
				ColorChangeVal = 3;
			break;
		
			case 'Grey':
				ColorChangeVal = 4;
			break;
		
			case 'Red':
				ColorChangeVal = 5;
			break;
		
			case 'Purple':
				ColorChangeVal = 6;
			break;
		}

		JazzPlayer(Other).SpecialChangeSkin(ColorChangeVal);
	}
}

defaultproperties
{
     bWaterZone=False
}
