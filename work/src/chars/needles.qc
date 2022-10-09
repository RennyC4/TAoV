/*
+--------+
|Needles |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| An organic landmine creatures, explodes on contact but dies easily         |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

void() needles_die =
{
	local entity effect;
	
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	
	if (self.cnt < 50)
	{
		if (self.cnt == 1) // run once
			GiveExperience(self.experience);
		self.scale = self.scale + 0.1;
		self.cnt = self.cnt + 1;
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		sound (self, CHAN_BODY, "needles/die.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}
	self.think = needles_die;
	frameskip(0.01);
};

void() needles_think =
{
	local entity head;

	if (other.flags & FL_MONSTER)
		return;

	makevectors (self.angles);
	head = searchradius(self.origin, 10 * (self.scale * 1.25));
	while (head)
	{
		if (head.takedamage && head.classname == "player" && head.health > 0)
		{
			sound (self, CHAN_BODY, "needles/die.wav", 1, ATTN_NORM);

			head.knockback = 4; // always fall, even if on ground
			T_Damage (head, self, self, 50,0);
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
			remove(self);
			return;
		}
		head = head.chain;
	}
	
	// Bob up & down gently
	if (self.mode == 0)
	{
		if (self.velocity_z < 10)
			self.velocity_z = self.velocity_z + 1;
		else
			self.mode = 1;
	}
	else
	{
		if (self.velocity_z > -10)
			self.velocity_z = self.velocity_z - 1;
		else
			self.mode = 0;
	}
	frameskip(0.1);
};

void() monster_needles =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("needles/die.wav");
	
	precache_model ("progs/needles.mdl");
	setmodel (self, "progs/needles.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.movetype = MOVETYPE_FLY;
	self.health = 1;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_AIM;
	self.classname = "needles";
	self.displayname = "Needles";
	self.netname = "solid";
	self.avelocity = '0 50 0';
	self.cnt = 0;
	if (!self.scale)
		self.scale = 1;
	self.flags = self.flags | FL_MONSTER;
	self.experience = 20;
	self.maxgold = 30;
	self.noblood = TRUE;

	self.th_die = needles_die;
	self.think = needles_think;
	self.nextthink = time + 0.1;
};