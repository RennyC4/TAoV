//+------+
//|AI    |
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| All monsters thinking / physics are done in here.                          |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

.float ai_attack; // remember what type of attack the monster used
.float show_hostile; // set to time+0.2 whenever a client fires a
					 // weapon or takes damage.  Used to alert
					 // monsters that otherwise would let the player go

.float monster_running; // TRUE or FALSE, variable checks if the monster is currently running or not, it also stops running the same function
						// over and over

.float forceface_finished; // monster will look at their target at any angle, archers are a good example

void() baron_hidesword1;
void() CombatThink;

/*
=============
FireAwakeTargets

Monster can fire up to 9 targets at once on wake up
=============
*/
void() FireAwakeTargets =
{
	if (self.awaketarget)
		FireTarget(self.awaketarget); // Fire 'awaketarget' target 1
	if (self.awaketarget2)
		FireTarget(self.awaketarget2); // Fire 'awaketarget' target 2
	if (self.awaketarget3)
		FireTarget(self.awaketarget3); // Fire 'awaketarget' target 3
	if (self.awaketarget4)
		FireTarget(self.awaketarget4); // Fire 'awaketarget' target 4
	if (self.awaketarget5)
		FireTarget(self.awaketarget5); // Fire 'awaketarget' target 5
	if (self.awaketarget6)
		FireTarget(self.awaketarget6); // Fire 'awaketarget' target 6
	if (self.awaketarget7)
		FireTarget(self.awaketarget7); // Fire 'awaketarget' target 7
	if (self.awaketarget8)
		FireTarget(self.awaketarget8); // Fire 'awaketarget' target 8
	if (self.awaketarget9)
		FireTarget(self.awaketarget9); // Fire 'awaketarget' target 9
};

/*
=============
ai_strafe

Strafe sideways, but stay at aproximately the same range
=============
*/
.float lefty;
void(float dist) ai_strafe =
{
	local float	ofs;
	
	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	
	if (walkmove (self.ideal_yaw + ofs, dist))
		return;
		
	self.lefty = 1 - self.lefty;

	walkmove (self.ideal_yaw - ofs, dist);
};

/*
=============
close_check

small searchradius(); to see if a player is very close to the monsters origin point
=============
*/
.float closecheck_finished;
void() close_check =
{
	local entity head;
	
	if (!self.flags & FL_ONGROUND)
		return;
	if (self.classname == "zombie" || self.classname == "zombieboss" || self.classname == "ghoul" || self.classname == "esquid")
		return;
	if (self.grab_finished > time)
		return;
	if (self.enemy.owner.attack_finished > time)
		return;
	if (self.enemy.grabbed == TRUE)
		return;
	if (self.flags & FL_SWIM)
		return;
	
	if (self.enemy)
	{
		head = searchradius(self.origin, 5); // was 1
		while (head)
		{
			if (head == self.enemy && head.classname == "player" && head.health > 0 && self.closecheck_finished < time)
			{
				if (self.classname == "dragon" || self.classname == "golem" || self.classname == "werewolf")
				{
					if (self.th_melee)
						self.th_melee();
					return;
				}
				makevectors (self.angles);
				self.velocity = aim(self, 150);
				self.velocity = self.velocity * 150 * -1;
				if (self.flags & FL_ONGROUND)
					self.flags = self.flags - (self.flags & FL_ONGROUND);
				self.velocity_z = 125;
				self.closecheck_finished = time + 1;
				sound (self, CHAN_BODY, "player/jump.wav", 1, ATTN_NORM);
				
			}
			head = head.chain;
		}
	}
};

/*
=============
enrage

just like it says, monster gets angry and becomes more powerful temporary and faster as well
=============
*/
void() enrage_think =
{
	// Colormod removal is done through startframe now
	makevectors(self.owner.angles);
	if (self.owner.berserk_finished > time)
	{
		if (self.pain_finished < time)
		{
			self.owner.nextthink = self.owner.nextthink = time / 1.25; // think & move faster
			self.pain_finished = time + 0.1;
		}
	}

	// Remove enrage entity under these conditions
	if (self.owner.health < 1 || !self.owner || self.owner.berserk_finished < time)
	{
		self.owner.colormod = '1 1 1';
		remove(self);
		return;
	}
//	self.origin_x = self.owner.origin_x;
//	self.origin_y = self.owner.origin_y;
//	self.origin_z = self.owner.origin_z + 64;
	
	setorigin (self, self.owner.origin + v_up * 64);
	
	frameskip(0.01);
};

void() enrage =
{
	local entity enrager;

	enrager = spawn ();
	enrager.owner = self;
	enrager.movetype = MOVETYPE_NOCLIP;
	enrager.solid = SOLID_NOT;
	enrager.effects = EF_NODEPTHTEST;
	enrager.classname = "enrager";
	setmodel (enrager, "progs/enrage.spr");
	setsize (enrager, '0 0 0', '0 0 0');
	setorigin (enrager, self.origin + v_up * 64);

	// Give off RT Light
	spawn_color_glow(3, 0, 0, 70, self);
	
	enrager.think = enrage_think;
	enrager.nextthink = time;
	sound (enrager, CHAN_VOICE, "spells/enrage.wav", 1, ATTN_NORM);
};

/*
=============
monster_removeslide

when called removes all x velocity on entity, prevents 'sliding on slopes' when delt knockback and velocity changes
=============
*/

void() monster_removeslide =
{
	if (self.flags & FL_ONGROUND)
			self.velocity_x = self.velocity_y = 0; // FIXME: Remove X&Y velocity when landed on the ground to stop sliding
};

/*
=============
check_attack

returns 1 if the entity is nearly infront of self
=============
*/

float(entity targ) check_attack =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;

	if (dot > 0.99)
		return TRUE;

	return FALSE;
};

/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if (dot > 0.1)
		return TRUE;
	else
		return FALSE;
};

/*
=============
range

returns the range catagorization of an entity reletive to self
=============
*/

