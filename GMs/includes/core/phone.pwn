/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Phone System

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
	* Copyright (c) 2014, Next Generation Gaming, LLC
	*
	* All rights reserved.
	*
	* Redistribution and use in source and binary forms, with or without modification,
	* are not permitted in any case.
	*
	*
	* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

CMD:cellphonehelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    if (PlayerInfo[playerid][pPnumber] != 0) {
        SendClientMessageEx(playerid, COLOR_WHITE,"*** HELP *** - type a command for more infomation.");
        SendClientMessageEx(playerid, COLOR_GRAD3,"*** CELLPHONE *** /call 'eg: /call 911' /sms (/p)ickup (/h)angup /speakerphone /number");
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE,"You can buy a cell phone in any 24-7");
    }
    return 1;
}

CMD:phoneprivacy(playerid, params[])
{
    if(PlayerInfo[playerid][pPnumber] != 0 && PlayerInfo[playerid][pDonateRank] >= 2)
	{
        if(PlayerInfo[playerid][pPhonePrivacy] == 1)
		{
            PlayerInfo[playerid][pPhonePrivacy] = 0;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the phone privacy feature.");
        }
        else
		{
            PlayerInfo[playerid][pPhonePrivacy] = 1;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the phone privacy feature.");
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a phone or you aren't a Silver VIP.");
    }
    return 1;
}

CMD:speakerphone(playerid, params[])
{
    if(PlayerInfo[playerid][pPnumber] != 0)
	{
        if(PlayerInfo[playerid][pSpeakerPhone] == 1)
		{
            PlayerInfo[playerid][pSpeakerPhone] = 0;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the speakerphone feature on your phone.");
        }
        else
		{
            PlayerInfo[playerid][pSpeakerPhone] = 1;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the speakerphone feature on your phone.");
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a phone.");
    }
    return 1;
}

CMD:togphone(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use your phone in jail/prison.");
		return 1;
	}
	if(Mobile[playerid] == INVALID_PLAYER_ID)
	{
		if (!PhoneOnline[playerid])
		{
			PhoneOnline[playerid] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD2, "Your phone is now switched off.");
		}
		else
		{
			PhoneOnline[playerid] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD2, "Your phone is now switched on.");
		}
		return 1;
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "First use /hangup.");
}

CMD:colorcar(playerid, params[]) {
	new iColors[2];
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a vehicle.");
	else if(PlayerInfo[playerid][pSpraycan] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your spraycan is empty.");
	if(sscanf(params, "ii", iColors[0], iColors[1])) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /colorcar [ID 1] [ID 2]. Colors must be an ID.");
	else if((PlayerInfo[playerid][pDonateRank] == 0) && (iColors[0] > 127 || iColors[1] > 127)) return SendClientMessageEx(playerid, COLOR_GREY, "Only VIPs can use special color IDs above 127.");
	else if(!(0 <= iColors[0] <= 255 && 0 <= iColors[1] <= 255)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid color specified (IDs start at 0, and end at 255).");
	new szMessage[60];
	for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
	{
		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][i][pvId]))
		{
			PlayerVehicleInfo[playerid][i][pvColor1] = iColors[0], PlayerVehicleInfo[playerid][i][pvColor2] = iColors[1];
			ChangeVehicleColor(PlayerVehicleInfo[playerid][i][pvId], PlayerVehicleInfo[playerid][i][pvColor1], PlayerVehicleInfo[playerid][i][pvColor2]);
			PlayerInfo[playerid][pSpraycan]--;
			g_mysql_SaveVehicle(playerid, i);
			format(szMessage, sizeof(szMessage), "You have changed the colors of your vehicle to ID %d, %d.", iColors[0], iColors[1]);
			return SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
		}
	}
	for(new i = 0; i < sizeof(VIPVehicles); i++)
	{
		if(IsPlayerInVehicle(playerid, VIPVehicles[i]))
		{
			ChangeVehicleColor(VIPVehicles[i], iColors[0], iColors[1]);
			PlayerInfo[playerid][pSpraycan]--;
			format(szMessage, sizeof(szMessage), "You have changed the colors of this vehicle to ID %d, %d.", iColors[0], iColors[1]);
			return SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);			
		}
	}
	for(new i = 0; i < sizeof(FamedVehicles); i++)
	{
		if(IsPlayerInVehicle(playerid, FamedVehicles[i]))
		{
			ChangeVehicleColor(FamedVehicles[i], iColors[0], iColors[1]);
			PlayerInfo[playerid][pSpraycan]--;
			format(szMessage, sizeof(szMessage), "You have changed the colors of this vehicle to ID %d, %d.", iColors[0], iColors[1]);
			return SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);	
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "You can't spray other people's vehicles.");
	return 1;
}

