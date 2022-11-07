//=============================================================================
// JazzScoreBoard.
//=============================================================================
class JazzScoreBoard expands ScoreBoard;

//
// Parent class to use base scoreboard display routines to make future
// scoreboards more modular and easy to code.
//
// Also, base font routines are here for quick transition when new fonts are added and to
// adapt to different screen sizes and types.
//

//
// Tx - Ty 	- Texture X/Y Size
// TScale 	- Texture Scale
// AvailX	- Available X size
// AvailY	- Available Y size
// Ox - Oy	- Result Offset X/Y
//

var () font SFont;
var () font SSFont;
var () font SSSSFont;
var () font LFont;
var () texture HudMisc;
var () texture HudMiscT;

function ScaleIt ( int x, int y, int AvailX, int AvailY, canvas Canvas, Texture T )
{
	local float	TScale;
	local float	Tx,Ty;
	
	Tx = T.USize;
	Ty = T.VSize;
	
	TScale = 1;
	
	while ((TScale >= 0.1) && ((Tx>AvailX) || (Ty>AvailY)))
	{
		Tx *= 0.5;
		Ty *= 0.5;
		TScale *= 0.5;
	}
	
	Canvas.SetPos( x+(AvailX-Tx)/2 , y+(AvailY-Ty)/2 );
	Canvas.DrawTile(T,Tx,Ty,0,0,T.USize,T.VSize);
}

// Miscellaneous object (Item)
//
function MiscObjectDispIn	( canvas Canvas, float X, float Y, float Item, texture T, string Line1, string Line2, optional string Line3 )
{
	// Todo:  Scale the texture dynamically.
	local float ScaleX,ScaleY;
	local float Xi,Yi;

	Y = Y + Canvas.SizeY*(0.06*Item+0.005);
	X = X + Canvas.SizeX*0.01;
		
//function ScaleIt ( int x, int y, int AvailX, int AvailY, canvas Canvas, Texture T )
	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

	if (T != None)
	ScaleIt(X-Canvas.SizeX*0.005,Y-Canvas.SizeX*0.005,Canvas.SizeX*0.07,Canvas.SizeY*0.07,Canvas,T);
	else
	if (Line3 != "")
	{
		//Log("JazzScoreBoard) "$Line3);
		if (Canvas.SizeY >= 600)
		Canvas.Font = SFont;
		else
		if (Canvas.SizeY >= 400)
		Canvas.Font = SSFont;
		else
		Canvas.Font = SSSSFont;
	
		Canvas.SetPos(X,Y);
		Canvas.DrawText(Line3);
	}
	
	
/*	Xi = Canvas.SizeX*0.08;
	Yi = Canvas.SizeY*0.08;
	
	ScaleX = Xi / T.USize;
	ScaleY = Yi / T.VSize;
	
	if (ScaleX>ScaleY) ScaleX = ScaleY;
	
	if (ScaleX > 1) ScaleX = 1;
	else
	if (ScaleX > 0.5) ScaleX = 0.5;
	else
	if (ScaleX > 0.25) ScaleX = 0.25;	
	
	Canvas.SetPos(X,Y);
	Canvas.Style = 2;
	Canvas.DrawIcon( T, ScaleX );*/
	
	//Log("MiscObjectDisplay) SizeX:"$Canvas.SizeX);
	if (Canvas.SizeY >= 600)
	Canvas.Font = SSFont;
	else
	if (Canvas.SizeY >= 400)
	Canvas.Font = SSSSFont;
	else
	Canvas.Font = Canvas.SmallFont;
	
	Canvas.SetPos(X+Canvas.SizeX*0.055,Y+Canvas.SizeY*0.000);
	Canvas.DrawText(Line1);
	
	// Line 2 is not displayed when not enough room to display.
	if (Canvas.SizeY >= 199)
	{
	SetFontBrightness(Canvas,False);
	if (Canvas.SizeY >= 400)
	Canvas.Font = Canvas.MedFont;
	else
	Canvas.Font = Canvas.SmallFont;
	
	Canvas.SetPos(X+Canvas.SizeX*0.055,Y+Canvas.SizeY*0.025);
	Canvas.DrawText(Line2);
	}
}

// Miscellaneous object shaded bar
//
function MiscObjectDisplay	( canvas Canvas, float X, float Y, int Items, float Width )
{
	local texture T;
	local float Scale;

	Canvas.SetPos(X,Y);
	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	T = HudMisc;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*Width, Canvas.SizeY*0.06*Items, 0, 0, T.USize, T.VSize );
	
	Canvas.SetPos(X,Y);
	Canvas.Style = 3;
	T = HudMiscT;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*Width, Canvas.SizeY*0.06*Items, 0, 0, T.USize, T.VSize );
	
	Canvas.Style = 2;
}

// Font Functions
//
function SetFontBrightness(canvas Canvas, bool bBright)
{
	if ( bBright )
	{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
	else 
	{
		Canvas.DrawColor.R = 55;
		Canvas.DrawColor.G = 160;
		Canvas.DrawColor.B = 55;
	}
}

function LargeFont ( canvas Canvas )
{
	if (Canvas.ClipY>384)
		Canvas.Font = LFont;
		else
		Canvas.Font = SFont;
}

function SmallFont ( canvas Canvas )
{
	if (Canvas.ClipY>384)
		Canvas.Font=SFont;
		else
		Canvas.Font = SSFont;
}

// General function to return a string based on an integer with the correct # of digits (0s on front)
//
function string Digits ( int Value, int Digit )
{
	local string S;
	
	S = string(Value);

	if (InStr(S,"-")>=0)
	{
	S = Mid(S,1,9999);
	while (Len(S)<Digit-1)	S = "0"$S;
	S = "-"$S;
	}
	else
	while (Len(S)<Digit)	S = "0"$S;
	
	return S;
}

defaultproperties
{
    SFont=Texture'JazzFonts.SFont'
    SSFont=Texture'JazzFonts.SSFont'
    SSSSFont=Texture'JazzFonts.SSSSFont'
    LFont=Texture'JazzFonts.LFont'
    HudMisc=Texture'JazzArt.HudMisc'
    HudMiscT=Texture'JazzArt.HudMicT'
}
