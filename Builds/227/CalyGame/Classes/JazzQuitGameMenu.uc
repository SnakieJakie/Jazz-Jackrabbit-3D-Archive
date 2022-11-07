//=============================================================================
// JazzQuitGameMenu.
//=============================================================================
class JazzQuitGameMenu expands JazzMenu;

var() localized string TitleMap;
var string StartMap;

var bool YesNo;
var bool bResponse;
var float StartX;

var()	texture	Thumbup;
var()	texture	Thumbd;

function bool ProcessYes()
{
	if (YesNo)
	bResponse = true;
	return true;
}

function bool ProcessNo()
{
	if (YesNo)
	bResponse = false;
	return true;
}

function bool ProcessLeft()
{
	if (YesNo)
	bResponse = !bResponse;
	return true;
}

function bool ProcessRight()
{
	if (YesNo)
	bResponse = !bResponse;
	return true;
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

	if (YesNo)
	{
		if (bResponse)
		{
			if ( Selection == 2 )
			{
				// Load Starting Map
				bExitAllMenus = true;
				
				// 220 Version
				StartMap = TitleMap
							$"?Name="$PlayerOwner.PlayerReplicationInfo.PlayerName
							$"?Team="$PlayerOwner.PlayerReplicationInfo.TeamName
							$"?Rate="$PlayerOwner.NetSpeed;
		
				Log("StartMap) "$StartMap);
		
				SaveConfigs();
				PlayerOwner.ClientTravel(StartMap, TRAVEL_Absolute, false);			
			}
			else
			{
				// Quit Game to Windows
				PlayerOwner.SaveConfig();
				if ( Level.Game != None )
					Level.Game.SaveConfig();
				PlayerOwner.ConsoleCommand("Exit");
			}
		}
		else
		{
		 YesNo = false;
		}
	}
	else
	{
		if ( Selection == 1)
			ExitMenu();
		else if ( Selection == 2 )
		{
			YesNo = true;
			bResponse = false;
		}
		else
		{
			YesNo = true;
			bResponse = false;
		}
	}

	if ( ChildMenu != None )
	{
		// Reset Menu Movement in preparation for return to this menu
		PostBeginPlay();
	
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}

function DrawMenu (canvas Canvas)
{
	local int	i,x,y,MinX;
	local int	spacing,StartY;
	
	MenuStart(Canvas);
	
	DrawTitle(Canvas);
	
	DrawBackgroundACenter(Canvas);

	TextMenuCenter(Canvas);

	// Draw Jazz Graphic
	// 
	y = (Canvas.ClipY - MenuExistTime*100);
	if (y<Canvas.ClipY-80)
		y = Canvas.ClipY-80;
	Canvas.Style = 3;
	Canvas.SetPos(Canvas.SizeX-120,y);
	//Canvas.DrawIcon(Texture'JazzTitle3',0.25);	// Jazz3 Texture
	
	if (YesNo)
	{
		DrawYesNo(Canvas);
	}
	
	MenuEnd(Canvas);
}


function DrawYesNo ( canvas Canvas )
{
	local texture Thumb;
	local float Scale;
	local float StartY;

	if (Canvas.SizeX>=800)
		Scale = 1.0;
		else
	if (Canvas.Sizex>=600)
		Scale = 0.5;
		else
		Scale = 0.25;
		
	if (bResponse)
		Thumb = Thumbup;
		else
		Thumb = Thumbd;
		
	Canvas.Style = 3;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.SetPos(Canvas.SizeX*0.5 - (Thumb.USize * Scale / 2),Canvas.SizeY*0.6);
	Canvas.DrawIcon(Thumb,Scale);
	
	Canvas.Style = 2;
	// Yes/No Selection Text
	FontMenuMedium(Canvas);
	SetFontBrightness(Canvas, true);
	
	StartY = Canvas.ClipY+100-500*MenuExistTime;
	if (StartY<Canvas.ClipY*0.9) StartY=Canvas.ClipY*0.9;
	
	StartX = Canvas.SizeX*0.5 - 70;
	Canvas.SetPos(StartX, StartY );
	Canvas.DrawText("QUIT?", False);
	Canvas.SetPos(StartX + 100, StartY);
	if ( bResponse )
		Canvas.DrawText("YES", False);
	else
		Canvas.DrawText("NO", False);
	Canvas.DrawColor = Canvas.Default.DrawColor;
}


// Menu Input
//
function MenuProcessInput( byte KeyNum, byte ActionNum )
{
	if (bMenuReadyForInput)
	{
		if ( KeyNum == EInputKey.IK_Escape )
		{
			if (YesNo==false)
			{
			JazzEnterSound();
			ExitMenu();
			return;
			}
			else
			YesNo=false;
		}	
	
		if ( KeyNum == EInputKey.IK_Up )
		{
			if (YesNo==false)
			{
			JazzSelectSound();
			Selection--;
			if ( Selection < 1 )
				Selection = MenuLength;
			}
		}
		else if ( KeyNum == EInputKey.IK_Down )
		{
			if (YesNo==false)
			{
			JazzSelectSound();
			Selection++;
			if ( Selection > MenuLength )
				Selection = 1;
			}
		}
		else if ( KeyNum == EInputKey.IK_Enter )
		{
			bConfigChanged=true;
			if ( ProcessSelection() )
				JazzEnterSound();
		}
		else if ( KeyNum == EInputKey.IK_Left )
		{
			bConfigChanged=true;
			if ( ProcessLeft() )
				JazzModifySound();
		}
		else if ( KeyNum == EInputKey.IK_Right )
		{
			bConfigChanged=true;
			if ( ProcessRight() )
				JazzModifySound();
		}
		else if ( KeyNum == EInputKey.IK_Y )
		{
			bConfigChanged=true;
			if ( ProcessYes() )
				JazzModifySound();
		}
		else if ( KeyNum == EInputKey.IK_N )
		{
			bConfigChanged=true;
			if ( ProcessNo() )
				JazzModifySound();
		}
	}

	if ( bExitAllMenus )
		ExitAllMenus(); 
}

defaultproperties
{
     MenuLength=3
     Thumbup=Texture'JazzArt.Thumbup'
     Thumbd=Texture'JazzArt.Thumbd'
}
