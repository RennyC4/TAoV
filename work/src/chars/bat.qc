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
	local entity head;
	local vector source;

	if (!self.enemy)
	{
		head = findradius(self.origin, self.count);
		while (head)
		{
			if (head.classname == "player" && head.health > 0 && head.flypain == FALSE && visible(head) && head.origin_z < self.origin_z && !head.owner.flags & FL_NOTARGET)
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
				}
			}
			head = head.chain;
		}
	}
	else
	{
		self.movetype = MOVETYPE_FLY;
		self.touch = bat_touch;
		
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
	}

	//Hit something, remove it.
	if (self.velocity_x == 0 && self.enemy != world)
	{
		remove(self);
		return;
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
	}
	else
	{
		self.angles_y = 180;
		self.velocity_x = self.speed * -1;
	}
	
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

	if (other.flags & FL_MONSTER)
		return;

	if (other.takedamage && other.classname == "player" && other.health > 0)
		FireMelee(12,0,1,25,0,0,0,TRUE,0,0);

	effect = spawn();
	setorigin(effect, self.origin + v_up * 14);
	setmodel(effect, "progs/fire.spr");
	effect.movetype = MOVETYPE_NONE;
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
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_AIM;
	self.classname = "bat";
	self.displayname = "Bat";
	self.netname = "solid";
	self.use = bat_use;
	setsize(self, '-6 -6 7', '6 4 16');
	self.experience = 18;

	if (!self.speed)
		self.speed = 85;
	if (!self.count)
		self.count = 150;
	self.think = bat_think;
	self.nextthink = time + 0.1;
	self.th_die = bat_die;
	//spawn_shadow();
};