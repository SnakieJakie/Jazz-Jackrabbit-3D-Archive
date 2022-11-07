//=============================================================================
// JazzWaterZone.
//=============================================================================
class JazzWaterZone expands ZoneInfo;

defaultproperties
{
     ZoneGravity=(Z=15.000000)
     EntrySound=Sound'UnrealShare.Generic.DSplash'
     ExitSound=Sound'UnrealShare.Generic.WtrExit1'
     EntryActor=Class'UnrealShare.WaterImpact'
     ExitActor=Class'UnrealShare.WaterImpact'
     bWaterZone=True
}
