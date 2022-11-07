//=============================================================================
// MusicTouchEvent.
//=============================================================================
class MusicTouchEvent expands MusicEvent;

function Touch( actor Other )
{
	local PlayerPawn P;

	P = PlayerPawn(Other);
		
	if (P.SongSection != SongSection)
	{
		Trigger(Other,Pawn(Other));
	}
}

defaultproperties
{
     bAffectAllPlayers=False
}
