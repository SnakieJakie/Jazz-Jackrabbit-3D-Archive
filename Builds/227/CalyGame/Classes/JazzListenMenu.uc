//=============================================================================
// JazzListenMenu.
//=============================================================================
class JazzListenMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var string ClassString;
var string StartMap;

var() class PlayerClasses[8];

var string LastServer;
var InternetInfo receiver;
var float ListenTimer;

// Destroy receiver actor when done
//
function Destroyed()
{
	Super.Destroyed();
	if ( receiver != None )
		receiver.Destroy();
}

// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	local class<InternetInfo> C;

	Super.PostBeginPlay();
	C = class<InternetInfo>(DynamicLoadObject("IpDrv.ClientBeaconReceiver", class'Class'));
	receiver = spawn(C);
	
	// Setup Jazz menu timings
	ResetMenu();
}

function ResetMenu()
{
	// Plays sounds as menus move across the screen
	MenuSoundNum = 0;
	MenuExistTime = 0;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if (Selection >= MenuLength)
	{
		ExitMenu();
	}
	else
	if (Selection > -1)
	{
		ChildMenu = spawn(class'JazzMultiplayerCharacterSelectMenu', owner);
		JazzMultiplayerCharacterSelectMenu(ChildMenu).StartMap = Receiver.GetBeaconAddress(Selection-1)$"?LAN";
		Log("JazzServer) Connected to Server - Going to Map "$Receiver.GetBeaconAddress(Selection-1));
	}

	if ( ChildMenu != None )
	{
		// Reset Menu Movement in preparation for return to this menu
		ResetMenu();
	
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}

function ListenForServers ()
{
	local int i;
	local string Receive;

	MenuLength = -1;
	for ( i=0; i<16; i++ )
	{
		Receive = Receiver.GetBeaconAddress(i);
		if (( Receive != "" ) && (Receive != "0.0.0.0:0"))
		{
			MenuLength++;
			MenuList[i] =  Caps(Receiver.GetBeaconText(i));
		}
	}

	MenuLength++;
	MenuList[MenuLength] = "EXIT";
	MenuLength++;
	
	if ( MenuLength == 0 )
		return;
	else if ( Selection == 0 )
		Selection = 1;
}

function DrawMenu (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;
	
	ListenForServers();

	MenuStart(Canvas);
	
	DrawTitle(Canvas);
	
	DrawBackgroundA(Canvas);
	
	DrawTitle(Canvas);		// 220 Version

	TextMenuLeft(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
}
