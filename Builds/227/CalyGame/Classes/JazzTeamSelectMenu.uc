//=============================================================================
// JazzTeamSelectMenu.
//=============================================================================
class JazzTeamSelectMenu expands JazzMenu;

var		int		MenuRightSide;

var		int		TeamNum;
var JazzTeamInfo TeamInfoActor[32];

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	GenerateTeamList();
}

function GenerateTeamList()
{
	local JazzTeamInfo PRI;
	local int x;

	TeamNum=0;	
	foreach AllActors (class'JazzTeamInfo', PRI)
	{
		if ((PRI.TeamIndex>-1) && (PRI.TeamIndex<32))
		{
			TeamInfoActor[PRI.TeamIndex]=PRI;
			
			if (TeamNum<PRI.TeamIndex)
				TeamNum=PRI.TeamIndex;
		}
	}

	MenuLength = TeamNum+2;
	
	for (x=0; x<=TeamNum; x++)
	{
		MenuList[x]=Caps(TeamInfoActor[x].TeamName);
	}
	
	MenuList[MenuLength-1]="NO CHANGE";
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
	
	if ( Selection < MenuLength )
	{
		// Change to this team #
		Log("ChangeToTeam) "$Selection-1);
		PlayerOwner.ChangeTeam(Selection-1);
		ExitAllMenus();
	}
	else
	if ( Selection == MenuLength )
	{
		ExitMenu();
		return false;
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
	
	MenuRightSide = Canvas.SizeX;
	
	DrawBackgroundARight(Canvas);

	TextMenuRight(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
}