float(entity owner, entity targ) range =
{
	local float		r;
	
	r = vlen (owner.origin - targ.origin);
	if (r <= 40)
		return RANGE_CLOSE;
	else if (r > 40 && r <= 75)
		return RANGE_MELEE;
	else if (r > 75 && r <= 85)
		return RANGE_NEAR;
	else if (r > 85 && r < 200)
		return RANGE_MID;

	return RANGE_FAR;
};

void() ai_forceface =
{
	local vector view;
	if (self.enemy && visible(self.enemy) && self.enemy.health > 0)
	{
		view = vectoangles(self.enemy.origin - self.origin);
		self.angles_y = view_y;
	}
};

void() HuntTarget =
{
	if (self.enemy.owner.flags & FL_NOTARGET)
		return;
	if (self.movetype != MOVETYPE_NOCLIP)
		self.movetype = MOVETYPE_STEP;

	self.show_hostile = time + 1;
	self.goalentity = self.enemy;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);

	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	if (self.classname == "baron" || self.classname == "raven")
	{
		self.monster_running = FALSE;
		self.think = self.th_misc;
		frameskip(0.01);
		return;
	}

	if (self.classname == "ghost")
	{
		self.think = self.th_run;
		frameskip(0.01);
		return;
	}

	if (range(self, self.enemy) >= RANGE_FAR)
	{
		if (self.th_run)
		{
			self.monster_running = TRUE;
			self.think = self.th_run;
			frameskip(0.01);
			return;
		}
	}
	self.monster_running = FALSE;

	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		if (self.th_swim)
			self.think = self.th_swim;
		else
			self.think = self.th_walk;
	}
	else
	{
		if (self.th_walk)
			self.think = self.th_walk;
		else
			self.think = self.th_run;
	}
	frameskip(0.01);
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target
============
*/

void() FindTarget =
{
	local entity player, monster;

	if (self.awareness == 4 || self.enemy || cvar("developer") == 2)
		return;
	if (self.enemy.owner.flags & FL_NOTARGET)
		return;
		
	// search for monsters that have been awakened by the player
	monster = searchradius(self.origin, 500);
	while (monster)
	{
		if (monster.show_hostile > time && visible(monster) && range(self, monster) <= RANGE_MID && monster.enemy.health > 0 && monster.enemy.invunerability_finished < time && !monster.enemy.owner.flags & FL_NOTARGET)
		{
			FireAwakeTargets();
			dprint (self.classname);
			dprint (" has woken up to fight.\n");
			self.enemy = monster.enemy; // target the player that woke me up
			self.think = HuntTarget;
			self.nextthink = time + 0.1;
			return;
		}
		monster = monster.chain;
	}

	if (self.awareness != 3)
	{
		player = find(world, classname, "player");

		while (player)
		{
			if (self.awareness == 0)
			{
				if (visible(player) && player.deadflag != DEAD_DEAD && range(self, player) <= RANGE_MID && player.invunerability_finished < time && !player.owner.flags & FL_NOTARGET)
				{
					if (player.running == TRUE || infront(player))
					{
						FireAwakeTargets();
						dprint (self.classname);
						dprint (" has woken up to fight.\n");
						self.enemy = player;
						self.think = HuntTarget;
						self.nextthink = time + 0.1;
						return;
					}
				}
			}
			else if (self.awareness == 1)
			{
				if (visible(player) && player.deadflag != DEAD_DEAD && player.invunerability_finished < time && !player.owner.flags & FL_NOTARGET)
				{
					FireAwakeTargets();
					dprint (self.classname);
					dprint (" has woken up to fight.\n");
					self.enemy = player;
					self.think = HuntTarget;
					self.nextthink = time + 0.1;
					return;
				}
			}
			else if (self.awareness == 2)
			{
				if (player.deadflag != DEAD_DEAD && player.invunerability_finished < time && !player.owner.flags & FL_NOTARGET)
				{
					FireAwakeTargets();
					dprint (self.classname);
					dprint (" has woken up to fight.\n");
					self.enemy = player;
					self.think = HuntTarget;
					self.nextthink = time + 0.1;
					return;
				}
			}
			player = find(player, classname, "player");
		}
	}
	else // monsters will check if the camera is on screen
	{
		player = find(world, classname, "camera");
		while (player)
		{
			if ((self.origin_x < player.origin_x + 250 && self.origin_x > player.origin_x - 250)
			&& player.char.deadflag != DEAD_DEAD && player.char.invunerability_finished < time && !player.flags & FL_NOTARGET &&
			(self.origin_z < player.origin_z + 250 && self.origin_z > player.origin_z - 250))
			{
				FireAwakeTargets();
				dprint (self.classname);
				dprint (" has woken up to fight.\n");
				self.enemy = player.char;
				self.think = HuntTarget;
				self.nextthink = time + 0.1;
				return;
			}
			player = find(player, classname, "camera");
		}
	}
};

/*
=============
ai_watercheck_removal - land based creatures cannot exist in water
=============
*/
void() ai_watercheck_removal =
{
	if (pointcontents(self.origin) == CONTENT_LAVA && self.classname == "dragon")
		return;
	if (self.flags & FL_SWIM)
		return;
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.classname == "merman" || self.classname == "ethskull")
		return;
	if (self.nowaterremove_finished > time)
		return;

	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		dprint ("Monster water death, entity removed\n");
		if (self.enemy.classname == "player" && self.enemy.health > 0) // reward for death
			GiveExperience(self.experience);

		SUB_UseTargets();
		remove(self);
	}
};

/*
=============
check_game_progress - remove myself if conditions are met
=============
*/

void() check_game_progress =
{
	if (self.classname == "hellknight")
	{
		if (self.spawnflags & 4 && (game_progress & IT_PROGRESS3))
		{
			remove(self);
			return;
		}
	}
	if (self.classname == "zombie" || self.classname == "zombieboss")
	{
		if (self.spawnflags & 2 && (game_progress & IT_PROGRESS1))
		{
			remove(self);
			return;
		}
	}
	if (self.classname == "baron")
	{
		if (self.spawnflags & 2 && (game_progress & IT_PROGRESS5))
		{
			remove(self);
			return;
		}
	}
};

