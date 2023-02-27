// Action GiveNamedItemPre(int client, char classname[64], CEconItemView& item, bool& ignoredCEconItemView, bool& OriginIsNULL, float Origin[3])
// {
// 	if (IsValidClient(client))
// 	{
// 		if (g_iKnife[client] != 0 && IsKnifeClass(classname))
// 		{
// 			ignoredCEconItemView			   = true;
// 			CEconItemDefinition itemDefinition = PTaH_GetItemDefinitionByDefIndex(g_iKnife[client]);
// 			char				itemName[128];
// 			itemDefinition.GetDefinitionName(itemName, sizeof(itemName));
// 			strcopy(classname, sizeof(classname), itemName);
// 			return Plugin_Changed;
// 		}
// 	}
// 	return Plugin_Continue;
// }

// void GiveNamedItemPost(int client, const char[] classname, const CEconItemView item, int entity, bool OriginIsNULL, const float Origin[3])
// {
// 	if (IsValidClient(client) && IsValidEntity(entity))
// 	{
// 		if (IsKnifeClass(classname) && g_iKnife[client] != 0)
// 		{
// 			EquipPlayerWeapon(client, entity);
// 		}
// 	}
// }

Action WeaponCanUsePre(int client, int weapon, bool& pickup)
{
	if (IsKnife(weapon) && IsValidClient(client))
	{
		pickup = true;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}