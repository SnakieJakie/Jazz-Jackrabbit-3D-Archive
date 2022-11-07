//=============================================================================
// JazzIntroMenu.
//=============================================================================
class JazzIntroMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var		int		MenuRightSide;

// Determines what map starts a new game.
//
// This is hardcoded right now until we have the capability to edit the C code.
//
var string StartMap;

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if ( (Selection == 1) )
	{
		ChildMenu = spawn(class'JazzNewGameMenu', owner);
	}
	else 
	if ( Selection == 2 )
	{
		ChildMenu = spawn(class'JazzLoadMenu', owner);
	}
	else
	if ( Selection == 3 )
	{
		ChildMenu = spawn(class'JazzOptions2Menu', owner);
	}
	else
	if ( Selection == 4 )
	{
		ChildMenu = spawn(class'JazzQuitMenu', owner);
	}
	else
		return false;

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

//
function DrawMenu (canvas Canvas)
{
	local int	i,x,y,MinX;
	local int	spacing,StartY;

	MenuStart(Canvas);
	
	DrawBackground(Canvas);
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	DrawTitle(Canvas);		// 220 Version

	TextMenuLeft(Canvas);

	// Draw Jazz Graphic
	// 
	y = (Canvas.ClipY - 60 + MenuExistTime*100);
	if (y<Canvas.ClipY)
	{
	Canvas.Style = 3;
	Canvas.SetPos(Canvas.SizeX-120,y);
	//Canvas.DrawIcon(Texture'JazzTitle3',0.25);	// Jazz3 Texture
	}
	
	MenuEnd(Canvas);
}

// Background
//
function DrawBackGround(canvas Canvas)
{
	DrawBackGroundA(Canvas);
}

defaultproperties
{
     MenuLength=4
}