/*
=============
ai_stand - waiting for player
=============
*/

void() ai_stand =
{
	ai_watercheck_removal();
	check_game_progress();

	// Fixes floating monsters during stand frames
	if (!checkground(self))
	{
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
	}
	
	if (self.enemy.owner.flags & FL_NOTARGET)
		return;

	if (!self.spawnflags & 2)
	{
		if (self.flags & FL_ONGROUND)
			self.velocity_x = self.velocity_y = 0; // stop X/Y movement
		self.flags = self.flags - (self.flags & FL_ONGROUND); // Allow drop
	}
	
	if (self.health < 1 && self.deadflag != DEAD_DEAD)
	{
		if (self.th_die)
			self.th_die();
		return;
	}

	walkmove(0, 0); // use triggers on standing
	monster_removeslide();
	close_check(); // don't allow player inside origin point
	
	if (!self.enemy)
	{
		FindTarget();
	}
	else
	{
		if (visible(self.enemy))
			CombatThink();
		
		if (self.flags & FL_SWIM) // Swimming in water has it's own set of rules
		{
			HuntTarget();
			return;
		}
		
		if (self.stand_finished > time)
		{
			// player moved too far? he's vunerable? go after him!
			if (range(self, self.enemy) >= RANGE_FAR && self.flags & FL_ONGROUND || (self.enemy.angles_y == self.angles_y || self.enemy.owner.hflask_drink_finished > time || self.enemy.tired_finished > time || self.enemy.headsmash_recovery_finished > time))
			{
				if (self.th_run)
				{
					if (self.monster_running == FALSE)
					{
						self.monster_running = TRUE;
						self.think = self.th_run;
					}
				}
				else
				{
					if (self.monster_running == TRUE)
					{
						self.monster_running = FALSE;
						self.think = self.th_walk;
					}
				}
			}

			// look in the players direction
			if (self.classname == "esquid") // electric squid rotates as it moves
				self.angles_y = self.angles_y + 30;
			else if (self.flags & FL_ONGROUND)
			{
				if (self.forceface_finished > time)
				{
					local vector view;
					view = vectoangles(self.enemy.origin - self.origin);
					self.angles_y = view_y;
				}
				else
				{
					if (self.origin_x < self.enemy.origin_x)
						self.angles_y = 0;
					else
						self.angles_y = 180;
				}
				self.velocity_x = self.velocity_y = 0;
				self.flags = self.flags - FL_ONGROUND;
			}
			if (self.classname == "archer")
				self.forceface_finished = time + 100; // archers ALWAYS look at the player exactly
			return;
		}

		if (!self.enemy.flypain)
			HuntTarget();
		else
		{
			if (self.classname == "baron")
			{
				self.think = baron_hidesword1;
				self.nextthink = time + 0.1;
			}
			self.ai_reattack = FALSE; // turn off reattack flag
		}
	}
};

// Used for frames where a monster can cancel it's attack into a block.
void() BlockCancel =
{
	local float r;

	monster_removeslide();

	if (self.aircombo_finished > time)
		return;

	r = range(self, self.enemy);
	
	if (self.th_block && !self.enemy.swimming && self.berserk_finished < time)
	{
		if (!self.flags & FL_ONGROUND && self.enemy.onground == FALSE && difficulty > 0) // monster in-air blocking
		{
			if ((difficulty < 2 && random() < self.ai_blockfreq) || difficulty > 1)
			{
				self.think = self.th_block;
				self.nextthink = time + 0.12;
				return;
			}
		}
		else if (random() < self.ai_blockfreq && (self.enemy.owner.attack_finished > time && self.enemy.pain_finished < time) && self.enemy.angles_y != self.angles_y)
		{
			self.think = self.th_block;
			self.nextthink = time;
			return;
		}
		if (random() < self.ai_blockfreq && self.enemy.velocity_z != 0 && r != RANGE_FAR) // Specific headsmash blocking
		{
			self.think = self.th_block;
			self.nextthink = time;
			return;
		}
	}
};

