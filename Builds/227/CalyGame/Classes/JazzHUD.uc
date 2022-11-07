//=============================================================================
// JazzHUD.
//=============================================================================
class JazzHUD expands HUD;


// String Constants
//
var localized string	VersionString;

var float 		LifeTime;

var	float		DancingCarrotLife;
var float		DancingScoreLife;

var string	DancingMessageText;
var float		DancingMessageLife;
var float		DancingMessageDuration;
var string	VersionMessageText;
var float		VersionMessageLife;
var float		VersionMessageDuration;

// Heart animation for health display
var() texture		HealthDisplay[5];

// Wealth display
var() texture		WealthDisplay;

// HUD Display Components
//
// To facilitate components going in and out, we'll set how long they should appear when
// a change is made.
//
// Component 0 - Money (Carrot Cash)
// Component 1 - Score
// Component 2 - Health
//
var int			ComponentFixed[10];
var float		ComponentLife[10];
var	float		ComponentLifeInitial[10];
var float		ComponentX;
var float		ComponentY;

// Weapon Display
//
var float		CurrentWeaponPct;		// Current experience level of weapon/orb in use being displayed
var	float		NewWeaponPct;			// Shift to new pct slowly when changes
var texture		LastWeaponIcon;			// Last weapon display
var texture		NewWeaponIcon;			// New weapon display
var float		NewWeaponDisplayTime;	// New Weapon Display Time
var bool		NewWeaponDisplay;		// New Weapon Display Active

// Item Pickup Mesh updating
//
var NewInventoryDisplay		PreRenderInventory;

///////////////////////////////////////////////////////////////////////////////////////////////
// Inventory Subsystem Variables									HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
// About the Inventory:
//	An item's InventoryGroup determines what group it belongs to.
//  0-9 are reserved for Unreal's original weapon selection system, while
//  10-14 are reserved for Jazz's inventory groups.
//
// Setting an inventory item to 10 will make it a weapon power orb.
//
// Groups:
//	10 - Weapon orbs
//
//
var() int			InventoryItemGroupMax;		// Maximum number of groups in game
var() string	InventoryItemGroupName[10];	// Names of the inventory item groups
var	int				InventoryItemSelect;		// Selected inventory item # in list
var float			InventoryItemSelectChange;	// Slow Change direction and amount
var float			InventoryItemSelectChangeTo;// Slow Change amount until reaching
var	Inventory		InventoryItems[20];			// Items in inventory list
var bool			InventoryNewGroup;			// Inventory display changed?  
var bool			InventoryDisplayActive;		// Inventory display active?
var int				InventoryItemListNum;		// Number of items in group
var int				InventoryItemGroupNum;		// Group currently selected
var int				InventoryDisplayPosition;	// X position of window

var float			UpDelay;
var float			DownDelay;
var float			LeftDelay;
var float			RightDelay;

///////////////////////////////////////////////////////////////////////////////////////////////
// Conversation Subsystem Variables									HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
var JazzConversation 	CurrentConversation;
var bool				ConvEventFirst;	// First time conversation event called
var int					ConvEvent;		// Current event #
var float				ConvTime;		// Time from last event start
var float				ConvFade;		// Conversation Fade Away at End
var string			ConvText;		// Current Conversation Text
var bool				ConvEndLine;	// Conversation is at the end of the line and ready for next
var bool				ConvEnd;		// Conversation is Over and ready for ending
var actor				ConvFocus;		// Focus of conversation
var bool				ConvAccel;		// Accelerate conversation display
var float				ConvWindowYSize;// Y Size of conversation window display

///////////////////////////////////////////////////////////////////////////////////////////////
// Event Message Subsystem 												HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
var 	float			EventTime[10];		// Duration countdown to display event
var 	float			EventTimeStart[10];	// Starting Time
var 	int				EventType[10];		// Type of Event
var 	int				EventNum;			// # of events currently drawn
var		string		EventMessage[10];	// Event text
var() 	texture			EventSymbols[10];	// Symbols for event types


var(Display) enum HUDStyleSystem
{
	HUDKinetic
} HUDStyle;

///////////////////////////////////////////////////////////////////////////////////////////////
// Tutorial Message Subsystem 											HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
var		bool			TutorialUp;				// Tutorial Currently on Display?
var		bool			TutorialCentered;		// Center Text
var		string		TutorialTitle;			// Tutorial title string
var		string		TutorialText[3];		// Text for current tutorial window up for display.
var		float			TutorialTime;

var()	texture	MenuBack;
var()	texture	JoyBut1;
var()	texture	HudItem1;
var()	texture	HudItem2;
var()	texture	HudTrans;
var()	texture	NewHud;
var()	texture	NewHudCE;
var()	texture	NewHudC;
var()	texture	HudMisc;
var()	texture	HudMiscT;
var()	texture	WeapDisp;
var()	texture	WeapExp2;
var()	texture	WeapRedy;
var()	texture	WeapEOut;
var()	texture	WeapExp;
var()	texture	JazzSD1;
var()	texture	JazzSD1e;
var()	texture	JCoin_01;
var()	texture	BoxPat1;
var()	texture	WeapBack;
var()	texture	CardBas4;
var()	texture	CardBas3;
var()	texture	CardBas2;
var()	texture	CardBox;
var()	texture	CardDot;
var()	texture	WeapFlar;
var()	texture	JazzGrp1;
var()	texture	JazzGrp2;
var()	texture	EventN;
var()	texture	EventBr;
var()	texture	ConversationCon;

Enum EDir
{
	Dir_Up,
	Dir_Down,
	Dir_Left,
	Dir_Right
};

Enum ETargetType
{
	Target_Friendly,
	Target_Hostile
};

simulated function StartTargeting(canvas Canvas)
{
	DoTargeting(Canvas);
}

simulated function final DoTargeting(Canvas Canvas)
{
	local actor Target;
	local vector PlayerView;
	local float PointX,PointY;
	local float TargetDistance, TargetScale;
	local ETargetType TargetType;
	
	local vector X, Y, Z;
	
	GetAxes(JazzPlayer(Owner).MyCameraRotation,X,Y,Z);
	
	foreach VisibleActors(Class'Actor', Target,, Owner.Location)
	{
		// Get a vector from the player to the pawn
		// PlayerView = Target.Location - Owner.Location - (Pawn(Owner).EyeHeight * vect(0,0,1));
		PlayerView = (Target.Location - JazzPlayer(Owner).MyCameraLocation);
		
		// Make sure we have a valid target (ie. no actors that we don't want)
		if (CheckTarget(Target, PlayerView, X, TargetType))
		{
			// Find the distance to our potential target
			TargetDistance = VSize(Target.Location - JazzPlayer(Owner).MyCameraLocation);
			
			// The drawing scale of our potential target for the targeting display
			// Math: I don't understand this all that well
			TargetScale = ( (64 * 10) / TargetDistance) * 90 / Pawn(Owner).FOVAngle;
			
			// Math: Complex meat of it all math
			// Zprojection = (ScreensizeX / 2) / (tan(FOVAngle / 2) )
			
			PointX = (Canvas.SizeX / 2) + ((PlayerView Dot Y)) * ((Canvas.SizeX / 2) / tan(Pawn(Owner).FOVAngle * Pi / 360)) / (PlayerView Dot X);
			PointY = (Canvas.SizeY / 2) + (-(PlayerView Dot Z)) * ((Canvas.SizeX / 2) / tan(Pawn(Owner).FOVAngle * Pi / 360)) / (PlayerView Dot X);
			
			// Now we can do the drawning of the display
			DrawTargetingDisplay(Canvas,TargetDistance,TargetScale,PointX,PointY,Target,TargetType);
		}
	}
}

simulated function bool CheckTarget(actor Target, vector PlayerView, vector X, out ETargetType TargetType)
{
	local float TargetDistance;

	// Math: PlayerView Dot X > 0 will make sure the target is in front of the player
	if ((Target != Owner) && ((PlayerView Dot X) > 0))
	{
		if ( Pawn(target) != None) 
		{
			if (Pawn(Target).PlayerReplicationInfo.Team == Pawn(Owner).PlayerReplicationInfo.Team)
			{
				TargetType = Target_Friendly;
				return true;
			}
			else
			{
				TargetType = Target_Hostile;
				return true;
			}
		}
	}

	return False;
}

simulated function DrawTargetingDisplay(canvas Canvas, float TargetDistance, float TargetScale, float PointX, float PointY, actor Target, ETargetType TargetType)
{
	local int OldStyle;
	local color OldColor;
	
	// Get the old drawing style of the canvas
	OldStyle = Canvas.Style;
	OldColor = Canvas.DrawColor;
	
	Canvas.Style = 3;
	Canvas.Font = Canvas.SmallFont;

	switch(TargetType)
	{	
		case Target_Hostile:
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 0;
			Canvas.DrawColor.b = 0;
						
			// Draw a bracket around the target
			DrawBracket(Canvas,PointX,PointY,TargetScale,48*TargetScale);

			Canvas.DrawColor.r = 155;
			Canvas.DrawColor.g = 0;
			Canvas.DrawColor.b = 0;

			// Draw the circle over it
			DrawCurve(Canvas, 15, 0, (360 * Pi / 180), PointX,PointY,(2*Pi/180),TargetScale);
		break;
		case Target_Friendly:
			Canvas.DrawColor.r = 0;
			Canvas.DrawColor.g = 0;
			Canvas.DrawColor.b = 255;
			
			DrawBracket(Canvas,PointX,PointY,TargetScale,48*TargetScale);		
		break;
	}
	
	// Reset back to the default style
	Canvas.Style = OldStyle;
	Canvas.DrawColor = OldColor;
}

simulated function DrawBracket(canvas Canvas, float PointX, float PointY,float TargetScale, float Size)
{
	TargetScale *= 6;
	DrawLine(Canvas,TargetScale,Dir_Right,PointX-(Size/2),PointY-(Size/2));
	DrawLine(Canvas,TargetScale,Dir_Down,PointX-(Size/2),PointY-(Size/2));

	DrawLine(Canvas,TargetScale,Dir_Left,PointX+(Size/2),PointY-(Size/2));
	DrawLine(Canvas,TargetScale,Dir_Down,PointX+(Size/2),PointY-(Size/2));
	
	DrawLine(Canvas,TargetScale,Dir_Right,PointX-(Size/2),PointY+(Size/2));
	DrawLine(Canvas,TargetScale,Dir_Up,PointX-(Size/2),PointY+(Size/2));

	DrawLine(Canvas,TargetScale,Dir_Left,PointX+(Size/2),PointY+(Size/2));
	// This is made to draw an extra pixel because for some reason it wouldn't
	// draw in the lower right hand corner of the display
	DrawLine(Canvas,TargetScale+1,Dir_Up,PointX+(Size/2)-1,PointY+(Size/2));
}

simulated function DrawCurve(canvas Canvas, float Radius, float start, float end, float PointX, float PointY, float deltaTheta, float TargetScale)
{
	local float Theta, X, Y;
	
	radius *= TargetScale;
	deltaTheta /= TargetScale;
	
	Canvas.SetPos(PointX, PointY);
	
	for(theta = start; theta <= end; theta += deltaTheta)
	{
		X = radius * cos(theta);
		Y = radius * sin(theta);
		
		Canvas.CurX += X;
		Canvas.CurY -= Y;
		
		Canvas.DrawRect(MenuBack, 1, 1);
		
		Canvas.CurX = PointX;
		Canvas.CurY = PointY;
	}
}