CMD:number(playerid, params[]) {
	if(PlayerInfo[playerid][pPhoneBook] == 1) {

		new
			iTarget;

		if(sscanf(params, "u", iTarget)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /number [player]");
		}
		else if(IsPlayerConnected(iTarget)) {
			new
				szNumber[16 + MAX_PLAYER_NAME];

			format(szNumber, sizeof(szNumber), "* %s (%i)", GetPlayerNameEx(iTarget), PlayerInfo[iTarget][pPnumber]);
			SendClientMessageEx(playerid, COLOR_GRAD1, szNumber);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a phone book.");
	return 1;
}

/*
CMD:ringtone(playerid, params[])
{
    if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) {
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}

	if(!IsPlayerInAnyVehicle(playerid))
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		SetPlayerAttachedObject(playerid, 9, 330, 6);
	}
	return ShowPlayerDialog(playerid,RTONEMENU,DIALOG_STYLE_LIST,"Ringtone - Change Your Ringtone:","Ringtone 1\nRingtone 2\nRingtone 3\nRingtone 4\nRingtone 5\nRingtone 6\nRingtone 7\nRingtone 8\nRingtone 9\nTurn Off","Select","Close");
}
*/

CMD:setautoreply(playerid, params[])
{
	if(strlen(PlayerInfo[playerid][pAutoTextReply]) > 0)
	{
		strdel(PlayerInfo[playerid][pAutoTextReply], 0, 64);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled auto reply.");
		return 1;
	}

	if(PlayerInfo[playerid][pDonateRank] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't a VIP.");
		return 1;
	}

	if(isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setautoreply [text]");
		return 1;
	}

	new string[128];
	if(strlen(params) >= 1 && strlen(params) < 63)
	{
		format(PlayerInfo[playerid][pAutoTextReply], 64, "%s", params);
		format(string, sizeof(string), "You have changed your autotext response to: %s", params);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "ERROR: Your autotext response must consist of at least 1 character and can't exceed 64 characters.");
	}
	return 1;
}

CMD:call(playerid, params[])
{
	new string[128], phonenumb;

	if(sscanf(params, "d", phonenumb)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /call [phonenumber]");

	if (PlayerInfo[playerid][pJailTime] > 0)
	{
		SendClientMessageEx(playerid,COLOR_GREY,"You can't use your phone while in jail.");
		return 1;
	}
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0)
	{
		SendClientMessageEx(playerid,COLOR_GREY,"You can't use your phone whilist restrained.");
		return 1;
	}
	if(PlayerInfo[playerid][pPnumber] == 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a cell phone.");
		return 1;
	}
	if(PhoneOnline[playerid] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Your phone is off.");
		return 1;
	}
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] > 0) {
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	format(string, sizeof(string), "* %s takes out a cellphone.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	if(phonenumb == 911)
	{
		if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Cannot use this whilist in prison!");
		if(GetPVarType(playerid, "Has911Call")) SendClientMessageEx(playerid, COLOR_GREY, "You can only have one active call at a time. (/cancelcall)");
		else if(PlayerInfo[playerid][p911Muted] != 0) ShowPlayerDialog(playerid, 7955, DIALOG_STYLE_MSGBOX, "Call Blocked", "You are currently blocked from using 911 emergency services. This is generally caused by abuse of services.\n\n((Use /report to report for an unmute))", "Close", "");
		else 
			ShowPlayerDialog(playerid, DIALOG_911MENU, DIALOG_STYLE_LIST, "911 Emergency Services", "Emergency\nMedical\nPolice Assistance (Non-Emergency)\nTowing\nVehicle Burglary (In Progress)\nFire", "Select", "End Call");
		return 1;
	}
	if(phonenumb == 08001800)
	{
		if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Cannot use this whilist in prison!");
		if(GetPVarType(playerid, "Has911Call")) SendClientMessageEx(playerid, COLOR_GREY, "You can only have one active call at a time. (/cancelcall)");
		else 
			ShowPlayerDialog(playerid, DIALOG_NEWSHOTLINE, DIALOG_STYLE_INPUT, "Interglobal News Hotline", "Please let us know briefly about your news.", "Enter", "End Call");
		return 1;
	}
	if(phonenumb == PlayerInfo[playerid][pPnumber])
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You just get a busy tone...");
		return 1;
	}
	if(Mobile[playerid] != INVALID_PLAYER_ID)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already on a call...");
		return 1;
	}
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
			{
				new giveplayerid = i;
				Mobile[playerid] = giveplayerid; //caller connecting
				if(IsPlayerConnected(giveplayerid))
				{
					if(giveplayerid != INVALID_PLAYER_ID)
					{
						if(PhoneOnline[giveplayerid] > 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "That player's phone is switched off.");
							Mobile[playerid] = INVALID_PLAYER_ID;
							return 1;
						}
						if(Mobile[giveplayerid] != INVALID_PLAYER_ID)
						{
							SendClientMessageEx(playerid, COLOR_GRAD2, "You just get a busy tone...");
							Mobile[playerid] = INVALID_PLAYER_ID;
							return 1;
						}
						if(Spectating[giveplayerid]!=0)
						{
							SendClientMessageEx(playerid, COLOR_GRAD2, "You just get a busy tone...");
							Mobile[playerid] = INVALID_PLAYER_ID;
							return 1;
						}
						if (Mobile[giveplayerid] == INVALID_PLAYER_ID)
						{
							format(string, sizeof(string), "Your mobile is ringing - type /p to answer it. [Caller ID: %s]", GetPlayerNameEx(playerid));
							SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);
							RingTone[giveplayerid] = 10;
							format(string, sizeof(string), "* %s's phone begins to ring.", GetPlayerNameEx(i));
							SendClientMessageEx(playerid, COLOR_WHITE, "HINT: You now use T to talk on your cellphone, type /hangup to hang up.");
							ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							new Float:rX, Float:rY, Float:rZ;
							GetPlayerPos(giveplayerid, rX, rY, rZ);
							//SendRingtoneToArea(playerid, 100, rX, rY, rZ);
							//SendAudioToPlayer(playerid, 60, 100);
							CellTime[playerid] = 1;
							SetPlayerAttachedObject(playerid, 8, 330, 6);
							return SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
						}
					}
				}
			}
		}	
	}
	SendClientMessageEx(playerid, COLOR_GRAD2, "Your call can not be completed as dialed, please check the number and try again.");
	return 1;
}

