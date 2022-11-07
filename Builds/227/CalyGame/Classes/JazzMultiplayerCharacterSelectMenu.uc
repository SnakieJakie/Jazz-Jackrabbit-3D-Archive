//=============================================================================
// JazzMultiplayerCharacterSelectMenu.
//=============================================================================
class JazzMultiplayerCharacterSelectMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var		int		MenuRightSide;

var	globalconfig	int		ClassSelect;
var	globalconfig	int		SkinSelect;

var string 	ClassString;
var string StartMapInit;
var string StartMap;
var string 	PreferredSkin;

var float SpinRotationOffset;

var() localized int			PlayerClassNum;
var() localized string 	PlayerClasses[8];

var() localized string	PlayerClassName[8];
var() localized int			PlayerSkins1;
var() localized string	PlayerSkinsClass1[10];
var() localized int			PlayerSkins2;
var() localized string	PlayerSkinsClass2[10];
var() localized int			PlayerSkins3;
var() localized string	PlayerSkinsClass3[10];
var() localized int			PlayerSkins4;
var() localized string	PlayerSkinsClass4[10];
var() localized int			PlayerSkins5;
var() localized string	PlayerSkinsClass5[10];
var() localized int			PlayerSkins6;
var() localized string	PlayerSkinsClass6[10];
var() localized int			PlayerSkins7;
var() localized string	PlayerSkinsClass7[10];
var() localized int			PlayerSkins8;
var() localized string	PlayerSkinsClass8[10];

var() mesh Jazz;

// Currently assume initial values are defaults
//
function PreBeginPlay()
{
	ChangeMesh();

	ResetMenu();
}

function FindSkin(int Dir)
{
	local string SkinName;
	local string MeshName;
	local string SkinNm, SkinDesc;
	local texture NewSkin;
	local int pos;

	MeshName = GetItemName(String(Mesh));
	SkinName = string(Skin);
	if ( Left(SkinName, Len(MeshName)) != MeshName )
		SkinName = MeshName$GetItemName(SkinName);
	GetNextSkin(MeshName, SkinName, Dir, SkinNm, SkinDesc);
	SkinName = SkinNm;
	if ( SkinName != "" )
	{
		NewSkin = texture(DynamicLoadObject(SkinName, class'Texture'));
		if ( NewSkin != None )
			Skin = NewSkin;
	}
	
	PreferredSkin = String(Skin);
}
	
function ResetMenu()
{
	// Plays sounds as menus move across the screen
	MenuSoundNum = 0;
	MenuExistTime = 0;
	mesh = Jazz;
	FindSkin(0);	
}

function SaveConfigs()
{
	SaveConfig();
}


function bool ProcessLeft()
{
	switch (Selection)
	{
	case 1:
		if (ClassSelect>1) ClassSelect--; else ClassSelect=PlayerClassNum;
	break;
	
	case 2:
		FindSkin(-1);
	break;
	}

	ChangeMesh();
	
	return true;
} 

function bool ProcessRight()
{
	switch (Selection)
	{
	case 1:
		if (ClassSelect<PlayerClassNum) ClassSelect++; else ClassSelect=1;
	break;
	
	case 2:
		FindSkin(1);
	break;
	}

	ChangeMesh();

	return true;
}

function string SkinText ( int SelNum )
{
	if (SelNum>SkinNum())
	return(NoneText);
	else
	{
		switch (ClassSelect)
		{
		case 1:
		return(PlayerSkinsClass1[SelNum]);
		break;
		}
	}
}

function int SkinNum ( )
{
	switch (ClassSelect)
	{
	case 1:
	return(PlayerSkins1);
	break;
	}
}

function Menu ExitMenu()
{
	BuildStartMap();
				
	Super.ExitMenu();
}