simulated function DrawLine(canvas Canvas, float Length, EDir Dir, float PointX, float PointY)
{
	switch(Dir)
	{
		case Dir_Up:
			Canvas.SetPos(PointX,PointY-Length);		
			Canvas.DrawRect(MenuBack, 1, Length);
		break;
		case Dir_Down:
			Canvas.SetPos(PointX,PointY);		
			Canvas.DrawRect(MenuBack, 1, Length);		
		break;
		case Dir_Left:
			Canvas.SetPos(PointX-Length,PointY);		
			Canvas.DrawRect(MenuBack, Length, 1);		
		break;
		case Dir_Right:
			Canvas.SetPos(PointX,PointY);
			Canvas.DrawRect(MenuBack, Length, 1);		
		break;
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// HUD Basic Functions														Basic
//////////////////////////////////////////////////////////////////////////////////////////////////
//

//
// Tx - Ty 	- Texture X/Y Size
// TScale 	- Texture Scale
// AvailX	- Available X size
// AvailY	- Available Y size
// Ox - Oy	- Result Offset X/Y
//
function ScaleIt ( int x, int y, int AvailX, int AvailY, canvas Canvas, Texture T )
{
	local float	TScale;
	local float	Tx,Ty;
	
	Tx = T.USize;
	Ty = T.VSize;
	
	TScale = 1;
	
	while ((TScale >= 0.1) && ((Tx>AvailX) || (Ty>AvailY)))
	{
		Tx *= 0.5;
		Ty *= 0.5;
		TScale *= 0.5;
	}
	
	Canvas.SetPos( x+(AvailX-Tx)/2 , y+(AvailY-Ty)/2 );
	Canvas.DrawTile(T,Tx,Ty,0,0,T.USize,T.VSize);
}

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
	ChangeHudStyle(HUDKinetic);
	
	// DEMO Text
	ScreenMessage(Level.LevelEnterText,10);
	//VersionMessage(VersionString,10);

	// Event
	BeginEvent();

	// Inventory
	ResetInventoryDisplay();	
	InventoryDisplayActive = false;
	InventoryDisplayPosition = -200;
	
	// LastWeaponIcon
	LastWeaponIcon = JazzPlayer(Owner).Weapon.Icon;
}

// PreRender calls to other associated inventory displays
//
function PreRender ( canvas Canvas )
{
	Super.PreRender(Canvas);
	
	if (PreRenderInventory != None)
		PreRenderInventory.PreRender( Canvas );
}

// Switch HUDStyle to new style
//
simulated function ChangeHudStyle(HUDStyleSystem d)
{
	// Unused for JazzHUD
	HUDStyle = d;
}

simulated function ChangeCrosshair(int d)
{
	// Unused for JazzHUD
}

// Returns to main menu when ESC key pressed (?)
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
		
		// Play Enter Sound if normal Menu, otherwise use Jazz-based MenuEntrySound
		if (JazzMenu(MainMenu)!=None)
			JazzMenu(MainMenu).PlayEntrySound();
		else
			MainMenu.PlayEnterSound();
	}
}

// - HUD Drawing Functions -
//
//
//  Prepares Canvas for drawing HUD
//
simulated function HUDSetup(canvas canvas)
{
	// Setup the way we want to draw all HUD elements
	Canvas.Reset();
	Canvas.SpaceX=0;
	Canvas.bNoSmooth = True;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;	
	Canvas.OrgX = 0;
	Canvas.OrgY = 0;
	Canvas.Font = Canvas.LargeFont;
	// Override the bad word wrap.  BAD WORD WRAP!  BAD WORD WRAP!  Heh, no more word wrap...
	Canvas.ClipX = 100000;
}

simulated function DrawCrossHair( canvas Canvas, int StartX, int StartY )
{
	// Not Used in Jazz
}

simulated function DisplayProgressMessage( canvas Canvas )
{
	local int i;
	local float YOffset, XL, YL;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.bCenter = true;
	Canvas.Font = Canvas.MedFont;
	YOffset = 0;
	Canvas.StrLen("TEST", XL, YL);
	for (i=0; i<5; i++)
	{
		Canvas.SetPos(0, 0.25 * Canvas.ClipY + YOffset);
		Canvas.DrawColor = PlayerPawn(Owner).ProgressColor[i];
		Canvas.DrawText(PlayerPawn(Owner).ProgressMessage[i], false);
		YOffset += YL + 1;
	}
	Canvas.bCenter = false;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;;
}


/////////////////////
// Component System
//
// Returns false if component in totally off position (do not draw, probably)
//
function bool ProcessComponent ( int Component, int OffX, int OffY, int OnX, int OnY )
{
	if (ComponentLife[Component]>0)
	{
		if (ComponentLife[Component] < 1)
		{
			ComponentX = OffX - ((OffX - OnX)*ComponentLife[Component]);
			ComponentY = OffY - ((OffY - OnY)*ComponentLife[Component]);
		}
		else
		if (ComponentLife[Component] > ComponentLifeInitial[Component] - 1)
		{
			ComponentX = OffX - ((OffX - OnX)*(ComponentLifeInitial[Component]-(ComponentLife[Component])));
			ComponentY = OffY - ((OffY - OnY)*(ComponentLifeInitial[Component]-(ComponentLife[Component])));
		}
		else
		{
			ComponentX = OnX;
			ComponentY = OnY;
		}
		return true;
	}
	else
	{
	ComponentX = OffX;
	ComponentY = OffY;
	return false;
	}
}

function UpdateComponent(int Component, float Time, optional bool Fixed)
{
	ComponentFixed[Component]=int(Fixed);

	if ((ComponentLife[Component]<ComponentLifeInitial[Component]-1) || (ComponentLifeInitial[Component]<=0))
	{
		if ((ComponentLife[Component]<=0))
		{
		ComponentLife[Component] = Time;
		ComponentLifeInitial[Component] = Time;
		}
		else
		if (ComponentLife[Component]>1)
		{
		ComponentLife[Component] = Time-1;
		ComponentLifeInitial[Component] = Time;
		}
		else
		{
		ComponentLife[Component] = (Time-ComponentLife[Component]);
		ComponentLifeInitial[Component] = Time;
		}
	}
}

// Component Display Updates
// 
function UpdateHealth()				{	UpdateComponent(2,20);  }
function UpdateScore()				{	UpdateComponent(1,20);  }
function UpdateCarrots()			{	UpdateComponent(0,20);  }
function UpdateWeaponExperience()	{	UpdateComponent(3,20);  }

// Draw the HUD
// 
simulated function PostRender( canvas Canvas )
{
	// Send PostRender command to Inventory
	if (PreRenderInventory != None)
		PreRenderInventory.PostRender( Canvas );
		
	if ( PlayerPawn(Owner) != None )
	{
		// Player Menu Entering
		//
		if ( PlayerPawn(Owner).bShowMenu )
		{
			if ( MainMenu == None )
				CreateMenu();
			if ( MainMenu != None )
				MainMenu.DrawMenu(Canvas);
			return;
		}

		// Update Tutorial Display
		//
		if (JazzPlayer(Owner).bShowTutorial)
		{
			UpdateTutorialDisplay( Canvas );
		}
		else
		{
			UpdateComponent(5, 3,true);
			UpdateComponent(6, 3,true);
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
			DrawCrossHair(Canvas, 0.5 * Canvas.SizeX - 8, 0.5 * Canvas.ClipY - 8);

		// Player Progress Message
		//
		if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
			DisplayProgressMessage(Canvas);	

		// Setup for main HUD drawing
		//	
		HUDSetup(canvas);

		// Draw HUD Type based on HUDStyle variable
		//
		switch (HUDStyle)
		{
		case HUDKinetic:
			DrawHudKinetic(Canvas);
			break;
		}
	}
	
	// Update Event Message Drawing
	UpdateEventMessageDisplay( Canvas );
	
	// Update Subsystem Drawing
	UpdateInventoryDisplay( Canvas );
	
	// Update Subsystem Drawing
	UpdateConversationDisplay( Canvas );

	// Restore the Canvas positions
	Canvas.ClipX = Canvas.SizeX;
	Canvas.ClipY = Canvas.SizeY;
	Canvas.OrgX = 0;
	Canvas.OrgY = 0;
	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	// Note to Devon:
	// Enabling this currently crashes Unreal while playing (instantly).
	// Unknown error in the Unreal.log.  
	// (1) Suggest Targeting is not getting initialized correctly?
	//
/*	if(Level.Game.bTeamGame)
	{
		// Only draw the team info if it's a team game
		StartTargeting(Canvas);
	}
	
	JazzPlayer(Owner).Targeting.Target();
	Canvas.DrawActor(JazzPlayer(Owner).Targeting, false);*/
}

// HUD Style : Kinetic Single Player
//
function DrawHudKinetic(canvas Canvas)
{
	// TEST
	//MiscObjectDisplay	(Canvas,100,150,2,0.14);		// 0.14 * ScreenWidth
	
		// Display object amount bar at right
		//MiscObjectDisplayBar(Canvas);
		
		if (ProcessComponent(0,Canvas.SizeX+10,-50,Canvas.SizeX-40,4))
		DancingCarrot	(Canvas,ComponentX,ComponentY);
		
		if (ProcessComponent(1,Canvas.SizeX+10,-50,Canvas.SizeX-40,34))
		DancingScore	(Canvas,ComponentX,ComponentY);
		
		if ((JazzConsole(JazzPlayer(Owner).Player.Console) != None) && 
			(JazzConsole(JazzPlayer(Owner).Player.Console).bMessage == false))
		{
		DancingMessage	(Canvas,DancingMessageText,Canvas.SizeX/2,Canvas.SizeY/2);
		DancingMessage	(Canvas,VersionMessageText,Canvas.SizeX/2,Canvas.SizeY*0.6);
		}

		DrawWeapon		(Canvas,5,Canvas.SizeY);

		if (ProcessComponent(7,-50,-50,5,5))
		DrawLives		(Canvas,ComponentX,ComponentY);
		
//		if (ProcessComponent(5,-100,-50,Canvas.SizeX*0.03,Canvas.SizeY*0.03))
//		DeanHudTypeA	(Canvas,ComponentX,ComponentY);

//		if (ProcessComponent(6,Canvas.SizeX*1.2,Canvas.SizeY*1.2,Canvas.SizeX*0.97,Canvas.SizeY*0.97))
//		DeanHudItemBox	(Canvas,ComponentX,ComponentY,None,false,0,None);

/*		if (ProcessComponent(3,-40,Canvas.SizeY+200,0,Canvas.SizeY))
		WeaponDisplay	(Canvas,ComponentX,ComponentY);
		//WeaponDisplay	(Canvas,10,Canvas.SizeY-10);
		
		if (ProcessComponent(2,-50,-50,1,1))	// Component 2 - Health
		HeartHealthBar	(Canvas,ComponentX,ComponentY,JazzPlayer(Owner).Health,5);*/
}

// Master function for the display bar
//
function MiscObjectDisplayBar(canvas Canvas)
{
	// Top-Right Inventory Amount Display
	if (ProcessComponent(0,Canvas.SizeX+1,0,Canvas.SizeX*0.85,40))		// Component 0 - Carrots / Money
	{
	
	MiscObjectDisplay	(Canvas,ComponentX,ComponentY,2,0.14);		// 0.14 * ScreenWidth
	if (JazzPlayer(Owner) != None)
	MiscObjectDispIn	(Canvas,ComponentX,ComponentY,1,WealthDisplay,string(JazzPlayer(Owner).Carrots));
	MiscObjectDispIn	(Canvas,ComponentX,ComponentY,2,JoyBut1,"TEST");
	
	}
}

// Dean Hud Type A (Special Item display)
//
//
function DeanHudItemBox(canvas Canvas, float XPos, float YPos, texture Item, bool NewItemAnim, float DisplayTime, actor ItemActor )
{
	local texture Box;
	local float Scale;

	if (Canvas.SizeX < 401)
	Scale = 0.25;
	else
	if (Canvas.SizeX < 641)
	Scale = 0.5;
	else
	Scale = 1.0;
	
	Box = HudItem1;
	XPos = XPos-Box.USize*Scale;
	YPos = YPos-Box.VSize*Scale;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	Canvas.Style = 3;
	Canvas.SetPos(XPos,YPos);
	Canvas.DrawIcon(HudItem2,Scale);
	
	Canvas.Style = 2;
	Canvas.SetPos(XPos,YPos);
	Canvas.DrawIcon(Box,Scale);

	if (Item != None)	// Draw special item
	{
	Canvas.Style = 2;
	Canvas.SetPos(XPos+2,YPos+2);
	ScaleIt(XPos+2,YPos+2,Box.USize*Scale-4,Box.VSize*Scale-4,Canvas,Item);
	}
	
	if (ItemActor != None)		// Draw special item (as original mesh)
	{
	
	}
}

function DrawLives (canvas Canvas, float XPos, float YPos)
{
	// Draw the number of lives that the player has
	//
	Canvas.SetPos(XPos,YPos+(5*Sin((DancingCarrotLife/360)*Pi*2)));
	Canvas.Style = 2;

	Log("DrawLives) "$XPos$" "$YPos);
	
	Canvas.DrawText(JazzPlayer(Owner).Lives,false);
}

function DrawWeapon(canvas Canvas, float XPos, float YPos)
{
	local float Scale;
	local texture WeapIcon;
	local float WeapRechargeTime;

	// Scale
	if (Canvas.SizeX < 501)
	Scale = 0.25;
	else
	if (Canvas.SizeX < 1001)
	Scale = 0.5;
	else
	Scale = 1;
	
	// Weapon in Use
	Canvas.Style = 2;
	Canvas.SetPos(XPos,YPos-120*Scale);
	
	if ((JazzPlayer(Owner) != None) && (JazzPlayer(Owner).Weapon != None))
	{
		WeapIcon = JazzPlayer(Owner).Weapon.Icon;
		
		Canvas.DrawIcon(WeapIcon,Scale);
	}

	// Weapon Cell in Use
	Canvas.Style = 2;
	Canvas.SetPos(XPos+150*Scale,YPos-140*Scale);
	
	if (JazzPlayer(Owner) != None)
	{
		if (JazzPlayer(Owner).InventorySelections[0] == None)
		{
		JazzWeapon(JazzPlayer(Owner).Weapon).ChangeCell(0);
		WeapRechargeTime = 0;
		WeapIcon=None;
		}
		else
		{
		WeapIcon = JazzPlayer(Owner).InventorySelections[0].Icon;
		WeapRechargeTime = 
			FMax(JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).MainReadyTime,
				JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).AltReadyTime);
		}
	
		if (WeapIcon != None)
		{
			if (WeapRechargeTime<=0)
			Canvas.DrawIcon(WeapIcon,Scale);
			else
			{
			Canvas.Style=2;
			Canvas.DrawColor.R = 255-WeapRechargeTime*100;
			Canvas.DrawColor.G = 255-WeapRechargeTime*100;
			Canvas.DrawColor.B = 255-WeapRechargeTime*100;
			Canvas.DrawIcon(WeapIcon,Scale);
			
			Canvas.Style=2;
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
			}
		}
	}

}

