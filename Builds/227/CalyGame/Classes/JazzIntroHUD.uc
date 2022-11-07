//=============================================================================
// JazzIntroHUD.
//=============================================================================
class JazzIntroHUD expands HUD;

var() float HUDExistTime;

var() 	string	Introductions[20];			// Credits-style text
var() 	int			IntroductionNum;

var()	font DSFont;
var()	font DLFont;

//////////////////////////////////////////////////////////////////////////////////////////////////
// HUD Initialization														INITIALIZE
//////////////////////////////////////////////////////////////////////////////////////////////////
// Initialize our Hud interface and go from there.
//
// We'll want to set the interface window defauls.
//
//
function PostBeginPlay()
{
	// DEMO Text
	//ScreenMessage("JAZZ 3 DEMO V4",10);
}

// PreRender calls to other associated inventory displays
//
function PreRender ( canvas Canvas )
{
	Super.PreRender(Canvas);
}

simulated function ChangeCrosshair(int d)
{
	// Unused for JazzHUD
}

// New Menu Desired
//
simulated function CreateMenu()
{
	if ( PlayerPawn(Owner).bSpecialMenu && (PlayerPawn(Owner).SpecialMenu != None) )
	{
		MainMenu = Spawn(PlayerPawn(Owner).SpecialMenu, self);
		PlayerPawn(Owner).bSpecialMenu = false;
	}
	
	if ( MainMenu == None )
		MainMenu = Spawn(MainMenuType, self);
		
	if ( MainMenu == None )
	{
		PlayerPawn(Owner).bShowMenu = false;
		Level.bPlayersOnly = false;
		return;
	}
	else
	{
		MainMenu.PlayerOwner = PlayerPawn(Owner);
		MainMenu.PlayEnterSound();
	}
}

// System which displays the credit text and handles events associated with the HUD time which affect the credits
//
function DisplayCredits ( canvas Canvas )
{
	local int		CreditNum;
	local float		CreditTime;
	local bool		LocationLeft;
	local int		Brightness;
	local float		X,Y;
	
	CreditNum = HUDExistTime / 4;				// Duration of each credit display
	CreditTime = HUDExistTime - CreditNum*4;	// Current display time
	
	CreditNum = CreditNum % IntroductionNum;
	
	// Location alternates left/right
	LocationLeft = (CreditNum % 2)==0;
	
	Brightness = 255*(1-abs(CreditTime-2)/2);
	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = Brightness;
	Canvas.DrawColor.B = Brightness/2;
	
	if (Canvas.SizeX>600)
	Canvas.Font = DLFont;
	else
	Canvas.Font = DSFont;
	
	Canvas.Style = 3;
	
	if (LocationLeft)
	{
		Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.5);
	}
	else
	{
		Canvas.StrLen(Caps(Introductions[CreditNum]),X,Y);
		Canvas.SetPos(Canvas.SizeX*0.95-X,Canvas.SizeY*0.5);
	}
	
/*	X = Canvas.CurX;
	Y = Canvas.CurY;
	Canvas.SetPos(X+2,Y+2);
	Canvas.Style=2;
	Canvas.DrawText( Caps(Introductions[CreditNum]) );
	Canvas.SetPos(X,Y);
	Canvas.Style=3;*/
	Canvas.DrawText( Caps(Introductions[CreditNum]) );
}

// Draw the HUD
// 
simulated function PostRender( canvas Canvas )
{
	// Credits display
	//
	DisplayCredits( Canvas );

	//HUDSetup(canvas);

	if ( PlayerPawn(Owner) != None )
	{
		// Player Menu Entering
		//
		if ( PlayerPawn(Owner).bShowMenu )
		{
			HUDExistTime = 0;
		
			if ( MainMenu == None )
				CreateMenu();
			if ( MainMenu != None )
				MainMenu.DrawMenu(Canvas);
			return;
		}
		
		// Player Score Display
		//
		if ( PlayerPawn(Owner).bShowScores )
		{
			if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
				PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
			if ( PlayerPawn(Owner).Scoring != None )
			{ 
				PlayerPawn(Owner).Scoring.ShowScores(Canvas);
				return;
			}
		}
		else if ( (PlayerPawn(Owner).Weapon != None) && (Level.LevelAction == LEVACT_None) )
			DrawCrossHair(Canvas, 0.5 * Canvas.ClipX - 8, 0.5 * Canvas.ClipY - 8);

		// Player Progress Message
		//
		//if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
			//DisplayProgressMessage(Canvas);	
	}
	
	// Draw HUD Type based on HUDStyle variable
	//
	/*switch (HUDStyle)
	{
	case HUDKinetic:
		// Dancing Carrot at top-right
		ProcessComponent(0,Canvas.SizeX+50,0,Canvas.SizeX-40,40);	// Component 0 - Carrots / Money
		DancingCarrot	(Canvas,ComponentX,ComponentY);
		ProcessComponent(1,Canvas.SizeX+10,-50,Canvas.SizeX-40,4);
		DancingScore	(Canvas,ComponentX,ComponentY);
		DancingMessage	(Canvas,Canvas.SizeX/2,Canvas.SizeY/2);
		
		ProcessComponent(2,-50,-50,1,1);	// Component 2 - Health
		HeartHealthBar	(Canvas,ComponentX,ComponentY,JazzPlayer(Owner).Health,5);
		break;
	}*/
	
	// Update Subsystem Drawing
	//UpdateInventoryDisplay( Canvas );
	
	// Update Subsystem Drawing
	//UpdateConversationDisplay( Canvas );
	
	DrawJazzIcon( Canvas );
	
}

function DrawJazzIcon( canvas Canvas )
{
	local float y;

	y = (Canvas.ClipY - HUDExistTime*100);
	if (y<Canvas.ClipY-60)
		y = Canvas.ClipY-60;
	Canvas.Style = 3;
	Canvas.SetPos(Canvas.ClipX-120,y);
	//Canvas.DrawIcon(Texture'JazzTitle3',0.25);		// Jazz3 Texture
}

event Tick ( float DeltaTime )
{
	HUDExistTime += DeltaTime;
}

function bool InterceptButton ()
{
	// Return true if button is intercepted
	
	// Bring up menu
	PlayerPawn(Owner).ShowMenu();
	
	return (true);
}

defaultproperties
{
     Introductions(0)="Jazz 3 Ver 013d"
     Introductions(1)="Do Not Distribute"
     Introductions(2)="Programming"
     Introductions(3)="Jason"
     Introductions(4)="Devon"
     Introductions(5)="Artwork"
     Introductions(6)="Dean"
     Introductions(7)="Modeling"
     Introductions(8)="Will"
     Introductions(9)="Level Design"
     Introductions(10)="Justin"
     Introductions(11)="Music"
     Introductions(12)="Alec"
     Introductions(13)="Voice Acting"
     Introductions(14)="Tristin"
     IntroductionNum=15
     MainMenuType=Class'CalyGame.JazzIntroMenu'
     DSFont=Texture'JazzFonts.DSFont'
     DLFont=Texture'JazzFonts.DLFont'
}
