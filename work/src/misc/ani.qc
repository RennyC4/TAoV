//+-------+
//|Sprites|
//+-------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| All misc animations from 2D sprites to 3D models are handled here          |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

//embers from fire effects
void() ember_animate =
{
	self.frame = self.frame + 1;
	if (self.frame > 16)
	{
		remove(self);
		return;
	}
	else
		self.think = ember_animate;
			self.alpha = self.alpha - 0.08;
	frameskip(0.05);
};

void() spawn_embers =
{
	local entity embers;
	embers = spawn();
	setmodel(embers, "progs/embers.mdl");
	setorigin(embers, self.origin);
	embers.angles_y = random() * 360;
	embers.think = ember_animate;
	embers.alpha = 1;
	embers.effects = EF_ADDITIVE;
	embers.nextthink = time + 0.025;
	embers.movetype = MOVETYPE_NOCLIP;
	embers.velocity = '0 0 10';
};

//
void() fireweakness_firefx_think =
{
	self.scale = self.scale - 0.08;
	if (self.scale < 0)
	{
		remove(self);
		return;
	}
	if (self.skin < 19)
		self.skin = self.skin + 1;
	else
		self.skin = 0;
	frameskip (0.05);
};

// spark effect for blocking
void() sparkeffect =
{
	if (self.attack_finished < time)
		remove(self);
	particle (self.origin, '0 0 0', 111, 6); // yellow particles
	frameskip(0.01);
};

// charging magic / headsmash effect
void() effect_think =
{
	if (!self.frame)
		self.scale = 1.15;
	else
		self.scale = 1;

	self.angles_y = self.angles_y + 16;

	droptofloor();
	if (self.frame < 3)
		self.frame = self.frame + 1;
	else
		remove(self);
	frameskip (0.1);
};

void() perfectguard_fx_think =
{
	if (self.pain_finished < time)
	{
		if (self.frame < 3)
			self.frame = self.frame + 1;
		else
		{
			remove(self);
			return;
		}
		if (self.frame == 2)
			self.pain_finished = time + 0.4;
		else
			self.pain_finished = time + 0.05;
	}
	self.alpha = self.alpha - 0.02;
	self.scale = self.scale + 0.1;
	frameskip(0.01);
};

// Blocking vfx
void() fx_think =
{
	self.angles_z = self.angles_z + 20; // spin
	if (self.frame < 3)
		self.frame = self.frame + 1;
	else
	{
		remove(self);
		return;
	}
	frameskip(0.07);
};

// fire sprite animation
void() firesprite_think =
{
	if (self.cnt == 0)
		spawn_embers();
	if (self.cnt < 6)
		self.cnt = self.cnt + 1;
	else
	{
		remove(self);
		return;
	}
	frameskip(0.1);
};

// explosion model animation
void() explodemodel_think =
{
	if (self.frame < 5)
	{
		self.frame = self.frame + 1;
		if (self.alpha > 0.15)
			self.alpha = self.alpha - 0.15;
	}
	else
	{
		remove(self);
		return;
	}
	frameskip (0.07);
};

// large sphere effect used on flaming headsmash
void() efxflashe_think =
{
	self.avelocity = '800 800 800';
	if (self.alpha > 0.1)
		self.alpha = self.alpha - 0.005;
	if (self.scale > 12)
	{
		remove(self);
		return;
	}
	else
		self.scale = self.scale + 0.1;
	frameskip(0.01);
};

// spin attack spiral
void() spinwindspiral_think =
{
	if (self.owner.pain_finished > time || self.owner.dodge_finished > time || self.owner.block_finished > time)
	{
		remove(self);
		return;
	}
	if (self.cnt2 == 3 && self.owner.frame != 241) // 241 is $djump1
	{
		remove(self);
		return;
	}

	if (self.cnt < 50)
		self.cnt = self.cnt + 1; // rising speed
	else
		self.cnt = 50; // stop at this height

	if (self.cnt2 < 2)
	{
		self.angles_y = self.angles_y + 8; // spin speed
		setorigin (self, self.owner.origin - v_up * 30 + (v_up * self.cnt));
		if (self.attack_finished < time)
		{
			if (self.scale < 3)
				self.scale = self.scale + 0.025;
			else
			{
				if (self.alpha > 0)
					self.alpha = self.alpha - 0.05;
				else
				{
					remove(self);
					return;
				}
			}
		}
	}
	else
	{
		makevectors(self.owner.angles);
		self.angles_y = self.owner.angles_y;
		self.angles_x = self.angles_x - 12; // spin speed
		setorigin (self, self.owner.origin - v_right * 6);
		if (self.attack_finished < time)
		{
			remove(self);
			return;
		}
	}

	frameskip (0.01);
};

//wall grab sword sparks
void() spark_think =
{
	particle (self.origin, '0 0 0', 111, 2); // yellow particles
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	frameskip(0.025);
};

// mini spin attack spiral
void() spinwindspiralmini_think =
{
	if (self.owner.pain_finished > time || self.owner.dodge_finished > time || self.owner.block_finished > time)
	{
		remove(self);
		return;
	}

	setorigin (self, self.owner.origin + (v_up * 8));

	self.angles_y = self.angles_y + 8 ; // spin speed

	if (self.attack_finished < time)
	{
		self.effects = EF_ADDITIVE;
		if (self.scale < 3)
			self.scale = self.scale + 0.025;
		else
		{
			if (self.alpha > 0)
				self.alpha = self.alpha - 0.08;
			else
			{
				remove(self);
				return;
			}
		}
	}
	frameskip (0.01);
};

// sword spin attack spiral
void() player_swordspin_fx_think =
{
	if (self.owner.pain_finished > time || self.owner.health < 1 || (self.owner.frame < 256 || self.owner.frame > 267))
	{
		remove(self);
		return;
	}
	self.avelocity = '2500 0 0';

	frameskip (0.01);
};

// wind spiral
void() windspiral_think =
{
	if (self.scale < 5)
		self.scale = self.scale + 0.1;
	if (self.alpha > 0.01)
		self.alpha = self.alpha - 0.01;
	else
	{
		remove(self);
		return;
	}
	if (!self.frame)
		self.angles_y = self.angles_y + 10;
	else
		self.angles_z = self.angles_z + 10;
	self.colormod = '1 1 1' * self.alpha;
	frameskip (0.01);
};

// izuna wind spiral
void() izuna_windspiral_think =
{
	if (self.scale < 1)
		self.scale = self.scale + 0.01;
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	self.angles_y = self.angles_y + 6;

	frameskip (0.01);
};

// diving swallow hit ring model animation
void() divings_hit_think =
{
	if (self.alpha > 0.1)
		self.alpha = self.alpha - 0.1;
	if (self.frame < 9)
		self.frame = self.frame + 1;
	else
	{
		remove(self);
		return;
	}
	frameskip(0.02);
};

// dust cloud animation / movement on vigils feet
void() dust_think =
{
	if (self.owner.waterlevel > 0)
	{
		remove(self);
		return;
	}
	// Used for when a monster dies and hits the floor
	if (self.owner.flags & FL_MONSTER)
		droptofloor();

	// move the dust cloud in the opposite direction the owner is facing
	if (self.owner.angles_y == 0) // facing left
		self.velocity_x = -200;
	else if (self.owner.angles_y == 180)
		self.velocity_x = 200;

	if (self.cnt < 2)
	{
		self.alpha = 0.3;
		self.cnt = self.cnt + 1;
	}
	else
	{
		remove(self);
		return;
	}
	frameskip(0.05);
};