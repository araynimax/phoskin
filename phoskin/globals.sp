#define MAX_STICKER_SLOTS		 6
#define STICKER_ATTRIBUTE_OFFSET 113

char g_prefix[]				  = "[\x06PHOSKIN\x01]";
char g_command[]			  = "pho";

int	 g_iKnife[MAXPLAYERS + 1] = { 0, ... };

ConVar g_cvar_inspect_url;
char g_inspect_url[256];