// Dean Hud Type A (Item display)
//
//
function DeanHudTypeA(canvas Canvas,float XPos, float YPos)
{
	local float Scale;
	local float HealthPct;
	local float HealthClip;
	local texture WeapIcon;
	local float WeapRechargeTime;
	local font UseFont;

	// Do not draw when player is dead
	if (Pawn(Owner).Health<=0)
	return;

	// Specifications:
	//
	// Display weapon in top-left transparent bubble.
	// Display special item in transparent bubble to the right of that.
	// Display health as carrot percentage at left.
	// 

	if (Canvas.SizeX < 501)
	Scale = 0.25;
	else
	if (Canvas.SizeX < 1001)
	Scale = 0.5;
	else
	Scale = 1;
	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	//Canvas.Style = 3;
	//Canvas.SetPos(XPos,YPos);
	//Canvas.DrawIcon(HudTrans,Scale);
	
	Canvas.Style = 2;
	Canvas.SetPos(XPos,YPos);
	Canvas.DrawIcon(NewHud,Scale);
	
	// Health Carrot
	if (JazzPlayer(Owner).HealthMaximum<=0)
	HealthPct = 0;
	else
	HealthPct = float(JazzPlayer(Owner).Health) / float(JazzPlayer(Owner).HealthMaximum);
	
	//Log("HUD) Health "$HealthPct);
	
	HealthClip = 197*HealthPct;
	Canvas.SetPos(XPos+Scale*14,YPos+150*Scale);
	Canvas.DrawTile(NewHudCE, 72*Scale, 197*Scale, 0, 0, 72, 197);
	Canvas.SetPos(XPos+Scale*14,YPos+150*Scale);
	Canvas.DrawTile(NewHudC, 72*Scale, HealthClip*Scale, 0, 0, 72, HealthClip);

	// Weapon in Use
	Canvas.SetPos(XPos+130*Scale,YPos+48*Scale);
	if ((JazzPlayer(Owner) != None) && (JazzPlayer(Owner).Weapon != None))
	{
		WeapIcon = JazzPlayer(Owner).Weapon.Icon;
		
		Canvas.DrawIcon(WeapIcon,Scale);
	}

	// Weapon Cell in Use
	Canvas.SetPos(XPos+335*Scale-32*Scale,YPos+48*Scale-32*Scale+8*Scale);
	
	if (JazzPlayer(Owner) != None)
	{
		if (JazzPlayer(Owner).InventorySelections[0] == None)
		{
		JazzWeapon(JazzPlayer(Owner).Weapon).ChangeCell(0);
		WeapRechargeTime = 0;
		WeapIcon=None;
		}
		else
		{
		WeapIcon = JazzPlayer(Owner).InventorySelections[0].Icon;
		WeapRechargeTime = 
			FMax(JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).MainReadyTime,
				JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).AltReadyTime);
		}
	
		if (WeapIcon != None)
		{
			if (WeapRechargeTime<=0)
			Canvas.DrawIcon(WeapIcon,Scale);
			else
			{
			Canvas.Style=2;
			Canvas.DrawColor.R = 255-WeapRechargeTime*100;
			Canvas.DrawColor.G = 255-WeapRechargeTime*100;
			Canvas.DrawColor.B = 255-WeapRechargeTime*100;
			Canvas.DrawIcon(WeapIcon,Scale);
			
			Canvas.Style=2;
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
			}
		}
	}
}

// Miscellaneous object (Item)
//
// This is a new display routine which is more powerful.
//
function MiscObjectDispIn2	( canvas Canvas, float X, float Y, float Item, texture T, string Line1, string Line2, optional string Line3 )
{
	// Todo:  Scale the texture dynamically.
	local float ScaleX,ScaleY;
	local float Xi,Yi;

	Y = Y + Canvas.SizeY*(0.09*Item+0.01);
	X = X + Canvas.SizeX*0.01;
		
	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

	if (T != None)
	ScaleIt(X,Y,Canvas.SizeX*0.07,Canvas.SizeY*0.08,Canvas,T);
	else
	if (Line3 != "")
	{
		if (Canvas.SizeY >= 600)
		Canvas.Font = font'DSFont';
		else
		if (Canvas.SizeY >= 400)
		Canvas.Font = font'DSFont';
		else
		Canvas.Font = font'DSFont';
	
		Canvas.SetPos(X,Y);
		Canvas.DrawText(Line3);
	}
	
	if (Canvas.SizeY >= 600)
	Canvas.Font = font'DSFont';
	else
	if (Canvas.SizeY >= 400)
	Canvas.Font = font'DSFont';
	else
	Canvas.Font = Canvas.SmallFont;
	
	if (Line2 == "")
	Canvas.SetPos(X+Canvas.SizeX*0.055,Y+Canvas.SizeY*0.020);
	else
	Canvas.SetPos(X+Canvas.SizeX*0.055,Y+Canvas.SizeY*0.000);
	
	if (Canvas.SizeY <400)
	{
	Canvas.Style=3;
	Canvas.DrawColor.R = 200;
	Canvas.DrawColor.G = 200;
	Canvas.DrawColor.B = 200;
	}
	Canvas.DrawText(Caps(Line1));
	Canvas.Style=2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	// Line 2 is not displayed when not enough room to display.
	if (Canvas.SizeY >= 199)
	{
	if (Canvas.SizeY >= 400)
	Canvas.Font = Canvas.MedFont;
	else
	Canvas.Font = Canvas.SmallFont;
	
	Canvas.SetPos(X+Canvas.SizeX*0.055,Y+Canvas.SizeY*0.025);
	Canvas.DrawText(Line2);
	}
}

// Miscellaneous object (Item)
//
function MiscObjectDispIn	( canvas Canvas, float X, float Y, float Item, texture T, string Value )
{
	// Todo:  Scale the texture dynamically.
	local float ScaleX,ScaleY;
	local float Xi,Yi;

	Y = Y + Canvas.SizeY*(0.09*Item-0.09+0.01);
	X = X + Canvas.SizeX*0.005;
		
//function ScaleIt ( int x, int y, int AvailX, int AvailY, canvas Canvas, Texture T )
	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	if (T != None)
	ScaleIt(X,Y,Canvas.SizeX*0.07,Canvas.SizeY*0.08,Canvas,T);
/*	Xi = Canvas.SizeX*0.08;
	Yi = Canvas.SizeY*0.08;
	
	ScaleX = Xi / T.USize;
	ScaleY = Yi / T.VSize;
	
	if (ScaleX>ScaleY) ScaleX = ScaleY;
	
	if (ScaleX > 1) ScaleX = 1;
	else
	if (ScaleX > 0.5) ScaleX = 0.5;
	else
	if (ScaleX > 0.25) ScaleX = 0.25;	
	
	Canvas.SetPos(X,Y);
	Canvas.Style = 2;
	Canvas.DrawIcon( T, ScaleX );*/
	
	//Log("MiscObjectDisplay) SizeX:"$Canvas.SizeX);
	if (Canvas.SizeX >= 500)
	Canvas.Font = Canvas.MedFont;
	else
	Canvas.Font = Canvas.SmallFont;
	
	Canvas.SetPos(X+Canvas.SizeX*0.065,Y+Canvas.SizeY*0.02);
	Canvas.DrawText(Value);
}

// Miscellaneous object shaded bar
//
function MiscObjectDisplay	( canvas Canvas, float X, float Y, int Items, float Width )
{
	local texture T;
	local float Scale;

	Canvas.SetPos(X,Y);
	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	T = HudMisc;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*Width, Canvas.SizeY*0.09*Items, 0, 0, T.USize, T.VSize );
	
	Canvas.SetPos(X,Y);
	Canvas.Style = 3;
	T = HudMiscT;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*Width, Canvas.SizeY*0.09*Items, 0, 0, T.USize, T.VSize );
	
	Canvas.Style = 2;
}

//
//
function WeaponDisplayTick ( float DeltaTime )
{
	UpdateWeaponExperience();	// Keep it up indefinately
	if (NewWeaponDisplay)
	{
		NewWeaponDisplayTime += DeltaTime*0.8;
	}
}

