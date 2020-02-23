#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "github.com/tetragromaton"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <pVars>
//#include <sdkhooks>
StringMap PlayerVars[MAXPLAYERS];
StringMap ServerDataMGR;
StringMap ServerDataMapMGR;
Handle g_hGFwd_OnClientLoaded;
public Plugin myinfo = 
{
	name = "personalVars",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = ""
};

public OnClientPutInServer(client)
{
	CreateTimer(2.0, ForceIfGone, client);
	ClearTrie(PlayerVars[client]);
}
public Action ForceIfGone(Handle:timer,any:client)
{
	ClearTrie(PlayerVars[client]);
}
public OnClientDisconnect(client)
{
	ClearTrie(PlayerVars[client]);
}
public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max)
{
	CreateNative("pVar_GetValue", Native_GetValue);
	CreateNative("pVar_GetString", Native_GetString);
	CreateNative("pVar_SetValue", Native_SetValue);
	CreateNative("pVar_SetString", Native_SetString);
	CreateNative("pVar_TriggerAction", Native_TriggerACT);
	g_hGFwd_OnClientLoaded = CreateGlobalForward("pVar_OnAction", ET_Ignore, Param_String,Param_String,Param_String, Param_String);
	RegPluginLibrary("pVar");
	return APLRes_Success;
}
void TriggerAction(const char[] sfl, const char[] extra, const char[] extra2, const char[] extra3 = "")
{
    Call_StartForward(g_hGFwd_OnClientLoaded);
    Call_PushString(sfl);
	Call_PushString(extra);
	Call_PushString(extra2);
	Call_PushString(extra3);
    Call_Finish();
}
public void OnPluginStart()
{
	for (new i = 0; i < sizeof(PlayerVars); i++)
	{
		PlayerVars[i] = CreateTrie();
	}
	ServerDataMGR = CreateTrie();
	ServerDataMapMGR = CreateTrie();
	//If hook not found, recompile this with teamplay_round_start or whatever game you use.
	
	HookEvent("round_start", OnRoundStart);
	//RegConsoleCmd("dgl", FGL);
}
public Action FGL(client,args)
{
	//TriggerAction("1g", "2g", "3g", "NATIVE_DEKEL_ARG4");
	pVar_TriggerAction("NATIVE_INCOME_RAW_DEBUG", "1", "2", "3");
}

public OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	ClearTrie(ServerDataMapMGR);
}
public int Native_GetValue(Handle hPlugin, int iNumParams)
{
	int client = GetNativeCell(1);
	char key[255];
	GetNativeString(2, key, sizeof(key));
	int value = -1;
	if (StrContains(key, "GLOBAL_", false) != -1)
	{
		GetTrieValue(ServerDataMGR, key, value);
	}else if (StrContains(key, "MAP_", false) != -1)
	{
		GetTrieValue(ServerDataMapMGR, key, value);
	}  else GetTrieValue(PlayerVars[client], key, value);
	return value;
}
public int Native_TriggerACT(Handle hPlugin, int iNumParams)
{
	char val1[2048];
	char val2[2048];
	char val3[2048];
	char val4[2048] = "";
	GetNativeString(1, val1, sizeof(val1));
	GetNativeString(2, val2, sizeof(val2));
	GetNativeString(3, val3, sizeof(val3));
	GetNativeString(4, val4, sizeof(val4));
	TriggerAction(val1, val2, val3, val4);
}
public int Native_GetString(Handle hPlugin, int iNumParams)
{
	int client = GetNativeCell(1);
	char key[255];
	GetNativeString(2, key, sizeof(key));
	char value[1024];
	if (StrContains(key, "GLOBAL_", false) != -1)
	{
		GetTrieString(ServerDataMGR, key, value, sizeof(value));
	} else if (StrContains(key, "MAP_", false) != -1)
	{
		SetTrieString(ServerDataMapMGR, key, value);
	} else GetTrieString(PlayerVars[client], key, value,sizeof(value));
	SetNativeString(3, value, sizeof(value));
}

public int Native_SetValue(Handle hPlugin, int iNumParams)
{
	int client = GetNativeCell(1);
	char key[255];
	GetNativeString(2, key, sizeof(key));
	int value = GetNativeCell(3);
	if (StrContains(key, "GLOBAL_", false) != -1)
	{
		SetTrieValue(ServerDataMGR, key, value);
	}else if (StrContains(key, "MAP_", false) != -1)
	{
		SetTrieValue(ServerDataMapMGR, key, value);
	}  else SetTrieValue(PlayerVars[client], key, value);
}

public int Native_SetString(Handle hPlugin, int iNumParams)
{
	int client = GetNativeCell(1);
	char key[255];
	GetNativeString(2, key, sizeof(key));
	char value[1024];
	GetNativeString(3, value, sizeof(value));
	if (StrContains(key, "GLOBAL_", false) != -1)
	{
		SetTrieString(ServerDataMGR, key, value);
	} else if (StrContains(key, "MAP_", false) != -1)
	{
		SetTrieString(ServerDataMapMGR, key, value);
	} else 	SetTrieString(PlayerVars[client], key, value);
}