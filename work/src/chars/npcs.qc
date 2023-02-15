//+------+
//|NPCS  |
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Non-playable characters and their respective coding all goes here.         |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() npc_default =
{
	local vector view;
	local entity y;

	if (!self.enemy)
	{
		y = find(world, classname, "player");
		while(y)
		{
			if (y.classname == "player" && range(self, y) < RANGE_NEAR && !y.owner.conversation && !y.enemy)
			{
				self.enemy = y;
				y.enemy = self;
				self.enemy.owner.safezone = TRUE;
			}
			y = find(y, classname, "player");
		}

		//
		// NPC is standing around
		//

		if (self.state < time && self.fixangle == FALSE)
		{
			if (random() < 0.5)
			{
				if (random() < 0.35)
					self.angles_y = self.angles_y + 15;
				else
					self.angles_y = self.angles_y - 15;
				self.state = time + 3 + random()*3;
			}
		}

		//
		// NPC is able to walk, but decides to randomly stand and look around
		// Movemode 0 = Walking, otherwise standing
		//

		if (self.speed > 0)
		{
			if (self.npcmove_finished < time)
			{
				if (self.npcmove_mode == 0)
					self.npcmove_mode = 1;
				else
					self.npcmove_mode = 0;
				self.npcmove_finished = time + 2 + random()*3;
			}

			// NPC Moves
			if (self.npcmove_mode == 1)
			{
				local float testdir;

				testdir = walkmove(self.angles_y, self.speed);
				if (testdir == FALSE)
				{
					if (self.npcturn_dir == 0)
					{
						if (random() < 0.5)
							self.npcturn_dir = 1;
						else
							self.npcturn_dir = 2;
					}
					else
					{
						if (self.npcturn_dir == 1)
							self.angles_y = self.angles_y + 3;
						else
							self.angles_y = self.angles_y - 3;
					}
				}
				else
					self.npcturn_dir = 0;

				if (self.state < time)
				{
					if (random() < 0.5)
						self.angles_y = self.angles_y + 25;
					else
						self.angles_y = self.angles_y - 25;
					self.state = time + 0.3 + random()*1;
				}
				ai_forward(self.speed);
				self.frame = 1;
			}
			else
				self.frame = 0;
		}
	}
	else
	{
		self.frame = 0;
		self.npcmove_mode = 0;
		self.npcmove_finished = time;
		if (self.enemy.enemy == self)
		{
			if (range(self, self.enemy) < RANGE_NEAR)
			{
				view = vectoangles(self.enemy.origin - self.origin);
				self.angles_y = view_y;
				self.fixangle = TRUE;
				if ((self.enemy.owner.button0 && self.pain_finished < time) || self.mode == 1)
				{
					if (self.enemy.owner.button0 && self.mode == 0)
					{
						self.cnt = 0; // reset default topic
						self.selection = TRUE;
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					}
					if (self.npc_talk)
					{
						self.mode = 1;
						self.npc_talk();
					}
				}
			}
			else
			{
				self.mode = 0; // Not chatting anymore
				if (self.npc_talk)
					self.npc_talk();
				if (self.fixangle == TRUE)
				{
					self.angles_y = self.score; // self.score holds snap back angle
					self.fixangle = FALSE;
				}
				self.enemy.owner.conversation = FALSE;
				self.enemy.owner.safezone = FALSE;
				self.enemy = self.enemy.enemy = world;
			}
		}
	}

	frameskip(0.01);
};

