/*
+---------+
|Lightning|
+---------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Ambient lightning for the castle map is done here                          |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

void() lightning;
float lightning_strikes; // only allow so many lightning strikes (one) at a time
				         // otherwise dire consequences can occur

void() light_reset =
{
	lightstyle(0, "m");
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	lightstyle(4, "mamamamamama");
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	lightstyle(6, "nmonqnmomnmomomno");
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	lightstyle(9, "aaaaaaaazzzzzzzz");
	lightstyle(10, "mmamammmmammamamaaamammma");
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	lightstyle(63, "a");
};

void() full_bright =
{
	lightstyle(0, "z");
	lightstyle(1, "z");
	lightstyle(2, "z");
	lightstyle(3, "z");
	lightstyle(4, "z");
	lightstyle(5,"z");
	lightstyle(6, "z");
	lightstyle(7, "z");
	lightstyle(8, "z");
	lightstyle(9, "z");
	lightstyle(10, "z");
	lightstyle(11, "z");
	lightstyle(63, "z");
};

void() lightning_strike =
{
	local vector targ;

	if (random() < 0.2 && !lightning_strikes)
	{
		lightning_strikes = TRUE;
		self.cnt = TRUE;

		targ = self.origin - '0 0 9999';
		targ_x = (targ_x + RandomRange (-50, 50));
		targ_y = (targ_y + RandomRange (-50, 50));
		
		if (random() <= 0.5)
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity (MSG_BROADCAST, self);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
			WriteCoord (MSG_BROADCAST, targ_x);
			WriteCoord (MSG_BROADCAST, targ_y);
			WriteCoord (MSG_BROADCAST, targ_z);
		}
		else
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LIGHTNING3);
			WriteEntity (MSG_BROADCAST, self);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
			WriteCoord (MSG_BROADCAST, targ_x);
			WriteCoord (MSG_BROADCAST, targ_y);
			WriteCoord (MSG_BROADCAST, targ_z);
		}
	}

	if (self.cnt == TRUE)
	{
		lightning_strikes = FALSE;
		self.cnt = FALSE;
	}

	if (!deathmatch && !coop)
		light_reset();

	self.think = lightning;
	self.nextthink = time + 0.1;
};

/*QUAKED lightning (0 1 0) (-10 -10 -10) (10 10 10)
Lightning entity effective for stormy weather ambience
*/
void() lightning =
{
	local float f = cvar("r_shadow_realtime_dlight");
	if (random() < 0.1 && !coop && !deathmatch && !f && framecount > 30)
		full_bright();

	self.think = lightning_strike;
	self.nextthink = time + 5 + random()*15;
};