/*function WeaponDisplay ( canvas Canvas, float XPos, float YPos )
{
	local float Scale;
	local float IconPowerClip;
	local texture WeapIcon;
	local float	MainReadyPct;
	local float AltReadyPct;

	Canvas.Style = 2;
	Canvas.bCenter = false;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;

	// Do not execute if player has no weapon - this should not be possible
	//
	if (JazzPlayer(Owner).InventorySelections[0] == None)
	return;
/*	NewWeaponPct = JazzWeapon(JazzPlayer(Owner).Weapon).CurrentExperience / JazzWeapon(JazzPlayer(Owner).Weapon).ExperienceNeededNext();
	WeapIcon = JazzWeapon(JazzPlayer(Owner).Weapon).Icon;*/

	if (JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).ExperienceNeededNext()==9999)
	NewWeaponPct = 1;
	else
	NewWeaponPct = 	JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).CurrentExperience / 
					JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).ExperienceNeededNext();
	WeapIcon = JazzPlayer(Owner).InventorySelections[0].Icon;
	
	// Is new weapon?	
	if ((WeapIcon != LastWeaponIcon) && (WeapIcon != NewWeaponIcon))
	{
		UpdateWeaponExperience();	
		NewWeaponDisplay = true;
		NewWeaponDisplayTime = 0;
		NewWeaponIcon = WeapIcon;
		//Log("NewWeaponDisplay) Start");
	}
	
	if (NewWeaponDisplay)
	{
		if (NewWeaponDisplayTime>1)
		{
		NewWeaponDisplay = false;
		NewWeaponIcon = None;
		}
		else
		if (NewWeaponDisplayTime>0.5)
		{
		LastWeaponIcon = NewWeaponIcon;
		}
	}

	if (abs(CurrentWeaponPct-NewWeaponPct) < 0.05)
	CurrentWeaponPct = NewWeaponPct;
	else
	if (CurrentWeaponPct > NewWeaponPct)
	CurrentWeaponPct -= 0.05;
	else
	CurrentWeaponPct += 0.05;
	
	if (Canvas.SizeX < 401)
	Scale = 0.25;
	else
	if (Canvas.SizeX < 801)
	Scale = 0.5;
	else
	Scale = 1.0;
	
	YPos -= 332 * Scale;
	
	// Weapon Interface
	Canvas.SetPos(XPos,YPos);
	Canvas.DrawIcon(WeapDisp,Scale);
	
	// Weapon Experience
	IconPowerClip = 185*CurrentWeaponPct;		// Y pixels vertically
	Canvas.SetPos(XPos+24*Scale,YPos+((185-IconPowerClip+130)*Scale));
	Canvas.DrawTile( WeapExp2, 51*Scale, IconPowerClip*Scale, 0, 184-(IconPowerClip)+(IconPowerClip%4), 51, IconPowerClip );
	
	Canvas.SetPos(XPos+8*Scale,YPos+2*Scale);
	if ((NewWeaponDisplay) && (NewWeaponDisplayTime<1))
	{
	// Weapon Icon FadeIn
	Canvas.Style = 3;
	Canvas.DrawColor.r = 255*(1-NewWeaponDisplayTime);
	Canvas.DrawColor.g = 255*(1-NewWeaponDisplayTime);
	Canvas.DrawColor.b = 255*(1-NewWeaponDisplayTime);
	if (LastWeaponIcon != None)
	Canvas.DrawIcon(LastWeaponIcon,Scale*2);
	Canvas.SetPos(XPos+8*Scale,YPos+2*Scale);
	Canvas.DrawColor.r = 255*NewWeaponDisplayTime;
	Canvas.DrawColor.g = 255*NewWeaponDisplayTime;
	Canvas.DrawColor.b = 255*NewWeaponDisplayTime;
	if (NewWeaponIcon != None)
	Canvas.DrawIcon(NewWeaponIcon,Scale*2);
	}
	else
	{
	// Weapon Icon Normal
	if (LastWeaponIcon != None)
	Canvas.DrawIcon(LastWeaponIcon,Scale*2);
	}
	
	// Weapon Ready Indicators
	if (JazzPlayer(Owner).InventorySelections[0] != None)
	{
		MainReadyPct = JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).MainReadyPct();
	}
	
	Canvas.SetPos(XPos+100*Scale,YPos+128*Scale);
	Canvas.Style = 3;
	Canvas.DrawColor.r = 255*MainReadyPct;
	Canvas.DrawColor.g = 255*MainReadyPct;
	Canvas.DrawColor.b = 255*MainReadyPct;
	Canvas.DrawIcon(WeapRedy,Scale);
	
	
	
	Canvas.Style = 2;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;

/*	YPos -= 124 * Scale;
	
	IconPowerClip = 124*CurrentWeaponPct;		// Y pixels vertically
	
	Canvas.SetPos(XPos,YPos);
	Canvas.DrawIcon(WeapEOut,Scale);
	Canvas.SetPos(XPos,YPos+((124-IconPowerClip)*Scale));
	Canvas.DrawTile( WeapExp, 124*Scale, IconPowerClip*Scale, 0, 124-(IconPowerClip), 124, IconPowerClip );

	if (NewWeaponDisplay)
	{
	//Log("NewWeaponDisplay) "$NewWeaponDisplayTime);
	Canvas.SetPos(XPos+ (124/2*Scale) - (62/2*Scale) ,YPos+ (124/2*Scale) - (62/2*Scale) + (150-abs(NewWeaponDisplayTime-0.5)*300.0)*Scale );
	}
	else
	Canvas.SetPos(XPos+ (124/2*Scale) - (62/2*Scale) ,YPos+ (124/2*Scale) - (62/2*Scale) );
	
	if (LastWeaponIcon != None)
	Canvas.DrawIcon(LastWeaponIcon,Scale);*/
}*/

function DisplayPowerBar(canvas Canvas,float XPos,float YPos,int Value,int MaxValue)
{
/*	local int x;
	Canvas.Style = 3;
	Canvas.bCenter = false;
	
	for (x=0; x<MaxValue; x++)
	{
	Canvas.SetPos(XPos,YPos-10-x*7);
	
	if (x<Value-1)
	Canvas.DrawIcon(JazzSD1, 1.0);
	else
	Canvas.DrawIcon(JazzSD1e, 1.0);
	}*/
}

function DisplayCurvedPowerBar(canvas Canvas,float XPos,float YPos,int Value,int MaxValue)
{
/*	local int x;
	Canvas.Style = 3;
	Canvas.bCenter = false;
	
	for (x=0; x<MaxValue; x++)
	{
	if (x<MaxValue-6)
	Canvas.SetPos(XPos,YPos-10-x*7);
	else
	Canvas.SetPos(XPos-(30-cos(float(6-(MaxValue-x))*(3.1428/6/2))*30),YPos-10-x*7);
	
	
	if (x<Value-1)
	Canvas.DrawIcon(JazzSD1, 1.0);
	else
	Canvas.DrawIcon(JazzSD1e, 1.0);
	}*/
}