// Mode 0, not chatting
// Mode 1, chatting
void() blacksmith_chat =
{
	local float aprice, sprice;
	
	if (!self.enemy)
		return;
	
	if (self.mode == 0 && self.enemy.owner.conversation == TRUE) // Say good bye to player!
	{
		centerprint (self.enemy.owner, "Take care Vigil, I bid you well on your quest.");
		self.enemy.owner.display_price = 0; // clear on-screen price
	}
	else if (self.mode == 1)
	{
		self.enemy.owner.conversation = TRUE;

		if (self.cnt == 0)
		{
			if (self.enemy.owner.armorlevel == 0)
				aprice = self.enemy.owner.display_price = 1000;
			else if (self.enemy.owner.armorlevel == 1)
				aprice = self.enemy.owner.display_price = 5000;
			else if (self.enemy.owner.armorlevel == 2)
				aprice = self.enemy.owner.display_price = 12500;
			else if (self.enemy.owner.armorlevel == 3)
				aprice = self.enemy.owner.display_price = 30000;
			else
				aprice = self.enemy.owner.display_price = 0;
		}
		else if (self.cnt == 1)
		{
			if (self.enemy.owner.swordlevel == 0)
				sprice = self.enemy.owner.display_price = 1000;
			else if (self.enemy.owner.swordlevel == 1)
				sprice = self.enemy.owner.display_price = 7000;
			else if (self.enemy.owner.swordlevel == 2)
				sprice = self.enemy.owner.display_price = 18000;
			else if (self.enemy.owner.swordlevel == 3)
				sprice = self.enemy.owner.display_price = 30000;
			else
				sprice = self.enemy.owner.display_price = 0;
		}
		else
			self.enemy.owner.display_price = 0; // clear on-screen price

		if (self.chatrefresh_finished < time)
		{
			if (self.cnt == 0)
				centerprint (self.enemy.owner, "/PGreetings Vigil! Glad you've returned to Kharlia,\nhow may I help you?\n\n===========================\n\n\nç^bBuy an armor upgrade^b\n      Upgrade Vol'Brand\n                   Leave\n");
			else if (self.cnt == 1)
				centerprint (self.enemy.owner, "/PGreetings Vigil! Glad you've returned to Kharlia,\nhow may I help you?\n\n===========================\n\n\n  Buy an armor upgrade\nç    ^bUpgrade Vol'Brand^b\n                   Leave\n");
			else if (self.cnt == 2)
				centerprint (self.enemy.owner, "/PGreetings Vigil! Glad you've returned to Kharlia,\nhow may I help you?\n\n===========================\n\n\n  Buy an armor upgrade\n      Upgrade Vol'Brand\nç                 ^bLeave^b\n");

			self.chatrefresh_finished = time + 0.1;
		}

		//
		// User menu control
		//

		if (self.enemy.owner.keyflags & KEY_UP)
		{
			if (self.selection_up == FALSE)
			{
				self.cnt = self.cnt - 1;
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
			}
			self.chatrefresh_finished = time;
			self.selection_up = TRUE;
		}
		else
			self.selection_up = FALSE;

		if (self.enemy.owner.keyflags & KEY_DOWN)
		{
			if (self.selection_down == FALSE)
			{
				self.cnt = self.cnt + 1;
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
			}
			self.chatrefresh_finished = time;
			self.selection_down = TRUE;
		}
		else
			self.selection_down = FALSE;

		//
		// User menu selection
		//

		if (self.enemy.owner.button0)
		{
			if (self.selection == FALSE)
			{
				if (self.cnt == 0) // User purchases an armor upgrade
				{
					if (self.enemy.owner.gold >= aprice && self.enemy.owner.armorlevel < 4)
					{
						self.enemy.owner.armorlevel = self.enemy.owner.armorlevel + 1;
						DisplayArmor(self.enemy);
						sound (self.enemy.owner, CHAN_AUTO, "misc/levelup2.wav", 1, ATTN_NORM);
						self.enemy.owner.gold = self.enemy.owner.gold - aprice; // remove gold

						//End Convo
						self.mode = 0; // Not chatting anymore
						self.enemy.owner.display_price = 0; // clear on-screen price
						self.cnt = 0; // reset default topic
						self.enemy.owner.conversation = FALSE;
						centerprint (self.enemy.owner, "\n");
						self.pain_finished = time + 1; // Won't talk to user again for a second
					}
					else
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}

				if (self.cnt == 1) // User purchases Vol'Brand upgrade
				{
					if (self.enemy.owner.gold >= sprice && self.enemy.owner.swordlevel < 4)
					{
						self.enemy.owner.swordlevel = self.enemy.owner.swordlevel + 1;
						DisplaySword(self.enemy);
						sound (self.enemy.owner, CHAN_AUTO, "misc/levelup2.wav", 1, ATTN_NORM);
						self.enemy.owner.gold = self.enemy.owner.gold - sprice; // remove gold
						
						//End Convo
						self.mode = 0; // Not chatting anymore
						self.enemy.owner.display_price = 0; // clear on-screen price
						self.cnt = 0; // reset default topic
						self.enemy.owner.conversation = FALSE;
						centerprint (self.enemy.owner, "\n");
						self.pain_finished = time + 1; // Won't talk to user again for a second
					}
					else
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}

				if (self.cnt == 2) // User leaves conversation screen
				{
					self.mode = 0; // Not chatting anymore
					self.enemy.owner.display_price = 0; // clear on-screen price
					self.cnt = 0; // reset default topic
					self.enemy.owner.conversation = FALSE;
					centerprint (self.enemy.owner, "\n");
					self.pain_finished = time + 1; // Won't talk to user again for a second
					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					self.enemy = self.enemy.enemy = world;
				}
			}
 			self.selection = TRUE;
		}
		else
 			self.selection = FALSE;

		// Prevent menu overflow
		if (self.cnt > 2)
			self.cnt = 0;
		if (self.cnt < 0)
			self.cnt = 2;
	}
};

