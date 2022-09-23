void PrintHelp(int client)
{
	if (GetCmdReplySource() == SM_REPLY_TO_CHAT)
	{
		Pho_PrintToChat(client, "See console output");
	}

	PrintToConsole(client, "Welcome to phoskin!\n\n");
	PrintToConsole(client, "If you want to generate a weapon from an inspect link, just paste the url into the chat. This plugin will detect any inspect-url automatically!\n\n");
	PrintToConsole(client, "Usage sm_pho <command> [arguments]");
	PrintToConsole(client, "    help");
	PrintToConsole(client, "        Show this help");
	PrintToConsole(client, "    gen <defIndex> <paintIndex> <paintSeed> <paintWear> [<stickerslot1> <stickerslot1wear>...]");
	PrintToConsole(client, "        Generate a skin");
	PrintToConsole(client, "    reset");
	PrintToConsole(client, "        Resets current skin to your owned one (does not work for team based weapons if not on the right team!)");
	PrintToConsole(client, "    skin <paintIndex>");
	PrintToConsole(client, "        Set current skin");
	PrintToConsole(client, "    float <paintWear>");
	PrintToConsole(client, "        Set current skin to specific float");
	PrintToConsole(client, "    seed [paintSeed]");
	PrintToConsole(client, "        Set current seed to a specific one (without argument will choose a random seed)");
	PrintToConsole(client, "    sticker [<stickerslot1> <stickerslot1wear>...]");
	PrintToConsole(client, "        set stickers to current weapon (wihtout arguments will remove any stickers)");
	PrintToConsole(client, "    rename [newname]");
	PrintToConsole(client, "        Add or remove nametag (without arguments will remove nametag)");
	PrintToConsole(client, "    stattrak <1|0> [count]");
	PrintToConsole(client, "        Enable/Disable stattrak");
	PrintToConsole(client, "    gloves reset");
	PrintToConsole(client, "        Reset gloves to owned one");
	PrintToConsole(client, "    gloves skin <paintIndex>");
	PrintToConsole(client, "        Set gloves skin");
	PrintToConsole(client, "    gloves float <paintWear>");
	PrintToConsole(client, "        Sets gloves float to a specific float");
	PrintToConsole(client, "    gloves seed [paintSeed]");
	PrintToConsole(client, "        Set gloves seed to specific one (without argument will choose a random seed)");
}

