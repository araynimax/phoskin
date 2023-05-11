void Pho_Generate(
	int			 client,
	int			 defIndex,
	int			 paintIndex,
	int			 paintSeed,
	float		 paintWear,
	SStickerData stickers[MAX_STICKER_SLOTS],
	int			 quality		= -1,
	bool		 stattrak		= false,
	int			 stattrackValue = 1337)
{
	ESlot slot = GetItemSlotFromDefIndex(defIndex);

	// check which type of item it is and call other methods if needed
	if (slot == ESlot_Primary || slot == ESlot_Secondary || slot == ESlot_Knife)
	{
		int weapon = Pho_Weapon_SpawnOrGetWeaponFromDefIndex(client, defIndex, slot);

		if (weapon == -1)
		{
			return;
		}

		Pho_Weapon_SetPaintIndex(weapon, paintIndex);
		Pho_Weapon_SetPaintSeed(weapon, paintSeed);
		Pho_Weapon_SetPaintWear(weapon, paintWear);
		Pho_Weapon_SetQuality(weapon, slot == ESlot_Knife ? 3 : quality != -1 ? quality
																			  : 0);
		Pho_Weapon_SetStattrak(weapon, stattrak, stattrackValue, slot != ESlot_Knife);
		if (slot != ESlot_Knife)
		{
			Pho_Weapon_SetStickers(weapon, stickers);
		}
		Pho_Weapon_SetNameTag(weapon, "");
		//Pho_Weapon_Refresh(client, weapon, false);
	}
	else if (slot == ESlot_Glove) {
		int activeWeapon = Pho_Gloves_PrepareForEdit(client);
		int gloves		 = Pho_Gloves_GenerateWearable(client);

		if (gloves == -1)
		{
			Pho_Gloves_Refresh(client, activeWeapon);
			return;
		}

		Pho_Gloves_SetDefIndex(gloves, defIndex);
		Pho_Gloves_SetPaintIndex(gloves, paintIndex);
		Pho_Gloves_SetPaintSeed(gloves, paintSeed);
		Pho_Gloves_SetPaintWear(gloves, paintWear);

		DispatchSpawn(gloves);

		SetEntPropEnt(client, Prop_Send, "m_hMyWearables", gloves);
		SetEntProp(client, Prop_Send, "m_nBody", 1);

		Pho_Gloves_Refresh(client, activeWeapon);
	}
	else {
		ShowErrorMessage(client, "Invalid defIndex!");
		return;
	}

	// generate !gen command
	char genCommand[256] = "!gen %d %d %d %f";

	for (int i = 0; i < MAX_STICKER_SLOTS; i++)
	{
		char stickerCommand[32];
		Format(stickerCommand, sizeof(stickerCommand), " %d %f", stickers[i].id,
				stickers[i].wear);
		StrCat(genCommand, sizeof(genCommand), stickerCommand);
	}

	Format(genCommand, sizeof(genCommand), genCommand, defIndex, paintIndex, paintSeed, paintWear);

	// !gen <defIndex> <paintIndex> <paintSeed> <paintWear> [<stickerslot1> <stickerslot1wear>...]




	Pho_PrintToChat(client, "\x06%s", genCommand);
}

//
// Weapons and Knifes
//
int Pho_Weapon_GetAndPrepareEquippedWeapon(int client)
{
	int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if (weapon == -1) return -1;

	SetEntProp(weapon, Prop_Send, "m_iAccountID", GetSteamAccountID(client));
	SetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity", client);
	SetEntPropEnt(weapon, Prop_Send, "m_hPrevOwner", -1);
	SetEntProp(weapon, Prop_Send, "m_iItemIDHigh", -1);

	return weapon;
}

int Pho_Weapon_GivePlayerItem(int client, int defIndex)
{
	char itemName[128];
	PTaH_GetItemDefinitionByDefIndex(defIndex)
		.GetDefinitionName(itemName, sizeof(itemName));
	return GivePlayerItem(client, itemName);
}