// Mode 0, not chatting
// Mode 1, chatting
void() priest_chat =
{
	local string h;
		
	if (!self.enemy)
		return;
	
	if (self.mode == 0 && self.enemy.owner.conversation == TRUE) // Say good bye to player!
	{
		centerprint (self.enemy.owner, "May god guide you on the path to righteousness!");
		self.enemy.owner.display_price = 0; // hide display
	}
	else if (self.mode == 1)
	{
		//
		// Show players experience / Next level experience
		//

		local float NextLevelExp;
		NextLevelExp = self.enemy.owner.level + 18 * self.enemy.owner.level;
		h = ftos(NextLevelExp);

		local string g;
		g = ftos(self.enemy.owner.experience);

		self.enemy.owner.conversation = TRUE;

		if (self.chatrefresh_finished < time)
		{
			if (self.cnt2 == 0)
				centerprint (self.enemy.owner, "/PYou're safe within the confines of this church, what do you seek brother?\n\n===========================\n\n^bç      Ask for a blessing^b\n          Record progress\n              Refill Flask\n   Upgrade Health Flask\n                   Leave\n\n","^3   Experience: ", g, " / ", h);
			else if (self.cnt2 == 1)
				centerprint (self.enemy.owner, "/PYou're safe within the confines of this church, what do you seek brother?\n\n===========================\n\n        Ask for a blessing\n^bç         Record progress^b\n              Refill Flask\n   Upgrade Health Flask\n                   Leave\n\n","^3   Experience: ", g, " / ", h);
			else if (self.cnt2 == 2)
				centerprint (self.enemy.owner, "/PYou're safe within the confines of this church, what do you seek brother?\n\n===========================\n\n        Ask for a blessing\n          Record progress\n^bç             Refill Flask^b\n   Upgrade Health Flask\n                   Leave\n\n","^3   Experience: ", g, " / ", h);
			else if (self.cnt2 == 3)
				centerprint (self.enemy.owner, "/PYou're safe within the confines of this church, what do you seek brother?\n\n===========================\n\n        Ask for a blessing\n          Record progress\n              Refill Flask\n^bç  Upgrade Health Flask^b\n                   Leave\n\n","^3   Experience: ", g, " / ", h);
			else if (self.cnt2 == 4)
				centerprint (self.enemy.owner, "/PYou're safe within the confines of this church, what do you seek brother?\n\n===========================\n\n        Ask for a blessing\n          Record progress\n              Refill Flask\n   Upgrade Health Flask\n^bç                  Leave^b\n\n","^3   Experience: ", g, " / ", h);

			self.chatrefresh_finished = time + 0.1;
		}

		// Flask Refill
		if (self.cnt2 == 2)
		{
			local float rprice;
			rprice = 2 * (self.enemy.owner.hflask_max_amt / 1.25);
			self.enemy.owner.display_price = rprice;
		}

		// Flask Upgrade
		if (self.cnt2 == 3)
		{
			local float hprice;
			hprice = 14 * (self.enemy.owner.hflask_max_amt / 1.25);
			self.enemy.owner.display_price = hprice;
		}

		if (self.cnt2 != 2 && self.cnt2 != 3)
			self.enemy.owner.display_price = 0; // hide CSQC display
			
		//
		// User menu control
		//

		if (self.enemy.owner.keyflags & KEY_UP)
		{
			if (self.selection_up == FALSE)
			{
				self.cnt2 = self.cnt2 - 1;
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
			}
			self.chatrefresh_finished = time;
			self.selection_up = TRUE;
		}
		else
			self.selection_up = FALSE;

		if (self.enemy.owner.keyflags & KEY_DOWN)
		{
			if (self.selection_down == FALSE)
			{
				self.cnt2 = self.cnt2 + 1;
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
			}
			self.chatrefresh_finished = time;
			self.selection_down = TRUE;
		}
		else
			self.selection_down = FALSE;

		//
		// User menu selection
		//

		if (self.enemy.owner.button0)
		{
			if (self.selection == FALSE)
			{
				if (self.cnt2 == 0) // User receives a blessing of health and mana
				{
					self.enemy.owner.display_price = 0;
					self.cnt = self.enemy.max_health;
					self.enemy.health = self.enemy.max_health;
					//self.enemy.owner.mana = self.enemy.max_mana;
					sound (self.enemy.owner, CHAN_AUTO, "misc/levelup2.wav", 1, ATTN_NORM);
					self.mode = 0; // Not chatting anymore
					self.cnt2 = 0; // reset default topic
					self.enemy.owner.conversation = FALSE;
					centerprint (self.enemy.owner, "\n");
					
					item_health_CSQC_draw(); // heh
					
					self.pain_finished = time + 1;
				}
				if (self.cnt2 == 1) // Open Save Menu
				{
					self.enemy.owner.display_price = 0;
					localcmd("menu_save\n");
				}
				if (self.cnt2 == 2)
				{
					if (self.enemy.owner.gold >= rprice && self.enemy.owner.hflask_amt < self.enemy.owner.hflask_max_amt)
					{
						self.enemy.owner.display_price = 0;						
						setpause (1);
						centerprint (self.enemy.owner, "/P^bFlask Refilled!^b\n\n===========================\n\n\n^1Flask refilled, your contribution is appreciated.\n\n\n\n^3Press ATTACK or JUMP to resume ...\n");
						sound (self, CHAN_AUTO, "misc/potland.wav", 1, ATTN_NORM);
						self.enemy.owner.hflask_amt = self.enemy.owner.hflask_max_amt;
						self.enemy.owner.gold = self.enemy.owner.gold - rprice;
					}
					else
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}
				if (self.cnt2 == 3)
				{
					if (self.enemy.owner.gold >= hprice && self.enemy.owner.hflask_max_amt < 200)
					{
						self.enemy.owner.display_price = 0;						
						setpause (1);
						centerprint (self.enemy.owner, "/P^bFlask Upgraded!^b\n\n===========================\n\n\n^1Additional reserve health has been added to your flask by 5 hit points.\n\n\n\n^3Press ATTACK or JUMP to resume ...\n");
						self.enemy.owner.hflask_max_amt = self.enemy.owner.hflask_max_amt + 5;
						sound (self, CHAN_AUTO, "misc/potland.wav", 1, ATTN_NORM);
						self.enemy.owner.gold = self.enemy.owner.gold - hprice;
					}
					else
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}
				if (self.cnt2 == 4) // User leaves conversation screen
				{
					self.enemy.owner.display_price = 0;
					self.mode = 0; // Not chatting anymore
					self.cnt2 = 0; // reset default topic
					self.enemy.owner.conversation = FALSE;
					centerprint (self.enemy.owner, "\n");
					self.pain_finished = time + 1; // Won't talk to user again for a second
					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					self.enemy = self.enemy.enemy = world;
				}
			}
			self.selection = TRUE;
		}
		else
			self.selection = FALSE;

		// Prevent menu overflow
		if (self.cnt2 > 4)
			self.cnt2 = 0;
		if (self.cnt2 < 0)
			self.cnt2 = 4;
	}
};

