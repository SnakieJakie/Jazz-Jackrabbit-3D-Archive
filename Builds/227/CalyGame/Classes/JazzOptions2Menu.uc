//=============================================================================
// JazzOptions2Menu.
//=============================================================================
class JazzOptions2Menu expands JazzMenu;

// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	ResetMenu();
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

	if (Selection == 1)
	{
		ChildMenu = spawn(class'JazzVideoMenu', owner);
	}
	else
	if (Selection == 2)
	{
		ChildMenu = spawn(class'JazzAudioMenu', owner);
	}
	else
	if (Selection == 3)
	{
		ChildMenu = spawn(class'JazzControlMenu', owner);
	}
	else
	if (Selection == 4)
	{
		PlayerOwner.ConsoleCommand("PREFERENCES");
	}
	else
	if (Selection == 5)
	{
		ExitMenu();
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

function DrawMenu (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;
	
	MenuStart(Canvas);
	
	DrawBackgroundARight(Canvas);

	TextMenuRight(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
     MenuLength=5
}