CMD:t(playerid, params[])
{
	return cmd_sms(playerid, params);
}

CMD:txt(playerid, params[])
{
	return cmd_sms(playerid, params);
}

CMD:sms(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You haven't logged in yet!");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pPnumber] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "  You don't have a cell phone.");
	if(PhoneOnline[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Your phone is off.");
	if(GetPVarInt(playerid, "Injured") != 0 || PlayerInfo[playerid][pHospital] != 0) return SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use your phone whilist restrained.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You can not use your phone while in jail or prison!");

	new string[128], phonenumb, text[100];
	if(sscanf(params, "ds[100]", phonenumb, text)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/t)ext [phonenumber] [text chat]");

	if(Spectating[playerid] == 0 || !GetPVarType(playerid, "FlyMode"))
	{
		format(string, sizeof(string), "* %s takes out a cellphone.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}

	if(phonenumb == 555)
	{
		if ((strcmp("yes", text, true, strlen(text)) == 0) && (strlen(text) == strlen("yes")))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Text message delivered.");
			SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: I'm watching you, Sender: MOLE (555)");
			//SendAudioToPlayer(playerid, 47, 100);
			RingTone[playerid] = 20;
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: I'm watching you, Sender: MOLE (555)");
			//SendAudioToPlayer(playerid, 47, 100);
			RingTone[playerid] = 20;
			return 1;
		}
	}
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
			{
				new giveplayerid = i;
				if(Mobile[giveplayerid] != INVALID_PLAYER_ID)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "That player's phone is busy (on a call).");
					return 1;
				}
				Mobile[playerid] = giveplayerid; //caller connecting
				if(IsPlayerConnected(giveplayerid))
				{
					if(giveplayerid != INVALID_PLAYER_ID)
					{

						if(PhoneOnline[giveplayerid] > 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "That player's phone is switched off.");
							Mobile[playerid] = INVALID_PLAYER_ID;
							return 1;
						}
						//foreach(new u: Player)
						for(new u = 0; u < MAX_PLAYERS; ++u)
						{
							if(IsPlayerConnected(u))
							{
								if(GetPVarInt(u, "BigEar") == 6 && (GetPVarInt(u, "BigEarPlayer") == playerid || GetPVarInt(u, "BigEarPlayer") == giveplayerid))
								{
									format(string, sizeof(string), "(BE) %s SMS to %s: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), text);
									SendClientMessageEx(u,COLOR_YELLOW, string);
								}
							}	
						}
						if(PlayerInfo[playerid][pPhonePrivacy] == 1)
						{
							format(string, sizeof(string), "SMS: %s, Sender: Unknown.", text, GetPlayerNameEx(playerid));
						}
						else
						{
							format(string, sizeof(string), "SMS: %s, Sender: %s (%d)", text, GetPlayerNameEx(playerid), PlayerInfo[playerid][pPnumber]);
						}

						if(i != playerid)
						{
							if(PlayerInfo[i][pSmslog] > 0)
							{
								new query[384], ftext[128];
								mysql_escape_string(text, ftext);
								if(PlayerInfo[playerid][pPhonePrivacy] == 1) format(query, sizeof(query), "INSERT INTO `sms` (`id`, `sender`, `senderid`, `sendernumber`, `receiver`, `receiverid`, `receivernumber`, `message`, `date`) VALUES (NULL, '%s', %d, 0, '%s', %d, %d, '%s', NOW())", GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), GetPlayerNameExt(i), GetPlayerSQLId(i), phonenumb, ftext);
								else format(query, sizeof(query), "INSERT INTO `sms` (`id`, `sender`, `senderid`, `sendernumber`, `receiver`, `receiverid`, `receivernumber`, `message`, `date`) VALUES (NULL, '%s', %d, %d, '%s', %d, %d, '%s', NOW())", GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pPnumber], GetPlayerNameExt(i), GetPlayerSQLId(i), phonenumb, ftext);
								mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
							}
						}

						//format(string, sizeof(string), "* %s's phone beeps.", sendername);
						RingTone[giveplayerid] =20;
						SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
						SendClientMessageEx(playerid, COLOR_WHITE, "Text Message Delivered");
						format(string, sizeof(string), "~r~$-%d", 25);
						GameTextForPlayer(playerid, string, 5000, 1);
						GivePlayerCash(playerid,-25);
						//PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
						//SendAudioToPlayer(playerid, 47, 100);
						//SendAudioToPlayer(giveplayerid, 47, 100);
						Mobile[playerid] = INVALID_PLAYER_ID;

						if(strcmp(PlayerInfo[giveplayerid][pAutoTextReply], "Nothing", true) != 0)
						{
							format(string, sizeof(string), "SMS: %s, Sender: %s [automated response] (%d)", PlayerInfo[giveplayerid][pAutoTextReply], GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pPnumber]);
							SendClientMessageEx(playerid, COLOR_YELLOW, string);
						}

						return 1;
					}
				}
			}
		}	
	}
	SendClientMessageEx(playerid, COLOR_GRAD2, "  Message delivery failed...");
	return 1;
}