function DancingCarrot(canvas Canvas,float XPos, float YPos)
{
	local string 	CarrotNum;
	local int			Ch;
	local int			CarrotSize;
	local rotator		DrawRot,NewRot;
	local vector		DrawLoc,DrawOffset;
	
	// Dancing Carrot - Carrot moves despite system time / unsynchronized
	//
	if (DancingCarrotLife>360)
		DancingCarrotLife-=360;

	if (Canvas.SizeX>400)
	{
	Canvas.Font = font'DLFont';
	CarrotSize = 2;
	}
	else
	{
	Canvas.Font = font'DSFont';
	CarrotSize = 1;
	}

	XPos -= (CarrotSize-1) * 40;

	DisplayMesh( Canvas, mesh'Coin', JCoin_01, XPos, YPos+4, 0.1, LifeTime*10000 );
	
/*	// Base XPos at 100.0,85.0,80.0
	//
	DrawOffset = vect(100.0,85.0,85.0);
	DrawOffset.Y += (XPos-(Canvas.SizeX-40))*1;
	DrawOffset.Z += -(YPos-4)*1;
	
	DrawRot = JazzPlayer(Owner).MyCameraRotation;
	DrawOffset = (DrawOffset >> JazzPlayer(Owner).MyCameraRotation);
	DrawLoc = JazzPlayer(Owner).MyCameraLocation+ Pawn(Owner).EyeHeight * vect(0,0,1);

	Mesh = mesh'coin';
	Texture = jcoin_01;
	DrawScale = 0.2;
	SetLocation(DrawLoc + DrawOffset);
	NewRot = DrawRot;
	NewRot.Yaw = Owner.Rotation.Yaw - 65536/2 + LifeTime*10000;
	NewRot.Pitch = 6000;
	SetRotation(NewRot);
	Canvas.DrawActor(self, false);
	*/

/*	Canvas.SetPos(XPos,YPos+(10*Sin((DancingCarrotLife/360)*Pi*2)));
	Canvas.Style = 2;
	Canvas.bCenter = false;
	Canvas.DrawIcon(WealthDisplay, 0.25*CarrotSize);*/

	Canvas.DrawColor.R = 128;
	Canvas.DrawColor.G = 128;
	Canvas.DrawColor.B = 255;

	CarrotNum = string(JazzPlayer(Owner).Carrots);
	// First Digit of Carrot #	
	for (Ch=0; Ch<=Len(CarrotNum); Ch++)
	{
		Canvas.SetPos(XPos+(8*Ch),YPos+(10*Sin(((DancingCarrotLife-40+(Ch*40))/360)*Pi*2))+(8*(CarrotSize-1)));
		Canvas.DrawText(Mid(CarrotNum,Ch,1),false);
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

function DancingScore(canvas Canvas,float XPos, float YPos)
{
	local string	CarrotNum;
	local int			Ch;
	local int			CarrotSize;
	
	// Dancing Carrot - Carrot moves despite system time / unsynchronized
	//
	if (DancingCarrotLife>360)
		DancingCarrotLife-=360;
		
	CarrotNum = string(int(JazzPlayer(Owner).PlayerReplicationInfo.Score));	// 220 Version

	if (Canvas.SizeX>400)
	{
	Canvas.Font = font'DLFont';
	CarrotSize = 2;
	}
	else
	{
	Canvas.Font = font'DSFont';
	CarrotSize = 1;
	}
	
	XPos -= Len(CarrotNum)*10;

	Canvas.SetPos(XPos,YPos+(5*Sin((DancingCarrotLife/360)*Pi*2)));
	Canvas.Style = 2;
	Canvas.bCenter = false;


	// First Digit of Carrot #	
	for (Ch=0; Ch<=Len(CarrotNum); Ch++)
	{
		Canvas.SetPos(XPos+18*CarrotSize+(10*Ch),YPos+(5*Sin(((DancingCarrotLife-40+(Ch*40))/360)*Pi*2))+(8*(CarrotSize-1)));
		Canvas.DrawText(Mid(CarrotNum,Ch,1),false);
		
		//Canvas.SetPos(X,YPos+(10*Sin(((DancingMessageLife+X)/360)*Pi*2)));
		//Canvas.Font = Canvas.LargeFont;
		//Canvas.DrawText(Mid(DancingMessageText,Ch,1),false);
		//X=Canvas.CurX;
	}
}

function DancingMessage(canvas Canvas,string Message,float XPos, float YPos)
{
	local	int	X,Ch;
	if (DancingMessageDuration>0)
	{
		// Dancing Message - Message moves despite system time / unsynchronized
		//
		if (DancingMessageLife>360)
			DancingMessageLife-=360;
	
		if (DancingMessageDuration<1)
		{
			Canvas.Style = 3;
			Canvas.DrawColor.R = 255*DancingMessageDuration;
			Canvas.DrawColor.G = 255*DancingMessageDuration;
			Canvas.DrawColor.B = 255*DancingMessageDuration;
		}
		
		if (Canvas.SizeX>600)
		{
		X=XPos-Len(Message)*15/2;
		Canvas.Font = font'DLFont';
		}
		else
		{
		X=XPos-Len(Message)*10/2;
		Canvas.Font = font'DSFont';
		}
		
		// Draw Message Text
	
		//if (DancingMessageDuration<1)	// Disappear Time
			//X += (1-DancingMessageDuration)*1000;
	
		for (Ch=0; Ch<=Len(Message); Ch++)
		{
		Canvas.SetPos(X,YPos+(10*Sin(((DancingMessageLife+X)/360)*Pi*2)));
		
		//Canvas.DrawText(Caps(Mid(Message,Ch,1)),false);
		X=Canvas.CurX;
		}
	}
}

function HeartHealthBar(canvas Canvas,float XPos, float YPos, float Health, int HeartNum)
{
	local float HealthPerHeart;
	local int	H;
	local int   HeartFrame;

	HealthPerHeart = 100/HeartNum;
	
	Canvas.Style = 2;
	
	if (Health>=0)
	for (H=0; H<HeartNum; H++)
	{
		Canvas.SetPos(XPos+H*16,YPos);
	
		if (Health>=HealthPerHeart)
			HeartFrame = 4;
		else
			HeartFrame = 5*(Health/HealthPerHeart);
		
		if (HeartFrame<0) HeartFrame = 0;
		
		Canvas.DrawIcon(HealthDisplay[HeartFrame], 1.0);

		Health -= HealthPerHeart;
	}
}


// Drawing position modifications (same speed desipte system speed)
//
event Tick(float DeltaTime)
{
	local int C;

	// Message Dies after time expires
	if (DancingMessageDuration>0)
		DancingMessageDuration -= DeltaTime;

	// Dancing Status Displays
	DancingCarrotLife 	+= 360*DeltaTime;	// Modify this to change the carrot bob speed
	DancingScoreLife 	+= 360*DeltaTime;	// Modify this to change the carrot bob speed
	DancingMessageLife 	+= 200*DeltaTime;	// Modify this to change the carrot bob speed
	LifeTime			+= DeltaTime;

	// Weapon Display Tick
	WeaponDisplayTick(DeltaTime);
	
	// Conversation Tick
	ConversationTick (DeltaTime);
	//UpdateConversationTime (DeltaTime);

	// Component Tick
	for (C=0; C<10; C++)
		if (ComponentLife[C]>0)
		if ((ComponentFixed[C]==0) || (ComponentLife[C]>2))
		ComponentLife[C]-=DeltaTime*2;
		
	// Event Tick
	EventMessageTick(DeltaTime);
}

function ScreenMessage (string Message, int Life)
{
	DancingMessageText = Message;
	DancingMessageDuration = Life;
	DancingMessageLife = 0;
}

function VersionMessage (string Message, int Life)
{
	VersionMessageText = Message;
	VersionMessageDuration = Life;
	VersionMessageLife = 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Inventory Subsystem													HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
function DoInventoryMenu()		// Activation of computer
{
	local int i;

	// Toggle Inventory On/Off
	InventoryDisplayActive = !InventoryDisplayActive;
	JazzPlayer(Owner).bShowInventory=InventoryDisplayActive;
}

// Tick update event - move inventory display as needed
//
event UpdateInventoryTick ( float DeltaTime )
{
	// Position Change - Slowly move from -1 to 0 or 1 to 0 to simulate slow change in one direction or another
	//
	if (InventoryItemSelectChange != 0)
	{
		InventoryItemSelectChangeTo = InventoryItemSelectChangeTo + InventoryItemSelectChange*DeltaTime*3;
		
		if (InventoryItemSelectChange>0)
		{
			if (InventoryItemSelectChangeTo>0)
			{
				InventoryItemSelectChange=0;
				InventoryItemSelectChangeTo=0;
			}		
		}
	
		if (InventoryItemSelectChange<0)
		{
			if (InventoryItemSelectChangeTo<0)
			{
				InventoryItemSelectChange=0;
				InventoryItemSelectChangeTo=0;
			}		
		}
	}

	if ((InventoryDisplayActive) && (InventoryDisplayPosition<0))
		InventoryDisplayPosition+=DeltaTime*500;
	else
	if ((!InventoryDisplayActive) && (InventoryDisplayPosition>-200))
		InventoryDisplayPosition-=DeltaTime*500;
	
	if (InventoryDisplayPosition>0) InventoryDisplayPosition=0;
	
	if ((InventoryDisplayActive) && (InventoryDisplayPosition>-150))
	{
	// Scan Player input to get keypresses 
	// (Roundabout way since I can't do actual code changes but should work perfectly)

		UpDelay 	-= DeltaTime;
		DownDelay 	-= DeltaTime;
		LeftDelay 	-= DeltaTime;
		RightDelay 	-= DeltaTime;
	
		//Log("Inventory) Input "$JazzPlayer(Owner).bWasForward$" "$JazzPlayer(Owner).bEdgeForward$" "$JazzPlayer(Owner).aForward);
		// Move up in list
		if (InventoryItemSelectChange==0)
		{
		if (JazzPlayer(Owner).bEdgeBack)
		{
			if (UpDelay<=0)
			{
			InventoryItemSelect++;
			if (InventoryItemSelect>InventoryItemListNum) InventoryItemSelect = InventoryItemListNum;
			else
			{
			InventoryItemSelectChangeTo=1;
			InventoryItemSelectChange=-1;
			}
			
			MakeInventorySelection();
			UpDelay = 0.1;
			}
		}
		else
		UpDelay = 0;
		
		// Move down in list
		if (JazzPlayer(Owner).bEdgeForward)
		{
			if (DownDelay<=0)
			{
			InventoryItemSelect--;
			if (InventoryItemSelect<0) InventoryItemSelect = 0;
			else
			{
			InventoryItemSelectChangeTo=-1;
			InventoryItemSelectChange=1;
			}
			
			MakeInventorySelection();
			DownDelay = 0.1;
			}
		}
		else
		DownDelay = 0;
		}
		
		// Move to previous group
		if (JazzPlayer(Owner).bEdgeLeft)
		{
			if (LeftDelay<=0)
			{
			InventoryItemGroupNum--;
			if (InventoryItemGroupNum<0) InventoryItemGroupNum=0;
			InventoryNewGroup=true;	
			InventoryItemSelect = 0;
			LeftDelay = 0.5;
			}
		}
		else
		LeftDelay = 0;
		
		// Move to next group
		if (JazzPlayer(Owner).bEdgeRight)
		{
			if (RightDelay<=0)
			{
			InventoryItemGroupNum++;
			if (InventoryItemGroupNum>InventoryItemGroupMax) InventoryItemGroupNum=InventoryItemGroupMax;
			InventoryNewGroup=true;	
			InventoryItemSelect = 0;
			RightDelay = 0.5;
			}
		}
		else
		RightDelay = 0;
	}	
}

// Inventory selection change in group - new item selected
//
function MakeInventorySelection()
{
	JazzPlayer(Owner).SetInventorySelection(InventoryItemGroupNum,InventoryItems[InventoryItemSelect]);
}

// Draw Individual Inventory Item Box
//
function DrawInventoryItem( int x1, int y1, int x2, int y2, Inventory Item, canvas Canvas, bool Selected )
{
	local	int		SizeX, SizeY, TempX, TempY;
	
	SizeX = x2-x1;
	SizeY = y2-y1;

	Canvas.Style = 4;
	Canvas.SetPos(x1,y1);
	Canvas.DrawTile( BoxPat1, SizeX, SizeY, 0, 0, 8, 8 );

	Canvas.DrawColor.R = 155;
	Canvas.DrawColor.G = 155;
	Canvas.DrawColor.B = 155;
	
	// Draw Item Icon
	Canvas.Style = 4;
	Canvas.SetPos(x1,y1);
	//Canvas.DrawIcon(WeapBack,1);
	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	// Draw Item Icon
	Canvas.Style = 2;
	Canvas.SetPos(x1-SizeX/2,y1-SizeY/2);
	if (Item.Icon != None)
	Canvas.DrawIcon(Item.Icon,0.5);
	
	// Draw Item Text
	Canvas.Style = 3;
	Canvas.SetPos(x1+SizeX*0.3, y1+(SizeY/2-6));
	Canvas.Font = Canvas.SmallFont;
	
	if (Selected)
	{
	Canvas.DrawColor.R = 200;
	Canvas.DrawColor.G = 200;
	Canvas.DrawColor.B = 200;
	}
	else
	{
	Canvas.DrawColor.R = 128;
	Canvas.DrawColor.G = 128;
	Canvas.DrawColor.B = 128;
	}
	
	Canvas.DrawText(Item.PickupMessage);
	
/*	if (JazzInventoryItem(Item) != None)
		Canvas.DrawText(JazzInventoryItem(Item).ItemName);
	else
	if (JazzWeapon(Item) != None)
		Canvas.DrawText("Normal");*/
	
}

// Draw Inventory Menu Groups
//
/*function DrawInventoryGroup( int x1, int y1, int x2, int y2, int GroupType, bool Selected, canvas Canvas )
{
	local	int		SizeX, SizeY, TempX, TempY;
	
	SizeX = x2-x1;
	SizeY = y2-y1;

	Canvas.Style = 4;
	Canvas.SetPos(x1,y1);
	Canvas.DrawPattern( BoxPat1,SizeX,SizeY, 1 );
//	Canvas.DrawTile( BoxPat1,SizeX,SizeY, 0, 0, 8, 8 );
	
	if (Selected)
	{
	Canvas.DrawColor.R = 200;
	Canvas.DrawColor.G = 200;
	Canvas.DrawColor.B = 200;
	}
	else
	{
	Canvas.DrawColor.R = 128;
	Canvas.DrawColor.G = 128;
	Canvas.DrawColor.B = 128;
	}
	
	Canvas.Font = Canvas.SmallFont;
	Canvas.SetPos(x1+SizeX/2-7*4,y1+SizeY*0.1);
	Canvas.DrawText(InventoryItemGroupName[GroupType]);
}*/

// Draw Item Specific Information
//
/*function DrawItemInfo ( int x1, int y1, int x2, int y2, Inventory Item, canvas Canvas )
{
	local	int		SizeX, SizeY, TempX, TempY;
	
	SizeX = x2-x1;
	SizeY = y2-y1;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
/*	Canvas.Style = 4;
	Canvas.SetPos(x1,y1);
	Canvas.DrawTile( BoxPat1, SizeX, SizeY, 0, 0, 8, 8 );*/
	
	Canvas.Style = 2;
	Canvas.SetPos(x1,y1);
	Canvas.DrawIcon( CardBas4, 0.5 );
	

	// Draw Item Icon
	Canvas.Style = 3;
	ScaleIt ( x1+5,y1,SizeX*0.3,SizeY*0.3, Canvas, Item.Icon );

	// Draw Item Text
	Canvas.Style = 3;
	Canvas.SetPos(x1+SizeX*0.3, y1+SizeY*0.1);
	Canvas.Font = Canvas.SmallFont;
	if (JazzInventoryItem(Item) != None)
		Canvas.DrawText(JazzInventoryItem(Item).ItemName);
	
	if (JazzWeaponCell(Item) != None)		// Weapon Cell
	{
	// Button Controls
	Canvas.Style = 2;
	ScaleIt ( x1-5,y1+SizeY*0.31,SizeX*0.2,SizeY*0.2, Canvas, JoyBut1 );
	Canvas.SetPos(x1+SizeX*0.3,y1+SizeY*0.35);
	Canvas.DrawText(JazzWeaponCell(Item).FireButtonDesc);
	}
	else
	if (JazzWeapon(Item) != None)			// Main Weapon
	{
	// Button Controls
	Canvas.Style = 2;
	ScaleIt ( x1+5,y1+SizeY*0.31,SizeX*0.2,SizeY*0.2, Canvas, JoyBut1 );
	Canvas.SetPos(x1+SizeX*0.3,y1+SizeY*0.35);
	Canvas.DrawText(JazzWeaponCell(Item).FireButtonDesc);
	}
	
}*/

/*function CardFont( canvas Canvas, float Scale, bool Selected )
{

	if (Scale==0.25)
	{
		Canvas.Font = Canvas.SmallFont;
		if (Selected)
		{
		Canvas.DrawColor.R = 100;	Canvas.DrawColor.G = 50;		Canvas.DrawColor.B = 50;
		}
		else
		{
		Canvas.DrawColor.R = 0;		Canvas.DrawColor.G = 0;			Canvas.DrawColor.B = 0;
		}	
	}
	else
	{
		Canvas.Font = Canvas.MedFont;
		if (Selected)
		{
		Canvas.DrawColor.R = 255;	Canvas.DrawColor.G = 255;		Canvas.DrawColor.B = 255;
		}
		else
		{
		Canvas.DrawColor.R = 80;	Canvas.DrawColor.G = 80;		Canvas.DrawColor.B = 80;
		}	
	}
}*/

/*function GroupCard ( int x, int y, float scale, int GroupType, canvas Canvas )
{
	local int i;
	local int SizeX, SizeY;
	local texture T;
	local float TempX,TempY;
	
//	T = CardBas2;
	SizeX = T.USize*Scale;
	SizeY = T.VSize*Scale;

	Canvas.Style = 2;
	Canvas.SetPos(x,y);
//	Canvas.DrawIcon(CardBas2,scale);

	Canvas.SetPos(x+16*Scale,y+6*Scale);
	CardFont(Canvas,Scale,false);
	
	switch (GroupType)
	{
	case 0:	// Weapon Cells
		Canvas.DrawText("Weapon Cells");
	
		// Draw Cells
		for (i=0; i<=InventoryItemListNum; i++)
		{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		TempY = y+SizeY*(0.1+float(i)*0.11);
		Canvas.SetPos(x+10*Scale,TempY);
		Canvas.DrawIcon(CardBox,Scale);
		ScaleIt(x+10*Scale,TempY,50*Scale,50*Scale,Canvas,InventoryItems[i].Icon);
		
		CardFont(Canvas,Scale,i==InventoryItemSelect);
		Canvas.SetPos(x+SizeX*0.13,TempY+6*Scale);
		Canvas.DrawText(InventoryItems[i].PickupMessage);
		}
	break;
	}
}*/

/*function ItemCard ( int x, int y, float scale, Inventory Item, canvas Canvas )
{
	local int i,j,e;
	local int SizeX, SizeY;
	local texture T;
	local float TempX,TempY;
	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
		
	T = CardBas2;
	SizeX = T.USize*Scale;
	SizeY = T.VSize*Scale;

	Canvas.Style = 2;
	Canvas.SetPos(x,y);
	Canvas.DrawIcon(CardBas3,scale);

	Canvas.SetPos(x+16*Scale,y+6*Scale);
	CardFont(Canvas,Scale,false);
	Canvas.DrawText(Item.PickupMessage);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	ScaleIt(x+12*Scale,y+36*Scale,308*Scale,175*Scale,Canvas,Item.Icon);
	
	if (JazzWeaponCell(Item) != None)		// Weapon Orb
	{
		Canvas.SetPos(x+11*Scale,y+SizeY*0.41);
		Canvas.DrawIcon(JoyBut1,scale/4);
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*0.13,y+SizeY*0.40+10*Scale);
		Canvas.DrawText(JazzWeaponCell(Item).FireButtonDesc);
		
		for (i=0; i<=JazzWeaponCell(Item).MaxPowerLevel; i++)		// Level Displays
		{
			for (j=0; j<=i; j++)
			{
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 255;
				Canvas.DrawColor.B = 255;
				Canvas.SetPos(x+SizeX*(0.04+j*0.04),y+SizeY*(0.48+i*0.04));
				Canvas.DrawIcon(CardDot,Scale);
			}
			CardFont(Canvas,Scale,true);
			Canvas.SetPos(x+SizeX*(0.04+5*0.04),y+SizeY*(0.48+i*0.04));
			
			if (JazzWeaponCell(Item).ExperienceNeeded[i]==0)
				Canvas.DrawText("MAX");
			else
			{
				e=0;
				for (j=0; j<=i; j++)
				e += JazzWeaponCell(Item).ExperienceNeeded[j];
				Canvas.DrawText(e);
			}
		}
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*(0.02+5*0.04),y+SizeY*(0.48+(i)*0.04));
		Canvas.DrawText(
			Digits(JazzWeaponCell(Item).CurrentExperience,4)
			$"/"$
			Digits(JazzWeaponCell(Item).ExperienceNeededNext(),4)
			);
	}
	else
	if (JazzWeapon(Item) != None)		// Weapon Orb
	{
		Canvas.SetPos(x+11*Scale,y+SizeY*0.41);
		Canvas.DrawIcon(JoyBut1,scale/4);
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*0.13,y+SizeY*0.40+10*Scale);
		Canvas.DrawText(JazzWeapon(Item).FireButtonDesc);

		for (i=0; i<=JazzWeapon(Item).MaxPowerLevel; i++)		// Level Displays
		{
			for (j=0; j<=i; j++)
			{
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 255;
				Canvas.DrawColor.B = 255;
				Canvas.SetPos(x+SizeX*(0.04+j*0.04),y+SizeY*(0.48+i*0.04));
				Canvas.DrawIcon(CardDot,Scale);
			}
			CardFont(Canvas,Scale,true);
			Canvas.SetPos(x+SizeX*(0.04+5*0.04),y+SizeY*(0.48+i*0.04));
			
			if (JazzWeapon(Item).ExperienceNeeded[i]==0)
				Canvas.DrawText("MAX");
			else
			{
				e=0;
				for (j=0; j<=i; j++)
				e += JazzWeapon(Item).ExperienceNeeded[j];
				Canvas.DrawText(e);
			}
		}
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*(0.02+5*0.04),y+SizeY*(0.48+(i)*0.04));
		Canvas.DrawText(
			Digits(JazzWeapon(Item).CurrentExperience,4)
			$"/"$
			Digits(JazzWeapon(Item).ExperienceNeededNext(),4)
			);
	}
}*/

/*function ItemCard ( int x, int y, float scale, Inventory Item, canvas Canvas )
{
	local int i,j,e;
	local int SizeX, SizeY;
	local texture T;
	local float TempX,TempY;
	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
		
	T = CardBas4;
	SizeX = T.USize*Scale;
	SizeY = T.VSize*Scale;

	Canvas.Style = 2;
	Canvas.SetPos(x,y);
	Canvas.DrawIcon(CardBas4,scale);

	Canvas.SetPos(x+16*Scale,y+6*Scale);
	CardFont(Canvas,Scale,false);
	Canvas.DrawText(Item.PickupMessage);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	ScaleIt(x+12*Scale,y+36*Scale,308*Scale,175*Scale,Canvas,Item.Icon);
	
	if (JazzWeaponCell(Item) != None)		// Weapon Orb
	{
		Canvas.SetPos(x+11*Scale,y+SizeY*0.41);
		Canvas.DrawIcon(JoyBut1,scale/4);
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*0.13,y+SizeY*0.40+10*Scale);
		Canvas.DrawText(JazzWeaponCell(Item).FireButtonDesc);
		
		for (i=0; i<=JazzWeaponCell(Item).MaxPowerLevel; i++)		// Level Displays
		{
			for (j=0; j<=i; j++)
			{
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 255;
				Canvas.DrawColor.B = 255;
				Canvas.SetPos(x+SizeX*(0.50+j*0.05),y+SizeY*(0.10+i*0.05));
				Canvas.DrawIcon(CardDot,Scale);
			}
			CardFont(Canvas,Scale,true);
			Canvas.SetPos(x+SizeX*(0.50+5*0.05),y+SizeY*(0.10+i*0.05));
			
			if (JazzWeaponCell(Item).ExperienceNeeded[i]==0)
				Canvas.DrawText("MAX");
			else
			{
				e=0;
				for (j=0; j<=i; j++)
				e += JazzWeaponCell(Item).ExperienceNeeded[j];
				Canvas.DrawText(e);
			}
		}
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*(0.50),y+SizeY*(0.30));
		Canvas.DrawText(
			Digits(JazzWeaponCell(Item).CurrentExperience,4)
			$"/"$
			Digits(JazzWeaponCell(Item).ExperienceNeededNext(),4)
			);

	}
	else
	if (JazzWeapon(Item) != None)		// Weapon Orb
	{
		Canvas.SetPos(x+11*Scale,y+SizeY*0.41);
		Canvas.DrawIcon(JoyBut1,scale/4);
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*0.13,y+SizeY*0.40+10*Scale);
		Canvas.DrawText(JazzWeapon(Item).FireButtonDesc);


		for (i=0; i<=JazzWeapon(Item).MaxPowerLevel; i++)		// Level Displays
		{
			for (j=0; j<=i; j++)
			{
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 255;
				Canvas.DrawColor.B = 255;
				Canvas.SetPos(x+SizeX*(0.50+j*0.05),y+SizeY*(0.10+i*0.05));
				Canvas.DrawIcon(CardDot,Scale);
			}
			CardFont(Canvas,Scale,true);
			Canvas.SetPos(x+SizeX*(0.50+5*0.05),y+SizeY*(0.10+i*0.05));
			
			if (JazzWeapon(Item).ExperienceNeeded[i]==0)
				Canvas.DrawText("MAX");
			else
			{
				e=0;
				for (j=0; j<=i; j++)
				e += JazzWeapon(Item).ExperienceNeeded[j];
				Canvas.DrawText(e);
			}
		}
		CardFont(Canvas,Scale,true);
		Canvas.SetPos(x+SizeX*(0.50),y+SizeY*(0.30));
		Canvas.DrawText(
			Digits(JazzWeapon(Item).CurrentExperience,4)
			$"/"$
			Digits(JazzWeapon(Item).ExperienceNeededNext(),4)
			);
	}
}*/

// Card-Based Inventory System
//
/*event UpdateInventoryDisplay( canvas Canvas )
{
	local int i;
	local float Scale;
	
	if (InventoryDisplayPosition>-150)
	{
	
	// New Inventory List
	if (InventoryNewGroup)
	{
	ExtractNewGroup();
	InventoryNewGroup = false;
	}
	
	// Bring HUD Objects into View
	if (InventoryDisplayActive)
	for (i=0; i<10; i++)
	{
		UpdateComponent(i,0);
	}
	
	if (Canvas.SizeX<401)
	Scale = 0.25;
	else
	Scale = 0.5;

	Canvas.Style = 4;
	Canvas.SetPos(Canvas.SizeX-100,Canvas.ClipY-100);
	Canvas.DrawTile( BoxPat1, 40, 40, 0, 0, 8, 8 );
	Canvas.SetPos(Canvas.SizeX-100,Canvas.ClipY-150);
	Canvas.DrawTile( BoxPat1, 40, 40, 0, 0, 8, 8 );
	
	// Group Card
	GroupCard(10+InventoryDisplayPosition,Canvas.ClipY*0.35,Scale,0,Canvas);
	
	// Item Card
	ItemCard(Canvas.sizex*0.70-InventoryDisplayPosition,Canvas.ClipY*0.35,Scale,InventoryItems[InventoryItemSelect],Canvas);
	}
	else
	ResetInventoryDisplay();
}*/

// PreRender update event
//
event UpdateInventoryDisplay( canvas Canvas )
{
	local int i,j;
	local float X,Y;
	local float k;
	local float Scale,TempScale;
	local float Spacing;
	local texture T;
	
	if (InventoryDisplayPosition>-150)
	{
	
	// Bring HUD Objects into View				// CPU usage negligable
	if (InventoryDisplayActive)
	for (i=0; i<10; i++)
	{
		UpdateComponent(i,10);
	}

	// New Inventory List
	if (InventoryNewGroup)
	{
	//Log("Inventory New Group");
	ExtractNewGroup();
	InventoryNewGroup = false;
	}
	
	if (Canvas.sizex<600) Scale=0.5;
	else
	Scale = 1;
	
	// Draw Item Info Window
	
/*	Canvas.Style = 4;
	Canvas.SetPos(Canvas.sizex*0.1,Canvas.ClipY*0.35);
	Canvas.DrawTile( BoxPat1, Canvas.SizeX*0.3, Canvas.ClipY*0.3, 0, 0, 8, 8 );*/
	
	// Draw Item Flare Highlight
	//
/*	Canvas.Style = 3;
//	T = WeapFlar;
	Canvas.DrawColor.R = 60;
	Canvas.DrawColor.G = 60;
	Canvas.DrawColor.B = 60;
	Canvas.SetPos(Canvas.SizeX*0.7-T.USize*Scale/2,Canvas.ClipY*0.5-T.VSize*Scale/2);
	Canvas.DrawIcon(T,Scale);*/
	
	// Draw specific inventory objects
	//
	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	Spacing = 0.8/(InventoryItemListNum+1);
	
	for (i=0; i<=InventoryItemListNum; i++)
	{
	J = i;
	K = i-InventoryItemSelect+InventoryItemSelectChangeTo;
	//InventoryItemListNum/2+InventoryItemSelectChangeTo;
	//if (J<0) J+=InventoryItemListNum+1;		if (J>InventoryItemListNum) J-=InventoryItemListNum+1;
	
	if (abs(K)>1.99)
	TempScale = Scale/4;	// Scale of Item shown
	else
	if (abs(K)>1)
	TempScale = Scale/2-((abs(K)-1)/2)*(Scale/4);	// Scale of Item shown
	else
	if (abs(K)==1)
	TempScale = Scale/2;
	else
	TempScale = Scale-abs(K)*(Scale/2);	// Scale of Item shown
	
	T = InventoryItems[J].Icon;
	X = Canvas.SizeX*0.7 + (1-cos(abs(K)/float(InventoryItemListNum+1)))*Canvas.SizeX*0.5;
	Y = Canvas.ClipY*(K*Spacing+0.5)-T.VSize*TempScale/2;
	
	Canvas.Style = 4;
	Canvas.SetPos(X,Y);
	Canvas.DrawPattern( BoxPat1,Canvas.SizeX/2, (T.VSize-2)*TempScale, 1 );
//	Canvas.DrawTile( BoxPat1, Canvas.SizeX, (T.VSize-1)*TempScale, 0, 0, 8, 8 );
	
	Canvas.Style = 2;
	Canvas.SetPos(X - T.USize*TempScale/2, Y);
	if (T != None)
	Canvas.DrawIcon(T,TempScale);
	
/*	DrawInventoryItem(	Canvas.SizeX*0.6, 	Canvas.ClipY*(K*Spacing+0.5),
					  	Canvas.SizeX*0.7, 	Canvas.ClipY*(K*Spacing+0.6),
					  	InventoryItems[J], Canvas, i==InventoryItemSelect );*/
	}

	/*ItemCard(			Canvas.SizeX*0.05,	Canvas.ClipY*0.4, Scale/2,
						InventoryItems[InventoryItemSelect],
						Canvas);*/
	
	// Inventory display groups
/*	for (i=0; i<=2; i++)
	{
	J = InventoryItemGroupNum+i-1;
	if (J<0) J+=InventoryItemGroupMax+1;	if (J>InventoryItemGroupMax) J-=InventoryItemGroupMax+1;
	DrawInventoryGroup(	Canvas.SizeX*(i*0.333+0.02),	Canvas.ClipY*0.02 + InventoryDisplayPosition,
						Canvas.SizeX*(i*0.333+0.313),	Canvas.ClipY*0.1  + InventoryDisplayPosition,
						J, J==InventoryItemGroupNum, Canvas);
	}*/

	}
}
 
function ResetInventoryDisplay ()
{
	InventoryNewGroup = true;
	InventoryItemListNum = -1;
	InventoryItemSelect = 0;
	InventoryItemSelectChange = 0;
}

// General function to return a string based on an integer with the correct # of digits (0s on front)
//
function string Digits ( int Value, int Digit )
{
	local string S;
	
	S = string(Value);

	if (InStr(S,"-")>=0)
	{
	S = Mid(S,1,9999);
	while (Len(S)<Digit-1)	S = "0"$S;
	S = "-"$S;
	}
	else
	while (Len(S)<Digit)	S = "0"$S;
	
	return S;
}

/*function DrawInventoryDisplay( canvas Canvas, int X, int Y )
{
	local int i;
	
	// New Inventory List
	if (InventoryNewGroup) 
	{
	ExtractNewGroup();
	InventoryNewGroup = false;
	}
	
	// Display Inventory Window
	Canvas.Style = 2;
	Canvas.Font = Canvas.SmallFont;
	
	// Note that the inventory window uses the PickupMessage for the name of the item.
	//
	for (i=0; i<=InventoryItemListNum; i++)
	{
	if (i==InventoryItemSelect)
	{
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;
	} else
	{
	Canvas.DrawColor.r = 50;
	Canvas.DrawColor.g = 50;
	Canvas.DrawColor.b = 50;	
	}
	
	Canvas.SetPos(X+13,Y+23+i*12);
	if (InventoryItems[i] == None)
	{
	Canvas.DrawText("None");
	}
	else
	{
	Canvas.DrawText(InventoryItems[i].PickupMessage);
	}
	}
	
	// Display Experience if Weapon Cell
	//
	Canvas.Font = Canvas.SmallFont;
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
	if (InventoryItems[InventoryItemSelect] == None)
	{
		Canvas.SetPos(X+17,Y+92);
		Canvas.DrawText(
			"Level "$JazzWeapon(JazzPlayer(Owner).Weapon).CurrentPowerLevel
			);
		Canvas.SetPos(X+17,Y+100);
		Canvas.DrawText(
			Digits(JazzWeapon(JazzPlayer(Owner).Weapon).CurrentExperience,4)
			$"/"$
			Digits(JazzWeapon(JazzPlayer(Owner).Weapon).ExperienceNeededNext(),4)
			);
	}
	else
	if (JazzWeaponCell(InventoryItems[InventoryItemSelect]) != None)
	{
		Canvas.SetPos(X+17,Y+92);
		Canvas.DrawText(
			"Level "$JazzWeaponCell(InventoryItems[InventoryItemSelect]).CurrentPowerLevel
			);
		Canvas.SetPos(X+17,Y+100);
		Canvas.DrawText(
			Digits(JazzWeaponCell(InventoryItems[InventoryItemSelect]).CurrentExperience,4)
			$"/"$
			Digits(JazzWeaponCell(InventoryItems[InventoryItemSelect]).ExperienceNeededNext(),4)
			);
	}
	
	
	// Display Groups
	//
	for (i=0; i<=InventoryItemGroupMax; i++)
	{
	if (i==InventoryItemGroupNum)
	{
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;
	} else
	{
	Canvas.DrawColor.r = 50;
	Canvas.DrawColor.g = 50;
	Canvas.DrawColor.b = 50;	
	}
	
	Canvas.SetPos(X+13+i*12,Y+120);
	
	//Log("InventoryGroup) "$i);
	
	switch (i)
	{
	case 0:
		Canvas.DrawIcon(JazzGrp1, 1.0);
		break;
		
	case 1:
		Canvas.DrawIcon(JazzGrp2, 1.0);
		break;
	}
	}
}*/

function ExtractNewGroup()
{
	local Inventory Inv;
	local bool  ValidCell;

	// Looking For Matching Inventory Type - InventoryGroup variable
	//
	// InventoryGroup
	// 10 - Weapon Type
	// 11 - 
	// 12 -
	//
	InventoryItemListNum = -1;
	
	// Extract items
	//
	Inv = PlayerPawn(Owner).Inventory;
		
	while (Inv != None)
	{
		ValidCell = true;
		if (JazzWeaponCell(Inv) != None)
		{
			if (JazzWeaponCell(Inv).WeaponCapable[JazzWeapon(PlayerPawn(Owner).Weapon).WeaponTypeNumber]==0)
			ValidCell = false;
		}
	
		if ((Inv.InventoryGroup == InventoryItemGroupNum+10) && ValidCell)
		{
			InventoryItemListNum++;
			InventoryItems[InventoryItemListNum]=Inv;
			
			if (Inv==JazzPlayer(Owner).InventorySelections[InventoryItemGroupNum])
				InventoryItemSelect = InventoryItemListNum;
		}
		Inv = Inv.Inventory;
	}
}

//////
// New Item was picked up by Owner, who called this event for the HUD to update itself.
//
event NewInventoryItem ()
{
	ExtractNewGroup();
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Tutorial Message Subsystem 											HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
function UpdateTutorialDisplay( canvas Canvas )
{
	local texture T;
	local bool    CapsOnly;

	Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.6);
	
	if (TutorialTime<1)
	{
	Canvas.Style = 3;
	Canvas.DrawColor.R = TutorialTime*255/1;
	Canvas.DrawColor.G = TutorialTime*255/1;
	Canvas.DrawColor.B = TutorialTime*255/1;
	}
	else
	{
	Canvas.Style = 3;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	}
	
	T = HudMisc;

	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*0.8, Canvas.SizeY*0.35, 0, 0, T.USize, T.VSize );

	Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.6);
	Canvas.Style = 3;
	T = HudMiscT;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*0.8, Canvas.SizeY*0.35, 0, 0, T.USize, T.VSize );
	
	// Select Font
	//
	
	if (Canvas.SizeY>600)
	{
	CapsOnly = true;
	Canvas.Font = font'DLFont';
	}
	else
	if (Canvas.SizeY>400)
	{
	CapsOnly = true;
	Canvas.Font = font'DSFont';
	}
	else
	//if (Canvas.SizeY>240)
	//else
	{
	CapsOnly = true;
	Canvas.Font = font'DSFont';
	}
	
	Canvas.SetPos(Canvas.SizeX*0.2,Canvas.SizeY*0.6);
	if (CapsOnly==true)
	Canvas.DrawText(Caps(TutorialTitle));
	else
	Canvas.DrawText(TutorialTitle);
	
	Canvas.SetPos(0,0);
	Canvas.OrgX = Canvas.SizeX*0.13;
	Canvas.OrgY = Canvas.SizeY*0.65;
	Canvas.ClipX = Canvas.SizeX*0.74;
	Canvas.ClipY = Canvas.SizeX*0.92;
	
	if (TutorialCentered==true)
	Canvas.bCenter=true;
	
	if (CapsOnly==true)
	Canvas.DrawText(Caps(TutorialText[0]));
	else
	Canvas.DrawText(TutorialText[0]);

	Canvas.bCenter = false;	
	Canvas.ClipX = 10000;
	Canvas.ClipY = 10000;
	Canvas.OrgX = 0;
	Canvas.OrgY = 0;
}

