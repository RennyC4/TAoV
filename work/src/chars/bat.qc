/*
+--------+
|Bat     |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Bat that flies into an object and explodes into flames.                    |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

void() bat_touch;
void() bat_think =
{
	local entity head, effect;

	if (!self.enemy)
	{
		head = searchradius(self.origin, self.count);
		while (head)
		{
			if (head.classname == "player" && head.health > 0 && visible(head) && head.origin_z < self.origin_z && !head.owner.flags & FL_NOTARGET)
			{
				if (head != self)
				{
					setorigin (self, self.origin - v_up*28); // move out of ceiling
					self.enemy = head;
					if (self.origin_x < self.enemy.origin_x)
					{
						self.angles_y = 0;
						self.velocity_x = self.speed;
					}
					else
					{
						self.angles_y = 180;
						self.velocity_x = self.speed * -1;
					}
					self.lip = self.velocity_x; // store it
				}
			}
			head = head.chain;
		}
	}
	else
	{
		self.movetype = MOVETYPE_FLY;
		self.touch = bat_touch;

		// Do damage
		local entity headdmg = searchradius(self.origin, 5);
		while (headdmg)
		{	// Frame241 = double jump
			if (headdmg.takedamage && headdmg.classname == "player" && headdmg.health > 0 && self.combo_finished < time && headdmg.frame != 241 && !headdmg.owner.flags & FL_NOTARGET && !headdmg.flypain)
			{
				// spawn a hit sprite
				if (max_hit_ents < 10)
				{
					effect = spawn();
					setorigin(effect, headdmg.origin);
					setmodel(effect, "progs/hit2.spr");
					effect.alpha = 1;
					effect.scale = 1;
					effect.angles_z = random()*360;
					effect.angles_y = -90; // face camera
					effect.movetype = MOVETYPE_NOCLIP;
					effect.think = fx_think;
					effect.effects = EF_NODEPTHTEST;
					effect.nextthink = time;
					effect.solid = SOLID_NOT;
					max_hit_ents = max_hit_ents + 1;
				}
				FireMelee(13,0,1,20,5,0,TRUE,TRUE,0,0,1);
				self.combo_finished = time + 3; // Allow re-hit after time passed
			}
			headdmg = headdmg.chain;
		}

		if (infront(self.enemy))
		{
			if (self.origin_z > self.enemy.origin_z)
				self.velocity_z = self.speed * -1 / 2;
			else
				self.velocity_z = self.speed / 2;
			if (self.origin_y > self.enemy.origin_y)
				self.velocity_y = self.speed * -1 / 4;
			else
				self.velocity_y = self.speed / 4;
		}
		else
			self.velocity_z = self.velocity_y = 0;

		if (self.pain_finished < time)
		{
			if (self.frame < 12)
				self.frame = self.frame + 1;
			else
				self.frame = 1;
			self.pain_finished = time + 0.08; // how fast to animate
		}
		if (self.velocity_x != self.lip) // fixes bug where bats could get stuck flying still
			self.velocity_x = self.lip; // restore it
	}
	frameskip(0.01);
};

// Used for triggers to wake up
void() bat_use =
{
	setorigin (self, self.origin - v_up*28); // move out of ceiling
	self.enemy = activator;
	
	if (self.origin_x < self.enemy.origin_x)
	{
		self.angles_y = 0;
		self.velocity_x = self.speed;
		self.lip = self.velocity_x; // store it
	}
	else
	{
		self.angles_y = 180;
		self.velocity_x = self.speed * -1;
		self.lip = self.velocity_x; // store it
	}
	self.velocity_x = self.lip;

	self.think = bat_think;
	self.nextthink = time;
};

void() bat_die =
{
	local entity effect;

	sound (self, CHAN_AUTO, "bat/die.wav", 1, ATTN_NORM);
	sound (self, CHAN_AUTO, "spells/fhit.wav", 1, ATTN_NORM);

	GiveExperience(self.experience);
	effect = spawn();
	setorigin(effect, self.origin + v_up * 14);
	setmodel(effect, "progs/fire.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.think = firesprite_think;
	effect.nextthink = time;
	effect.solid = SOLID_NOT;
	remove(self);
};

void() bat_touch =
{
	local entity effect;

	if (other.solid != SOLID_BSP)
		return;

	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/fire.spr");
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = firesprite_think;
	effect.nextthink = time;
	effect.solid = SOLID_NOT;
	sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);
	remove(self);
};

void() monster_bat =
{
	precache_sound ("bat/die.wav");
	precache_model ("progs/bat.mdl");
	setmodel (self, "progs/bat.mdl");

	self.health = 1;
	self.effects = EF_FULLBRIGHT;
	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_AIM;
	self.classname = "bat";
	self.displayname = "Bat";
	self.netname = "solid";
	self.use = bat_use;
	setsize(self, '-6 -6 7', '6 4 16');
	self.experience = 18;
	self.maxgold = 10;
	self.flags |= FL_MONSTER;
	self.dimension_hit = 0;
	self.dimension_solid = 0;
	
	if (!self.speed)
		self.speed = 85;
	if (!self.count)
		self.count = 150;
	self.think = bat_think;
	self.nextthink = time + 0.1;
	self.th_die = bat_die;
	//spawn_shadow();
};