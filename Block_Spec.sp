#include <sourcemod>
#include <smlib>
#include <l4d2util>
#include <l4d2_direct>
#include <left4downtown>

new Handle:BlockSpec_Timer;
new secCount;

public Plugin:myinfo =
{
	name = "Block spec abuse",
	author = "H.se",
	version = "0.1",
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
        if (((StrContains(TeamHeh, "3", false) != -1 || StrContains(TeamHeh, "infected", false) != -1) || (StrContains(TeamHeh, "2", false) != -1 || StrContains(TeamHeh, "survivor", false) != -1)) && BlockSpec_Timer != INVALID_HANDLE)
        {
                PrintHintText(client, "Wait %d seconds more", secCount);
                return Plugin_Handled;
        }
        return Plugin_Continue;
}

public Action:Command_Spectate(client, args)
{
	if (IsClientInGame(client) && !IsFakeClient(client) && BlockSpec_Timer == INVALID_HANDLE)
	{
		BlockSpec(client); 
		return Plugin_Continue;
	}
	else
	{
		PrintHintText(client, "Wait %d seconds more", secCount);
		return Plugin_Handled;
	}
}

BlockSpec(client)
{
	if (GetClientTeam(client) == 1)
	{
		secCount = 15;
		if (BlockSpec_Timer == INVALID_HANDLE)
		{
			BlockSpec_Timer = CreateTimer(1.0, tCallback, client, TIMER_REPEAT);
		}
	}
}

public Action:tCallback(Handle:timer)
{
	if (secCount > 0)
	{
		secCount = secCount - 1;
	}
	else
	{
		KillTimer(BlockSpec_Timer);
		BlockSpec_Timer = INVALID_HANDLE;
	}
}
