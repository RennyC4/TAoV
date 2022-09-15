/*
+----------------+
|Ethereal Skull  |
+----------------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Slowly floats towards the player and touches him delivering damage         |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame idle1

// stand
void() ethskull_1	=[	$idle1,	ethskull_1		] {ai_stand();};
// move
void() ethskull_2	=[	$idle1,	ethskull_2		] 
{
	local entity head, effect;
	
	if (self.pain_finished < time)
	{
		self.pain_finished = time + 6;
		sound (self, CHAN_BODY, "ethskull/idle.wav", 1, ATTN_NORM);
	}

	head = searchradius(self.origin, 10 * (self.scale * 1.05));
	while (head)
	{
		if (head.takedamage == DAMAGE_AIM && head.classname == "player" && head.health > 0 && self.attack_finished < time)
		{
			// spawn a hit sprite
			effect = spawn();
			setorigin(effect, head.origin);
			setmodel(effect, "progs/jhit.spr");
			effect.movetype = MOVETYPE_NOCLIP;
			effect.think = fx_think;
			effect.effects = EF_NODEPTHTEST;
			effect.nextthink = time;
			effect.solid = SOLID_NOT;

			if (self.angles_y == 0)
				self.velocity_x = -50;
			else
				self.velocity_x = 50;
		
			sound (self, CHAN_WEAPON, "player/bigcut.wav", 1, ATTN_NORM);
			head.knockback = 4; // always fall, even if on ground
			self.status_blind_finished = time + 20;
			T_Damage (head, self, self, 28, 0.44);
			self.attack_finished = time + 3;
		}
		head = head.chain;
	}
	ai_fly(12);
};

//pain
void() ethskull_3	=[	$idle1,	ethskull_2		] 
{
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		self.th_die();
		return;
	}
	sound (self, CHAN_BODY, "skeleton/smash.wav", 1, ATTN_NORM);

	skel_particle();
	self.airtight_finished = time + 1;
	monster_pain(self.enemy);

	// Back away on hits
	if (self.angles_y == 0)
		self.velocity_x = -50;
	else
		self.velocity_x = 50;

	self.attack_finished = time + 0.8;
	self.nextthink = time + 0.1;
};

void() ethskull_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		self.velocity = '0 0 0';
		GiveExperience(self.experience);
		self.gaveexp = TRUE;
		self.solid = SOLID_NOT;
		self.takedamage = DAMAGE_NO;
		sound (self, CHAN_BODY, "ethskull/death.wav", 1, ATTN_NORM);
		self.velocity = '0 0 0';
	}
	if (self.scale > 0)
	{
		self.scale = self.scale - 0.01;
		if (self.alpha > 0)
			self.alpha = self.alpha - 0.005;
	}
	else
	{
		remove(self);
		return;
	}

	self.think = ethskull_die;
	frameskip(0.01);
};

void() ethskull_flame_think =
{
	if (self.owner.health < 1)
	{
		if (self.scale < 6)
		{
			self.scale = self.scale + 0.01;
			if (self.alpha > 0)
				self.alpha = self.alpha - 0.005;
		}
		else
		{
			remove(self);
			return;
		}
	}
	makevectors (self.owner.angles); // needed for smooth origin calls
	if (self.owner)
	{
		setorigin (self, self.owner.origin + v_up*18);
		self.angles_x = self.owner.angles_x;
		self.angles_z = self.owner.angles_z;
	}
	frameskip (0.01);
};

void() ethskull_flame =
{
	local entity flame;
	
	flame = spawn();
	flame.owner = self;
	flame.colormod = '1 1 3';
	setmodel (flame, "progs/ethflame.mdl");
	setorigin (flame, self.origin);
	flame.movetype = MOVETYPE_NOCLIP;
	flame.solid = SOLID_NOT;
	flame.alpha = 0.5;
	flame.scale = 3;
	flame.frame = 1;
	flame.effects = EF_NODEPTHTEST | EF_ADDITIVE;
	flame.think = ethskull_flame_think;
	flame.nextthink = time + 0.1;
};

/*QUAKED monster_ethskull (1 0 0) (-32 -32 -24) (32 32 64)
Flying noclip monster
"awareness":
0 (default) notice player when near and visible
1 notice player if visible at all
2 notice player instantly
3 ignore player, check if camera is infront of monster
4 not aware at all, must be triggered
"target":
If monster is given a target, when the monster dies it
can cause an event such as a door opening!
*/
void() monster_ethskull =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/ethskull.mdl");
	precache_model ("progs/ethflame.mdl");
	precache_sound ("skeleton/smash.wav");
	precache_sound ("ethskull/idle.wav");
	precache_sound ("ethskull/death.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NOCLIP;
	setmodel (self, "progs/ethskull.mdl");
	if (difficulty < 2)
		self.health = 100; // regular health
	else
		self.health = 150; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;

	self.classname = "ethskull";
	self.displayname = "Ethereal Skull";
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	self.colormod = '1 1 3';
	self.scale = 3;
	self.alpha = 0.9;
	self.effects = EF_NODEPTHTEST;
	self.experience = 44;
	self.maxgold = 118;

	self.th_stand = ethskull_1;
	self.th_walk = ethskull_2;
	self.th_pain = ethskull_3;
	self.th_die = ethskull_die;

	self.noblood = TRUE;
	ethskull_flame();

	enemy_start();
};