function NewTutorial( string Message, string Title, optional bool Centered )
{
	local int i;

	JazzPlayer(Owner).bShowTutorial = true;
	JazzPlayer(Owner).Player.Console.GotoState('Menuing');
	if( Level.Netmode == NM_Standalone )
		JazzPlayer(Owner).SetPause(true);
	
	TutorialUp=true;
	TutorialText[0]=Message;
	TutorialText[1]="";
	TutorialText[2]="";
	TutorialTitle=Title;
	TutorialTime=0;
	TutorialCentered = Centered;

	if (DancingMessageDuration>1) DancingMessageDuration=1;

	// Move HUD Objects Away
	for (i=0; i<10; i++)
	{
		UpdateComponent(i,1);
	}
}

function TutorialTick ( float DeltaTime )
{
	local JazzPlayer J;

	TutorialTime += DeltaTime;
	
	if (TutorialTime>2)
	{
	J = JazzPlayer(Owner);
	}
	
	Tick(DeltaTime);
}

// Called when Fire or AltFire pressed.
// 
function TutorialEnd()
{
	if (TutorialTime>0.5)
	{
	TutorialUp = false;
	JazzPlayer(Owner).bShowTutorial = false;
	JazzPlayer(Owner).Player.Console.GotoState('');
	if( Level.Netmode == NM_Standalone )
		JazzPlayer(Owner).SetPause(false);
	}
}

