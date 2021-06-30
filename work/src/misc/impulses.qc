/*
+--------+
|Impulses|
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Handle and execute "Impulse" commands - as entered from console.           |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

void() player_miniswordspin1;
void() CheckImpulseButtons =
{
	if (self.char.health <= 0)
		return;

	//
	// Magic Menu
	//

	if (self.impulse == 1 && self.safezone == FALSE && self.char.flags & FL_ONGROUND && self.attack_finished < time
	&& self.char.pain_finished < time && self.char.tired_finished < time
	&& self.char.invunerability_finished < time && self.forcewalk_finished < time && self.char.block_finished < time
	&& self.char.dodge_finished < time && !self.char.swimming && self.char.inair == 0)
	{
		if (self.char.grabbed == TRUE)
		{
			self.char.grabbed = FALSE;
			self.char.sword_spincnt = 0;
			self.char.purge_cooldown = time;
			self.purge_toggle = FALSE;
			self.noblock_finished = time + 1;
			self.char.movetype = MOVETYPE_WALK; // fix flying vigil from ledge grab -> kick
			self.attack_finished = time + 0.575;
			self.char.think = player_miniswordspin1;
			self.char.nextthink = time;
		}
		else
		{
			if (self.magicmenu == FALSE)
			{
				// Get out of turning angles
				if (self.char.angles_y == 45 || self.char.angles_y == -45)
					self.char.angles_y = 0;
				if (self.char.angles_y == 225 || self.char.angles_y == -225)
					self.char.angles_y = 180;
				self.char.turn_y = self.char.angles_y;
				self.char.angles_x = 0;
				self.char.angles_y = -180; // set specific angle
				self.char.running = FALSE;
				self.magicmenu = TRUE;
				sound (self, CHAN_ITEM, "player/mmenu1.wav", 1, ATTN_NORM);
			}
			else
			{
				if (self.currentspell == SPELL_FIREBALL)
				{
					if (self.mana >= 10)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = self.char.turn_y;
						self.attack_finished = time + 0.6;
						self.char.think = player_fireball1;
						self.char.nextthink = time + 0.1;
					}
					else if (self.mana >= 10 / 1.5)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = self.char.turn_y;
						self.attack_finished = time + 0.6;
						self.char.think = player_fireball1;
						self.char.nextthink = time + 0.1;
						self.char.tired_finished = time + 3; // add .6 from attack_finished
					}
					else
						self.char.angles_y = self.char.turn_y;
				}
				else if (self.currentspell == SPELL_LIGHTNING)
				{
					if (self.mana >= 50)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.char.lcount = 0;
						self.attack_finished = time + 1;
						self.char.think = player_lightning1;
						self.char.nextthink = time + 0.1;
					}
					else if (self.mana >= 50 / 1.5)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.char.lcount = 0;
						self.attack_finished = time + 1;
						self.char.think = player_lightning1;
						self.char.nextthink = time + 0.1;
						self.char.tired_finished = time + 6;
					}
					else
						self.char.angles_y = self.char.turn_y;
				}
				else if (self.currentspell == SPELL_ICE)
				{
					if (self.mana >= 30)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.char.icefield_count = 0;
						self.attack_finished = time + 1;
						self.char.think =	player_icefield1;
						self.char.nextthink = time + 0.1;
					}
					else if (self.mana >= 30 / 1.5)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.char.icefield_count = 0;
						self.attack_finished = time + 1;
						self.char.think =	player_icefield1;
						self.char.nextthink = time + 0.1;
						self.char.tired_finished = time + 7;
					}
					else
						self.char.angles_y = self.char.turn_y;
				}
				else if (self.currentspell == SPELL_BEAM)
				{
					if (self.mana >= 100)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.attack_finished = time + 999;
						self.char.beams_shot = 0;
						self.char.think =	player_magicd1;
						self.char.nextthink = time + 0.1;
					}
					else if (self.mana >= 100 / 1.5)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.attack_finished = time + 999;
						self.char.beams_shot = 0;
						self.char.think =	player_magicd1;
						self.char.nextthink = time + 0.1;
						self.char.tired_finished = time + 9;
					}
					else
						self.char.angles_y = self.char.turn_y;
				}
				else if (self.currentspell == SPELL_TWISTER)
				{
					if (self.mana >= 75)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.attack_finished = time + 5;
						self.char.tcount = 0;
						self.char.think =	player_twister1;
						self.char.nextthink = time + 0.1;
					}
					else if (self.mana >= 75 / 1.5)
					{
						sound (self, CHAN_ITEM, "player/mmenu2.wav", 1, ATTN_NORM);
						self.char.angles_y = -180; // set specific angle
						self.char.tcount = 0;
						self.attack_finished = time + 5;
						self.char.think =	player_twister1;
						self.char.nextthink = time + 0.1;
						self.char.tired_finished = time + 8;
					}
					else
						self.char.angles_y = self.char.turn_y;
				}
				self.magicmenu = FALSE;
			}
		}
	}

	//
	//
	//

	//
	// Health flask
	//
	
	if (self.impulse == 4 && self.forcewalk_finished < time && (self.char.health < self.char.max_health || self.status_poison_finished > time || self.status_blind_finished > time || self.status_broken_finished > time))
	{
		if (self.char.grabbed == TRUE || self.ledgegrab == TRUE || self.char.pain_finished > time || self.char.tired_finished > time || self.wallrun == TRUE
		|| (self.char.onground == FALSE && self.doublejump == TRUE && self.char.djump_spincnt < 4))
			return;
		if (self.char.health < 1)
			return;
		if (self.char.bigfall_recovery_finished > time)
			return;
		if (self.keyflags & (KEY_UP | KEY_DOWN | KEY_LEFT | KEY_RIGHT))
			return; // Fixes Vigil dancing when spamming flask key whilst moving

		if (self.char.block_finished > time)
			self.char.block_finished = time - 1;

		self.softshadow_time = time;
		self.char.movetype = MOVETYPE_STEP; // Stop sliding
		self.char.swing_count = 0; // Balance issue
		self.noblock_finished = time + 0.1; // don't allow block for a split second while drinking
		self.char.angles_x = 0; // fix rare angle bug
		
		if (self.magicmenu == TRUE)
		{
			self.char.angles_y = self.char.turn_y;
			sound (self, CHAN_ITEM, "player/mmenu1.wav", 1, ATTN_NORM);
			self.magicmenu = FALSE;
		}

		// Get out of turning angles
		if (self.char.angles_y == 45 || self.char.angles_y == -45)
			self.char.angles_y = 0;
		if (self.char.angles_y == 225 || self.char.angles_y == -225)
			self.char.angles_y = 180;

		self.dodge_finished = time;
		self.attack_finished = time;
		self.char.flypain = FALSE;
		if (self.char.perfectguard_buff < time)
			self.char.takedamage = DAMAGE_AIM;

		// Start drinking
		self.hflask_drink_finished = time + 9999;

		//self.char.think = player_drink;
		//self.char.nextthink = time;
	}

	if (self.impulse == 5)
	{
		if (self.hflask_drink_finished < time)
			return;
		self.hflask_drink_finished = time;
		self.dodge_finished = time;
		self.attack_finished = time;
		self.char.hflask_drink_finished = time;
	}

	//
	// Block
	//

	if (self.button3)
	//if (input_buttons & BUTTON3)
	{
		if (self.FL_BLKPRESSED == FALSE)
		{
			if (self.forcewalk_finished > time)
				return;
			if (pointcontents(self.char.origin) == CONTENT_WATER || pointcontents(self.owner.origin) == CONTENT_LAVA || pointcontents(self.owner.origin) == CONTENT_SLIME)
				return;
			if (self.char.flypain || self.char.tired_finished > time || self.wallrun == TRUE)
				return;
			if (self.char.health < 1)
				return;
			if (self.char.bigfall_recovery_finished > time)
				return;
			if (deathmatch && self.char.pain_finished > time) // Deathmatch rules
				return;
			if (self.noblock_finished > time)
				return;
			
			self.softshadow_time = time;
			self.char.swing_count = 0; // Balance issue

			if (self.ledgegrab == TRUE) // blocking removes ledge grabbing flag
			{
				self.ledgegrab = FALSE;
				self.char.velocity_x = 0; // stop sideways movement
			}
			
			self.char.angles_x = 0; // fix rare angle bug
			
			if (self.char.enemy) // remove grab on enemy
				self.char.grabbed =	self.char.enemy.grabbed = FALSE;

			if (self.magicmenu == TRUE)
			{
				self.char.angles_y = self.char.turn_y;
				sound (self, CHAN_ITEM, "player/mmenu1.wav", 1, ATTN_NORM);
				self.magicmenu = FALSE;
			}

			// Get out of turning angles
			if (self.char.angles_y == 45 || self.char.angles_y == -45)
				self.char.angles_y = 0;
			if (self.char.angles_y == 225 || self.char.angles_y == -225)
				self.char.angles_y = 180;

			// round house kick can now be put into an air combo
			if ((self.keyflags & (KEY_LEFT) && self.char.angles_y == 0) || (self.keyflags & (KEY_RIGHT) && self.char.angles_y == 180) 
			&& self.char.aircombo_count != 9 && self.char.aircombo_count != 8 && self.wallgrab == FALSE && self.safezone == FALSE)
			{
				if (self.attack_finished < time)
				{
					self.char.purge_cooldown = time;
					self.purge_toggle = FALSE;
					self.char.enemy = world;
					self.char.perform_flyingswallow = FALSE; // remove flag on new kick
					self.noblock_finished = time + 0.4; // don't allow block for a split second on round house
					self.char.idle_count = 0; // reset pose
					self.char.attack_type = 0; // reset attack type
					self.char.velocity_y = 0; // remove foreground/backgound velocity
					self.char.movetype = MOVETYPE_WALK; // fix flying vigil from ledge grab -> kick
					self.char.think = player_kick1;
					self.char.inair = self.char.bigfall = 0; // remove any big fall flags
					self.attack_finished = time + 1;
					self.char.nextthink = time;
					self.char.aircombo_count = 9; // can only do it once in air
				}
			}
			else if (self.char.dodge_finished < time)
			{
				self.swordshadow_time = time; // sword shadow remove
				self.shadow_time = time;
				self.char.swing_count = 0; // reset sword swing
				self.char.idle_count = 0; // reset pose
				self.attack_finished = time;
				self.dodge_finished = time;
				self.char.purge_cooldown = time;
				self.purge_toggle = FALSE;

				// needed to fix "blocking while getting up"
				self.char.flypain = FALSE;
				if (self.char.perfectguard_buff < time)
					self.char.takedamage = DAMAGE_AIM;
				// needed to fix "blocking while getting up"

				self.char.movetype = MOVETYPE_WALK; // FIXME: Stop mid-air hangup on ledgegrabs

				self.char.block_finished = time + 99999;
				self.char.think = player_block;

				// Perfect Block
				if (relics & IT_RELIC8)
				{
					if (self.char.perfectblock_cooldown < time)
					{
						self.char.perfectblock = time + 0.135;
						self.char.perfectblock_cooldown = time + 0.5;
					}
				}
				self.char.nextthink = time;
				sound (self, CHAN_BODY, "player/motion2.wav", 1, ATTN_NORM);
			}
		}
		self.FL_BLKPRESSED = TRUE;
	}
	else
	{
		if (self.attack_finished < time && self.FL_BLKPRESSED && self.char.dodge_finished < time && self.char.pain_finished < time && !self.char.flypain)
			sound (self, CHAN_BODY, "player/motion1.wav", 1, ATTN_NORM);

		self.FL_BLKPRESSED = FALSE;
		self.button3 = FALSE;

		if (self.char.block_finished > time)
			self.char.block_finished = time;
	}

	//
	// Debugging! / Cheats!
	//
	
	if (self.impulse == 10)
	{
		local string s = ftos(self.level);
		bprint ("Vigils Level: ", s, "\n");
	}
	
	if (cvar("developer") != 1)
			return;

	if (self.impulse == 6 && self.level < 99)
	{
		local entity oself;
		oself = self;
		self = self.char;

		sound (self, CHAN_AUTO, "misc/levelup.wav", 1, ATTN_NORM);
		self.owner.level = self.owner.level + 1;
	
		//num = ceil(random()*2);
		self.max_health = self.max_health + 3;
		self.owner.max_health = self.owner.max_health + 3; // + num; //(10*(self.owner.level / 6)); // needed for parm11 save
			
		self.max_mana = self.max_mana + 3;
		self.owner.max_mana = self.owner.max_mana + 3;
		
		self.owner.experience = 0; // reset back
		self.owner.armorvalue = self.owner.level; // Update HUD
		DisplayLevel(); // display sprite sign
		freeze_finished = time + 5 * frametime;
		
		self = oself;
	}
	if (self.impulse == 7)
		self.gold = 99999;
	
	if (self.impulse == 8)
	{
		local string a = ftos(game_progress);
		bprint ("Game Progress Flag: ", a, "\n");
		local string d = ftos(hp_max_ups);
		bprint ("HP Max Up Flag: ", d, "\n");
	}
};