int Pho_Weapon_SpawnOrGetWeaponFromDefIndex(int client, int defIndex, ESlot slot, bool deleteExisting = false)
{
	int weapon;

	deleteExisting = true

	if (slot == ESlot_Primary)
	{
		weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	}
	else if (slot == ESlot_Secondary) {
		weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
	}
	else if (slot == ESlot_Knife) {
		weapon = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	}
	else {
		ShowErrorMessage(client, "Invalid defIndex!");
		return -1;
	}

	if (weapon == -1 || GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex") != defIndex || deleteExisting)
	{
		if (weapon != -1)
		{
			RemovePlayerItem(client, weapon);
			AcceptEntityInput(weapon, "Kill");
		}

		if (slot == ESlot_Knife)
		{
			g_iKnife[client] = defIndex;
		}


		float vecOrigin[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", vecOrigin);

		weapon = PTaH_SpawnItemFromDefIndex(defIndex, vecOrigin);

		// weapon = Pho_Weapon_GivePlayerItem(client, defIndex);

		if (slot == ESlot_Knife)
		{
			g_iKnife[client] = 0;
		}		
	}

	SetEntProp(weapon, Prop_Send, "m_iAccountID", GetSteamAccountID(client));
	SetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity", client);
	SetEntPropEnt(weapon, Prop_Send, "m_hPrevOwner", -1);
	SetEntProp(weapon, Prop_Send, "m_iItemIDLow", -1);

	// static int IDHigh = 16384;
	SetEntProp(weapon, Prop_Send, "m_iItemIDHigh", -1);

	return weapon;
}

void Pho_Weapon_SetPaintIndex(int weapon, int paintIndex)
{
	SetEntProp(weapon, Prop_Send, "m_nFallbackPaintKit", paintIndex);
}

void Pho_Weapon_SetPaintSeed(int weapon, int paintSeed)
{
	SetEntProp(weapon, Prop_Send, "m_nFallbackSeed", paintSeed);
}

void Pho_Weapon_SetPaintWear(int weapon, float paintWear)
{
	SetEntPropFloat(weapon, Prop_Send, "m_flFallbackWear", paintWear);
}

void Pho_Weapon_SetNameTag(int weapon, char customName[21])
{
	SetEntDataString(weapon, FindSendPropInfo("CBaseAttributableItem", "m_szCustomName"), customName, sizeof(customName));
}

void Pho_Weapon_SetQuality(int weapon, int quality)
{
	SetEntProp(weapon, Prop_Send, "m_iEntityQuality", quality);
}

/**
 * Setquality is only for weapons and not for knifes!!
 */
void Pho_Weapon_SetStattrak(int weapon, bool enable, int count = -1, bool setQuality = true)
{
	CEconItemView  pEconItemView = PTaH_GetEconItemViewFromEconEntity(weapon);
	CAttributeList attributeList = pEconItemView.NetworkedDynamicAttributesForDemos;

	attributeList.SetOrAddAttributeValue(80, enable ? (count == -1 ? 1337 : count) : -1);	 // stattrak
	attributeList.SetOrAddAttributeValue(81, enable ? 0 : -1);

	if (setQuality)
	{
		Pho_Weapon_SetQuality(weapon, enable ? 9 : 0);
	}
}

void Pho_Weapon_SetStickers(int weapon, SStickerData stickers[MAX_STICKER_SLOTS])
{
	int			   defIndex		 = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
	CEconItemView  pEconItemView = PTaH_GetEconItemViewFromEconEntity(weapon);
	CAttributeList attributeList = pEconItemView.NetworkedDynamicAttributesForDemos;
	int			   offset		 = STICKER_ATTRIBUTE_OFFSET;

	for (int i = 0; i < MAX_STICKER_SLOTS; i++)
	{
		if (i > PTaH_GetItemDefinitionByDefIndex(defIndex).GetNumSupportedStickerSlots()) continue;

		attributeList.SetOrAddAttributeValue(offset, stickers[i].id);
		attributeList.SetOrAddAttributeValue(offset + 1, stickers[i].wear);

		offset += 4;
	}
}

void Pho_Weapon_Refresh(int client, int weapon, bool invUpdate = false)
{
	if (invUpdate)
	{
		RemovePlayerItem(client, weapon);

		DataPack dpack;
		CreateDataTimer(0.1, Timer_RefreshWeapon, dpack);
		dpack.WriteCell(client);
		dpack.WriteCell(weapon);
	}

	PTaH_ForceFullUpdate(client);
}

public Action Timer_RefreshWeapon(Handle timer, DataPack pack)
{
	ResetPack(pack);
	int client = pack.ReadCell();
	int weapon = pack.ReadCell();

	if (IsClientInGame(client) && IsValidEntity(weapon))
	{
		EquipPlayerWeapon(client, weapon);
	}

	return Plugin_Continue;
}

//
// Gloves
//

int Pho_Gloves_PrepareForEdit(int client)
{
	int activeWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if (activeWeapon != -1)
	{
		SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1);
	}

	return activeWeapon;
}

int Pho_Gloves_GenerateWearable(int client)
{
	int gloves = GetEntPropEnt(client, Prop_Send, "m_hMyWearables");
	if (gloves != -1)
	{
		AcceptEntityInput(gloves, "KillHierarchy");
	}

	gloves = CreateEntityByName("wearable_item");

	SetEntProp(gloves, Prop_Send, "m_iItemIDLow", -1);
	SetEntPropEnt(gloves, Prop_Data, "m_hOwnerEntity", client);
	SetEntPropEnt(gloves, Prop_Data, "m_hParent", client);
	SetEntPropEnt(gloves, Prop_Data, "m_hMoveParent", client);
	SetEntProp(gloves, Prop_Send, "m_bInitialized", 1);

	return gloves;
}

void Pho_Gloves_SetDefIndex(int gloves, int defIndex)
{
	SetEntProp(gloves, Prop_Send, "m_iItemDefinitionIndex", defIndex);
}

void Pho_Gloves_SetPaintIndex(int gloves, int paintIndex)
{
	SetEntProp(gloves, Prop_Send, "m_nFallbackPaintKit", paintIndex);
}

void Pho_Gloves_SetPaintSeed(int gloves, int paintSeed)
{
	SetEntProp(gloves, Prop_Send, "m_nFallbackSeed", paintSeed);
}

void Pho_Gloves_SetPaintWear(int gloves, float paintWear)
{
	SetEntPropFloat(gloves, Prop_Send, "m_flFallbackWear", paintWear);
}

void Pho_Gloves_Refresh(int client, int activeWeapon)
{
	if (activeWeapon != -1)
	{
		DataPack dpack;
		CreateDataTimer(0.1, Timer_ResetGloves, dpack);
		dpack.WriteCell(client);
		dpack.WriteCell(activeWeapon);
	}

	PTaH_ForceFullUpdate(client);
}

public Action Timer_ResetGloves(Handle timer, DataPack pack)
{
	ResetPack(pack);
	int clientIndex	 = pack.ReadCell();
	int activeWeapon = pack.ReadCell();

	if (IsClientInGame(clientIndex) && IsValidEntity(activeWeapon))
	{
		SetEntPropEnt(clientIndex, Prop_Send, "m_hActiveWeapon", activeWeapon);
	}

	return Plugin_Continue;
}

void Pho_GenerateFromInspectUrl(int client, char[] inspectUrl)
{
	Pho_PrintToChat(client, "\x08Fetching item information...");

    char apiURL[256];
	// get api url 
	g_cvar_inspect_url.GetString(apiURL, sizeof(apiURL));

	HTTPRequest request = new HTTPRequest(apiURL);
	request.AppendQueryParam("url", inspectUrl)
	request.Get(OnCSGOFloatResponse, client);
}

void OnCSGOFloatResponse(HTTPResponse response, int client)
{
	if (response.Status != HTTPStatus_OK)
	{
		ShowErrorMessage(client, "Could not fetch item information!");
		// Failed to retrieve todo
		return;
	}

	JSONObject						 jsonResponse = view_as<JSONObject>(response.Data);
	JSONObject						 itemInfo	  = view_as<JSONObject>(jsonResponse.Get("iteminfo"));

	int								 defIndex	  = itemInfo.GetInt("defindex");
	int								 paintIndex	  = itemInfo.GetInt("paintindex");
	int								 paintSeed	  = itemInfo.GetInt("paintseed");
	int								 quality	  = itemInfo.GetInt("quality");
	float							 paintWear	  = itemInfo.GetFloat("floatvalue");

	bool							 stattrak	  = itemInfo.HasKey("killeatervalue")

						SStickerData stickers[MAX_STICKER_SLOTS];
	for (int i = 0; i < MAX_STICKER_SLOTS; i++)
	{
		stickers[i].id	 = 0;
		stickers[i].wear = 0.0;
	}

	JSONArray jsonStickers = view_as<JSONArray>(itemInfo.Get("stickers"));

	if (jsonStickers.Length > 0)
	{
		for (int i = 0; i < jsonStickers.Length; i++)
		{
			JSONObject jsonSticker = view_as<JSONObject>(jsonStickers.Get(i));

			int		   slot		   = jsonSticker.GetInt("slot");
			stickers[slot].id	   = jsonSticker.GetInt("stickerId");
			if (jsonSticker.HasKey("wear"))
			{
				stickers[slot].wear = jsonSticker.GetFloat("wear");
			}
		}
	}

	Pho_Generate(
		client,
		defIndex,
		paintIndex,
		paintSeed,
		paintWear,
		stickers,
		quality,
		stattrak);
}