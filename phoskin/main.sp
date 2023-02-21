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

	// ChatListener
    AddCommandListener(ChatListener, "say");
	AddCommandListener(ChatListener, "say2");
	AddCommandListener(ChatListener, "say_team");

    // Hooks
	PTaH(PTaH_GiveNamedItemPre, Hook, GiveNamedItemPre);
	PTaH(PTaH_GiveNamedItemPost, Hook, GiveNamedItemPost);

	ConVar g_cvGameType = FindConVar("game_type");
	ConVar g_cvGameMode = FindConVar("game_mode");
	
	if(g_cvGameType.IntValue == 1 && g_cvGameMode.IntValue == 2)
	{
		PTaH(PTaH_WeaponCanUsePre, Hook, WeaponCanUsePre);
	}
}