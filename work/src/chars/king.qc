/*
+--------+
|King    |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| The King / Teleportation System (trigger_transport)                        |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

//===
// trigger transporter room
//===

void() transporter_touch =
{
	local string line, x;
	
	// Only host/player 1 can interact
	if (other.owner.playerid != 1)
		return;

	if (other.owner.button0 && self.mode == 0 && self.pain_finished < time)
	{
		centerprint (other.owner, "");
		other.owner.conversation = TRUE;
		self.cnt = 0; // reset default topic
		self.selection = TRUE;
		sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
		self.mode = 1;
		other.owner.currentshrine = IT_SHRINE0; // reset shrine selection
		self.pain_finished = time + 1; // Won't talk to user again for a second

		float f = fopen("teleport.txt", FILE_READ);	// Open "teleport" file for reading
		if((line = fgets(f)))
		fclose(f);

		//
		// Add missing shrines on first open & congratulate the player
		//
		
		if (!shrine_progress & IT_SHRINE1)
		{
			if (line == "castle")
			{
				shrine_progress = shrine_progress | IT_SHRINE1; // give shrine location
				setpause(1);
				centerprint (other.owner, "/P^bKharlia Castle Shrine Unlocked^b\n\n===========================\n\n^1You may now warp to the current area as well as Kharlia Village. Warping from Kharlia Village back to the Transporter Shrine will cost gold.\n\n\n^3Press ATTACK or JUMP to resume ...");
				self.mode = 0;
				self.cnt = 0;
			}
		}

		if (!shrine_progress & IT_SHRINE2)
		{
			// Ignore the compiler warning and DON'T REMOVE this line
			f = fopen("teleport.txt", FILE_READ);	// Open "teleport" file for reading
			if((line = fgets(f)))
			fclose(f);

			if (line == "cavern")
			{
				shrine_progress = shrine_progress | IT_SHRINE2; // give shrine location
				setpause(1);
				centerprint (other.owner, "/P^bCursed Cavern Shrine Unlocked^b\n\n===========================\n\n\n^1You may now warp to the current area as well as Kharlia Village. Warping from Kharlia Village back to the Transporter Shrine will cost gold.\n\n\n^3Press ATTACK or JUMP to resume ...");
				self.mode = 0;
				self.cnt = 0;
			}
		}

		if (!shrine_progress & IT_SHRINE3)
		{
			// Ignore the compiler warning and DON'T REMOVE this line
			f = fopen("teleport.txt", FILE_READ);	// Open "teleport" file for reading
			if((line = fgets(f)))
			fclose(f);

			if (line == "gcathedrl")
			{
				shrine_progress = shrine_progress | IT_SHRINE3; // give shrine location
				setpause(1);
				centerprint (other.owner, "/P^bGrand Cathedral Shrine Unlocked^b\n\n===========================\n\n\n^1You may now warp to the current area as well as Kharlia Village. Warping from Kharlia Village back to the Transporter Shrine will cost gold.\n\n\n^3Press ATTACK or JUMP to resume ...");
				self.mode = 0;
				self.cnt = 0;
			}
		}
	}

	if (self.mode == 1) // Init on
	{
		shrineHUD_on = TRUE;
		//centerprint (other.owner, "/P^5My dear Vigil, although I have perished from flesh and blood I am still able lend assistance from this spirtual plane. I still possess enough power to transfer your essense to various shrine rooms around my former kingdom.\n\nWhere would you make haste to?^7\n");

		if (other.owner.keyflags & (KEY_RIGHT | KEY_LEFT) || other.owner.button2 || other.owner.button3) // Turn off
		{
			other.owner.FL_JMPPRESSED = TRUE; // Don't allow jump on menu close with button2
			shrineHUD_on = FALSE;
			self.mode = 0; // Not chatting anymore
			self.cnt = 0; // reset default topic
			other.owner.conversation = FALSE;
			self.pain_finished = time + 1; // Won't talk to user again for a second
			sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);	
			return;
		}

		// Shrine scrolling here
		if (other.owner.keyflags & (KEY_UP | KEY_DOWN))
		{
			if (other.owner.keyflags & (KEY_UP) && self.selection_up == FALSE)
			{
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);

				if (other.owner.currentshrine == IT_SHRINE0) // Currently on village
				{
					if (shrine_progress & IT_SHRINE3) // Start checking bottom up
						other.owner.currentshrine = IT_SHRINE3;
					else // Not found, cycle to next ...
					{
						if (shrine_progress & IT_SHRINE2)
							other.owner.currentshrine = IT_SHRINE2;
						else if (shrine_progress & IT_SHRINE1)
							other.owner.currentshrine = IT_SHRINE1;
						else
							other.owner.currentshrine = IT_SHRINE0;
					}
				}
				else if (other.owner.currentshrine == IT_SHRINE3)
				{
					if (shrine_progress & IT_SHRINE2)
						other.owner.currentshrine = IT_SHRINE2;
					else // Not found, cycle to next ...
					{
						if (shrine_progress & IT_SHRINE1)
							other.owner.currentshrine = IT_SHRINE1;
						else
							other.owner.currentshrine = IT_SHRINE0;						
					}
				}
				else if (other.owner.currentshrine == IT_SHRINE2)
				{
					if (shrine_progress & IT_SHRINE1)
						other.owner.currentshrine = IT_SHRINE1;
					else // Not found, cycle to next ...
							other.owner.currentshrine = IT_SHRINE0;
				}
				else if (other.owner.currentshrine == IT_SHRINE1)
						other.owner.currentshrine = IT_SHRINE0;

				self.selection_up = TRUE;
			}
			// Key down scrolling
			else if (other.owner.keyflags & (KEY_DOWN) && self.selection_down == FALSE)
			{
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);

				if (other.owner.currentshrine == IT_SHRINE0) // Currently on village
				{
					if (shrine_progress & IT_SHRINE1) // Start checking top down
						other.owner.currentshrine = IT_SHRINE1;
					else // Not found, cycle to next ...
					{
						if (shrine_progress & IT_SHRINE2)
							other.owner.currentshrine = IT_SHRINE2;
						else if (shrine_progress & IT_SHRINE3)
							other.owner.currentshrine = IT_SHRINE3;
						else
							other.owner.currentshrine = IT_SHRINE0;
					}
				}
				else if (other.owner.currentshrine == IT_SHRINE1)
				{
					if (shrine_progress & IT_SHRINE2) // Start checking top down
						other.owner.currentshrine = IT_SHRINE2;
					else // Not found, cycle to next ...
					{
						if (shrine_progress & IT_SHRINE3)
							other.owner.currentshrine = IT_SHRINE3;
						else if (!shrine_progress & IT_SHRINE3)
							other.owner.currentshrine = IT_SHRINE0;
					}
				}
				else if (other.owner.currentshrine == IT_SHRINE2)
				{
					if (shrine_progress & IT_SHRINE3) // Start checking top down
						other.owner.currentshrine = IT_SHRINE3;
					else // Not found, cycle to next ...
							other.owner.currentshrine = IT_SHRINE0;
				}
				else if (other.owner.currentshrine == IT_SHRINE3)
					other.owner.currentshrine = IT_SHRINE0;

				self.selection_down = TRUE;
			}
		}
		else // Remove key depresses
		{
			self.selection_up = FALSE;
			self.selection_down = FALSE;
		}
		// Debugging bprints
		//local string g = ftos(other.owner.currentshrine);
		//bprint ("Current Shrine: ", g, "\n");
	}

	if (other.owner.button0 && self.mode == 1)
	{
		if (self.selection == FALSE)
		{
			stuffcmd (other.owner, "wf\n");
			cvar_set("gamecfg", "99");
			
			if (other.owner.currentshrine == IT_SHRINE0) // Woosh!
			{				
				float v = fopen("teleport.txt", FILE_WRITE);
				if (v >= 0)
				{
					fputs(v, "village", "\n");
					fclose(v);
				}
			}
			if (other.owner.currentshrine == IT_SHRINE1) // Woosh!
			{				
				float z = fopen("teleport.txt", FILE_WRITE);
				if (z >= 0)
				{
					fputs(z, "castle", "\n");
					fclose(z);
				}
			}
			if (other.owner.currentshrine == IT_SHRINE2) // Woosh!
			{				
				float c = fopen("teleport.txt", FILE_WRITE);
				if (c >= 0)
				{
					fputs(c, "cavern", "\n");
					fclose(c);
				}
			}
			if (other.owner.currentshrine == IT_SHRINE3) // Woosh!
			{				
				float n = fopen("teleport.txt", FILE_WRITE);
				if (n >= 0)
				{
					fputs(n, "gcathedrl", "\n");
					fclose(n);
				}
			}
			shrineHUD_on = FALSE;
			self.mode = 0; // Not chatting anymore
			self.cnt = 0; // reset default topic
			other.owner.conversation = FALSE;
			self.pain_finished = time + 1; // Won't talk to user again for a second
			sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);			
		}
 		self.selection = TRUE;
	}
	else
		self.selection = FALSE;
};

void() trigger_transport =
{
	precache_sound("misc/menu1.wav");
	precache_sound("misc/menu2.wav");
	self.solid = SOLID_TRIGGER;
	InitTrigger ();
	self.touch = transporter_touch;
};