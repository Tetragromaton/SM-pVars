/*
**
*/
#if defined _pvars_included
 #endinput
#endif
#define _pvars_included


native int pVar_GetValue(int client, const char[] nameofvar);

native int pVar_SetValue(int client, const char[] nameofvar, int value);

native void pVar_GetString(int client, const char[] nameofvar, const char[] stringstoreto);

native void pVar_SetString(int client, const char[] nameofvar, const char[] value);
native void pVar_TriggerAction(const char[] action = "", const char[] extra = "", const char[] extra3 = "", const char[]extra4 = "");
//typedef pVar_OnCallback = function Action (const char[] action, const char[] extra, const char[] extra2);
forward void pVar_OnAction(const char[] action, const char[] extra, const char[] extra2, const char[] extra3, const char[] extra4);

//native void pVar_OnCalledCB(pVar_OnCallback func);