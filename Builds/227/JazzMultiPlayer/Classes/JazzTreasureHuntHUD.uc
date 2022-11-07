//=============================================================================
// JazzTreasureHuntHUD.
//=============================================================================
class JazzTreasureHuntHUD expands JazzHUD;

var () texture JazzKey;
var () texture Clock;
var () texture JazzGem;

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
		
	DancingMessage	(Canvas,DancingMessageText,Canvas.SizeX/2,Canvas.SizeY/2);
	DancingMessage	(Canvas,VersionMessageText,Canvas.SizeX/2,Canvas.SizeY*0.6);

	//if (ProcessComponent(3,-40,Canvas.SizeY+200,00,Canvas.SizeY))
	//WeaponDisplay	(Canvas,ComponentX,ComponentY);

	DeanHudTypeA	(Canvas,Canvas.SizeX*0.03,Canvas.SizeY*0.03);

	if(THPlayerReplicationInfo(Pawn(Owner).PlayerReplicationInfo).TreasureKey)
	{
		DeanHudItemBox	(Canvas,Canvas.SizeX*0.97,Canvas.SizeY*0.97,JazzKey,false,0,None);
	}
	else
	{
		DeanHudItemBox	(Canvas,Canvas.SizeX*0.97,Canvas.SizeY*0.97,None,false,0,None);
	}

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

	if (ProcessComponent(0,Canvas.SizeX+100,0,Canvas.SizeX*0.69,5))		// Component 0 - Carrots / Money
	{
	MiscObjectDisplay	(Canvas,ComponentX,ComponentY,2,0.30);

	// Display Time Elapsed	
	Min = Level.TimeSeconds/60;
	Sec = Level.TimeSeconds - (Min*60);
	Temp = Level.TimeSeconds - (Min*60) - Sec;
	PSec = Temp * 100;
	
	// Display Time Elapsed
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,0,Clock,
		Digits(Min,3)$":"$Digits(Sec,2)$":"$Digits(PSec,2),""); 			// Display Time
		
	// Display Treasure (Gems)
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,1,JazzGem,
		string(THPlayerReplicationInfo(Pawn(Owner).PlayerReplicationInfo).GemNumber),""
		);								// Display Treasure

	}
		
	// Force Display
	UpdateComponent(0,10);
}

defaultproperties
{
    JazzKey=Texture'JazzArt.JazzKey'
    Clock=Texture'JazzArt.Clock'
    JazzGem=Texture'JazzArt.JazzGem'
}
