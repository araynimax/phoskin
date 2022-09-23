#include "./globals.sp"
#include "./enums.sp"
#include "./helpers.sp"
#include "./commands.sp"
#include "./generator.sp"
#include "./hooks.sp"

public void OnPluginStart()
{
	// Load ConVars
	g_cvEnabled         = CreateConVar("sm_phoskin_enabled", "1", "Enable/disable phoskin globally", true, 0, true, 1);
	g_cvDisableSpawn    = CreateConVar("sm_phoskin_disable_spawn", "0", "if enabled only exiting weapons can be edited", true, 0, true, 1);
	g_cvTimeoutDuration = CreateConVar("sm_phoskin_timeout_duration", "0", "how long a player has to wait to generate a new weapon after generating a weapon from a inspect url", true, 0);

	// Commands
	RegConsoleCmd("sm_pho", Command_Pho, "Type sm_pho help for a list of commands");
	RegConsoleCmd("sm_gen", Command_Gen, "Alias for sm_pho gen");
	RegConsoleCmd("sm_gengl", Command_Gen, "Alias for sm_pho gen");

	RegConsoleCmd("sm_test", Command_Test);

    AddCommandListener(ChatListener, "say");
	AddCommandListener(ChatListener, "say2");
	AddCommandListener(ChatListener, "say_team");

    // Hooks
	PTaH(PTaH_GiveNamedItemPre, Hook, GiveNamedItemPre);
	PTaH(PTaH_GiveNamedItemPost, Hook, GiveNamedItemPost);
}

public Action Command_Test(int client, int args)
{


    return;

    static bool tgl = false;
    static int seed = 10;

    SStickerData stickers[MAX_STICKER_SLOTS];
   
    if(tgl) {
        Pho_Generate(client,4725, 10086, 740, 0.1, stickers);
    } else {
        Pho_Generate(client,5031, 10042, seed, 0.7, stickers);
        seed+=10;
    } 
    
    return;
	int activeWeapon = Pho_Gloves_PrepareForEdit(client);

	int oldGloves = GetEntPropEnt(client, Prop_Send, "m_hMyWearables");
	if (oldGloves != -1)
	{
        //5031 10042 740
        //4725 10086 740
		SetEntProp(oldGloves, Prop_Send, "m_iItemDefinitionIndex", 5031);
		SetEntProp(oldGloves, Prop_Send, "m_nFallbackPaintKit", 10042);
		SetEntProp(oldGloves, Prop_Send, "m_nFallbackSeed", 187);
		SetEntPropFloat(oldGloves, Prop_Send, "m_flFallbackWear", 0.062019042670726776);
		//		AcceptEntityInput(oldGloves, "KillHierarchy");
	}

	Pho_Gloves_Refresh(client, activeWeapon);
	return;

	int newGloves = CreateEntityByName("wearable_item");

	if (newGloves == -1)
	{
		PrintToChat(client, " \x01\x0B\x07Error: Could not spawn gloves!");
		return;
	}
	SetEntProp(newGloves, Prop_Send, "m_iItemIDLow", -1);
    SetEntProp(newGloves, Prop_Send, "m_iItemIDHigh", -1);
	SetEntProp(newGloves, Prop_Send, "m_iItemDefinitionIndex", 4725);
	SetEntProp(newGloves, Prop_Send, "m_nFallbackPaintKit", 10086);
	SetEntProp(newGloves, Prop_Send, "m_nFallbackSeed", 740);
	SetEntPropFloat(newGloves, Prop_Send, "m_flFallbackWear", 0.062019042670726776);
	SetEntPropEnt(newGloves, Prop_Data, "m_hOwnerEntity", client);
	SetEntPropEnt(newGloves, Prop_Data, "m_hParent", client);
	SetEntPropEnt(newGloves, Prop_Data, "m_hMoveParent", client);
	SetEntProp(newGloves, Prop_Send, "m_bInitialized", 1);
	DispatchSpawn(newGloves);

	SetEntPropEnt(client, Prop_Send, "m_hMyWearables", newGloves);
	SetEntProp(client, Prop_Send, "m_nBody", 1);
}



public void Test(int client, int args)
{	
	PrintToChat(client, "TEST");



	int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(item == -1 || GetEntProp(item, Prop_Send, "m_iItemDefinitionIndex") != 35) {
		item = GivePlayerItem(client, "weapon_nova");
	}
	//SetEntProp(item, Prop_Send, "m_iItemIDLow", -1);          
	SetEntProp(item, Prop_Send, "m_iItemIDHigh", -1);
	SetEntProp(item, Prop_Send, "m_iEntityQuality", 0);

	static int paintindex = 1;
	SetEntProp(item, Prop_Send, "m_nFallbackPaintKit", paintindex++);

	
	static int c = -1;
	char name[] = "Name 000";

	Format(name, sizeof(name),"Name %i", c);

	SetEntDataString(item, FindSendPropInfo("CBaseAttributableItem", "m_szCustomName"), name, sizeof(name));

	CEconItemView pEconItemView = PTaH_GetEconItemViewFromEconEntity(item);
	CAttributeList attributeList = pEconItemView.NetworkedDynamicAttributesForDemos;

    for(int i = 110; i<150; i+=2) {
	    attributeList.SetOrAddAttributeValue(i, 5339);
	    attributeList.SetOrAddAttributeValue(i+1, 0);
    }
	// attributeList.SetOrAddAttributeValue(118, 0);
	// attributeList.SetOrAddAttributeValue(121, 5339 + c);
	// attributeList.SetOrAddAttributeValue(122, 0);
	// attributeList.SetOrAddAttributeValue(125, 5339 + c);
	// attributeList.SetOrAddAttributeValue(126, 0);
	// attributeList.SetOrAddAttributeValue(129, 5339 + c);
	// attributeList.SetOrAddAttributeValue(130, 0);
	// attributeList.SetOrAddAttributeValue(133, 5339 + c);
	// attributeList.SetOrAddAttributeValue(134, 0);
	// attributeList.SetOrAddAttributeValue(133, 5339 + c);
	// attributeList.SetOrAddAttributeValue(134, 0);
	
	// to override equipped stattrak

	attributeList.SetOrAddAttributeValue(80, c); // stattrak
	attributeList.SetOrAddAttributeValue(81, 0);  // stattrack type

	c++;


	PTaH_ForceFullUpdate(client);


	// if(!newItem) {
	// 	PrintToChat(client, "ZERO");
	// }
}