void Pho_PrintToChat(int client, char[] format, any ...) {
    char output[128];
    VFormat(output, sizeof(output), format, 3);

    PrintToChat(client, " %s %s", g_prefix, output);
}

void ShowErrorMessage(int client, const char[] msg) {
	Pho_PrintToChat(client, "\x07Error: %s", msg);
}

ESlot GetItemSlotFromDefIndex(int defIndex) {
	switch (defIndex) {
		case 
			7,   // AK-47
			8,   // AUG
			9,   // AWP
			10,  // FAMAS
			11,  // G3SG1
			13,  // Galil AR
			14,  // M249
			16,  // M4A4
			17,  // MAC-10
			19,  // P90
			23,  // MP5-SD
			24,  // UMP-45
			25,  // XM1014
			26,  // PP-Bizon
			27,  // MAG-7
			28,  // Negev
			29,  // Sawed-Off
			33,  // MP7
			34,  // MP9
			35,  // Nova
			38,  // SCAR-20
			39,  // SG 553
			40,  // SSG 08
			60   // M4A1-S
		: return ESlot_Primary;

		case
			1,   // Desert Eagle
			2,   // Dual Berettas
			3,   // Five-SeveN
			4,   // Glock-18
			30,  // Tec-9
			32,  // P2000
			36,  // P250
			61,  // USP-S
			63,  // CZ75-Auto
			64   // R8 Revolver
		: return ESlot_Secondary;

		case
			42,  // Default CT Knife
			59,  // Default T Knife

			500, // Bayonet
			503, // Classic Knife
			505, // Flip Knife
			506, // Gut Knife
			507, // Karambit
			508, // M9 Bayonet
			509, // Huntsman Knife
			512, // Falchion Knife
			514, // Bowie Knife
			515, // Butterfly Knife
			516, // Shadow Daggers
			517, // Paracord Knife
			518, // Survival Knife
			519, // Ursus Knife
			520, // Navaja Knife
			521, // Nomad Knife
			522, // Stiletto Knife
			523, // Talon Knife
			525  // Skeleton Knife
		: return ESlot_Knife;

		case
			5028, // Default T Gloves
			5029, // Default CT Gloves

			4725, // Broken Fang Gloves
			5027, // Bloodhound Gloves
			5030, // Sport Gloves
			5031, // Driver Gloves
			5032, // Hand Wraps
			5033, // Moto Gloves
			5034, // Specialist Gloves
			5035  // Hydra Gloves
		: return ESlot_Glove;
	}

	return ESlot_Invalid;
}

bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || IsFakeClient(client) || IsClientSourceTV(client) || IsClientReplay(client))
	{
		return false;
	}
	return true;
}

bool IsKnifeClass(const char[] classname)
{
	if ((StrContains(classname, "knife") > -1 && strcmp(classname, "weapon_knifegg") != 0) || StrContains(classname, "bayonet") > -1)
		return true;
	return false;
}


Regex re_steamInspectUrl = null;
public bool IsInspectUrl(char[] string)
{
   if (re_steamInspectUrl == null)
	{
		re_steamInspectUrl = new Regex("^steam:\\/\\/rungame\\/730\\/76561202255233023\\/\\+csgo_econ_action_preview(%20|\\s)(S|M)(\\d+)A(\\d+)D(\\d+)$");
	}
    
	return re_steamInspectUrl.Match(string) > 0;
}
