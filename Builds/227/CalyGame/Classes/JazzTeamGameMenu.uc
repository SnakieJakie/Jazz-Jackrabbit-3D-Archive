//=============================================================================
// JazzTeamGameMenu.
//=============================================================================
class JazzTeamGameMenu expands JazzMenu;

var int MenuRightSide;

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if ( Selection == 1 )
		ChildMenu = spawn(class'JazzTeamSelectMenu', owner);
	else if ( Selection == 2 )
		ChildMenu = spawn(class'JazzNewGameMenu', owner);
	else if ( Selection == 3 )
		ChildMenu = spawn(class'JazzOptions2Menu', owner);
	else	
		ChildMenu = spawn(class'JazzQuitMenu', owner);

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
	
	MenuRightSide = Canvas.SizeX;
	
	DrawBackgroundARight(Canvas);

	TextMenuRight(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
     MenuLength=4
}
