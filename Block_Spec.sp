#include <sourcemod>
#include <left4downtown>

new Handle:BlockSpec_Timer[MAXPLAYERS + 1];
new secCount[MAXPLAYERS + 1];

public Plugin:myinfo =
{
	name = "Block spec abuse",
	author = "H.se",
	version = "0.2",
};

public OnPluginStart()
{
	RegConsoleCmd("sm_spectate", Command_Spectate);
	RegConsoleCmd("sm_spec", Command_Spectate);
	RegConsoleCmd("sm_s", Command_Spectate);

	RegConsoleCmd("jointeam", Command_JoinTeam);
}

public Action:Command_JoinTeam(client, args)
{
        decl String:TeamHeh[256];
        GetCmdArg(1, TeamHeh, sizeof(TeamHeh));
        if (((StrContains(TeamHeh, "3", false) != -1 || StrContains(TeamHeh, "infected", false) != -1) || (StrContains(TeamHeh, "2", false) != -1 || StrContains(TeamHeh, "survivor", false) != -1)) && BlockSpec_Timer[client] != INVALID_HANDLE)
        {
                PrintHintText(client, "Wait %d seconds more", secCount[client]);
                return Plugin_Handled;
        }
        return Plugin_Continue;
}

public Action:Command_Spectate(client, args)
{
	if (IsClientInGame(client) && !IsFakeClient(client) && BlockSpec_Timer[client] == INVALID_HANDLE)
	{
		BlockSpec(client); 
		return Plugin_Continue;
	}
	else
	{
		PrintHintText(client, "Wait %d seconds more", secCount[client]);
		return Plugin_Handled;
	}
}

BlockSpec(client)
{
	if (GetClientTeam(client) == 1)
	{
		secCount[client] = 15;
		if (BlockSpec_Timer[client] == INVALID_HANDLE)
		{
			BlockSpec_Timer[client] = CreateTimer(1.0, tCallback, client, TIMER_REPEAT);
		}
	}
}

public Action:tCallback(Handle:timer, any:client)
{
	if (secCount[client] > 0)
	{
		secCount[client] = secCount[client] - 1;
	}
	else
	{
		KillTimer(BlockSpec_Timer[client]);
		BlockSpec_Timer[client] = INVALID_HANDLE;
	}
}
