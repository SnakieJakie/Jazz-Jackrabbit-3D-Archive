//=============================================================================
// VoicePack.
//=============================================================================
class VoicePack expands Info
	abstract;
	
/*
(exec function to do ServerVoiceMessage, and use in OrdersMenu)
(voicepack configuration for players and bots)
*/

/* 
Initialize() sets up playing the appropriate voice segment, and returns a string
 representation of the message
*/
function Initialize(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageIndex, Actor Location);
function ClientInitialize(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageIndex, Actor Location);
function PlayerSpeech(int Type, int Index, int Callsign);
	

defaultproperties
{
     RemoteRole=ROLE_None
     LifeSpan=10.000000
}
