//=============================================================================
// JazzTreasureHuntHUD.
//=============================================================================
class JazzTreasureHuntHUD expands JazzHUD;

function PostRender(canvas Canvas)
{
/*	local int Min, Sec, PSec;
	local float Temp;*/
	
	Super.PostRender(Canvas);
	
/*	Canvas.Font = Canvas.SmallFont;
	
	if(!JazzPlayer(Owner).bShowScores)
	{
	
		Min = TreasureHunt(Level.Game).GameTime/60;
		Sec = TreasureHunt(Level.Game).GameTime - (Min*60);
		
		Temp = TreasureHunt(Level.Game).GameTime - (Min*60) - Sec;
		
		PSec = Temp * 100;
		
		Canvas.SetPos(0,0);
		
		Canvas.DrawText(Digits(Min,3)$":"$Digits(Sec,2)$":"$Digits(PSec,2), False);
		
		Canvas.SetPos(0,10);
		Canvas.DrawText("Gems: "$JazzPlayer(Owner).GemNumber);
		
		if(JazzPlayer(Owner).TreasureKey)
		{
			Canvas.SetPos(0,20);
			Canvas.DrawText("Key");
		}
	}*/
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HUD Kinetic																		HUD STYLE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HUD Style : Kinetic Single Player
//
function DrawHudKinetic(canvas Canvas)
{
	// Display object amount bar at right
	MiscObjectDisplayBar(Canvas);
		
	// No score in this multiplayer mode.
	//if (ProcessComponent(1,Canvas.SizeX+10,-50,Canvas.SizeX-40,4))
	//DancingScore	(Canvas,ComponentX,ComponentY);
		
	DancingMessage	(Canvas,Canvas.SizeX/2,Canvas.SizeY/2);

	if (ProcessComponent(3,-40,Canvas.SizeY+200,10,Canvas.SizeY-10))
	WeaponDisplay	(Canvas,ComponentX,ComponentY);
	//WeaponDisplay	(Canvas,10,Canvas.SizeY-10);
		
	//if (ProcessComponent(2,-50,-50,1,1))	// Component 2 - Health
	//HeartHealthBar	(Canvas,ComponentX,ComponentY,JazzPlayer(Owner).Health,5);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Master function for the display bar												HUD FUNCTION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Override the display bar to provide multiplayer personal game stats instead of normal bar information.
//
//
function MiscObjectDisplayBar(canvas Canvas)
{
	local int   Min,Sec,PSec;
	local float Temp;

	if (ProcessComponent(0,-100,0,Canvas.SizeX*0.02,5))		// Component 0 - Carrots / Money
	{
	MiscObjectDisplay	(Canvas,ComponentX,ComponentY,3,0.30);

	// Display Time Elapsed	
	Min = TreasureHunt(Level.Game).GameTime/60;
	Sec = TreasureHunt(Level.Game).GameTime - (Min*60);
	Temp = TreasureHunt(Level.Game).GameTime - (Min*60) - Sec;
	PSec = Temp * 100;
	
	// Display Time Elapsed
	MiscObjectDispIn	(Canvas,ComponentX,ComponentY,1,texture'Clock',
		Digits(Min,3)$":"$Digits(Sec,2)$":"$Digits(PSec,2));			// Display Time
		
	// Display Treasure (Gems)
	MiscObjectDispIn	(Canvas,ComponentX,ComponentY,2,texture'JazzGem',
		""$JazzPlayer(Owner).GemNumber);								// Display Treasure

	// Display Key		
	if(JazzPlayer(Owner).TreasureKey)
	{
		MiscObjectDispIn	(Canvas,ComponentX,ComponentY,3,texture'JazzKey',
			"Key Found");								// Display Key
	}
	else
	{
		MiscObjectDispIn	(Canvas,ComponentX,ComponentY,3,None,
			"Need Key");								// Display Key
	}
		
	}
		
	// Force Display
	UpdateComponent(0,10);
}

defaultproperties
{
}
