#include "./globals.sp"
#include "./enums.sp"
#include "./helpers.sp"
#include "./commands.sp"
#include "./generator.sp"
#include "./hooks.sp"

public void OnPluginStart()
{
	// Commands
	RegConsoleCmd("sm_pho", Command_Pho, "Type sm_pho help for a list of commands");

	// if g_command is not pho, register the alias
	if (strcmp(g_command, "pho") != 0)
	{
		// combine string
		char g_command_alias[32];
		Format(g_command_alias, sizeof(g_command_alias), "sm_%s", g_command);
		RegConsoleCmd(g_command_alias, Command_Pho, "Alias for sm_pho");
	}

	RegConsoleCmd("sm_gen", Command_Gen, "Alias for sm_pho gen");
	RegConsoleCmd("sm_gengl", Command_Gen, "Alias for sm_pho gen");

	// ChatListener
	AddCommandListener(ChatListener, "say");
	AddCommandListener(ChatListener, "say2");
	AddCommandListener(ChatListener, "say_team");

	// AddCommandListener(Command_Drop, "drop");

	// Hooks
	// PTaH(PTaH_GiveNamedItemPre, Hook, GiveNamedItemPre);
	// PTaH(PTaH_GiveNamedItemPost, Hook, GiveNamedItemPost);
	PTaH(PTaH_WeaponCanUsePre, Hook, WeaponCanUsePre);
}