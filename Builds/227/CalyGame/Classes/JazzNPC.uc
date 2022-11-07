//=============================================================================
// JazzNPC.
//=============================================================================
class JazzNPC expands JazzPawnAI;

//
// This is a class grouping for pawns which interact as NPCs, in other words talk
// to the player if activated and perform other NPC tasks.
//

defaultproperties
{
     AttitudeVsPlayer=ATT_Friendly
     WalkingSpeed=100.000000
     RushSpeed=250.000000
     FindFriendDesire=2
     WanderDesire=15
     WanderRange=1000.000000
     WaitingDesire=10
     Activateable=True
     EnergyDamage=0.000000
     FireDamage=0.000000
     WaterDamage=0.000000
     SoundDamage=0.000000
     SharpPhysicalDamage=0.000000
     BluntPhysicalDamage=0.000000
     RotationRate=(Pitch=4096)
}