void() CombatThink =
{
	local float r, h;

	close_check(); // don't allow player inside origin point
	ai_watercheck_removal();

	//
	// monsters can block, they block more on higher difficulty settings
	//

	if (!self.th_melee && !self.th_missile && !self.th_magic)
		return;
	if (self.enemy.flypain || self.enemy.lowceil == TRUE || self.enemy.owner.purge_toggle) // vigil got hit hard and is flying or is crouched under a low ceiling or is purging someone, don't attack
		return;
	if (self.enemy.izunatarg)
		return;

	r = range(self, self.enemy);
	h = random();

	// This code *caused* AI jitters when they're moving! - Fixed (Don't use self.think for th_block)
	if (self.th_block && !self.enemy.swimming && self.invunerability_finished < time && self.enemy.tired_finished < time && self.berserk_finished < time && self.enemy.owner.hflask_drink_finished < time)
	{
		if (self.grabbed == FALSE)
		{
			if (!self.flags & FL_ONGROUND) // monster in-air blocking
			{
				if ((difficulty >= 0 && random() < self.ai_blockfreq) || difficulty > 1)
				{
					self.th_block();
					return;
				}
			}
			else if (self.enemy.angles_y != self.angles_y) // monster on-ground blocking
			{
				if ((difficulty >= 0 && random() < self.ai_blockfreq) || difficulty > 1)
				{
					if (self.enemy.owner.inair > 15)
						self.th_block();
					if (self.enemy.owner.attack_finished > time || self.enemy.owner.aircombo_finished > time)
						self.th_block();
					return;
				}
			}
		}
	}

	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
		self.velocity_x = self.velocity_y = 0;
	}

	//
	// Flying / Swimming Monsters attack
	//

	if (self.classname == "merman" && self.flags & FL_SWIM && pointcontents(self.origin) == CONTENT_WATER)
	{
		if (random() < 0.1)
		{
			if (self.th_missile)
				self.th_missile();
		}
		return;
	}

	if (self.movetype == MOVETYPE_FLY || self.movetype == MOVETYPE_NOCLIP || (self.flags & FL_SWIM && pointcontents(self.origin) == CONTENT_WATER))
	{
		if (self.th_melee && r <= RANGE_CLOSE)
		{
			if (self.movetype == MOVETYPE_FLY || self.movetype == MOVETYPE_NOCLIP)
				self.velocity = self.velocity / 2;
			self.th_melee();
		}
		else
		{
			if (random() < 0.1)
			{
				if (self.th_missile)
					self.th_missile();
			}
		}
		return;
	}
	
	//
	// Force AI to relaunch an attack before thinking of anything else
	//

	if (self.ai_reattack == TRUE)
	{
		if (self.ai_attack == 0)
		{
			if (self.th_melee)
				self.th_melee();
		}
		else if (self.ai_attack == 1)
		{
			if (h < 0.5)
			{
				if (self.th_missile)
					self.th_missile();
			}
		}
		else if (self.ai_attack == 2)
		{
			if (self.classname == "gaunt" || self.classname == "archg" || self.classname == "troglod")
			{
				if (h < 0.5)
				{
					if (self.th_magic)
					{
						self.think = self.th_magic;
						self.nextthink = time;
					}
				}
			}
			else if (h < 0.02) // used to be 0.08
			{
				if (self.th_magic)
				{
					self.think = self.th_magic;
					self.nextthink = time;
				}
			}
		}
		self.ai_reattack = FALSE;
		return;
	}

	//
	// Electric Squids firing AI
	//
	if (self.classname == "esquid")
	{
		if (r <= RANGE_MID)
		{
			if (self.th_missile)
				self.th_missile();
			self.ai_attack = 1;
		}
		return;
	}

	//
	// Archer firing AI
	//
	if (self.classname == "archer")
	{
		if (random() > 0.1)
			return;
		if (self.th_missile)
		{
			self.think = self.th_missile;
			self.nextthink = time;
		}
		return;
	}
	
	//
	// Zombie healing boss zombie - always fire fast
	//

	if (self.classname == "zombie" && self.enemy.classname == "zombieboss")
	{
		local float r2;
		r2 = vlen (self.origin - self.enemy.origin);
	
		if (self.th_magic && r2 <= 275) // Range 275 units
			self.th_magic();
		return;
	}

	//
	// This is where monsters AI is told when to launch an attack
	//

	if (self.classname != "archer")
	{		
		if (r <= RANGE_MELEE || r <= RANGE_CLOSE)
		{
			if (self.th_melee) // Don't allow melee attacks if the player is jumping all around
			{
				if (self.enemy.onground || self.enemy.flags & FL_ONGROUND || self.enemy.paincount >= 1 || (self.enemy.attack_finished > time &&
				(self.enemy.aircombo_count == 5 || self.enemy.aircombo_count == 6)))
					self.th_melee();
				else if (self.th_block)
					self.th_block();
				else
					self.th_melee();
			}
			self.ai_attack = 0;
		}
		else if (r == RANGE_NEAR && check_attack(self.enemy))
		{
			if (self.th_missile)
				self.th_missile();
			self.ai_attack = 1;
		}
		else if ((r == RANGE_MID || r == RANGE_FAR) && check_attack(self.enemy))
		{
			if (self.classname == "gaunt" || self.classname == "archg")
			{
				if (h < 0.5)
				{
					if (self.th_magic)
					{
						self.think = self.th_magic;
						self.nextthink = time;
					}
				}
			}
			else if (h < 0.1)
			{
				if (self.th_magic)
				{
					local float r3;
					r3 = vlen (self.origin - self.enemy.origin);
					
					// Take into account of range for magic
					if (self.classname == "zombieboss" || self.classname == "zombie")
					{
						if (r3 <= 275)
						{
							self.think = self.th_magic;
							self.nextthink = time;
						}
					}
					else if (self.classname == "hellknight")
					{
						if (r3 <= 350)
						{
							self.think = self.th_magic;
							self.nextthink = time;
						}
					}
					else
					{
						self.think = self.th_magic;
						self.nextthink = time;
					}
				}
				self.ai_attack = 2;
			}
		}
	}
};

void(float dist) ai_forward =
{
	walkmove (self.angles_y, dist);
};

void(float dir) monsterjump =
{
	sound (self, CHAN_BODY, "player/jump.wav", 1, ATTN_NORM);

	self.velocity = '0 0 0';
	self.velocity_z = 165;
	if (dir == 0)
	{
		if (self.angles_y == 0)
			self.velocity_x = 135;
		else
			self.velocity_x = -135;
	}
	else if (dir == 1)
	{
		if (self.angles_y == 0)
			self.velocity_y = 125;
		else
			self.velocity_y = -125;
	}
	else if (dir == 2)
	{
		if (self.angles_y == 0)
			self.velocity_y = -125;
		else
			self.velocity_y = 125;
	}

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.think = self.th_jump;
	self.nextthink = time + 0.1;
};

/*
===============
check_for_ledge - allow monsters to jump off ledges
===============
*/