function BuildStartMap()
{
	// 220 Version
	StartMap = StartMap
				$"?Class="$PlayerClasses[ClassSelect-1] 
				$"?Skin="$PreferredSkin
				$"?Name="$PlayerOwner.PlayerReplicationInfo.PlayerName		// 220 Version
				$"?Team="$PlayerOwner.PlayerReplicationInfo.TeamName
				$"?Rate="$PlayerOwner.NetSpeed;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;
	local int p;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if (Selection > 0)
	{
		bExitAllMenus = true;

		switch (Selection)
		{
		case 0:
		case 1:
			// Defaults		
			ClassString = "DudeGame.DudeJazz";
			break;
		}

		BuildStartMap();

		PlayerOwner.UpdateURL("Skin",PreferredSkin, true);		
		PlayerOwner.ServerChangeSkin(PreferredSkin,"",0);

		//Log("Character Select : "$ClassString);
		//Log("StartMap) "$StartMap);

		SaveConfigs();
		PlayerOwner.ClientTravel(StartMap, TRAVEL_Absolute, false);
		return true;
	}
	else
		return false;

	if ( ChildMenu != None )
	{
		// Reset Menu Movement in preparation for return to this menu
		ResetMenu();
	
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}

function class<PlayerPawn> ChangeMesh()
{ 
	local class<playerpawn> NewPlayerClass;
	local Texture Ab;

	NewPlayerClass = class<playerpawn>(DynamicLoadObject(PlayerClasses[PlayerClassNum-1], class'Class'));
	Ab = Texture(DynamicLoadObject(PreferredSkin, class'Texture'));

	if ( NewPlayerClass != None )
	{
		ClassString = PlayerClasses[PlayerClassNum];
		mesh = NewPlayerClass.Default.mesh;
		
		if (Ab != None)
		skin = Ab;
		else
		skin = NewPlayerClass.Default.skin;

		LoopAnim(NewPlayerClass.Default.AnimSequence,1.0);
		Log("Animation) "$NewPlayerClass.Default.AnimSequence$" "$Mesh$" "$AnimSequence$" "$AnimRate);
	}
	return NewPlayerClass;
}	

function AnimEnd()
{
}

function DrawMenu (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;
	local vector DrawOffset, DrawLoc;
	local rotator NewRot, DrawRot;

	MenuStart(Canvas);
	
	MenuRightSide = Canvas.SizeX;
	
	DrawBackgroundA(Canvas);

	DrawTitle(Canvas);	// 220 Version

	TextMenuLeft(Canvas);
	
/*	MenuSelections[0] = PlayerClassName[ClassSelect-1];
	MenuSelections[1] = SkinText(SkinSelect-1);
	
	TextMenuSelections(Canvas);*/
	
	if (ClassSelect<1) ClassSelect=1;
	if (ClassSelect>PlayerClassNum) ClassSelect=PlayerClassNum;
	if (SkinSelect<1) SkinSelect=1;
	if (SkinSelect>SkinNum()) SkinSelect=SkinNum();
	
	// Draw Mesh
	/*PlayerOwner.ViewRotation.Pitch = 0;
	PlayerOwner.ViewRotation.Roll = 0;
	DrawRot = PlayerOwner.ViewRotation;
	DrawOffset = ((vect(-50.0,0.0,0.0)) >> PlayerOwner.ViewRotation);
	DrawLoc = PlayerOwner.Location + PlayerOwner.EyeHeight * vect(0,0,1);*/
	
	PlayerOwner.ViewRotation.Pitch = 0;
	PlayerOwner.ViewRotation.Roll = 0;
	DrawRot = JazzPlayer(PlayerOwner).MyCameraRotation;
	DrawOffset = ((vect(100.0,20.0,25.0)) >> JazzPlayer(PlayerOwner).MyCameraRotation);
	DrawLoc = JazzPlayer(PlayerOwner).MyCameraLocation+ PlayerOwner.EyeHeight * vect(0,0,1);

	SetLocation(DrawLoc + DrawOffset);
	NewRot = DrawRot;
	NewRot.Yaw = PlayerOwner.Rotation.Yaw - 65536/2 + SpinRotationOffset;
	NewRot.Pitch = 2000;
	SetRotation(NewRot);
	Canvas.DrawActor(self, false);

	MenuEnd(Canvas);
}

event MenuTick (float DeltaTime)
{
	SpinRotationOffset += 5000*DeltaTime;
	Super.MenuTick(DeltaTime);
	
	AnimFrame += AnimRate*DeltaTime;
}

defaultproperties
{
     ClassSelect=1
     SkinSelect=6
     PlayerClassNum=1
     PlayerClasses(0)="DudeGame.DudeJazz"
     PlayerSkins1=5
     PlayerSkinsClass1(0)="JAZZ_BLUE_BB"
     PlayerSkinsClass1(1)="JAZZ_BLUE_GB"
     PlayerSkinsClass1(2)="JAZZ_BLUE_PB"
     PlayerSkinsClass1(3)="JAZZ_BLUE_RB"
     PlayerSkinsClass1(4)="JAZZ_BLUE_YB"
     MenuLength=3
     MenuTitle="SELECt CHARACTER"
     bTravel=True
     AnimSequence=Walk
     AnimRate=1.000000
     DrawType=DT_Mesh
     bOnlyOwnerSee=True
     Jazz=Mesh'Jazz3.Jazz'
}
