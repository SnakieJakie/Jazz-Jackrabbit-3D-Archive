//=============================================================================
// HidePlayer.
//=============================================================================
class HidePlayer expands Triggers;

function Trigger( actor Other, pawn EventInstigator )
{
	Log("HidePlayer) "$EventInstigator);

	EventInstigator.bHidden = true;
}

defaultproperties
{
}