.float check_finished; // prevents spawning a lot of checker entities at once which can cause packet overflows
void() check_for_ledge =
{
	local	vector org;
	local entity checker, oself;
	local float cj;

	if (self.origin_z - 5 < self.enemy.origin_z)
		return;
	if (self.enemy.swimming)
		return;

	makevectors(self.angles);

	if (self.check_finished < time)
	{
		self.check_finished = time + 0.5;

		org = self.origin + v_forward * 35;
		traceline (org, org - v_up*60, FALSE, self);
		if (trace_fraction == 1)
		{
			checker = spawn();
			setmodel (checker, "progs/null.spr");
			setorigin(checker, trace_endpos);
			checker.movetype = MOVETYPE_STEP;
			setsize(checker, self.mins, self.maxs);

			oself = self;
			self = checker;
			droptofloor();

			cj = walkmove(0,0);

			self = oself;

			if (cj == TRUE && (checker.flags & FL_ONGROUND))
				monsterjump(0);
			if (checker)
				remove(checker);
			return;
		}

		org = self.origin - v_right * 35;
		traceline (org, org - v_up*60, FALSE, self);
		if (trace_fraction == 1)
		{
			checker = spawn();
			setmodel (checker, "progs/null.spr");
			setorigin(checker, trace_endpos);
			checker.movetype = MOVETYPE_STEP;
			setsize(checker, self.mins, self.maxs);

			oself = self;
			self = checker;
			droptofloor();

			cj = walkmove(0,0);

			self = oself;

			if (cj == TRUE && (checker.flags & FL_ONGROUND))
				monsterjump(1);
			if (checker)
				remove(checker);
			return;
		}

		org = self.origin + v_right * 35;
		traceline (org, org - v_up*60, FALSE, self);
		if (trace_fraction == 1)
		{
			checker = spawn();
			setmodel (checker, "progs/null.spr");
			setorigin(checker, trace_endpos);
			checker.movetype = MOVETYPE_STEP;
			setsize(checker, self.mins, self.maxs);

			oself = self;
			self = checker;
			droptofloor();

			cj = walkmove(0,0);

			self = oself;

			if (cj == TRUE && (checker.flags & FL_ONGROUND))
				monsterjump(2);
			if (checker)
				remove(checker);
			return;
		}
	}
};

/*
=============
ai_fly - the monster is flying its beat
=============
*/

.float airtight_finished;
void(float dist) ai_fly =
{
	local float r;
	local	vector	source;

	if (self.health < 1)
		return;

	if (self.enemy.owner.flags & FL_NOTARGET)
	{
		if (self.th_stand)
			self.think = self.th_stand;
		self.nextthink = time;
		self.velocity = '0 0 0';
		return;
	}

	ai_watercheck_removal();

	// Whenever a new monster that's a flying type is added that is MOVETYPE_FLY
	// they need to be added to this list...
	if (self.twister_damage_finished < time)
	{
		if (self.classname == "horror" || self.classname == "troglod" || self.classname == "raven")
			self.movetype = MOVETYPE_FLY;
		else
			self.movetype = MOVETYPE_NOCLIP;
		self.angles_x = self.angles_z = 0;
		self.avelocity = '0 0 0';
	}

	if (self.enemy.health < 1)
	{
		self.velocity = '0 0 0';
		self.ai_reattack = FALSE;
		if (self.movetype != MOVETYPE_NOCLIP) // this is important
			self.enemy = world;
		if (self.awareness == 4) // enemy is dead, find new target visible
			self.awareness = 2; // all seeing eye
		self.th_stand();
		return;
	}
	if (self.health < 1) // I've had issues with monsters not completely dying so this is a safety check
	{
		self.th_die();
		return;
	}
	r = range(self, self.enemy);

	// look in the players direction
	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	if (self.enemy.flypain)
	{
		if (self.classname != "ethskull") // etheral skulls need to backup after hitting target
			self.velocity = self.velocity * -1 / 2;
		if (self.classname == "horror" && self.enemy) // prevent fireball spam on Vigil wakeup
			self.attack_finished = time + 3;

		self.th_stand();
		return;
	}

	CombatThink();

	// Equip noclip monsters with tighter flying, aside from etheral skull
	if (self.movetype == MOVETYPE_NOCLIP)
	{
		if (self.airtight_finished < time)
		{
			if (random() < 0.5)
				self.velocity = self.velocity / 2;
			else
				self.velocity = self.velocity / 6;
			self.airtight_finished = time + 0.5;
		}
	}

	if (self.movetype == MOVETYPE_FLY)
	{
		if (visible(self.enemy))
		{
			if (self.origin_x < self.enemy.origin_x)
				self.velocity_x = self.velocity_x + dist;
			if (self.origin_x > self.enemy.origin_x)
				self.velocity_x = self.velocity_x - dist;
			if (self.origin_y < self.enemy.origin_y)
				self.velocity_y = self.velocity_y + dist;
			if (self.origin_y > self.enemy.origin_y)
				self.velocity_y = self.velocity_y - dist;
			if (self.origin_z < self.enemy.origin_z)
				self.velocity_z = self.velocity_z + dist / 2;
			if (self.origin_z > self.enemy.origin_z)
				self.velocity_z = self.velocity_z - dist / 2;

			source = self.origin;
			traceline (source, source - v_up*48, FALSE, self);
			if (trace_fraction == 1.0)
				return;

			if (trace_ent.solid == SOLID_BSP)
				self.velocity_z = (dist * 4); // stay off ground
		}
		else
		{
			self.velocity = '0 0 0';
			self.velocity_z = self.velocity_z + 15;
		}
	}
	else
	{
		if (self.origin_x < self.enemy.origin_x)
			self.velocity_x = self.velocity_x + dist;
		if (self.origin_x > self.enemy.origin_x)
			self.velocity_x = self.velocity_x - dist;
		if (self.origin_y < self.enemy.origin_y)
			self.velocity_y = self.velocity_y + dist;
		if (self.origin_y > self.enemy.origin_y)
			self.velocity_y = self.velocity_y - dist;
		if (self.origin_z < self.enemy.origin_z)
			self.velocity_z = self.velocity_z + dist;
		if (self.origin_z > self.enemy.origin_z)
			self.velocity_z = self.velocity_z - dist;
	}

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	if (self.flags & FL_PARTIALGROUND)
		self.flags = self.flags - FL_PARTIALGROUND;

	if (vlen(self.velocity) > 800) // max cap movement speed
		self.velocity = self.velocity / 3; // divided by 3
};

/*
=============
ai_walk - the monster is walking its beat
=============
*/

