//=============================================================================
// SavedMove is used during network play to buffer recent client moves,
// for use when the server modifies the clients actual position, etc.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class SavedMove expands Info;

// also stores info in Acceleration attribute
var SavedMove NextMove;		// Next move in linked list.
var float TimeStamp;		// Time of this move.
var float Delta;			// Distance moved.
var bool	bRun;
var bool	bDuck;
var bool	bPressedJump;
var EDodgeDir DodgeMove;	// Dodge info.
var bool	bSent;			// Whether sent.

final function Clear()
{
	TimeStamp = 0;
	Delta = 0;
	bSent = false;
	DodgeMove = DODGE_None;
	Acceleration = vect(0,0,0);
}

defaultproperties
{
}