public Action Command_Pho(int client, int args)
{
	if (args == 0)
	{
		PrintHelp(client);
		return Plugin_Handled;
	}

	// Get first argument
	char command[64];
	GetCmdArg(1, command, sizeof(command));

	if (StrEqual(command, "help"))
	{
		PrintHelp(client);
		return Plugin_Handled;
	}
	else if (StrEqual(command, "gen")) {
		GenerateCommand(client, args, 1);
		return Plugin_Handled;
	}
	else if (StrEqual(command, "reset")) {
		ShowErrorMessage(client, "Not implemented yet. Just respawn to reset your skins!");
		return Plugin_Handled;
	}
	else if (StrEqual(command, "skin")) {
		if (args < 2)
		{
			ShowErrorMessage(client, "Usage: !pho skin <paintIndex>");
			return Plugin_Handled;
		}

		int weapon = Pho_Weapon_GetAndPrepareEquippedWeapon(client);

		if (weapon == -1)
		{
			return Plugin_Handled;
		}

		int   defIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
		ESlot slot     = GetItemSlotFromDefIndex(defIndex);

		if (slot != ESlot_Primary && slot != ESlot_Secondary && slot != ESlot_Knife)
		{
			ShowErrorMessage(client, "This weapon is not supported!");
			return Plugin_Handled;
		}

		char buff[64];
		GetCmdArg(2, buff, sizeof(buff));
		int paintIndex = StringToInt(buff);

		Pho_Weapon_SetPaintIndex(weapon, paintIndex);
		Pho_Weapon_Refresh(client, weapon, true);

		Pho_PrintToChat(client, "\x06Generated weapon");
	}
	else if (StrEqual(command, "seed")) {
		int paintSeed = -1;
		if (args >= 2)
		{
			char buff[64];
			GetCmdArg(2, buff, sizeof(buff));
			paintSeed = StringToInt(buff);
		}

		int weapon = Pho_Weapon_GetAndPrepareEquippedWeapon(client);

		if (weapon == -1)
		{
			return Plugin_Handled;
		}

		int   defIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
		ESlot slot     = GetItemSlotFromDefIndex(defIndex);

		if (slot != ESlot_Primary && slot != ESlot_Secondary && slot != ESlot_Knife)
		{
			ShowErrorMessage(client, "This weapon is not supported!");
			return Plugin_Handled;
		}

		if (paintSeed == -1)
		{
			paintSeed = GetRandomInt(1, 1000);
		}

		Pho_Weapon_SetPaintSeed(weapon, paintSeed);
		Pho_Weapon_Refresh(client, weapon, false);

		Pho_PrintToChat(client, "\x06Set seed to %i", paintSeed);
	}
	else if (StrEqual(command, "float")) {
		if (args < 2)
		{
			ShowErrorMessage(client, "Usage: !pho float <paintWear>");
			return Plugin_Handled;
		}

		int weapon = Pho_Weapon_GetAndPrepareEquippedWeapon(client);

		if (weapon == -1)
		{
			return Plugin_Handled;
		}

		int   defIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
		ESlot slot     = GetItemSlotFromDefIndex(defIndex);

		if (slot != ESlot_Primary && slot != ESlot_Secondary && slot != ESlot_Knife)
		{
			ShowErrorMessage(client, "This weapon is not supported!");
			return Plugin_Handled;
		}

		char buff[64];
		GetCmdArg(2, buff, sizeof(buff));
		int paintWear = StringToFloat(buff);

		Pho_Weapon_SetPaintWear(weapon, paintWear);
		Pho_Weapon_Refresh(client, weapon, false);

		Pho_PrintToChat(client, "\x06Set float to %f", paintWear);
	}
	else if (StrEqual(command, "stattrak")) {
		if (args < 2)
		{
			ShowErrorMessage(client, "Usage: !pho stattrak <1|0> [count]");
			return Plugin_Handled;
		}

		int weapon = Pho_Weapon_GetAndPrepareEquippedWeapon(client);

		if (weapon == -1)
		{
			return Plugin_Handled;
		}

		int   defIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
		ESlot slot     = GetItemSlotFromDefIndex(defIndex);

		if (slot != ESlot_Primary && slot != ESlot_Secondary && slot != ESlot_Knife)
		{
			ShowErrorMessage(client, "This weapon is not supported!");
			return Plugin_Handled;
		}

		int enabled;
		int count = 1337;

		char buff[64];
		GetCmdArg(2, buff, sizeof(buff));
		enabled = StringToInt(buff);

		if (args >= 3)
		{
			char buff[64];
			GetCmdArg(3, buff, sizeof(buff));
			count = StringToInt(buff);
		}

		Pho_Weapon_SetStattrak(weapon, enabled, count, slot != ESlot_Knife);
		Pho_Weapon_Refresh(client, weapon, true);

		if (enabled)
		{
			Pho_PrintToChat(client, "\x06Enabled Stattrak (%i)", count);
		}
		else {
			Pho_PrintToChat(client, "\x06Disabled Stattrak");
		}
	}
	else if (StrEqual(command, "sticker")) {
		int weapon = Pho_Weapon_GetAndPrepareEquippedWeapon(client);

		if (weapon == -1)
		{
			return Plugin_Handled;
		}

		int   defIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
		ESlot slot     = GetItemSlotFromDefIndex(defIndex);

		if (slot != ESlot_Primary && slot != ESlot_Secondary && slot != ESlot_Knife)
		{
			ShowErrorMessage(client, "This weapon is not supported!");
			return Plugin_Handled;
		}

		SStickerData stickers[MAX_STICKER_SLOTS];

		if (args >= 2)
		{
			char buff[64];
			int  currentStickerIndex = 0;
			int  currentArgindex     = 2;
			while (currentArgindex <= args)
			{
				GetCmdArg(currentArgindex, buff, sizeof(buff));
				stickers[currentStickerIndex].id = StringToInt(buff);

				if (currentArgindex + 1 <= args)
				{
					GetCmdArg(currentArgindex + 1, buff, sizeof(buff));
					stickers[currentStickerIndex].wear = StringToFloat(buff);
					currentArgindex++;
				}

				currentArgindex++;
				currentStickerIndex++;
			}
		}

		Pho_Weapon_SetStickers(weapon, stickers);
		Pho_Weapon_Refresh(client, weapon, false);

		if (args >= 2)
		{
			Pho_PrintToChat(client, "\x06Applied stickers");
		}
		else {
			Pho_PrintToChat(client, "\x06Removed all stickers");
		}
	}
	else if (StrEqual(command, "rename")) {
		int weapon = Pho_Weapon_GetAndPrepareEquippedWeapon(client);

		if (weapon == -1)
		{
			return Plugin_Handled;
		}

		char buff[21];
		if (args >= 2)
		{
			GetCmdArg(2, buff, sizeof(buff));
			Pho_Weapon_SetNameTag(weapon, buff);
		}
		else {
			Pho_Weapon_SetNameTag(weapon, "");
		}

		Pho_Weapon_Refresh(client, weapon, true);

		if (args >= 2)
		{
			Pho_PrintToChat(client, "\x06Added nametag (%s)", buff);
		}
		else {
			Pho_PrintToChat(client, "\x06Removed nametag");
		}
	}
	else if (StrEqual(command, "gloves")) {
		if (args <= 2)
		{
			PrintHelp(client);
			return Plugin_Handled;
		}

		char sub_command[64];
		GetCmdArg(2, sub_command, sizeof(sub_command));

		if (StrEqual(sub_command, "help"))
		{
			PrintHelp(client);
			return Plugin_Handled;
		}
		else if (StrEqual(sub_command, "reset"))
		{
			ShowErrorMessage(client, "Not implemented yet. Just respawn to reset your skins!");
			return Plugin_Handled;
		} else if (StrEqual(sub_command, "skin"))
		{
			if (args < 3)
			{
				ShowErrorMessage(client, "Usage: !pho gloves skin <paintIndex>");
				return Plugin_Handled;
			}

			int gloves = GetEntPropEnt(client, Prop_Send, "m_hMyWearables");

			if (gloves == -1)
			{
				ShowErrorMessage(client, "You need to have gloves equipped!");
				return Plugin_Handled;
			}

			char buff[64];
			GetCmdArg(3, buff, sizeof(buff));
			int paintIndex = StringToInt(buff);

			int activeWeapon = Pho_Gloves_PrepareForEdit(client);
			Pho_Gloves_SetPaintIndex(gloves, paintIndex);

			Pho_Gloves_Refresh(client, activeWeapon);
			Pho_PrintToChat(client, "\x06Set gloves skin to %i", paintIndex);
		}
		else if (StrEqual(sub_command, "seed"))
		{
			int gloves = GetEntPropEnt(client, Prop_Send, "m_hMyWearables");

			if (gloves == -1)
			{
				ShowErrorMessage(client, "You need to have gloves equipped!");
				return Plugin_Handled;
			}

			int paintSeed = -1;
			if (args >= 3)
			{
				char buff[64];
				GetCmdArg(3, buff, sizeof(buff));
				paintSeed = StringToInt(buff);
			}

			if (paintSeed == -1)
			{
				paintSeed = GetRandomInt(1, 1000);
			}

			int activeWeapon = Pho_Gloves_PrepareForEdit(client);
			Pho_Gloves_SetPaintSeed(gloves, paintSeed);
			Pho_Gloves_Refresh(client, activeWeapon);
			Pho_PrintToChat(client, "\x06Set gloves seed to %i", paintSeed);
		}
		else if (StrEqual(sub_command, "float"))
		{
			if (args < 3)
			{
				ShowErrorMessage(client, "Usage: !pho gloves float <paintWear>");
				return Plugin_Handled;
			}

			int gloves = GetEntPropEnt(client, Prop_Send, "m_hMyWearables");

			if (gloves == -1)
			{
				ShowErrorMessage(client, "You need to have gloves equipped!");
				return Plugin_Handled;
			}

			char buff[64];
			GetCmdArg(3, buff, sizeof(buff));
			float paintWear = StringToFloat(buff);

			int activeWeapon = Pho_Gloves_PrepareForEdit(client);
			Pho_Gloves_SetPaintWear(gloves, paintWear);

			Pho_Gloves_Refresh(client, activeWeapon);
			Pho_PrintToChat(client, "\x06Set gloves float to %i", paintWear);
		}
	}

	return Plugin_Handled;
}

