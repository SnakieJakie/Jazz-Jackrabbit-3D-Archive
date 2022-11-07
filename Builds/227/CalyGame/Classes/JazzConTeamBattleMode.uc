//=============================================================================
// JazzConTeamBattleMode.
//=============================================================================
class JazzConTeamBattleMode expands JazzConMenu;

function bool ProcessLeft()
{
	switch (Selection)
	{
	case 4:
		if (BattleMode(GameType).FluffLimit>0)
		BattleMode(GameType).FluffLimit--;
	break;
	
	case 5:
		if (BattleMode(GameType).TimeLimit>0)
		BattleMode(GameType).TimeLimit--;
	break;
	
	case 6:
		if (BattleMode(GameType).MaxPlayers>1)
		BattleMode(GameType).MaxPlayers--;
	break;
	
	case 7:
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
	case 4:
		if (BattleMode(GameType).FluffLimit<100)
		BattleMode(GameType).FluffLimit++;
	break;
	
	case 5:
		if (BattleMode(GameType).TimeLimit<60)
		BattleMode(GameType).TimeLimit++;
	break;
	
	case 6:
		if (BattleMode(GameType).MaxPlayers<32)
		BattleMode(GameType).MaxPlayers++;
	break;
	
	case 7:
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
	
	MenuSelections[0] = "2";
	
	MenuSelections[2] = "Normal";
	if (DMGame.FluffLimit==0)
	MenuSelections[3] = "NONE"; else MenuSelections[3] = string(DMGame.FluffLimit);
	if (DMGame.TimeLimit==0)
	MenuSelections[4] = "NONE"; else MenuSelections[4] = string(DMGame.TimeLimit)$" MIN";
	MenuSelections[5] = string(DMGame.MaxPlayers);
	MenuSelections[6] = string(DMGame.InitialBots);
	//if (DMGame.Weapon
	//MenuSelections[4] = DMGame.WeaponStay
	TextMenuSelections(Canvas);
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
	MenuEnd(Canvas);
}

defaultproperties
{
     GameClass=Class'CalyGame.TeamBattleMode'
     MenuLength=8
}
