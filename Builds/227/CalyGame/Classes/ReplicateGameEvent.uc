//=============================================================================
// ReplicateGameEvent.
//=============================================================================
class ReplicateGameEvent expands Triggers;

//
// This class is intended to operate only when the game level has started which it exists
// in.  It will destroy itself after the first check.
//
// It will perform a search on the active player and attempt to replicate the conditions
// which would have existed if the event had taken place.
//
// Note that this is a difficult concept and may not be capable of everything for some time.
//

//
// In other words, place a 'Triggers/ReplicateGameEvent' into your level for each event that 
// should be reconstructed.  Then set the classes to delete, actor tags to search for and 
// delete, and actor tags to trigger.  (A tag is in the 'event' parameters.  If you know how 
// to use triggers, which you should by now, this will make sense. ;)
//
// The list of events is stored in the player's variables and should be saved with him in 
// Unreal's save file.  This would have been necessary, anyway, for creating a game that 
// could be ported over to a limited-storage device such as a console system.
//
// Events are currently set only when you pick up an item.  As more work is done and ideas 
// are come up with, this can be expanded on in the future.  The important thing is that it
// works and should do what we need it to. ;)
//

//
// Setting Events:
//
// Events are set elsewhere by actors in a level - generally inventory items or triggers.
//
// - JazzItem
// JazzItem contains a variable JazzItem.PickupEventSet which sets a new event when picked
// up.
//
//

//
// Restrictions:
//
// Events can only replicate basic actions.  It will not store the level state.
// In some cases you might want to just have an inventory item like a key rather than
// something like an event.
//
// Events should be used for important objects and the like, however.  We do not have the
// luxury of infinite memory space for a console system.  So remember that items will appear
// in a level over and over again, meaning the player could get infinite of anything if
// it's lying around, accessable, and not deleted by an event.
//
// Events should be limited to 2 per level, however up to 4 should be considered a maximum.
// It is unknown how many events Unreal will allow the player to store and keep at this 
// point.
//
// EventName should be limited to 8 chars.  Unreal won't mind, but try to keep memory size
// down for whoever might have to store the data to a console system backup.
//
//

// Name of event
// Check with Player 'Events' array to see if the event has occurred.
//
var(GameEvent) name EventName;

// Trigger Tag
//
// Triggers all of these tags when event is replicated.
//
var(GameEvent) name	TriggerTags[3];

// Delete Tag
//
// Delete actors with this tag when event is replicated.
//
var(GameEvent) name	DestroyTags[3];

// Delete Tag
//
// Delete actors of this class when event is replicated.
//
var(GameEvent) class	DestroyClass[3];


//
// Player should call this in its TravelPostAccept function so we're assured the travel
// name variables necessary have been accepted.
//
function PerformCheck(bool EventDone)
{
	local byte T;
	local actor A;

	//Log("Replication) Successful "$EventName);
	
	// Ok, let's replicate!
	
	// Calling all triggers!
	for (t=0; t<3; t++)
		if( TriggerTags[t] != '' )
			foreach AllActors( class 'Actor', A, TriggerTags[t] )
				A.Trigger( Instigator, Instigator );

	// Deleting all objects tagged!
	for (t=0; t<3; t++)
		if( DestroyTags[t] != '' )
			foreach AllActors( class 'Actor', A, DestroyTags[t] )
				A.Destroy();

	// Deleting all objects with class!
	for (t=0; t<3; t++)
		if( DestroyClass[t] != None )
			foreach AllActors( class<actor>(DestroyClass[t]), A )
				A.Destroy();
				
	Destroy();
}

defaultproperties
{
     Texture=Texture'Engine.S_Dispatcher'
}
