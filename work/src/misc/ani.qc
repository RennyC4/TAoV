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
	//droptofloor();
	if (self.frame < 3)
		self.frame = self.frame + 1;
	else
		remove(self);
	frameskip (0.07);
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

void() fx_think =
{
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
	if (self.cnt < 30)
		self.cnt = self.cnt + 2; // rising speed
	else
		self.cnt = 30; // stop at this height

	setorigin (self, self.owner.origin - v_up * 30 + (v_up * self.cnt));

	self.angles_y = self.angles_y + 8; // spin speed

	if (self.attack_finished < time)
	{
		if (self.scale < 3)
			self.scale = self.scale + 0.025;
		else
		{
			if (self.alpha > 0.05)
				self.alpha = self.alpha - 0.05;
			else
			{
				remove(self);
				return;
			}
		}
	}
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
	frameskip (0.01);
};

// diving swallow hit ring model animation
void() divingshit_think =
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