//=============================================================================
// HUD: Superclass of the heads-up display.
//=============================================================================
class HUD expands Actor
	abstract
	intrinsic;

//=============================================================================
// Variables.

var globalconfig int HudMode;	
var globalconfig int Crosshair;
var() class<menu> MainMenuType;
var	Menu MainMenu;

//=============================================================================
// Status drawing.

simulated event PreRender( canvas Canvas );
simulated event PostRender( canvas Canvas );

simulated event RenderOverlays( canvas Canvas )
{
	local Pawn P;

	// Have the owner's weapon draw its first person view
	P = Pawn(Owner);
	if ( (P != None) && (P.Weapon != None) )
		P.Weapon.RenderOverlays(Canvas);
}

simulated function InputNumber(byte F);
simulated function ChangeHud(int d);
simulated function ChangeCrosshair(int d);
simulated function DrawCrossHair( canvas Canvas, int StartX, int StartY);

simulated function PlayReceivedMessage(string[255] S, string[20] PName, ZoneInfo PZone)
{
	PlayerPawn(Owner).ClientMessage(S);
	PlayerPawn(Owner).PlayBeepSound();
}

// DisplayMessages is called by the Console in PostRender.
// It offers the HUD a chance to deal with messages instead of the
// Console.  Returns true if messages were dealt with.
simulated function bool DisplayMessages(canvas Canvas)
{
	return false;
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_SimulatedProxy
}
