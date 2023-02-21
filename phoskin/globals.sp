#define MAX_STICKER_SLOTS 6
#define STICKER_ATTRIBUTE_OFFSET 113

ConVar g_cvEnabled;         // enable/disable plugin globally
ConVar g_cvDisableSpawn;    // disable spawning weapons (if playing real matches on the server)
ConVar g_cvTimeoutDuration; // how long a player has to wait to generate a new weapon after generating a weapon from a inspect url

char g_prefix[] = "[\x06PHOSKIN\x01]";
char g_command[] = "pho";

int g_iKnife[MAXPLAYERS + 1] = { 0, ... };