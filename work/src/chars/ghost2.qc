/*
+--------+
|Ghost2  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Chases enemies non stop, is no clip and drains the players mana,           |
| invisible except for light.                                                |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

void() ghost2_think =
{
	local entity targ;
	local float disto, draindelay;

	targ = searchradius(self.origin, 200);
	while (targ)
	{
		if (targ.classname == "player" && visible(targ) && targ.health > 1
		&& targ.invunerability_finished < time && targ.takedamage != DAMAGE_NO)
		{
			self.enemy = targ;
			disto = vlen(self.enemy.origin - self.origin);
			if (self.attack_finished < time && !targ.owner.flags & FL_GODMODE && targ.perfectguard_buff < time)
			{
				if (difficulty < 2)
					draindelay = disto / 1000;
				else
					draindelay = disto / 750;
				if (draindelay < 0.2)
					draindelay = 0.2;

				if (targ.owner.mana > 0)
				{
					targ.owner.mana = targ.owner.mana - 1;
					self.health = self.health + 1;
				}

				self.attack_finished = time + draindelay;

				if (self.cnt < time)
				{
					self.cnt = time + 3;
					sound (self, CHAN_VOICE, "ghost/cry.wav", 1, ATTN_NORM); // Sorrowful cry
				}
			}
		}
		targ = targ.chain;
	}
	if (self.enemy)
		disto = vlen(self.enemy.origin - self.origin);

	if (disto >= 200)
	{
		if (self.color_z > 0)
			self.color_z = self.color_z - 0.05;
	}
	else if (self.color_z < 1)
		self.color_z = self.color_z + 0.05;

	// Cap it
	if (self.color_z > 1)
		self.color_z = 1;
	if (self.color_z < 0)
		self.color_z = 0;

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
	self.think = ghost2_think;
	frameskip(0.1);
};

void() ghost2_pain =
{
	self.cnt = time + 3;
	monster_pain(self.enemy);
	sound (self, CHAN_BODY, "ghost/pain.wav", 1, ATTN_NORM);
};

void() ghost2_die =
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

/*QUAKED monster_ghost2 (1 0 0) (-32 -32 -24) (32 32 64)
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
void() monster_ghost2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("ghost/taunt.wav");
	precache_sound ("ghost/pain.wav");
	precache_sound ("ghost/death.wav");
	precache_sound ("ghost/cry.wav");

	self.movetype = MOVETYPE_NOCLIP;
	setmodel (self, "progs/null.spr");
	self.health = self.max_health = 20; // never changes
	self.netname = "solid";
	self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_CORONA;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.experience = 21;
	self.color = '0 0 0';
	self.flags = FL_MONSTER;
	self.classname = "ghost2";
	self.displayname = "Sorrowful Spirit";
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.noblood = TRUE;
	self.th_stand = ghost2_think;
	self.th_run = ghost2_think;
	self.th_pain = ghost2_pain;
	self.th_die = ghost2_die;
	self.think = ghost2_think;
	self.nextthink = time + 0.1;

	enemy_start();
};