CMD:p(playerid, params[]) {
	return cmd_pickup(playerid, params);
}

CMD:pickup(playerid, params[])
{
	new string[128];
	if(Mobile[playerid] != INVALID_PLAYER_ID)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already on a call...");
		return 1;
	}
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] > 0) {
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(Mobile[i] == playerid)
			{
				Mobile[playerid] = i; //caller connecting
				SendClientMessageEx(i,  COLOR_GRAD2, "   They picked up the call.");
				format(string, sizeof(string), "* %s answers their cellphone.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				RingTone[playerid] = 0;
				SetPlayerAttachedObject(playerid, 8, 330, 6);
				return SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			}
		}	
	}
	return 1;
}

CMD:h(playerid, params[]) {
	return cmd_hangup(playerid, params);
}

CMD:hangup(playerid,params[])
{
	new string[128];
	if(GetPVarInt(playerid, "_UsingJailPhone") == 1) return cmd_jailhangup(playerid, params);
	if(GetPVarInt(playerid, "Injured") != 0||PlayerCuffed[playerid]!=0||PlayerInfo[playerid][pHospital]!=0)
	{
		SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
		return 1;
	}
	new caller = Mobile[playerid];
	if((IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID))
	{
		if(caller < MAX_PLAYERS)
		{
			if(GetPVarInt(caller, "_UsingJailPhone") == 1)
			{
				TogglePlayerControllable(caller, 1);
				DeletePVar(caller, "_UsingJailPhone");
				bJailPhoneUse[GetClosestPrisonPhone(caller)] = false;
			}
			SendClientMessageEx(caller,  COLOR_GRAD2, "   They hung up.");
			format(string, sizeof(string), "* %s puts away their cellphone.", GetPlayerNameEx(caller));
			ProxDetector(30.0, caller, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			CellTime[caller] = 0;
			Mobile[caller] = INVALID_PLAYER_ID;
		}
		CellTime[playerid] = 0;
		SendClientMessageEx(playerid,  COLOR_GRAD2, "   You hung up.");
		format(string, sizeof(string), "* %s puts away their cellphone.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		Mobile[playerid] = INVALID_PLAYER_ID;
		CellTime[playerid] = 0;
		RingTone[playerid] = 0;
		RemovePlayerAttachedObject(playerid, 8);
		RemovePlayerAttachedObject(caller, 8);
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		return 1;
	}
	SendClientMessageEx(playerid,  COLOR_GRAD2, "   Your phone is in your pocket.");
	return 1;
}
