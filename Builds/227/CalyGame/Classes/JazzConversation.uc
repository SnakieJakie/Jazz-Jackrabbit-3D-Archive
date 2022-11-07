//=============================================================================
// JazzConversation.
//=============================================================================
class JazzConversation expands Triggers;

// This actor contains the conversation text and commands necessary for each conversation in the 
// game.
//
// Place this actor somewhere in the level and activate it through a trigger command.
//

//
// How to use the JazzConversation.
//
// Each NPC (JazzPawnAI) contains a single variable currently called
// ConversationTag.  For lack of a more sophisticated conversation
// system (the sort of thing I do not code in when rushing through 
// lots of cool things like now) there is only one conversation that
// a character can have.
//
// Place this actor into your level (shown by a mouth icon) and
// change the Events/Tag property value to the tag name you want to
// use.  This tag should be the same as in the ConversationTag variable
// of the actor who uses this conversation.  It is kept separate so 
// multiple actors can use the same conversation text and to keep the .
// property window less complex.
//
// Now, you want to add in your conversation text.
//
// Basically, the JazzConversation actor has a sort of mini scripting
// system built into it.  This allows you to queue events and have them
// happen in order.
//
// Right now, all you can do is play sounds and display text.
//
// Conversation Properties
// 
// ConvEventNum - The number of events that are in the script.  The
// Conversation ends in the game when it reaches this event #.  So if
// you set it to 1 it will only go through the first ConvEvent.
// (Basically display one screen of tezt.)  Events are timed and
// have a delay which should be sufficient to read the text.
//
// ConvEvents contains a list of the events to choose from.  They're
// pretty self-explanatory.  It default to displaying text.
//
// ConvText contains the text each event # uses which is displayed to
// the screen.  Type your text in here.
//
// So, to get one screen of text that says 'I Love You' set:
//
// ConvEventNum = 1
// ConvEvents[0] = CONV_TextOnly
// ConvText[0] = "I Love You"
//
// And that should be it.  Additional variables exist, but not
// everything is implemented yet, of course.
//
// Enjoy!
//

enum EConversationEvent
{
	CONV_TextOnly,
	CONV_Sound,
	CONV_End
};

var(Conversation)	int				 	ConvEventNum;
var(Conversation)	EConversationEvent 	ConvEvents[20];
//var(Conversation)	float				DelayPrev[20];
var(Conversation)	float				TextTime[20];
var(Conversation)	sound				ConvSounds[20];
var(Conversation)	string			ConvText[20];

var(Conversation)	float				RadiusToStopConversation;
var					bool				DestroyConversationWhenDone;
var					bool				ConversationDone;

// ToDo: EventInstigator is the origin of the message.  Check distance from there
// when moving away is taken into account to end the conversation.
//
// Pass additional commands like animations back to the originating pawn to
// execute.
//

// Activate conversation when triggered
//
function Trigger( actor Other, pawn EventInstigator )
{
	if ((PlayerPawn(Other) != None) && (PlayerPawn(Other).myHUD != None))
	{
		// Tell the HUD to initiate this conversation.
		//
		JazzHUD(PlayerPawn(Other).myHUD).InitiateConversation(Self,EventInstigator);
	}
}

function int UpdateConversation(int CurEvent, pawn Jazz, bool FirstEventTime)
{
	switch(ConvEvents[CurEvent])
	{
		case CONV_Sound:
			PlaySound(ConvSounds[CurEvent]);
		break;
		
		case CONV_End:
			if (DestroyConversationWhenDone == true)
				ConversationDone = true;
			return(-1);
		break;
	}

	//JazzPlayer(Jazz).TextBox.AddText(ConvText[CurEvent],TextTime[CurEvent]);

	// Return -1 if conversation over
	// Return 1  if next event


	if (CurEvent >= ConvEventNum)
	{
		if (DestroyConversationWhenDone == true)
			ConversationDone = true;
		return(-1);
	}
	else
		return(1);
}

function string GetCurrentText(int CurEvent)
{
	return(ConvText[CurEvent]);
}

event Tick ( float DeltaTime )
{
	if (ConversationDone)
	{
		Destroy();
	}
}

defaultproperties
{
     Texture=Texture'JazzArt.Icons.Iconconv'
}