.float aistuck_finished;
void(float dist) ai_walk =
{
	local float r, ran;

	if (self.health < 1)
	{
		if (self.th_die)
			self.th_die();
		return;
	}

	if (self.enemy.owner.flags & FL_NOTARGET)
	{
		if (self.th_stand)
			self.think = self.th_stand;
		self.nextthink = time;
		return;
	}

	// Allows triggers to be hit, touchtriggers does nothing
	//MakeSolidList(FALSE);
	//UnmakeSolidList();
	//

	if (self.flags & FL_ONGROUND)
		self.velocity_x = 0; // Remove X velocity when landed on the ground to stop sliding

	ai_watercheck_removal();
	close_check(); // don't allow player inside origin point
	monster_removeslide();

	r = range(self, self.enemy);

	// Disabled, Twister made enemies flip in the air in the older versions. It was cool but
	// hard to work out all the bugs, so I'll keep this left over code if I ever come back to
	// fix that up. Low priority.
	/*
	if (self.twister_damage_finished < time)
	{
		self.movetype = MOVETYPE_STEP;
		self.angles_x = self.angles_z = 0;
		self.avelocity = '0 0 0';
	}
	*/

	if (self.enemy.health < 1) // Target destroyed
	{
		self.ai_reattack = FALSE;
		self.enemy = world;
		if (self.awareness == 4)
			self.awareness = 2; // all seeing eye
		if (self.classname == "baron")
			self.think = baron_hidesword1; // baron hides his sword then resumes th_stand(); manually
		else
		{
			if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
			{
				if (self.th_swim)
					self.think = self.th_swim;
				else
					self.think = self.th_stand;
			}
			else
				self.think = self.th_stand;
		}
		self.nextthink = time + 0.1;
		return;
	}
	
	// Long range archer permission to fire + other archer stuff
	if (self.classname == "archer")
		self.forceface_finished = time + 100; // archers ALWAYS look at the player exactly
	if (self.classname == "archer" && self.mode == 1) // mode 1 archers do not have to see their target to hit them...
		CombatThink();

	//
	// Zombie has a special condition to check on the health of any near by Zombie boss monster and heal them!
	//
	if (self.classname == "zombie")
	{
		if (self.enemy.classname != "zombieboss")
		{
			local entity y;
			y = find(world, classname, "zombieboss");
			while (y)
			{
				local float	r2;
				r2 = vlen (self.origin - y.origin);

				if (y.health <= y.state && r2 <= 800 && visible(y)) // if zombie boss health is 1/3 or under
				{
					self.oldenemy = self.enemy; // store
					self.enemy = y; // have the zombies heal the boss of zombies!
				}
				y = find(y, classname, "zombieboss");
			}
			y = find(world, classname, "zombieboss");
		}
		else
		{
			if (self.enemy.health >= self.enemy.max_health / 2)
			{
				if (self.oldenemy.health > 0)
					self.enemy = self.oldenemy;
				else
				{
					self.enemy = world;
					self.th_stand();
					return;
				}
			}
		}
	}

	if (self.th_jump)
	{
		if (self.flags & FL_ONGROUND && self.nojump == FALSE)
			check_for_ledge();
	}

	if (self.classname == "esquid") // electric squid rotates as it moves
		self.angles_y = self.angles_y + 30;
	else if (self.flags & FL_ONGROUND) // look in the players direction
	{
		if (self.forceface_finished > time)
		{
			local vector view;
			view = vectoangles(self.enemy.origin - self.origin);
			self.angles_y = view_y;
		}
		else
		{
			if (self.origin_x < self.enemy.origin_x)
				self.angles_y = 0;
			else
				self.angles_y = 180;
		}
	}

	// barons / electric squids / troglod / dragons never stand still
	// and neither do any other enemies if the player is vunerable!
	if (self.monster_running == FALSE && self.classname != "baron" && self.classname != "esquid"
	&& self.classname != "troglod" && self.classname != "dragon" && self.enemy.tired_finished < time && self.enemy.angles != self.angles && self.enemy.owner.hflask_drink_finished < time)
	{
		if (self.stand_finished < time)
		{
			if (random() < 0.1)
			{
				if (random() < 0.7)
				{
					self.stand_finished = time + 1 * random()*2;
					self.think = self.th_stand;
					self.nextthink = time;
					//return;
				}
			}
		}
	}

	if (self.enemy.flypain)
	{
		if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		{
			if (self.th_swim)
				self.th_swim();
			else
				self.th_stand();
		}
		else
			self.th_stand();
	}

	if (self.flags & FL_ONGROUND)
	{
		if (range(self, self.enemy) >= RANGE_FAR || (self.enemy.angles_y == self.angles_y || self.enemy.tired_finished > time || self.enemy.owner.hflask_drink_finished > time || self.enemy.headsmash_recovery_finished > time))
		{
			if (self.th_run)
			{
				if (self.monster_running == FALSE)
				{
					self.monster_running = TRUE;
					self.think = self.th_run;
					self.nextthink = time;
					//self.th_run();
				}
			}
			else
			{
				if (self.monster_running == TRUE)
				{
					self.monster_running = FALSE;
					self.think = self.th_walk;
					self.nextthink = time;

					//self.th_walk();
				}
			}
		}
		else
		{
			if (self.monster_running != FALSE)
			{
				self.monster_running = FALSE;
				if (self.th_walk)
				{
					self.think = self.th_walk;
					self.nextthink = time;
				}
				else
				{
					self.think = self.th_run;
					self.nextthink = time;
				}

/*
				if (self.th_walk)
					self.th_walk();
				else
					self.th_run();
*/
			}
		}
	}

	if (self.ai_reattack == FALSE)
	{
		// Fuzzy logic to wiggle if the AI gets stuck / Trying to get to Vigil
		if (self.oldorigin == self.origin)
		{
			if (self.aistuck_finished < time)
			{
				self.aistuck_finished = time + ceil(random()*4);
				self.lip = ceil(random()*2);
			}
			else
			{
				ai_strafe(dist);
			
				if (self.lip == 1)
					walkmove (self.angles_y, dist * (-1 / 1.55)); // Back up from stuck position to wiggle out?
				else
					walkmove (self.angles_y, dist * (1 / 1.25)); // Go forth
				return;
			}
		}
		self.oldorigin = self.origin;
		
		//
		// Traceline check if something breakable is blocking my path and I can smash it
		//

		makevectors(self.angles);
		traceline (self.origin, self.origin + v_forward*64 - v_up*24, FALSE, self); // center
		if (trace_ent.classname == "breakable")
		{
			if (self.th_melee)
				self.th_melee();
		}
		
		traceline (self.origin, self.origin + v_forward*64 - v_up*24 - v_right * 16, FALSE, self); // left
		if (trace_ent.classname == "breakable")
		{
			if (self.th_melee)
				self.th_melee();
		}

		traceline (self.origin, self.origin + v_forward*64 - v_up*24 + v_right * 16, FALSE, self); // right
		if (trace_ent.classname == "breakable")
		{
			if (self.th_melee)
				self.th_melee();
		}
		
		// Only 'navigate stupidly' when I can't see Vigil or I'm an electric squid
		if (!visible(self.enemy) || self.classname == "esquid")
		{
			if (self.classname == "esquid")
				CombatThink();
			movetogoal(dist);
			return;
		}

		// No need to shift foreground/background as I'm lined up my enemy
		if (self.origin_y < self.enemy.origin_y + 20 && self.origin_y > self.enemy.origin_y - 20)
		{
			if (self.enemy.inair && range(self, self.enemy) != RANGE_FAR)
				walkmove (self.angles_y, dist * (-1 / 1.25)); // Back up from air attacks
			else if (!(self.origin_x > self.enemy.origin_x - 40 && self.origin_x < self.enemy.origin_x + 40))
			{
				if (!walkmove (self.angles_y, dist)) // walkmove failed, push with movetogoal();
					movetogoal(dist);
			}
		}
		else
		{
			if (self.origin_y < self.enemy.origin_y)
			{
				if (self.angles_y == 0)
					walkmove (self.angles_y + 90, dist);
				else
					walkmove (self.angles_y - 90, dist);
			}
			else
			{
				if (self.angles_y == 0)
					walkmove (self.angles_y - 90, dist);
				else
					walkmove (self.angles_y + 90, dist);
			}
			if (!(self.origin_x > self.enemy.origin_x - 40 && self.origin_x < self.enemy.origin_x + 40))
			{
				if (!walkmove (self.angles_y, dist / 1.5)) // Move forward towards Vigil half speed
					movetogoal(dist / 1.5);
			}
		}
	}

	if (visible(self.enemy))
		CombatThink();
};