// DisplayMessages is called by the Console in PostRender.
// It offers the HUD a chance to deal with messages instead of the
// Console.  Returns true if messages were dealt with.
simulated function bool DisplayMessages(canvas Canvas)
{
	return true;
}

// Display mesh.
//
function DisplayMesh( canvas Canvas, mesh MeshToDisplay, texture MeshSkin, float XPos, float YPos, float Scale, optional float YawAdd )
{
	local float XRatio,YRatio;
	local vector DrawOffset,DrawLoc;
	local rotator DrawRot,NewRot;

	XRatio = float(Canvas.SizeX)/float(Canvas.SizeY);
	YRatio = float(Canvas.SizeY)/float(Canvas.SizeX);

	XPos = ((XPos-Canvas.SizeX/2)/float(Canvas.SizeX))*2;
	YPos = ((YPos-Canvas.SizeY/2)/float(Canvas.SizeY))*2;

	// Conversion from screen coordinates (1:1 screen ratio based)
	//
	XPos =  XPos*XRatio*3.75;
	YPos = -YPos*YRatio*4.5;
	
	//Log("DrawMesh) X"$XPos$" Y"$YPos$" XR"$XRatio$" YR"$YRatio);
	
	DrawOffset.X = 5;
	DrawOffset.Y = XPos;
	DrawOffset.Z = YPos;
	
	DrawRot = JazzPlayer(Owner).MyCameraRotation;
	DrawOffset = (DrawOffset >> JazzPlayer(Owner).MyCameraRotation);
	DrawLoc = JazzPlayer(Owner).MyCameraLocation /*+ Pawn(Owner).EyeHeight * vect(0,0,1)*/;

	Mesh = MeshToDisplay;
	Texture = MeshSkin;
	DrawScale = Scale/10;

	//Log("DrawMesh) "$Mesh$" "$Scale$" "$DrawLoc$" "$JazzPlayer(Owner).MyCameraLocation);
	
	SetLocation(DrawLoc + DrawOffset);
	NewRot = DrawRot;
	NewRot.Yaw += YawAdd;
	NewRot.Pitch = 0;
	SetRotation(NewRot);
	Canvas.DrawActor(self, false);
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Event Message Subsystem 												HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//

event EventMessageTick ( float DeltaTime )
{
	local int i;
	for (i=0; i<=EventNum; i++)
	{
		if (EventTime[i]>0) EventTime[i]-=DeltaTime;
	}	
}

// Draw event symbols
function EventSymbolDraw ( int x, int y, int Event, canvas Canvas, float Scale )
{
	local float MessageArea;

	// Determine width of message area
	MessageArea = Len(EventMessage[Event])*6.5 / 1.5;		// 1.5 is size decrease for word wrap estimate
	if (MessageArea<80) MessageArea = 80;					// Minimum area size
	
	Canvas.SetPos(x-MessageArea+56*Scale,y);

	Canvas.DrawIcon(EventN,Scale);
	//Canvas.DrawIcon(EventBr,Scale);
	
	Canvas.DrawColor.R = 50;
	Canvas.DrawColor.G = 0;
	Canvas.DrawColor.B = 0;
	Canvas.Font = Canvas.SmallFont;
	Canvas.SetPos(x-MessageArea+62*Scale,y+8*Scale);
	Canvas.ClipX = MessageArea-2;
	Canvas.OrgX = x-MessageArea+62*Scale;
	Canvas.SetPos(0,y+8*Scale);
	Canvas.DrawText(EventMessage[Event]);
	Canvas.OrgX = 0;
	Canvas.ClipX = 100000;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.SetPos(x-MessageArea,y);
	Canvas.DrawIcon(EventSymbols[EventType[EventNum-Event]],Scale);
}

function UpdateEventMessageDisplay ( canvas Canvas )
{
	local float Scale;
	local int i;

	if (Canvas.SizeX < 400)
	Scale = 0.5;
	else
	if (Canvas.SizeX < 512)
	Scale = 0.5;
	else
	if (Canvas.SizeX < 601)
	Scale = 0.5;
	else
	Scale = 0.5;
	
	// Draw Event Symbols
	for (i=0; i<=EventNum; i++)
	{
		if (EventTime[i]>0)
		{
			Canvas.Style = 2;
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
			if (EventTime[i]<1)
			EventSymbolDraw(Canvas.SizeX-58*Scale+200*(1-EventTime[i]),Canvas.ClipY-58*Scale*((EventNum-i)+1),i,Canvas,Scale);
			else
			EventSymbolDraw(Canvas.SizeX-58*Scale,Canvas.ClipY-58*Scale*((EventNum-i)+1),i,Canvas,Scale);
		}
		else
		{
			// Remove Event
			RemoveEvent(i);			
		}
	}
}

function AddEvent ( int Type, float Duration, string Message )
{
	if (EventNum<9)
	{
		EventNum++;
		EventType[EventNum]=Type;
		EventTimeStart[EventNum]=Duration;
		EventTime[EventNum]=Duration;
		EventMessage[EventNum]=Message;
	}
}

function RemoveEvent ( int Event )
{
	local int E;
	
	for (E=Event+1; E<=EventNum; E++)
	{
		EventType[E-1]=EventType[E];
		EventTimeStart[E-1]=EventType[E];
		EventTime[E-1]=EventTime[E];
		EventMessage[E-1]=EventMessage[E];
	}
	EventNum--;
}

function BeginEvent ()
{
	EventNum = -1;
//	AddEvent(0,20,"Test");
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Conversation Subsystem Variables									HUD SUBSYSTEM
///////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//

function InitiateConversation (JazzConversation NewConversation,pawn EventInstigator,optional bool LargeWindow)
{
	// Check of no current conversation
	if (CurrentConversation != NewConversation)
	{
		CurrentConversation = NewConversation;
		ConvEvent = 0;
		ConvEventFirst = true;
		ConvTime = 0;
		ConvFade = 0;
		ConvEnd = false;
		ConvEndLine = false;
	}

	if (!LargeWindow)
	{
		ConvWindowYSize = 0.2;
	}
	else
	{
		ConvWindowYSize = 0.4;
	}

	ConvFocus = EventInstigator;
	ConvText = Caps(CurrentConversation.GetCurrentText(ConvEvent));
	Log("InitiateConversation) "$NewConversation$" "$ConvText);
}

event UpdateConversationDisplay (canvas Canvas)
{
	local texture T;
	
	local int MaxChar,CurChar,X;
	
	local float MaxX,TextX,TextY,CurX,CurY,TX,TY,Scale;

	if (CurrentConversation != None)
	{		
		// Conversation End Fadeaway Done
		if ((ConvEnd == true) && (ConvFade >= 1))
		{
			CurrentConversation = NONE;
			return;
		}
		
		if (!ConvEnd)
		{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		}
		else
		{
		Canvas.DrawColor.R = 255*(1-ConvFade);
		Canvas.DrawColor.G = 255*(1-ConvFade);
		Canvas.DrawColor.B = 255*(1-ConvFade);
		}
		
	
		// Display Conversation Box
		T = HudMisc;
		Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*(0.8-ConvWindowYSize));
		Canvas.DrawTile(T,Canvas.SizeX*0.8,Canvas.SizeY*ConvWindowYSize,0,0,T.USize,T.VSize);
		
		T = HudMiscT;
		Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*(0.8-ConvWindowYSize));
		Canvas.Style = 3;
		Canvas.DrawTile(T,Canvas.SizeX*0.8,Canvas.SizeY*ConvWindowYSize,0,0,T.USize,T.VSize);
		
		// Display 3D Mesh of Conversation Object
		
		// Display Conversation Text
		Canvas.Style = 2;
		MaxChar = Len(ConvText);	// Max chars in string
		CurChar = (ConvTime / 0.15);	// Chars to draw
		if (CurChar>MaxChar) 
		{
			CurChar=MaxChar;
			ConvEndLine = true;
		}
		
		if (Canvas.SizeY>600)
		{
		Canvas.Font = font'DLFont';
		TextX = 32; TextY = 32;
		Scale = 1;
		}
		else
		{
		Canvas.Font = font'DSFont';
		TextX = 16; TextY = 16;
		Scale = 0.5;
		}
		
		CurX = Canvas.SizeX*0.18;
		CurY = Canvas.SizeY*(0.82-ConvWindowYSize);
		
		for (x=0; x<CurChar; x++)
		{
			// Draw char	
			Canvas.SetPos(CurX,CurY);
			Canvas.DrawText(Mid(ConvText,x,1));
			
			// Next char
			Canvas.StrLen(Mid(ConvText,x,1),TX,TY);
			CurX += TX;
			if (CurX > Canvas.SizeX*0.84)	// Next line
			{
				CurX = Canvas.SizeX*0.18;
				CurY += TextY;
			}
		}
		
		// Display Conversation Continue Icon
		if (ConvEndLine)
		{
			T = ConversationCon;
			Canvas.SetPos(Canvas.SizeX*0.78,Canvas.SizeY*0.75);
			Canvas.Style = 2;
			Canvas.DrawTile(T,T.USize*Scale,T.VSize*Scale,0,0,T.USize,T.VSize);
		}
		
		if (VSize(Owner.Location - ConvFocus.Location)>1000)
		ConversationEnd();
	}
}

