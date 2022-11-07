//=============================================================================
// JazzLeaderHUD.
//=============================================================================
class JazzLeaderHUD expands JazzHUD;

var () texture JLEAD1;
var () texture JLEAD2;

function PostRender(canvas Canvas)
{
	Super.PostRender(Canvas);
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
		
	DancingMessage	(Canvas,DancingMessageText,Canvas.SizeX/2,Canvas.SizeY/2);
	DancingMessage	(Canvas,VersionMessageText,Canvas.SizeX/2,Canvas.SizeY*0.6);

	DeanHudTypeA	(Canvas,Canvas.SizeX*0.03,Canvas.SizeY*0.03);
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

	if (ProcessComponent(0,Canvas.SizeX+100,1,Canvas.SizeX*0.69,5))		// Component 0 - Carrots / Money
	{
	MiscObjectDisplay	(Canvas,ComponentX,ComponentY,2,0.30);

	// Display Score (Kills)
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,0,None,
		"SCORE",
		"",
		Digits(Pawn(Owner).PlayerReplicationInfo.Score,3)
		);

	// Display Score (Kills)
	if (Owner == LeaderOfThePack(Level.Game).Leader)
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,1,JLEAD1,
		"LEADER",
		""
		);
	else
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,1,JLEAD2,
		"FOLLOWER",
		""
		);
	
	
	}
		
	// Force Display
	UpdateComponent(0,10);
}

defaultproperties
{
     DrawType=DT_Sprite
     JLEAD1=Texture'JazzArt.JLEAD1'
     JLEAD2=Texture'JazzArt.JLEAD2'
}