/*
=============
ai_swim - the monster is swimming its beat
=============
*/

void(float dist) ai_swim =
{
	local float r, lngth;
	local vector source;

	if (!self.enemy) // needed to stop choppy movement
		walkmove(0, 0); // use triggers on standing

	if (!self.enemy)
	{
		FindTarget();
		return;
	}

	r = range(self, self.enemy);

	if (self.enemy.health < 1) // Target destroyed
	{
		self.ai_reattack = FALSE;
		self.enemy = world;
		if (self.awareness == 4)
			self.awareness = 2; // all seeing eye
		return;
	}

	if (self.enemy.owner.flags & FL_NOTARGET)
	{
		if (self.th_stand)
			self.think = self.th_stand;
		self.nextthink = time;
		self.velocity = '0 0 0';
		return;
	}

	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	//
	// Jump out of the water after the player if possible
	//
	if (self.classname == "merman")
	{
		if (pointcontents(self.origin) == CONTENT_WATER)
		{
			if (self.enemy.origin_z > self.origin_z + 32 && !self.enemy.swimming && self.enemy.onground && r != RANGE_FAR && self.waterjump_finished < time)
			{
				self.waterjump_finished = time + 6;
				self.th_jump();
				return;
			}
		}
	}

	if (self.enemy.flypain)
	{
		self.velocity = '0 0 0';
		return;
	}

	CombatThink();
	
	if (!pointcontents(self.origin) == CONTENT_WATER)
	{
		if (self.velocity_z > 0)
			self.velocity_z = 0;
		self.velocity_z = self.velocity_z -50;
	}

	lngth = vlen(self.enemy.origin - self.origin);
	lngth = lngth / 6;
	if (lngth > 5) lngth = 5;

	if (visible(self.enemy))
	{
		if (self.origin_x < self.enemy.origin_x)
			self.velocity_x = self.velocity_x + dist + lngth;
		if (self.origin_x > self.enemy.origin_x)
			self.velocity_x = self.velocity_x - dist - lngth;
		if (self.origin_y < self.enemy.origin_y)
			self.velocity_y = self.velocity_y + dist + lngth;
		if (self.origin_y > self.enemy.origin_y)
			self.velocity_y = self.velocity_y - dist - lngth;
		if (self.origin_z < self.enemy.origin_z)
			self.velocity_z = self.velocity_z + dist + lngth;
		if (self.origin_z > self.enemy.origin_z)
			self.velocity_z = self.velocity_z - dist - lngth;

		source = self.origin;
		traceline (source, source - v_up*30, FALSE, self);
		if (trace_fraction == 1.0)
			return;		

		if (trace_ent.solid == SOLID_BSP)
			self.velocity_z = self.velocity_z + dist * 4; // stay off ground
	}
	else
		self.velocity = '0 0 0';
			
	if (vlen(self.velocity) > 100) // max cap movement speed
		self.velocity = self.velocity / 2;		

	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() ghoul_rise1;
void() wakeup =
{
	local entity player;

	player = find(world, classname, "player");

	if (player && !self.enemy)
	{
		FireAwakeTargets();
		
		dprint (self.classname);
		dprint (" has woken up to fight.\n");
		self.enemy = player;
		if (self.classname == "ghoul") // ghouls are special
			self.think = ghoul_rise1;
		else
			self.think = HuntTarget;
		self.nextthink = time;
	}
};

//
// Monster damage physics - Begin
//

void(entity attacker) monster_pain =
{
	if (self.classname == "player")
		return; // Oddly this is needed to fix a bug where Vigil can turn (colormod) red when blocked in mid-air even if he's never called it

	// Face player properly before physics are ran -
	// This is intentionally inaccurate; allows the player to control the battlefield moreso by using angle checks instead of origin_x (left/right)
	// whereas the opposite is true for monsters vs player
	if (attacker.angles_y >= 90 && attacker.angles_y <= 270)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	// Color flash on pain
	if (self.block_finished < time || self.deadflag != DEAD_DEAD)
		self.colormod = '3 1 1';

	// Ignore air combo flag is on the monster
	// My enemy isn't on the ground, otherwise physics are ran 
	if (self.ignoreaircombo && !self.enemy.onground && (!self.grabbed && !self.enemy.grabbed))
		return;

	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		self.velocity = '0 0 0';
		return;
	}

	if (self.flags & FL_ONGROUND) // required
		self.flags = self.flags - (self.flags & FL_ONGROUND);

	self.velocity_y = 0;

	if (self.grabbed == TRUE)
		self.th_grab();
	if (self.movetype == MOVETYPE_FLY)
		self.velocity_z = self.velocity_z - 150;
	else if (self.movetype == MOVETYPE_NOCLIP)
		self.velocity = '0 0 0';

	makevectors(self.angles);
	if (self.knockback == 1)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 300;

		if (self.angles_y >= 90 && self.angles_y <= 270)
			self.velocity_x = 100;
		else
			self.velocity_x = -100;
	}
	else if (self.knockback == 2)
	{
		self.velocity = '0 0 0';
		if (self.ignoreaircombo && !self.grabbed) // heavy weight enemy
			self.velocity_z = 212;
		else
			self.velocity_z = 425;
	}
	else if (self.knockback == 3)
	{
		self.velocity = '0 0 0';
		setorigin(self, self.origin);
		self.velocity_z = 300;

		if (self.angles_y >= 90 && self.angles_y <= 270)
			self.velocity_x = 300;
		else
			self.velocity_x = -300;
	}
	else if (self.knockback == 4)
	{
		self.velocity_z = 200;

		if (self.angles_y >= 90 && self.angles_y <= 270)
			self.velocity_x = 50;
		else
			self.velocity_x = -50;

		self.paincount = 2;
	}
	else if (self.knockback == 5)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 350;

		if (self.angles_y >= 90 && self.angles_y <= 270)
			self.velocity_x = 200;
		else
			self.velocity_x = -200;
	}
	else if (self.knockback == 6)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 0;

		if (self.angles_y >= 90 && self.angles_y <= 270)
			self.velocity_x = 400;
		else
			self.velocity_x = -400;
	}
	else if (self.knockback == 7)
	{
		self.velocity = '0 0 0';
		self.velocity_z = -500;
	}
	self.knockback = FALSE;
};