// Mode 0, not chatting
// Mode 1, chatting
void() guard_chat =
{
	if (!self.enemy)
		return;
	
	if (self.mode == 0 && self.enemy.owner.conversation == TRUE) // Say good bye to player!
	{
		if (random() < 0.25)
			centerprint (self.enemy.owner, "Fare thee well Vigil! Knights honor guide you!\n");
		else if (random() < 0.5)
			centerprint (self.enemy.owner, "The kings guard and your brethern bid you victory on your quest.\n");
		else if (random() < 0.75)
			centerprint (self.enemy.owner, "Crush our enemies beneath your heel for the sake of the land and our future!\n");
		else if (random() < 1)
			centerprint (self.enemy.owner, "The last of our hopes and dreams lay with you.\n");
	}
	else if (self.mode == 1)
	{
		self.enemy.owner.conversation = TRUE;

		if (self.chatrefresh_finished < time)
		{
			if (self.cnt == 0)
				centerprint (self.enemy.owner, "/PHail Vigil! Kharlia is safe, but for how long?\n\n\n===========================\n\nç ^bAsk for Rumors^b\n             Leave\n");
			else if (self.cnt == 1)
				centerprint (self.enemy.owner, "/PHail Vigil! Kharlia is safe, but for how long?\n\n\n===========================\n\n   Ask for Rumors\nç ^b         Leave^b\n");
			else if (self.cnt == 2)
				centerprint (self.enemy.owner, "/PJust before you set out on your quest the Guard Captain ordered a battalion of us to escort as many women and children towards Prydon as they could, I wonder where they ended up?");
			else if (self.cnt == 3)
				centerprint (self.enemy.owner, "/PI've heard rumors from escapees of ghastly horrors that strange sounds have been heard from the subterranean depths of the castle.");
			else if (self.cnt == 4)
				centerprint (self.enemy.owner, "/POur kingdom has been known as a pioneer of magic spell books and ability enhancing relics, mayhaps you should seek them out?");
			else if (self.cnt == 5)
				centerprint (self.enemy.owner, "/PSome good news in cruel times as Prince Ithael has been born from our neighboring kingdom.");
			else if (self.cnt == 6)
				centerprint (self.enemy.owner, "/PAs you can tell our kingdom has suffered greatly in such a short time, some areas have become completely unrecognizable as if changed by wicked magic");
			else if (self.cnt == 7)
				centerprint (self.enemy.owner, "/PI hear the subterranean bowels of Kharlia have hidden secrets, but be wary of danger!");
			else if (self.cnt == 8)
				centerprint (self.enemy.owner, "/PA resounding crash was heard throughout the land, hast something happened? I feel a sense of joy ...");
			else if (self.cnt == 9)
				centerprint (self.enemy.owner, "/PWicked howls of wolves have been heard recently, perhaps investigating will yeild rewards?");
			else if (self.cnt == 10)
				centerprint (self.enemy.owner, "/PA Dragon, here you say? Odd, they've only been seen out east across the sea...");
			else if (self.cnt == 11)
				centerprint (self.enemy.owner, "/PNot a single soul has been brave enough to investigate the Aqueducts, perhaps a man of your skill should");
			else if (self.cnt == 12)
				centerprint (self.enemy.owner, "/PBe wary of thick brush, there must be a way to slice through such thickness");
			else if (self.cnt == 13)
				centerprint (self.enemy.owner, "/PRumours are spreading of our great cathedral being defiled, it's sanctity fouled!");

			if (self.cnt >= 2)
			{
				self.mode = 0; // Not chatting anymore
				self.cnt = 0; // reset default topic
				self.enemy.owner.conversation = TRUE; // Guards always say farewell and clears "Rumor" centerprint
				self.pain_finished = time + 1; // Won't talk to user again for a second
			}
				
			self.chatrefresh_finished = time + 0.1;
		}

		//
		// User menu control
		//

		if (self.cnt < 2)
		{
			if (self.enemy.owner.keyflags & KEY_UP)
			{
				if (self.selection_up == FALSE)
				{
					self.cnt = self.cnt - 1;
					sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_up = TRUE;
			}
			else
				self.selection_up = FALSE;

			if (self.enemy.owner.keyflags & KEY_DOWN)
			{
				if (self.selection_down == FALSE)
				{
					self.cnt = self.cnt + 1;
					sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_down = TRUE;
			}
			else
				self.selection_down = FALSE;
		}

		//
		// User menu selection
		//

		if (self.enemy.owner.button0)
		{
			if (self.selection == FALSE)
			{
				if (self.cnt == 0)
				{ 	// self.cnt > 1 // Rumors enabled
					local float ranrum;
					if (!bosses)
						ranrum = random();
					else
					{
						if (bosses & IT_BOSS1)
							ranrum = random()*2;
						if (bosses & IT_BOSS2)
							ranrum = random()*3; // reroll
					}

					if (ranrum < 0.25)
						self.cnt = 2;
					else if (ranrum < 0.5)
						self.cnt = 3;
					else if (ranrum < 0.75)
						self.cnt = 4;
					else if (ranrum < 1)
						self.cnt = 5;
					else if (ranrum < 1.25) // After SGK defeated rumors
						self.cnt = 6;
					else if (ranrum < 1.5)
						self.cnt = 7;
					else if (ranrum < 1.75)
						self.cnt = 8;
					else if (ranrum < 2)
						self.cnt = 9;
					else if (ranrum < 2.25) // After Eternal Dragon
						self.cnt = 10;
					else if (ranrum < 2.5)
						self.cnt = 11;
					else if (ranrum < 2.75)
						self.cnt = 12;
					else if (ranrum < 3)
						self.cnt = 13;
		
					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}
				if (self.cnt == 1) // User leaves conversation screen
				{
					self.mode = 0; // Not chatting anymore
					self.cnt = 0; // reset default topic
					self.enemy.owner.conversation = FALSE;
					centerprint (self.enemy.owner, "\n");
					self.pain_finished = time + 1; // Won't talk to user again for a second
					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					self.enemy = self.enemy.enemy = world;
				}
			}
			self.selection = TRUE;
		}
		else if (self.cnt < 2)
			self.selection = FALSE;

		// Prevent menu overflow
		if (self.selection == FALSE)
		{
			if (self.cnt > 1)
				self.cnt = 0;
			if (self.cnt < 0)
				self.cnt = 1;
		}
	}
};

// Mode 0, not chatting
// Mode 1, chatting
void() lisa_chat =
{
	local float aprice;
	
	if (!self.enemy)
		return;
	
	if (self.enemy.owner)
	{
		if (game_progress & IT_PROGRESS2 && self.chatrefresh_finished < time) // remove centerprint off player
		{
			centerprint (self.enemy.owner, "");
			self.chatrefresh_finished = time + 999999999;
		}
	}
	
	if (self.mode == 0 && self.enemy.owner.conversation == TRUE) // Say good bye to player!
	{
		centerprint (self.enemy.owner, "I'll see you later ...");
		self.enemy.owner.display_price = 0;
	}
	else if (self.mode == 1)
	{
		self.enemy.owner.conversation = TRUE;

		if (self.cnt == 0)
		{
			if (!(game_progress & IT_PROGRESS2) || !(game_progress & IT_PROGRESS4) || !(game_progress & IT_PROGRESS6)) // Cyclone Crush, Diving Swallow, Airzuna Drop
			{
				if (!(game_progress & IT_PROGRESS2))
				{
					centerprint (self.enemy.owner, "/PHey Vigil, been a long time. Care to chat? or how about I teach you some new moves?\n\n===========================\n\nç ^bLearn New Attack^b\n                 Leave");
					aprice = 1000;
					self.enemy.owner.display_price = 1000;
				}
				else if (!(game_progress & IT_PROGRESS4))
				{
					centerprint (self.enemy.owner, "/PHey Vigil, been a long time. Care to chat? or how about I teach you some new moves?\n\n===========================\n\nç ^bLearn New Attack^b\n                 Leave");
					aprice = 4000;
					self.enemy.owner.display_price = 4000;
				}
				else if (!(game_progress & IT_PROGRESS6))
				{
					centerprint (self.enemy.owner, "/PHey Vigil, been a long time. Care to chat? or how about I teach you some new moves?\n\n===========================\n\nç ^bLearn New Attack^b\n                 Leave");
					aprice = 8000;
					self.enemy.owner.display_price = 8000;
				}
			}
			else
				centerprint (self.enemy.owner, "/PVigil! I'm hoping the new attack I've taught you has helped you? Come visit me from time to time and I'll see what else I can teach you.\n");
		}
	    if (self.cnt == 1)
		{
			centerprint (self.enemy.owner, "/PHey Vigil, been a long time. Care to chat? or how about I teach you some new moves?\n\n===========================\n\n   Learn New Attack\nç ^b              Leave^b");
			self.enemy.owner.display_price = 0;
		}

		//
		// User menu control
		//

		if (!(game_progress & IT_PROGRESS2) || !(game_progress & IT_PROGRESS4) || !(game_progress & IT_PROGRESS6)) // Cyclone, Diving Swallow & Airzuna Drop
		{
			if (self.enemy.owner.keyflags & KEY_UP)
			{
				if (self.selection_up == FALSE)
				{
					self.cnt = self.cnt - 1;
					sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_up = TRUE;
			}
			else
				self.selection_up = FALSE;

			if (self.enemy.owner.keyflags & KEY_DOWN)
			{
				if (self.selection_down == FALSE)
				{
					self.cnt = self.cnt + 1;
					sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_down = TRUE;
			}
			else
				self.selection_down = FALSE;
		}

		//
		// User menu selection
		//

		if (self.enemy.owner.button0)
		{
			if (self.selection == FALSE)
			{
				if (self.cnt == 0 && (!(game_progress & IT_PROGRESS2) || !(game_progress & IT_PROGRESS4)|| !(game_progress & IT_PROGRESS6))) // Cyclone, Diving Swallow, Airzuna Drop
				//if (self.cnt == 0 && (cycloneattack == FALSE || divingswallow == FALSE)) // User purchases an attack
				{
					if (self.enemy.owner.gold >= aprice)
					{
						if (!game_progress & IT_PROGRESS2)
						{
							if (bosses & IT_BOSS1) // SGK defeated
							{
								setpause (1);
								centerprint (self.enemy.owner, "/P^bYou've learned Cyclone Crush!^b\n\n===========================\n\n^1Perform this attack by pressing the DOWN, FORWARD + ATTACK button combination\n\n\n\n^3Press ATTACK or JUMP to resume ...\n");

								if (!game_progress & IT_PROGRESS2) // Cyclone Attack
									game_progress = game_progress | IT_PROGRESS2; // Add it (True)

								self.enemy.owner.display_price = 0;
								self.chatrefresh_finished = time + 3; // remove centerprint off player
								sound (self.enemy.owner, CHAN_AUTO, "misc/levelup2.wav", 1, ATTN_NORM);
								self.enemy.owner.gold = self.enemy.owner.gold - aprice; // remove gold
								self.mode = 0; // Not chatting anymore
								self.cnt = 0; // reset default topic
								self.enemy.owner.conversation = FALSE;
								self.pain_finished = time + 1; // Won't talk to user again for a second
							}
							else
							{
								setpause (1);
								centerprint (self.enemy.owner, "/P\n\nSorry Vigil, it appears you're not quite ready yet to learn this technique.\n\n\n\n^3Press ATTACK or JUMP to resume ...\n");
								self.enemy.owner.display_price = 0;
								self.chatrefresh_finished = time + 3; // remove centerprint off player
								self.mode = 0; // Not chatting anymore
								self.cnt = 0; // reset default topic
								self.enemy.owner.conversation = FALSE;
								self.pain_finished = time + 1; // Won't talk to user again for a second
							}
						}
						else if (!game_progress & IT_PROGRESS4)
						{
							if (bosses & IT_BOSS2) // Eternal Dragon defeated
							{
								setpause (1);
								centerprint (self.enemy.owner, "/P^bYou've learned Diving Swallow!^b\n\n===========================\n\n^1Perform this attack by using Vigil's Roundhouse kick against an enemy then quickly follow up with an ATTACK button press\n\n\n\n^3Press ATTACK or JUMP to resume ...\n");

								if (!game_progress & IT_PROGRESS4) // Diving Swallow Attack
									game_progress = game_progress | IT_PROGRESS4; // Add it (True)

								self.enemy.owner.display_price = 0;
								self.chatrefresh_finished = time + 3; // remove centerprint off player
								sound (self.enemy.owner, CHAN_AUTO, "misc/levelup2.wav", 1, ATTN_NORM);
								self.enemy.owner.gold = self.enemy.owner.gold - aprice; // remove gold
								self.mode = 0; // Not chatting anymore
								self.cnt = 0; // reset default topic
								self.enemy.owner.conversation = FALSE;
								self.pain_finished = time + 1; // Won't talk to user again for a second
							}
							else
							{
								setpause (1);
								centerprint (self.enemy.owner, "/P\n\nSorry Vigil, it appears you're not quite ready yet to learn this technique.\n\n\n\n^3Press ATTACK or JUMP to resume ...\n");
								self.enemy.owner.display_price = 0;
								self.chatrefresh_finished = time + 3; // remove centerprint off player
								self.mode = 0; // Not chatting anymore
								self.cnt = 0; // reset default topic
								self.enemy.owner.conversation = FALSE;
								self.pain_finished = time + 1; // Won't talk to user again for a second
							}
						}
						else if (!game_progress & IT_PROGRESS6) // TODO: Add Scroll Item / Small Quest
						{
							setpause (1);
							centerprint (self.enemy.owner, "/P^bYou've learned Airzuna Drop!^b\n\n===========================\n\n^1Perform this attack by pressing DOWN, DOWN, UP + ATTACK button combination after grabbing an opponent or landing a strike whilst airborne, damage scales with strike meter\n\n\n\n^3Press ATTACK or JUMP to resume ...\n");

							if (!game_progress & IT_PROGRESS6) // Izuna Drop Attack
								game_progress = game_progress | IT_PROGRESS6; // Add it (True)

							self.enemy.owner.display_price = 0;
							self.chatrefresh_finished = time + 3; // remove centerprint off player
							sound (self.enemy.owner, CHAN_AUTO, "misc/levelup2.wav", 1, ATTN_NORM);
							self.enemy.owner.gold = self.enemy.owner.gold - aprice; // remove gold
							self.mode = 0; // Not chatting anymore
							self.cnt = 0; // reset default topic
							self.enemy.owner.conversation = FALSE;
							self.pain_finished = time + 1; // Won't talk to user again for a second
						}
					}
					else
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}

				if (self.cnt == 1) // User leaves conversation screen
				{
					self.mode = 0; // Not chatting anymore
					self.cnt = 0; // reset default topic
					self.enemy.owner.display_price = 0;
					self.enemy.owner.conversation = FALSE;
					centerprint (self.enemy.owner, "\n");
					self.pain_finished = time + 1; // Won't talk to user again for a second
					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					self.enemy = self.enemy.enemy = world;
				}
			}
 			self.selection = TRUE;
		}
		else
 			self.selection = FALSE;

		// Prevent menu overflow
		if (self.cnt > 1)
			self.cnt = 0;
		if (self.cnt < 0)
			self.cnt = 1;
	}
};

void() wizard_cast =
{
	self.frame = 1;
};

// Mode 0, not chatting
// Mode 1, chatting
void() wizard_chat =
{
	local float aprice, sprice;
	local string h;
		
	if (!self.enemy)
		return;
	
	if (self.mode == 0 && self.enemy.owner.conversation == TRUE) // Say good bye to player!
	{
		centerprint (self.enemy.owner, ".....");
		self.enemy.owner.display_price = 0;
	}
	else if (self.mode == 1)
	{
		self.enemy.owner.conversation = TRUE;
		aprice = 100 * floor(self.enemy.owner.level / 3.5);
		if (self.chatrefresh_finished < time)
		{
			if (self.cnt == 0)
			{
				if (!shrine_progress & IT_SHRINE1)
				{
					centerprint (self.enemy.owner, "/PHmph! Unwise to bother a Master Wizard in meditation ''Knightja'', go seek our unresting Kings soul and perhaps I'll bother myself in helping you...\n\n===========================\n\nç ^bLeave^b");
					self.enemy.owner.display_price = 0;
				}
				else
				{
					centerprint (self.enemy.owner, "/PNot unexpected, you've found our where ours Kings soul is hiding and have proved your worth. Whenever you wish to warp back to the castle shrine come find me...\n\n===========================\n\nç ^bWarp to Transport^b\n                 Leave\n");
					self.enemy.owner.display_price = aprice;
				}
			}
			else
			{
				centerprint (self.enemy.owner, "/PNot unexpected, you've found our where ours Kings soul is hiding and have proved your worth. Whenever you wish to warp back to the castle shrine come find me...\n\n===========================\n\n   Warp to Transport\nç ^b              Leave^b\n");
				self.enemy.owner.display_price = 0;
			}
			self.chatrefresh_finished = time + 0.1;
		}

		//
		// User menu control
		//

		if (shrine_progress & IT_SHRINE1)
		{
			if (self.enemy.owner.keyflags & KEY_UP)
			{
				if (self.selection_up == FALSE)
				{
					self.cnt = self.cnt - 1;
					sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_up = TRUE;
			}
			else
				self.selection_up = FALSE;

			if (self.enemy.owner.keyflags & KEY_DOWN)
			{
				if (self.selection_down == FALSE)
				{
					self.cnt = self.cnt + 1;
					sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_down = TRUE;
			}
			else
				self.selection_down = FALSE;
		}

		//
		// User menu selection
		//

		if (self.enemy.owner.button0)
		{
			if (self.selection == FALSE)
			{
				if (self.cnt == 0)
				{
					if (shrine_progress & IT_SHRINE1)
					{
						if (self.enemy.owner.gold >= aprice) // warp vigil
						{
							float f = fopen("teleport.txt", FILE_WRITE);
							if (f >= 0)
							{
								fputs(f, "teleporter", "\n");
								fclose(f);
							}
							centerprint (self.enemy.owner, "");
							self.enemy.owner.gold = self.enemy.owner.gold - aprice; // remove gold
							self.mode = 0; // Not chatting anymore
							self.cnt = 0; // reset default topic
							self.enemy.owner.conversation = FALSE;
							self.enemy.owner.display_price = 0;
							self.pain_finished = time + 1; // Won't talk to user again for a second
							
							// Become Orb
							sound (self.enemy, CHAN_VOICE, "spells/charge.wav", 1, ATTN_NONE);
							WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
							WriteByte (MSG_BROADCAST, TE_TELEPORT);
							WriteCoord (MSG_BROADCAST, self.enemy.origin_x);
							WriteCoord (MSG_BROADCAST, self.enemy.origin_y);
							WriteCoord (MSG_BROADCAST, self.enemy.origin_z);
							setmodel(self.enemy, "progs/orb.mdl");
							setsize(self.enemy, VEC_HULL_MIN, VEC_HULL_MAX);

							self.enemy.classname = "tran_orb";		
							self.enemy.colormod = '2.5 2.5 1';
							self.enemy.alpha = 0.75;
							self.enemy.effects = EF_ADDITIVE | EF_NODEPTHTEST | EF_DIMLIGHT;
							self.enemy.movetype = MOVETYPE_NOCLIP;

							self.enemy.velocity = '0 0 0';
							self.enemy.cnt = 0;
							self.enemy.cnt2 = 0;
							self.enemy.pain_finished = time;
							self.enemy.owner.campos_z = self.enemy.origin_z;
							self.enemy.owner.campos_x = self.enemy.origin_x;
							self.enemy.think = OrbTransportThinkUp;
							self.enemy.nextthink = time;

							self.pain_finished = time + 999; // Won't talk to user again forever
							self.think = wizard_cast;
							self.nextthink = time;
						}
						else
							sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					}
					else
					{
						self.mode = 0; // Not chatting anymore
						self.enemy.owner.display_price = 0;
						self.cnt = 0; // reset default topic
						self.enemy.owner.conversation = FALSE;
						centerprint (self.enemy.owner, "\n");
						self.pain_finished = time + 1; // Won't talk to user again for a second
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					}
				}

				if (self.cnt == 1) // User leaves conversation screen
				{
					self.mode = 0; // Not chatting anymore
					self.cnt = 0; // reset default topic
					self.enemy.owner.display_price = 0;
					self.enemy.owner.conversation = FALSE;
					centerprint (self.enemy.owner, "\n");
					self.pain_finished = time + 1; // Won't talk to user again for a second
					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					self.enemy = self.enemy.enemy = world;
				}
			}
 			self.selection = TRUE;
		}
		else
 			self.selection = FALSE;

		// Prevent menu overflow
		if (self.cnt > 1)
			self.cnt = 0;
		if (self.cnt < 0)
			self.cnt = 1;
	}
};

// Mode 0, not chatting
// Mode 1, chatting
void() bartender_chat =
{
	local float aprice;
		
	if (!self.enemy)
		return;
	
	if (self.mode == 0 && self.enemy.owner.conversation == TRUE) // Say good bye to player!
	{
		centerprint (self.enemy.owner, "Ye ye whatever ...");
		self.enemy.owner.display_price = 0; // clear on-screen price
	}
	else if (self.mode == 1)
	{
		self.enemy.owner.conversation = TRUE;

		if (self.cnt == 0)
			aprice = self.enemy.owner.display_price = 25 * ceil(self.enemy.owner.level / 1.9);
		else if (self.cnt == 1)
			aprice = self.enemy.owner.display_price = 500;
		else
			self.enemy.owner.display_price = 0; // clear on-screen price

		if (self.chatrefresh_finished < time)
		{
			if (self.cnt == 0)
				centerprint (self.enemy.owner, "/PYou don't come 'round here often, I take it you're not here for a drink ...\n\n===========================\n\n\nç     ^bBuy a gold pouch^b\n             Ask for hint\n                    Leave\n");
			else if (self.cnt == 1)
				centerprint (self.enemy.owner, "/PYou don't come 'round here often, I take it you're not here for a drink ...\n\n===========================\n\n\n       Buy a gold pouch\nç           ^bAsk for hint^b\n                    Leave\n");
			else
				centerprint (self.enemy.owner, "/PYou don't come 'round here often, I take it you're not here for a drink ...\n\n===========================\n\n\n       Buy a gold pouch\n             Ask for hint\nç                  ^bLeave^b\n");
		
			self.chatrefresh_finished = time + 0.1;
		}

		//
		// User menu control
		//

		if (self.enemy.owner.keyflags & KEY_UP)
		{
			if (self.selection_up == FALSE)
			{
				self.cnt = self.cnt - 1;
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
			}
			self.chatrefresh_finished = time;
			self.selection_up = TRUE;
		}
		else
			self.selection_up = FALSE;

		if (self.enemy.owner.keyflags & KEY_DOWN)
		{
			if (self.selection_down == FALSE)
			{
				self.cnt = self.cnt + 1;
				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
			}
			self.chatrefresh_finished = time;
			self.selection_down = TRUE;
		}
		else
			self.selection_down = FALSE;

		//
		// User menu selection
		//

		if (self.enemy.owner.button0)
		{
			if (self.selection == FALSE)
			{
				if (self.cnt == 0) // User purchases a pouch
				{
					if (self.enemy.owner.gold >= aprice && self.enemy.owner.pouch == FALSE)
					{
						self.enemy.owner.pouch = TRUE;
						sound (self.enemy.owner, CHAN_AUTO, "misc/pickup.wav", 1, ATTN_NORM);
						self.enemy.owner.gold = self.enemy.owner.gold - aprice; // remove gold

						//End Convo
						self.mode = 0; // Not chatting anymore
						self.enemy.owner.display_price = 0; // clear on-screen price
						self.cnt = 0; // reset default topic
						self.enemy.owner.conversation = FALSE;
						setpause(1);
						centerprint (self.enemy.owner, "/P^bGold Pouch Obtained!^b\n\n\n===========================\n\n\n^1Allows Vigil to keep all his gold coins even when defeated!\n\nSingle use item only ...\n\n\n^3Press ATTACK or JUMP to resume ...");
						self.pain_finished = time + 1; // Won't talk to user again for a second
					}
					else
						sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}

				if (self.cnt == 1) // User purchases a hint
				{
					if (self.enemy.owner.gold >= aprice)
					{
						//End Convo
						self.enemy.owner.gold = self.enemy.owner.gold - aprice; // take gold
						self.mode = 0; // Not chatting anymore
						self.enemy.owner.display_price = 0; // clear on-screen price
						self.cnt = 0; // reset default topic
						self.enemy.owner.conversation = FALSE;
						centerprint (self.enemy.owner, "\n");
						self.pain_finished = time + 1; // Won't talk to user again for a second
						
						// Give a random HINT!
						setpause(1);
						if (hint_step == 0)
							centerprint (self.enemy.owner, "/POne of my many informants 'ave told me that the castle courtyard holds a secret treasure that may help you immensely...\n\n===========================\n\nç ^bLeave^b");
						else
						{
							centerprint (self.enemy.owner, "/PI've 'old you all I 'ave at the moment.\n\nEre's yer money back!");
							self.enemy.owner.gold = self.enemy.owner.gold + aprice; // give back gold
						}

						if (hint_step < 1)
							hint_step = hint_step + 1;
					}

					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				}

				if (self.cnt == 2) // User leaves conversation screen
				{
					self.mode = 0; // Not chatting anymore
					self.enemy.owner.display_price = 0; // clear on-screen price
					self.cnt = 0; // reset default topic
					self.enemy.owner.conversation = FALSE;
					centerprint (self.enemy.owner, "\n");
					self.pain_finished = time + 1; // Won't talk to user again for a second
					sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
					self.enemy = self.enemy.enemy = world;
				}
			}
 			self.selection = TRUE;
		}
		else
 			self.selection = FALSE;

		// Prevent menu overflow
		if (self.cnt > 2)
			self.cnt = 0;
		if (self.cnt < 0)
			self.cnt = 2;
	}
};

void() npc_bsmith =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/volup.spr");
	precache_model ("progs/armorup.spr");
	precache_model ("progs/bsmith.mdl");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");

	setmodel (self, "progs/bsmith.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.movetype = MOVETYPE_STEP;
	self.health = 9999; // Allows spawn_shadow(); to appear
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER;
	self.classname = "bsmith";

	//
	// Default NPC vars
	//
	self.npc_talk = blacksmith_chat;
	self.goalentity = world;
	self.think = npc_default;
	self.nextthink = time + 0.1;

	droptofloor();
	//spawn_shadow();
};

void() npc_priest =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/priest.mdl");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");

	setmodel (self, "progs/priest.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.movetype = MOVETYPE_STEP;
	self.health = 9999; // Allows spawn_shadow(); to appear
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER;
	self.classname = "priest";
	self.score = self.angles_y; // snap back here!
	self.fixangle = TRUE; // Won't turn around when idle

	//
	// Default NPC vars
	//
	self.npc_talk = priest_chat;
	self.goalentity = world;
	self.think = npc_default;
	self.nextthink = time + 0.1;

	droptofloor();
	//spawn_shadow();
};

void() npc_guard =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/guard.mdl");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");

	setmodel (self, "progs/guard.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.movetype = MOVETYPE_STEP;
	self.health = 9999; // Allows spawn_shadow(); to appear
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER; // Walks around
	self.hitcontentsmaski = CONTENTBIT_SOLID|0x00000002i|CONTENTBIT_BODY|CONTENTBIT_PLAYERCLIP; // don't ignore clipbrushes etc
	self.classname = "guard";
	self.score = self.angles_y; // snap back here!
	self.fixangle = TRUE; // Won't turn around when idle
	self.speed = 0.4; // Can move

	//
	// Default NPC vars
	//
	self.npc_talk = guard_chat;
	self.goalentity = world;
	self.think = npc_default;
	self.nextthink = time + 0.1;

	droptofloor();
	//spawn_shadow();
};

void() npc_wizard =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/wizard.mdl");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");

	setmodel (self, "progs/wizard.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.movetype = MOVETYPE_STEP;
	self.health = 9999; // Allows spawn_shadow(); to appear
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER; // Walks around
	self.classname = "wizard";
	self.score = self.angles_y; // snap back here!
	self.fixangle = TRUE; // Won't turn around when idle

	//
	// Default NPC vars
	//
	self.npc_talk = wizard_chat;
	self.goalentity = world;
	self.think = npc_default;
	self.nextthink = time + 0.1;

	droptofloor();
	//spawn_shadow();
};

void() npc_lisa =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/lisa.mdl");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");

	setmodel (self, "progs/lisa.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.movetype = MOVETYPE_STEP;
	self.health = 9999; // Allows spawn_shadow(); to appear
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER; // Walks around
	self.classname = "lisa";
	self.score = self.angles_y; // snap back here!
	self.fixangle = TRUE; // Won't turn around when idle

	//
	// Default NPC vars
	//
	self.npc_talk = lisa_chat;
	self.goalentity = world;
	self.think = npc_default;
	self.nextthink = time + 0.1;

	droptofloor();
	//spawn_shadow();
};

void() npc_bartender =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/bartender.mdl");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");

	setmodel (self, "progs/bartender.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.movetype = MOVETYPE_STEP;
	self.health = 9999; // Allows spawn_shadow(); to appear
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER;
	self.classname = "bartender";
	self.score = self.angles_y; // snap back here!
	self.fixangle = TRUE; // Won't turn around when idle

	//
	// Default NPC vars
	//
	self.npc_talk = bartender_chat;
	self.goalentity = world;
	self.think = npc_default;
	self.nextthink = time + 0.1;

	droptofloor();
	//spawn_shadow();
};
