//=============================================================================
// JazzConTreasureHunt.
//=============================================================================
class JazzConTreasureHunt expands JazzMenu;

function DrawMenu (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;

	MenuStart(Canvas);
	
	DrawBackgroundA(Canvas);

	TextMenuLeft(Canvas);
	
	//MenuSelections[0] = Caps(GameTypeDisplay);
	//MenuSelections[1] = Caps(Map);
	TextMenuSelections(Canvas);
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
	MenuEnd(Canvas);
}

defaultproperties
{
     MenuLength=6
     MenuList(0)="GAME SPEED"
     MenuList(1)="DEFEAT LIMIT"
     MenuList(2)="TIME LIMIT"
     MenuList(3)="MAX PLAYERS"
     MenuList(4)="WEAPONS STAY"
     MenuList(5)="CONFIGURE AI THINKERS"
}
