/*
+-------------+
|Medusa Head  |
+-------------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Typical Castlevania style medusa head monster, highly annoying             |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

// flymode 0 the medusa head is flying up
// flymode 1 the medusa head is flying down
// spawnflag 1 turns off Y axis player tracking

.float flytime;
.float flymode;

void() medusa_think =
{
	local entity effect, player;
	local float ct;
	local vector view;

	if (!self.spawnflags & 1)
	{
		// Track player's Y origin
		player = find(world, classname, "player");
		while (player)
		{
			if (visible(player) && infront(player))
			{
				self.enemy = player;
				ct = vlen(self.enemy.origin - self.origin);

				// keep medusa head somewhat in line with its target
				if (self.enemy.origin_y > self.origin_y)
					self.velocity_y = self.velocity_y + (ct * 0.1) * frametime; // the speed
				else
					self.velocity_y = self.velocity_y + (ct * 0.1) * frametime * -1; // the speed
			}
			else
			{
				self.enemy = world; // erase to find next player
				self.velocity_y = 0;
			}
			player = find(player, classname, "player");
		}
	}

	// Do damage
	local entity headdmg = searchradius(self.origin, 10);
	while (headdmg)
	{   // Frame241 = double jump
		if (headdmg.takedamage && headdmg.classname == "player" && headdmg.health > 0 && self.combo_finished < time && headdmg.frame != 241 && !headdmg.owner.flags & FL_NOTARGET && !headdmg.flypain)
		{
			// spawn a hit sprite
			effect = spawn();
			setorigin(effect, headdmg.origin);
			setmodel(effect, "progs/jhit.spr");
			effect.movetype = MOVETYPE_NOCLIP;
			effect.think = fx_think;
			effect.effects = EF_NODEPTHTEST;
			effect.nextthink = time;
			effect.solid = SOLID_NOT;
			FireMelee(13,0,1,15,5,0,TRUE,TRUE,0,0);
			self.combo_finished = time + 3; // Allow re-hit after time passed
		}
		headdmg = headdmg.chain;
	}

	// Movement
	if (self.flymode == 0) // up
	{
		if (self.velocity_z < 140)
			self.velocity_z = self.velocity_z + (300 * frametime);
		else
			self.velocity_z = 140;
	}
	else // down
	{
		if (self.velocity_z > -140)
			self.velocity_z = self.velocity_z - (300 * frametime);
		else
			self.velocity_z = -140;
	}

	if (self.pain_finished < time)
	{
		if (self.flymode < 1)
			self.flymode = self.flymode + 1;
		else
			self.flymode = 0;

		self.pain_finished = time + self.owner.flytime;
	}

	// Remove self after timer
	if (self.attack_finished < time)
	{
		if (self.alpha > 0)
			self.alpha = self.alpha - 0.01;
		else
		{
			remove(self);
			return;
		}
	}
	else // fade in
	{
		if (self.alpha < 1)
			self.alpha = self.alpha + 0.01;
	}
	frameskip (0.01);
};

void() medusa_die =
{
	local entity effect;

	GiveExperience(self.experience);
	effect = spawn();
	setorigin(effect, self.origin + v_up * 14);
	setmodel(effect, "progs/fire.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.think = firesprite_think;
	effect.nextthink = time;
	effect.solid = SOLID_NOT;
	sound (self, CHAN_VOICE, "medusa/headdie.wav", 0.5, ATTN_NORM);
	sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);
	ThrowGib("progs/gib3.mdl");
	spawn_embers();
	remove(self);
};

void() medusa_spawn =
{
	local entity medusa;

	medusa = spawn();

	medusa.owner = self;
	setmodel (medusa, "progs/medusahead.mdl");
	medusa.movetype = MOVETYPE_NOCLIP;
	medusa.solid = SOLID_NOT;
	medusa.takedamage = DAMAGE_AIM;
	medusa.classname = "medusahead";
	medusa.displayname = "Medusa Head";
	medusa.netname = "solid";
	medusa.effects = self.effects;
	medusa.alpha = 0.01;
	medusa.dimension_hit = 1;
	medusa.dimension_solid = 2;

	medusa.health = 1;
	setorigin (medusa, self.origin);
	setsize (self, '-17 -7 3', '13 10 28');
	medusa.th_die = medusa_die;
	medusa.angles = self.angles;
	medusa.experience = 25;
	medusa.maxgold = 50;
	medusa.flags |= FL_MONSTER;
	medusa.spawnflags = self.spawnflags; // carry over spawnflags
	
	if (self.lip)
		medusa.effects = EF_FULLBRIGHT | EF_NODEPTHTEST;
	else
		medusa.effects = EF_FULLBRIGHT;
	
	medusa.attack_finished = time + self.attack_finished;

	medusa.speed = self.speed;
	medusa.pain_finished = time + self.flytime;

	// Move the medusa head forward
	if (self.angles_y == 0)
		medusa.velocity_x = self.speed;
	else
		medusa.velocity_x = -self.speed;

	medusa.think = medusa_think;
	medusa.nextthink = time;
	
	//medusa.nextthink = time + 0.1;

	self.nextthink = time + (self.cnt2 + random()*4);
};

void() medusahead_spawner = // medusa head spawner
{
	if (!self.cnt2) // how fast to spawn + random 4 seconds
		self.cnt2 = 5;
	if (!self.speed) // speed it moves forward at
		self.speed = 70;
	if (!self.flytime) // medusa head decides to move up/down by second
		self.flytime = 1;
	if (!self.attack_finished) // how long to fly before removing itself
		self.attack_finished = time + 60;

	precache_sound ("medusa/headdie.wav");
	precache_model ("progs/medusahead.mdl");
	setmodel (self, "progs/null.spr");

	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "medusaspawner";
	
	setsize(self, '0 0 0', '0 0 0');

	self.think = medusa_spawn;
	self.nextthink = time + self.cnt2;
};