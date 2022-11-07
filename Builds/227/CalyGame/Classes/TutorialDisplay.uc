//=============================================================================
// TutorialDisplay.
//=============================================================================
class TutorialDisplay expands Triggers;

////////////
// This class is intended to display a tutorial message window on the player's screen when triggered.
//////
//
//  This is a stand-alone tutorial extension to the tutorial master system.
//
//  The tutorial text should be stored in the Tutorial variable.  Currently only one line
//  is supported, but that will change in the future if we need it.  The 'ParagraphNum' value
//  may be used in the future.  Just leave it at 0 for now.
//
//  Place the tutorial text anywhere in a level and have a trigger of whatever type you
//  like activate it.
//
//

var() string	TutorialName;
//var() int			ParagraphNum;
var() string	Tutorial[2];	// It is suggested to keep the # of paragraphs very low.

//
//
function Trigger ( actor Other, pawn EventInstigator )
{
	if (JazzPlayer(EventInstigator) != None)
	{
		DoTutorial( JazzPlayer(EventInstigator) );
	}
}

//
//
function DoTutorial ( JazzPlayer Player )
{
	Player.NewTutorial(Tutorial[0],"Scripted Tutorial",false);
	//Player.TutorialWindow.DoTutorial(Player,Self);
}

function string	GetLine ( int TutorialNum, int LineNum )
{
	return (Tutorial[LineNum]);
}

defaultproperties
{
     Texture=Texture'Engine.S_Ambient'
}
