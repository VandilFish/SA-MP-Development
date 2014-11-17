/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Speedo System

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

/*CMD:speedo(playerid, params[]) {
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
		SendClientMessageEx(playerid, COLOR_GREY, "You're not driving a vehicle.");
	}
	else if(!PlayerInfo[playerid][pSpeedo]) {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled your speedometer.");
		PlayerInfo[playerid][pSpeedo] = 1;

		if(!FindTimePoints[playerid] && arr_Engine{GetPlayerVehicleID(playerid)} != 0) {

			new
				szSpeed[42];

			format(szSpeed, sizeof(szSpeed),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%.0f MPH", player_get_speed(playerid));
			GameTextForPlayer(playerid, szSpeed, 1500, 3);
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled your speedometer.");
		PlayerInfo[playerid][pSpeedo] = 0;
		if(!FindTimePoints[playerid] && arr_Engine{GetPlayerVehicleID(playerid)} != 0) GameTextForPlayer(playerid, " ", 1500, 3);
	}
	return 1;
} // old speedometer */

CMD:speedopos(playerid, params[])
{
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER )
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You're not driving a vehicle.");
	}
	if (PlayerInfo[playerid][pSpeedo])
	{
		new Float: TPosX[2], Float:TPosY[2];
		if(!sscanf(params, "ff", TPosX[0], TPosY[0]))
		{
			if(TPosX[0] < 0 || TPosX[0] > 640)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /speedopos (optional) [X] [Y]");
				return SendClientMessageEx(playerid, COLOR_GREY, "X must be above 0 and below 640");
			}
			if(TPosY[0] < 0 || TPosY[0] > 640)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /speedopos (optional) [X] [Y]");
				return SendClientMessageEx(playerid, COLOR_GREY, "Y must be above 0 and below 480");
			}
			TPosX[1] = TPosX[0] + 60.0;
			TPosY[1] = TPosY[0] + 17.0;
		}
		else
		{
			switch(GetPVarInt(playerid, "SpeedoPos"))
			{
				case 0:
				{
					TPosX[0] = 495.0;
					TPosY[0] = 20.0;
					TPosX[1] = 555.0;
					TPosY[1] = 37.0;
					SetPVarInt(playerid, "SpeedoPos", 1);				
				}
				case 1:
				{
					TPosX[0] = 495.0;
					TPosY[0] = 367.0;
					TPosX[1] = 555.0;
					TPosY[1] = 384.0;
					SetPVarInt(playerid, "SpeedoPos", 2);				
				}			
				case 2:
				{
					TPosX[0] = 495.0;
					TPosY[0] = 133.0;
					TPosX[1] = 555.0;
					TPosY[1] = 150.0;
					SetPVarInt(playerid, "SpeedoPos", 0);
				}
			}
		}
		
		PlayerTextDrawDestroy(playerid, _vhudTextFuel[playerid]);
		_vhudTextFuel[playerid] = CreatePlayerTextDraw(playerid, TPosX[0], TPosY[0], "~b~Fuel: N/A");
		PlayerTextDrawBackgroundColor(playerid, _vhudTextFuel[playerid], 255);
		PlayerTextDrawFont(playerid, _vhudTextFuel[playerid], 1);
		PlayerTextDrawLetterSize(playerid, _vhudTextFuel[playerid], 0.270000, 2.000000);
		PlayerTextDrawColor(playerid, _vhudTextFuel[playerid], -1);
		PlayerTextDrawSetOutline(playerid, _vhudTextFuel[playerid], 1);
		PlayerTextDrawSetProportional(playerid, _vhudTextFuel[playerid], 1);

		PlayerTextDrawDestroy(playerid, _vhudTextSpeed[playerid]);
		_vhudTextSpeed[playerid] = CreatePlayerTextDraw(playerid, TPosX[1], TPosY[0], "~b~MPH: N/A");
		PlayerTextDrawBackgroundColor(playerid, _vhudTextSpeed[playerid], 255);
		PlayerTextDrawFont(playerid, _vhudTextSpeed[playerid], 1);
		PlayerTextDrawLetterSize(playerid, _vhudTextSpeed[playerid], 0.270000, 2.000000);
		PlayerTextDrawColor(playerid, _vhudTextSpeed[playerid], -1);
		PlayerTextDrawSetOutline(playerid, _vhudTextSpeed[playerid], 1);
		PlayerTextDrawSetProportional(playerid, _vhudTextSpeed[playerid], 1);

		PlayerTextDrawDestroy(playerid, _vhudSeatBelt[playerid]);
		_vhudSeatBelt[playerid] = CreatePlayerTextDraw(playerid, TPosX[1], TPosY[1], "~b~SB: ~r~OFF");
		PlayerTextDrawBackgroundColor(playerid, _vhudSeatBelt[playerid], 255);
		PlayerTextDrawFont(playerid, _vhudSeatBelt[playerid], 1);
		PlayerTextDrawLetterSize(playerid, _vhudSeatBelt[playerid], 0.270000, 2.000000);
		PlayerTextDrawColor(playerid, _vhudSeatBelt[playerid], -1);
		PlayerTextDrawSetOutline(playerid, _vhudSeatBelt[playerid], 1);
		PlayerTextDrawSetProportional(playerid, _vhudSeatBelt[playerid], 1);

		PlayerTextDrawDestroy(playerid, _vhudLights[playerid]);
		_vhudLights[playerid] = CreatePlayerTextDraw(playerid, TPosX[0], TPosY[1], "~b~Lights: ~r~OFF");
		PlayerTextDrawBackgroundColor(playerid, _vhudLights[playerid], 255);
		PlayerTextDrawFont(playerid, _vhudLights[playerid], 1);
		PlayerTextDrawLetterSize(playerid, _vhudLights[playerid], 0.270000, 2.000000);
		PlayerTextDrawColor(playerid, _vhudLights[playerid], -1);
		PlayerTextDrawSetOutline(playerid, _vhudLights[playerid], 1);
		PlayerTextDrawSetProportional(playerid, _vhudLights[playerid], 1);
		
		ShowVehicleHUDForPlayer(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have moved the position of your speedometer.");

	}
	return 1;
}

CMD:speedo(playerid, params[])
{
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER )
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not driving a vehicle.");
	}
	else if (!PlayerInfo[playerid][pSpeedo])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled your speedometer.");
		PlayerInfo[playerid][pSpeedo] = 1;
		ShowVehicleHUDForPlayer(playerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled your speedometer.");
		PlayerInfo[playerid][pSpeedo] = 0;
		HideVehicleHUDForPlayer(playerid);
	}

	return 1;
} // new speedometer
