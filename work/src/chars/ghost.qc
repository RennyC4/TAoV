/*
+--------+
|Ghost   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Chases enemies non stop, is no clip and drains the players health,         |
| invisible except for light.                                                |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

void() ghost_think =
{
	local entity targ;
	local float disto, draindelay;
		
	targ = searchradius(self.origin, 200);
	while (targ)
	{
		if (targ.classname == "player" && visible(targ) && targ.health > 1
		&& targ.invunerability_finished < time && targ.takedamage != DAMAGE_NO && !self.enemy.owner.flags & FL_NOTARGET && !targ.izunatarg)
		{
			self.enemy = targ;
			disto = vlen(self.enemy.origin - self.origin);
			if (self.attack_finished < time && !targ.owner.flags & FL_GODMODE && targ.perfectguard_buff < time && !self.enemy.owner.flags & FL_NOTARGET)
			{
				if (difficulty < 2)
					draindelay = disto / 1000;
				else
					draindelay = disto / 750;
				if (draindelay < 0.2)
					draindelay = 0.2;

				if (targ.health > 0)
					targ.health = targ.health - 1;
				if (self.health < self.max_health)
					self.health = self.health + 1;

				self.attack_finished = time + draindelay;

				if (self.cnt < time)
				{
					self.cnt = time + 3;
					sound (self, CHAN_VOICE, "ghost/taunt.wav", 1, ATTN_NORM);
				}
			}
		}
		targ = targ.chain;
	}
	if (self.enemy)
		disto = vlen(self.enemy.origin - self.origin);

	if (disto >= 200)
	{
		if (self.color_x > 0)
			self.color_x = self.color_x - 0.05;
	}
	else if (self.color_x < 1)
		self.color_x = self.color_x + 0.05;

	// Cap it
	if (self.color_x > 1)
		self.color_x = 1;
	if (self.color_x < 0)
		self.color_x = 0;

	if (self.enemy && self.enemy.health > 0)
	{
 		if (!self.enemy.flypain)
			ai_fly(12);
	}
	else
	{
		ai_stand();
		self.velocity = '0 0 0';
		self.color = '0 0 0';
	}
	self.think = ghost_think;
	frameskip(0.1);
};

void() ghost_pain =
{
	if (self.damage_type == 2) // Hit by fire
	{
		local entity temp;

		temp = spawn ();
		temp.movetype = MOVETYPE_NOCLIP;
		temp.solid = SOLID_NOT;
		temp.classname = "3dsprite";

		temp.alpha = 0.5;
		temp.frame = 1;

		temp.effects = EF_ADDITIVE;
		temp.alpha = 0.5;
		temp.scale = 1;
		temp.angles_y = 90; // face screen
		temp.think = fireweakness_firefx_think;
		temp.nextthink = time + 0.1;

		setmodel (temp, "progs/fire_fx.mdl");
		setsize (temp, '0 0 0', '0 0 0');	
		setorigin (temp, self.origin + v_up * 16);
		spawn_color_glow(5, 3, 0, 100, temp);
	}
	self.cnt = time + 3;
	monster_pain(self.enemy);
	sound (self, CHAN_BODY, "ghost/pain.wav", 1, ATTN_NORM);
};

void() ghost_die =
{
	self.deadflag = DEAD_DEAD;
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{			  // otherwise player can keep knocking corpse for EXP
		sound (self, CHAN_AUTO, "ghost/death.wav", 1, ATTN_NORM);
		GiveExperience(self.experience);
		self.gaveexp = TRUE;
		monster_death();
		remove(self);
		return;
	}
};

/*QUAKED monster_ghost (1 0 0) (-32 -32 -24) (32 32 64)
Flying noclip monster
"awareness":
0 (default) notice player when near and visible
1 notice player if visible at all
2 notice player instantly
3 ignore player, check if camera is infront of monster
"target":
If monster is given a target, when the monster dies it
can cause an event such as a door opening!
*/
void() monster_ghost =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("ghost/taunt.wav");
	precache_sound ("ghost/pain.wav");
	precache_sound ("ghost/death.wav");

	self.movetype = MOVETYPE_NOCLIP;
	setmodel (self, "progs/null.spr");
	self.health = self.max_health = 20; // never changes
	self.netname = "solid";
	self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_CORONA;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.experience = 21;
	self.maxgold = 20;
	self.color = '0 0 0';
	self.flags = FL_MONSTER;
	self.classname = "ghost";
	self.displayname = "Malevolent Spirit";
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.noblood = TRUE;
	self.th_stand = ghost_think;
	self.th_run = ghost_think;
	self.th_pain = ghost_pain;
	self.th_die = ghost_die;
	self.think = ghost_think;
	self.nextthink = time + 0.1;

	enemy_start();
};

// Dead wraiths become ghosts!
void() spawn_ghost =
{
	local entity ghost;

	ghost = spawn();
	ghost.movetype = MOVETYPE_NOCLIP;
	setorigin (ghost, self.origin);
	setmodel (ghost, "progs/null.spr");
	ghost.health = ghost.max_health = 20; // never changes
	ghost.experience = 21;
	ghost.maxgold = 20;
	ghost.color = '0 0 0';
	ghost.netname = "solid";
	ghost.flags = FL_MONSTER;
	ghost.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_CORONA;
	ghost.takedamage = DAMAGE_AIM;
	ghost.solid = SOLID_NOT;
	ghost.classname = "ghost2";
	ghost.displayname = "Malevolent Spirit";
	setsize (ghost, VEC_HULL_MIN, VEC_HULL_MAX);
	ghost.noblood = TRUE;
	ghost.th_stand = ghost_think;
	ghost.th_run = ghost_think;
	ghost.th_pain = ghost_pain;
	ghost.th_die = ghost_die;
	ghost.awareness = 2; // all seeing eye
	ghost.think = ghost_think;
	ghost.nextthink = time + 0.1;
	ghost.cnt = time + 3;
	ghost.owner = self;

	ghost.think = ghost.th_stand;
	ghost.nextthink = time + 0.1;
};