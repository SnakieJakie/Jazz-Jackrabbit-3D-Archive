//=============================================================================
// JazzSaveMenu.
//=============================================================================
class JazzSaveMenu expands JazzLoadMenu;

function BeginPlay()
{
	local int i;

	Super.BeginPlay();
	For (i=0; i<9; i++ )
		if (SlotNames[i] ~= "..Empty.." )
		{
			Selection = i + 1;
			break;
		}
}

function bool ProcessSelection()
{
	if ( PlayerOwner.Health <= 0 )
		return true;

	if (MenuNumReady<10)
	{

	if ( Level.Minute < 10 )
		SlotNames[Selection - 1] = (Level.Title$" "$Level.Hour$"\:0"$Level.Minute$" "$MonthNames[Level.Month - 1]$" "$Level.Day);
	else
		SlotNames[Selection - 1] = (Level.Title$" "$Level.Hour$"\:"$Level.Minute$" "$MonthNames[Level.Month - 1]$" "$Level.Day);

	if ( Level.NetMode != NM_Standalone )
		SlotNames[Selection - 1] = "Net:"$SlotNames[Selection - 1];
	SaveConfig();
	bExitAllMenus = true;
	PlayerOwner.ClientMessage(" ");
	PlayerOwner.bDelayedCommand = true;
	PlayerOwner.DelayedCommand = "SaveGame "$(Selection - 1);
	return true;
	}
	return false;
}

function DrawSlots(canvas Canvas)
{
	local int StartX, StartY, Spacing, i;
	local float XPos;
			
	Spacing = Clamp(0.05 * Canvas.ClipY, 12, 32);
	StartX = Max(20, 0.5 * (Canvas.ClipX - 206));
	StartY = Max(40, 0.5 * (Canvas.ClipY - MenuLength * Spacing-40));
	FontMenuMedium(Canvas);
	//Canvas.Font = Canvas.MedFont;

	For ( i=1; i<10; i++ )
	{
		if (i%2 == 0)
		{
			XPos = ((MenuExistTime-(float(i)*0.05))*500)-1000;
			if (XPos>StartX) 
			{
				XPos = StartX;
				if (MenuNumReady<i) 
				{
				MenuNumReady=i;
				JazzModifySound();
				}
			}
		}
		else
		{
			XPos = 1000-((MenuExistTime-(float(i)*0.05))*500);
			if (XPos<StartX) 
			{
				XPos = StartX;
				if (MenuNumReady<i) 
				{
				MenuNumReady=i;
				JazzModifySound();
				}
			}
		}
		
		SetFontBrightness(Canvas, (i == Selection) );
		Canvas.SetPos(XPos, StartY + i * Spacing - ((XPos-StartX)/50) );
		Canvas.bCenter = false;
		
		if (i>0)
		{
		Canvas.DrawText(SlotNames[i-1], False);
		}
	}
}

defaultproperties
{
}
