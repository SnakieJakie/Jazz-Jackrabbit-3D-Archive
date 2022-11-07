//=============================================================================
// JazzTeleportEvent.
//=============================================================================
class JazzTeleportEvent expands Teleporter;

//
// This class initiates a teleport sequence by fading out the music and triggering the linked teleporter.
//
//

// Redo touch function
//
function Touch( actor Other )
{
	local Teleporter Dest;
	local int i;
	local Actor A;
	
	if (PlayerPawn(Other) != None)
	{
		// If not local and not without teleport destination
		//
		if( (InStr( URL, "/" ) >= 0) || (InStr( URL, "#" ) >= 0) )
		{
		PlayerPawn(Other).Transition = MTRAN_SlowFade;
		PlayerPawn(Other).Transition = MTRAN_Fade;
		}
	}

	if ( !bEnabled )
		return;

	if( Other.bCanTeleport && Other.PreTeleport(Self)==false )
	{
		if( (InStr( URL, "/" ) >= 0) || (InStr( URL, "#" ) >= 0) )
		{
			// Teleport to a level on the net.
			if( PlayerPawn(Other) != None )
			{
				Log("JazzTeleporter) Touch "$URL);
				Level.Game.SendPlayer(PlayerPawn(Other), URL);
			}
		}
		else
		{
			// Teleport to a random teleporter in this local level, if more than one pick random.
			foreach AllActors( class 'Teleporter', Dest )
				if( string(Dest.tag)~=URL && Dest!=Self )
					i++;
			i = rand(i);
			foreach AllActors( class 'Teleporter', Dest )
				if( string(Dest.tag)~=URL && Dest!=Self && i-- == 0 )
					break;
			if( Dest != None )
			{
				// Teleport the actor into the other teleporter.
				if ( Other.IsA('Pawn') )
					PlayTeleportEffect( Pawn(Other), false);
				Dest.Accept( Other );
				if( (Event != '') && (Other.IsA('Pawn')) )
					foreach AllActors( class 'Actor', A, Event )
						A.Trigger( Other, Other.Instigator );
			}
			else Pawn(Other).ClientMessage( "Teleport destination not found!" );
		}
	}
}

defaultproperties
{
}