public void GenerateCommand(int client, int args, int offset)
{
	if (args < 4 + offset)
	{
		ShowErrorMessage(client, " \x01\x0B\x07Usage: !pho gen <defIndex> <paintIndex> <paintSeed> <paintWear> [<stickerslot1> <stickerslot1wear>...]");
		return;
	}

	char buff[64];
	int  currentIndex = 1 + offset;
	bool anyStickers  = false;

	GetCmdArg(currentIndex++, buff, sizeof(buff));
	int defIndex = StringToInt(buff);

	GetCmdArg(currentIndex++, buff, sizeof(buff));
	int paintIndex = StringToInt(buff);

	GetCmdArg(currentIndex++, buff, sizeof(buff));
	int paintSeed = StringToInt(buff);

	GetCmdArg(currentIndex++, buff, sizeof(buff));
	float paintWear = StringToFloat(buff);

	SStickerData stickers[MAX_STICKER_SLOTS];
	for (int i = 0; i < MAX_STICKER_SLOTS; i++)
	{
		stickers[i].id   = 0;
		stickers[i].wear = 0.0;
	}

	if (args > 4 + offset)
	{
		int currentStickerIndex = 0;
		while (currentIndex <= args)
		{
			GetCmdArg(currentIndex, buff, sizeof(buff));
			stickers[currentStickerIndex].id = StringToInt(buff);

			if (currentIndex + 1 <= args)
			{
				GetCmdArg(currentIndex + 1, buff, sizeof(buff));
				stickers[currentStickerIndex].wear = StringToFloat(buff);
				currentIndex++;
			}

			currentIndex++;
			currentStickerIndex++;
		}
	}

	Pho_Generate(client, defIndex, paintIndex, paintSeed, paintWear, stickers)
}

public Action Command_Gen(int client, int args)
{
	GenerateCommand(client, args, 0);
}

public Action ChatListener(int client, const char[] command, int args)
{
	if (client < 1)
	{
		return Plugin_Continue;
	}

	char msg[128];
	GetCmdArgString(msg, sizeof(msg));
	StripQuotes(msg);

	if (
		StrContains(msg, "!gen") == 0 ||
		StrContains(msg, "!gengl") == 0 ||
		StrContains(msg, "!pho") == 0
	)
	{
		return Plugin_Handled;
	}

	if (IsInspectUrl(msg))
	{
		Pho_GenerateFromInspectUrl(client, msg);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}