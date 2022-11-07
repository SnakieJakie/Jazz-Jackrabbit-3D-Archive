//=============================================================================
// JazzConBattleMode.
//=============================================================================
class JazzConBattleMode expands JazzConMenu;

function bool ProcessLeft()
{
	switch (Selection)
	{
	case 2:
		if (BattleMode(GameType).FluffLimit>0)
		BattleMode(GameType).FluffLimit--;
	break;
	
	case 3:
		if (BattleMode(GameType).TimeLimit>0)
		BattleMode(GameType).TimeLimit--;
	break;
	
	case 4:
		if (BattleMode(GameType).MaxPlayers>1)
		BattleMode(GameType).MaxPlayers--;
	break;
	
	case 5:
		if (BattleMode(GameType).InitialBots>0)
		BattleMode(GameType).InitialBots--;
	break;
	}
	
	return true;
} 

function bool ProcessRight()
{
	switch (Selection)
	{
	case 2:
		if (BattleMode(GameType).FluffLimit<100)
		BattleMode(GameType).FluffLimit++;
	break;
	
	case 3:
		if (BattleMode(GameType).TimeLimit<60)
		BattleMode(GameType).TimeLimit++;
	break;
	
	case 4:
		if (BattleMode(GameType).MaxPlayers<32)
		BattleMode(GameType).MaxPlayers++;
	break;
	
	case 5:
		if (BattleMode(GameType).InitialBots<32)
		BattleMode(GameType).InitialBots++;
	break;
	}
	
	return true;
}

function DrawMenu (canvas Canvas)
{
	local BattleMode DMGame;

	DMGame = BattleMode(GameType);

	MenuStart(Canvas);
	
	DrawBackgroundA(Canvas);

	TextMenuLeft(Canvas);
	
	MenuSelections[0] = "Normal";
	if (DMGame.FluffLimit==0)
	MenuSelections[1] = "NONE"; else MenuSelections[1] = string(DMGame.FluffLimit);
	if (DMGame.TimeLimit==0)
	MenuSelections[2] = "NONE"; else MenuSelections[2] = string(DMGame.TimeLimit)$" MIN";
	MenuSelections[3] = string(DMGame.MaxPlayers);
	MenuSelections[4] = string(DMGame.InitialBots);
	//if (DMGame.Weapon
	//MenuSelections[4] = DMGame.WeaponStay
	TextMenuSelections(Canvas);
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
	MenuEnd(Canvas);
}

defaultproperties
{
     GameClass=Class'JazzMultiPlayer.BattleMode'
     MenuLength=6
     MenuList(0)="GAME SPEED"
     MenuList(1)="FLUFF LIMIT"
     MenuList(2)="TIME LIMIT"
     MenuList(3)="MAX PLAYERS"
     MenuList(4)="NUM AI THINKERS"
     MenuList(5)="CONFIGURE AI THINKERS"
}