function bool ConversationTrapButton ()
{
	// If Fire/AltFire button is pressed.
	
	// Check if we should trap the button.
	// Return false if we should not trap it.
	//
	if (CurrentConversation != None)
	{
		if (ConvEndLine)
		{
			ConversationNextLine();
		}
		else
		{
			ConvAccel = true;
		}
		return(true);
	}
	else
	return(false);
}

function ConversationNextLine ()
{
	local int ConvReturn;

	if (ConvEnd)
	return;

	ConvEvent++;
	ConvReturn = CurrentConversation.UpdateConversation(ConvEvent,Pawn(Owner),ConvEventFirst);
	ConvEventFirst = false;
	ConvEndLine = false;
	ConvAccel = false;
	ConvTime = 0;
	
	switch (ConvReturn)
	{
		case -1:
			CurrentConversation = None;
			return;
		
		case 1:
			ConvEventFirst = true;
			break;
	}
	
	ConvText = Caps(CurrentConversation.GetCurrentText(ConvEvent));
}

function bool InConversation ()
{
	return(CurrentConversation != None);
}

function ConversationTick ( float DeltaTime )
{
	// Check if acceleration still in effect
	if ((JazzPlayer(Owner).bFire==0) && (JazzPlayer(Owner).bAltFire==0))
		ConvAccel = false;

	if (ConvAccel)
	ConvTime += DeltaTime*3;
	else
	ConvTime += DeltaTime;
	
	ConvFade += DeltaTime;
}

function ConversationEnd ()
{
	// Trigger the end of the conversation
	if (ConvEnd == false)
	{
		ConvEnd = true;
		ConvFade = 0;
	}
}

/*function UpdateConversationDisplay2( canvas Canvas )
{
	local texture T;
	local bool    CapsOnly;

	Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.6);
	
	if (TutorialTime<1)
	{
	Canvas.Style = 3;
	Canvas.DrawColor.R = TutorialTime*255/1;
	Canvas.DrawColor.G = TutorialTime*255/1;
	Canvas.DrawColor.B = TutorialTime*255/1;
	}
	else
	{
	Canvas.Style = 3;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	}
	
	T = HudMisc;

	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*0.8, Canvas.SizeY*0.35, 0, 0, T.USize, T.VSize );

	Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.6);
	Canvas.Style = 3;
	T = HudMiscT;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*0.8, Canvas.SizeY*0.35, 0, 0, T.USize, T.VSize );
	
	// Select Font
	//
	
	if (Canvas.SizeY>600)
	{
	CapsOnly = true;
	Canvas.Font = font'DLFont';
	}
	else
	if (Canvas.SizeY>400)
	{
	CapsOnly = true;
	Canvas.Font = font'DSFont';
	}
	else
	//if (Canvas.SizeY>240)
	//else
	{
	CapsOnly = true;
	Canvas.Font = font'DSFont';
	}
	
	Canvas.SetPos(Canvas.SizeX*0.2,Canvas.SizeY*0.6);
	if (CapsOnly==true)
	Canvas.DrawText(Caps(TutorialTitle));
	else
	Canvas.DrawText(TutorialTitle);
	
	Canvas.SetPos(0,0);
	Canvas.OrgX = Canvas.SizeX*0.13;
	Canvas.OrgY = Canvas.SizeY*0.65;
	Canvas.ClipX = Canvas.SizeX*0.74;
	Canvas.ClipY = Canvas.SizeX*0.92;
	
	if (TutorialCentered==true)
	Canvas.bCenter=true;
	
	if (CapsOnly==true)
	Canvas.DrawText(Caps(TutorialText[0]));
	else
	Canvas.DrawText(TutorialText[0]);

	Canvas.bCenter = false;	
	Canvas.ClipX = 10000;
	Canvas.ClipY = 10000;
	Canvas.OrgX = 0;
	Canvas.OrgY = 0;
}
*/

defaultproperties
{
     HealthDisplay(0)=Texture'JazzArt.Health.Jazzht5'
     HealthDisplay(1)=Texture'JazzArt.Health.Jazzht4'
     HealthDisplay(2)=Texture'JazzArt.Health.Jazzht3'
     HealthDisplay(3)=Texture'JazzArt.Health.Jazzht2'
     HealthDisplay(4)=Texture'JazzArt.Health.Jazzht1'
     WealthDisplay=Texture'JazzArt.Item.Jazzcoin'
     InventoryItemGroupMax=1
     InventoryItemGroupName(0)="Weapon Cell"
     InventoryItemGroupName(1)="Load Game"
     EventSymbols(0)=Texture'JazzArt.Events.Eventq'
     EventSymbols(1)=Texture'JazzArt.Events.Event2'
     MainMenuType=Class'CalyGame.JazzMainMenu'
     DrawType=DT_Mesh
	MenuBack=Texture'JazzArt.MenuBack'
	JoyBut1=Texture'JazzArt.JoyBut1'
	HudItem1=Texture'JazzArt.HudItem1'
	HudItem2=Texture'JazzArt.HudItem2'
	HudTrans=Texture'JazzArt.HudTrans'
	NewHud=Texture'JazzArt.NewHud'
	NewHudCE=Texture'JazzArt.NewHudCE'
	NewHudC=Texture'JazzArt.NewHudC'
	HudMisc=Texture'JazzArt.HudMisc'
	HudMiscT=Texture'JazzArt.HudMiscT'
	WeapDisp=Texture'JazzArt.WeapDisp'
	WeapExp2=Texture'JazzArt.WeapExp2'
	WeapRedy=Texture'JazzArt.WeapRedy'
	WeapEOut=Texture'JazzArt.WeapEOut'
	WeapExp=Texture'JazzArt.WeapExp'
	JazzSD1=Texture'JazzArt.JazzSD1'
	JazzSD1e=Texture'JazzArt.JazzSD1e'
	JCoin_01=Texture'JazzArt.JCoin_01'
	BoxPat1=Texture'JazzArt.BoxPat1'
	WeapBack=Texture'JazzArt.WeapBack'
	CardBas4=Texture'JazzArt.CarBas4'
	CardBas3=Texture'JazzArt.CardBas3'
	CardBas2=Texture'JazzArt.CardBas2'
	CardBox=Texture'JazzArt.CardBox'
	CardDot=Texture'JazzArt.CardDot'
	WeapFlar=Texture'JazzArt.WeapFlar'
	JazzGrp1=Texture'JazzArt.JazzGrp1'
	JazzGrp2=Texture'JazzArt.JazzGrp2'
	EventN=Texture'JazzArt.EventN'
	EventBr=Texture'JazzArt.EventBr'
	ConversationCon=Texture'JazzArt.ConversationCon'
}
