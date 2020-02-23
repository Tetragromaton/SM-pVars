# SM-pVars<br>
Personal variables ! Quickly store variable and use it between many plugins !<br>
Also comes with script caller ! Parse any actions between your plugins and etc !<br>
<br>
Examples:<br>
<br>
//Get/Set integer value for the player.<br>
int Frags = pVar_GetValue(client, "FragCount");<br>
PrintToChat(client, "Your frags %i", Frags);<br>
pVar_SetValue(client, "FragCount", 1337);<br>
//Executing this code again will print Your frags 1337.<br>
<br>
//Get/Set string variable for the player.<br>
char Temp[255];<br>
pVar_GetString(client, "MagicPowder", Temp);<br>
PrintToChat(client, "You have %s in magic powder !", Temp);<br>
pVar_SetString(client, "MagicPowder", "something unusual");<br>
//Result: <br>
//1.You have in magic powder !<br>
//2.(second execution of the code) You have something unusual in magic powder !<br>
<br>
//Trigger script code and see what comes with script event.<br>
//Plugin test1.smx<br>
//RegConsoleCmd blah blah<br>
//Executing the code<br>
pVar_TriggerAction("MAGIC_HAPPENED","Around of the castle", "Castle is seems to be closed", "And it definetly dont sell some of the bad things......");<br>

As only as this function was called, you can now see it from any plugin you want.<br>
//Plugin test2.smx<br>
public pVar_OnAction(const char[] g, const char[] g1, const char[]g2, const char[] gl3, const char[] g4)<br>
{<br>
PrintToChatAll("Oops ! Something incoming ! Script_def_name %s %s %s %s %s" g,g1,g2,gl3,g4);<br>
//Result: Oops ! Something incoming ! Script_def_name MAGIC_HAPPENED Around of the castle Castle is seems to be closed And it definetly dont sell some of the bad things ......<br>
}<br>