//
// Damage physics - End
//

void() player_move;
void() monster_death =
{
	if (self.colormod != '1 1 1')
		self.colormod = '1 1 1';

	self.berserk_finished = time;
	if (self.flags & FL_ONGROUND)
		self.velocity_x = self.velocity_y = 0;

	if (self.classname != "skeleton") // needs to hit floor for second animation
		self.flags = self.flags - (self.flags & FL_ONGROUND); // Allow drop

	if (self.deadflag == DEAD_DEAD)
		return;

	if (vlen(self.velocity) < 1 || self.flags & FL_ONGROUND || self.flags & FL_PARTIALGROUND || self.origin == self.oldorigin || checkground(self))
	{
		if (self.movetype != MOVETYPE_NOCLIP)
		{
			local entity effect;
	
			makevectors (self.angles);

			effect = spawn();
			setorigin(effect, self.origin);
			setmodel(effect, "progs/dust.spr");	
			effect.solid = SOLID_NOT;
			effect.owner = self;
			effect.movetype = MOVETYPE_NOCLIP;

			effect.think = dust_think;
			effect.nextthink = time;

			self.velocity_x = 0;
		}

		if (self.classname == "horror")
		{
			sound (self, CHAN_AUTO, "horror/crunch.wav", 1, ATTN_NORM);
			ThrowGib("progs/gib1.mdl");
			ThrowGib("progs/gib3.mdl");
		}
		else
			sound (self, CHAN_BODY, "misc/hitgrond.wav", 1, ATTN_NORM);

		self.avelocity = '0 0 0';
		self.angles_x = 0;
		self.takedamage = DAMAGE_NO;
		self.deadflag = DEAD_DEAD;
	}
	if (self.flags & FL_SWIM)
	{
		self.takedamage = DAMAGE_NO;
		self.deadflag = DEAD_DEAD;
	}
	self.oldorigin = self.origin;
};

.float nodrop; // don't auto-drop to floor
void() enemy_start =
{
	self.oeffects = 0;
	
	if (!walkmove(0,0))
	{
		dprint ("walk monster in object/wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
	if (self.movetype == MOVETYPE_STEP && !self.nodrop && !self.flags & FL_SWIM)
	{
		self.origin_z = self.origin_z + 1; // raise then drop
		droptofloor();
	}

	self.use = wakeup; // monsters can be woken up by triggers
	self.takedamage = DAMAGE_AIM;
	self.flags = self.flags | FL_MONSTER;

	self.solid = SOLID_SLIDEBOX;
	self.flags |= FL_FINDABLE_NONSOLID;
	self.dimension_hit = 1;
	self.dimension_solid = 2;

	// FTE: Monsters need to obey the rules of clip brushes with wrbrushes
	//if (self.movetype != MOVETYPE_NOCLIP)
	//	self.hitcontentsmaski = CONTENTBIT_SOLID|0x00000002i|CONTENTBIT_BODY|CONTENTBIT_PLAYERCLIP;

	//
	// Spawnflag setups
	//

	// * Spawnflag 4 is reserved for Hell Knight / progression (Map01) stuff *

	if (self.spawnflags & 64) // Ignore clip brushes
		self.hitcontentsmaski = CONTENTBIT_SOLID|0x00000002i|CONTENTBIT_BODY;
	if (!self.spawnflags & 2) // Allow drop when spawnflag 2 isn't set
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	if (self.spawnflags & 8) // Monster stays in air until hit/woken up
		self.movetype = MOVETYPE_FLY;
	
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		if (self.th_swim)
			self.th_swim();
		else
			self.th_stand();
	}
	else
		self.th_stand();

	self.max_health = self.health; // Set max health for half-health trigger checks
	self.view_ofs = '0 0 1';
};