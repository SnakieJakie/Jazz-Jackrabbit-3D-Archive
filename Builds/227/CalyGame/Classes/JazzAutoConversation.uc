//=============================================================================
// JazzAutoConversation.
//=============================================================================
class JazzAutoConversation expands JazzConversation;

// Destroy Conversation When Done
//
function PostBeginPlay()
{
	DestroyConversationWhenDone = true;
}

defaultproperties
{
}
