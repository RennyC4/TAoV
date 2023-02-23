//+-------+
//|Scenery|
//+-------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Assorted models, sprites that can be used to decorate maps.                |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() onground_touch =
{
	if (!other.flags & FL_ONGROUND && other.origin_z > self.absmax_z + 23)
		other.flags = other.flags | FL_ONGROUND;
};

void() SceneryGibRemove =
{
	if (self.alpha > 0.1)
		self.alpha = self.alpha - 0.1;
	else
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.2;
};

void(string gibname, vector org) ThrowSceneryGib =
{
	local entity gib;

	gib = spawn();
	gib.movetype = MOVETYPE_BOUNCE;
	gib.solid = SOLID_NOT;

	gib.angles_y = random() * 360;
	makevectors (gib.angles);
	gib.velocity = v_forward * random()*200;
	gib.velocity_z = random()*300;

	if (random() < 0.25)
		gib.avelocity = '1000 3000 2000';
	else if (random() < 0.50)
		gib.avelocity = '100 500 350';
	else if (random() < 0.75)
		gib.avelocity = '0 700 500';
	else
		gib.avelocity = '500 100 1000';

	gib.nextthink = time + 0.2;
	gib.think = SceneryGibRemove;
	gib.alpha = 1;

	setmodel (gib, gibname);
	setsize (gib, '0 0 0', '0 0 0');     
	setorigin (gib, org);
};

void() fountain_particlethink = 
{
	if (self.cnt == TRUE)
	{
		if (self.pain_finished < time)
		{
			remove(self);
			return;
		}
	}
	else if (self.attack_finished < time)
	{
		self.movetype = MOVETYPE_TOSS;

		self.angles_y = self.angles_y + random()*360;

		makevectors (self.angles);
		self.velocity = aim(self, 50);
		self.velocity = self.velocity * 50;
		
		self.cnt = TRUE;
		self.pain_finished = time + 0.75;
	}
	frameskip(0.01);
};

void() fountain_think =
{
	local entity part;

	part = spawn();

	part.owner = self;
	setmodel (part, "progs/fount.spr");
	part.movetype = MOVETYPE_FLY;
	part.solid = SOLID_NOT;
	part.takedamage = DAMAGE_NO;
	part.classname = "particle";
	setorigin (part, self.origin);
	setsize(part, '0 0 0', '0 0 0');

	part.velocity_z = 300;
	part.attack_finished = time + 0.8;

	part.think = fountain_particlethink;
	part.nextthink = time + 0.1;

	frameskip(0.1);
};

/*QUAKED fountain (0 1 0) (-1 -1 -1) (1 1 1)
A water fountain that sprays blue particles
*/
void() fountain =
{
	precache_model ("progs/fount.spr");
	setmodel (self, "progs/fount.spr");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "fountain";
	setsize(self, '0 0 0', '0 0 0');
	self.think = fountain_think;
	self.nextthink = time + 0.1;
	droptofloor();
};

/*QUAKED waterfall (0 1 0) (-1 -1 -1) (1 1 1)
Waterfall you can place, adjustable properties include
.scale for size
.alpha for transparency
.effects for whatever reason
.skin for texture on the waterfall.mdl
*/
void() waterfall_think =
{
	if (self.frame <= 24)
		self.frame = self.frame + 1;
	else
		self.frame = 0;
	frameskip (0.1);
};

void() waterfall =
{
	precache_model ("progs/waterfall.mdl");
	setmodel (self, "progs/waterfall.mdl");

	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "waterfall";
	setsize(self, '0 0 0', '0 0 0');
	setorigin (self, self.origin);
	self.frame = ceil(random()*25 - 1);
	self.think = waterfall_think;
	frameskip (0.1);
};

/*QUAKED fire (0 1 0) (-1 -1 -1) (1 1 1)
Placable fire effect, two sizes using frame 0 and 1
*/
void() firefx_think =
{
	if (self.skin < 19)
		self.skin = self.skin + 1;
	else
		self.skin = 0;
	frameskip (0.05);
};

void() firefx =
{
	precache_model ("progs/fire_fx.mdl");
	setmodel (self, "progs/fire_fx.mdl");

	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "fire_fx";
	setsize(self, '0 0 0', '0 0 0');
	setorigin (self, self.origin);
	self.skin = random()*19;
	self.think = firefx_think;
	self.nextthink = time + 0.1;
};

void() waterdrop_ripple_think =
{
	if (self.scale < 2)
		self.scale = self.scale + 0.005;
	else
	{
		remove(self);
		return;
	}
	if (self.alpha > 0)
	{
		self.alpha = self.alpha - 0.005;
		self.colormod = '1 1 1.25' * self.alpha; // Allow transparency without additive
	}

	frameskip(0.01);
};

void() waterdrop_ripple_vfx =
{
	local entity ripple;
	
	ripple = spawn();

	ripple.owner = self;

	precache_model ("progs/ripple.spr");
	setmodel (ripple, "progs/ripple.spr");
	setsize(ripple, '-1 -1 -1', '1 1 1');
	setorigin(ripple, self.origin);

	ripple.movetype = MOVETYPE_NOCLIP;
	ripple.solid = SOLID_NOT;

	ripple.angles_x = 90;
	ripple.scale = 0.1;
	ripple.alpha = 1;
	ripple.colormod = '1 1 1.25';
	ripple.angles_y = random()*360;
	ripple.think = waterdrop_ripple_think;
	ripple.nextthink = time;
};

void() waterdrop_fallthink =
{
	if (!self.velocity_z)
	{
		if (random() < 0.25)
			sound (self, CHAN_AUTO, "misc/drip1.wav", 1, ATTN_NORM);
		else if (random() < 0.5)
			sound (self, CHAN_AUTO, "misc/drip2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "misc/drip3.wav", 1, ATTN_NORM);
		waterdrop_ripple_vfx();
		remove(self);
		return;
	}
	frameskip(0.01);
};

void() waterdrop_think =
{
	local entity part;

	part = spawn();

	part.owner = self;
	setmodel (part, "progs/waterdrop.mdl");
	part.movetype = MOVETYPE_TOSS;
	part.solid = SOLID_NOT;
	part.takedamage = DAMAGE_NO;
	part.classname = "waterdrop_particle";
	part.effects = EF_ADDITIVE;
	part.alpha = 0.5;
	part.hitcontentsmaski = CONTENTBIT_WATER | CONTENTBIT_SLIME | CONTENTBIT_LAVA;
	part.think = waterdrop_fallthink;
	part.nextthink = time + 0.1;
	setorigin (part, self.origin);
	setsize(part, '-1 -1 -1', '1 1 1');
	self.nextthink = time + 0.1 + random()*3;
};

/*QUAKED waterdrop (0 1 0) (-1 -1 -1) (1 1 1)
Waterdrop that falls from the ceiling, set delay for spawning time
*/
void() waterdrop =
{
	precache_model ("progs/waterdrop.mdl");
	precache_sound ("misc/drip1.wav");
	precache_sound ("misc/drip2.wav");
	precache_sound ("misc/drip3.wav");

	setmodel (self, "progs/null.spr");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "waterdrop";
	setsize(self, '0 0 0', '0 0 0');
	self.think = waterdrop_think;
	self.nextthink = time + 0.1;
};

void() particlesmoke =
{
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	frameskip(0.1);
};

void() create_smoke =
{
	local entity smoke;

	smoke = spawn();
	setmodel (smoke, "progs/smoke.spr");
	smoke.movetype = MOVETYPE_NOCLIP;
	smoke.solid	= SOLID_NOT;
	setorigin(smoke, self.origin);

	smoke.velocity_z = smoke.velocity_z + 50 + random()*100;
	smoke.attack_finished = time + 0.2 + random()*0.6;
	smoke.think = particlesmoke;
	smoke.nextthink = time + 0.1;

	self.nextthink = time + 0.2;
};

/*QUAKED ambience_smoke (0 1 0) (-1 -1 -1) (1 1 1)
Chimney smoke
*/
void() ambience_smoke =
{
	setmodel (self, "progs/null.spr");
	self.classname = "smokespawner";
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage	= DAMAGE_NO;
	self.think = create_smoke;
	self.nextthink = time + 0.5 + random();
};

/*QUAKED ambience_fairylight (0 1 0) (-1 -1 -1) (1 1 1)
Fairy Light - Entity that's invisible other than EF_BRIGHTFIELD and EF_DIMLIGHT
Doesn't give off real time shadows to save on GPU usage
*/
void() ambience_fairylight =
{
	setmodel (self, "progs/null.spr");
	self.classname = "fairylight";
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage	= DAMAGE_NO;
	self.effects = EF_DIMLIGHT | EF_BRIGHTFIELD;
};

/*QUAKED dlight_dim (0 1 0) (-1 -1 -1) (1 1 1)
A real-time light using EF_DIMLIGHT, uses a lot of resources
so careful placement is recommended
*/
void() dlight_dim =
{
	setmodel (self, "progs/null.spr");
	self.classname = "dlight_dim";
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage	= DAMAGE_NO;
	self.effects = EF_DIMLIGHT;
};

/*QUAKED dlight_bright (0 1 0) (-1 -1 -1) (1 1 1)
A real-time light using EF_BRIGHTLIGHT, uses a lot of resources
so careful placement is recommended
*/
void() dlight_bright =
{
	setmodel (self, "progs/null.spr");
	self.classname = "dlight_bright";
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage	= DAMAGE_NO;
	self.effects = EF_BRIGHTLIGHT;
};

/*QUAKED dlight_pflags (0 1 0) (-1 -1 -1) (1 1 1)
A real-time light using PFLAGS for full control

self.pflags = PFLAGS_FULLDYNAMIC|otherflags;
self.light_lev = radiusoflight;
self.color = [red, green, blue];
self.style = lightstyletouse;

spawnflag 1 starts the light OFF
*/

void() dlight_pflags_use =
{
	self.light_lev = self.cnt;
	sound (self, CHAN_AUTO, "misc/fireout.wav", 1, ATTN_NORM);
};

void() dlight_pflags =
{
	precache_sound ("misc/fireout.wav");

	setmodel (self, "progs/null.spr");
	self.classname = "dlight_pflags";
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage	= DAMAGE_NO;
	self.use = dlight_pflags_use;

	self.cnt = self.light_lev; // save the light_lev to turn on

	if (self.spawnflags & 1) // Castle light off
	{
		self.model = string_null;
		self.light_lev = 0;
		self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_CORONA;
	}
	else if (self.spawnflags & 2) // Castle light on
		self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_CORONA;
	else // Give off RT Light
		self.pflags = PFLAGS_FULLDYNAMIC;
	if (!self.targetname && !self.style)
		makestatic(self);
};

/*QUAKED dlight_lightning (0 1 0) (-1 -1 -1) (1 1 1)
A real-time light using PFLAGS for full control, flashes and
gives off shadows for effect. Used for lightning in a game area.

self.pflags = PFLAGS_FULLDYNAMIC|otherflags;
self.light_lev = radiusoflight;
self.color = [red, green, blue];
self.style = lightstyletouse;

spawnflag 1 starts the light OFF
*/

void() dlight_lightning_think =
{
	if (self.cnt == FALSE)
	{
		self.light_lev = 667; // Higher levels cause FPS drops
		self.cnt = TRUE; // FLASH
		self.pflags = PFLAGS_FULLDYNAMIC;
		self.nextthink = time + random();
	}
	else
	{
		self.pflags = 0;
		self.model = string_null;
		self.cnt = FALSE;
		self.light_lev = 0;
		self.nextthink = time + 1 * ceil(random())*5;
	}
};

void() dlight_lightning =
{
	setmodel (self, "progs/null.spr");
	self.classname = "dlight_lightning";
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage	= DAMAGE_NO;
	
	self.pflags = 0;
	self.light_lev = 0;
	self.color = [1, 1, 1]; // full white
	self.cnt = FALSE; // off
	
	self.think = dlight_lightning_think;
	self.nextthink = time + 1 * ceil(random())*5;
};

void() chandelier_think =
{
	local entity effect;

	if (self.cnt2) // I'm falling
	{
		local entity head = searchradius(self.origin, 20);
		while (head) // do damage
		{
			if (head.takedamage && head.classname == "player" && head.health > 0 && self.cnt == FALSE && !head.flypain)
			{
				if (!relics & IT_RELIC12)
				{
					if (max_hit_ents < 10)
					{					
						// spawn a hit sprite
						effect = spawn();
						setorigin(effect, head.origin);
						setmodel(effect, "progs/hit.spr");
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
					sound (self, CHAN_WEAPON, "player/bigcut.wav", 1, ATTN_NORM);
					head.knockback = 1; // knock Vigil down
					T_Damage (head, self, self, 40, 0);
					self.cnt = TRUE;
				}
				else // Hit helmet, block
				{
					// spawn a block sprite
					if (max_block_ents < 6)
					{
						effect = spawn();
						setorigin(effect, head.origin + v_up * 24);
						setmodel(effect, "progs/block.spr");
						effect.angles_y = -90;
						effect.angles_z = random()*360;
						effect.effects = EF_NODEPTHTEST;
						effect.movetype = MOVETYPE_NONE;
						effect.solid = SOLID_NOT;
						effect.scale = 2;
						effect.owner = head;
						effect.think = fx_think;
						effect.nextthink = time + 0.1;
						max_block_ents = max_block_ents + 1;
					}
					
					sound (self, CHAN_WEAPON, "player/block.wav", 1, ATTN_NORM);
					self.cnt = TRUE;
				}
			}
			head = head.chain;
		}
		if ((self.velocity_z == 0 || checkground(self) || self.cnt || self.flags & FL_ONGROUND) && self.attack_finished < time) // Smashed the ground
		{
			self.solid = SOLID_NOT; // Remove spawn_color_glow
			sound (self, CHAN_BODY, "misc/metlbrk.wav", 1, ATTN_NORM);
			self.frame = 3;
			self.think = SUB_Null;
			self.nextthink = time;
			return;
		}
	}

	if (self.pain_finished < time)
	{
		if (self.frame < 2)
			self.frame = self.frame + 1;
		else
			self.frame = 0;

		self.pain_finished = time + 0.1; // normal quake think time
	}
	if (!self.lip && !self.spawnflags & 1)
	{
		spawn_color_glow(1, 0.75, 0, 250, self);
		self.lip = TRUE; // Run once
	}
	frameskip(0.01);
};

void() chandelier_use =
{
	self.velocity_z = -1;
	self.movetype = MOVETYPE_STEP; // step for extra checks in .think
	self.cnt2 = TRUE; // fall flag on
};

/*QUAKED chandelier (0 1 0) (-11 -16 -1) (10 12 23)
A chandelier

Spawnflag 1 removes the dynamic light
*/
void() chandelier =
{
	precache_sound ("misc/metlbrk.wav");
	precache_model ("progs/chandelier.mdl");
	setmodel (self, "progs/chandelier.mdl");

	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_NO;
	self.classname = "chandelier";
	self.frame = 0;
	self.think = chandelier_think;
	self.nextthink = time;
	self.use = chandelier_use;
	self.dimension_hit = self.dimension_solid = 0;
	setsize(self, '-74 -73 -17', '73 73 125');
};

/*QUAKED mushroom (0 1 0) (-11 -16 -1) (10 12 23)
A mushroom
*/
void() mushroom =
{
	precache_model ("progs/mushroom.mdl");
	setmodel (self, "progs/mushroom.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "mushroom";
	setsize(self, '-11 -16 -1', '10 12 23');
	droptofloor();
};

/*QUAKED fence (0 1 0) (-50 -10 -17) (49 12 29)
a fence, has a variety of skins
*/
void() fence =
{
	precache_model ("progs/fence.mdl");
	setmodel (self, "progs/fence.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "fence";
	self.touch = onground_touch;
	setsize(self, '-50 -10 -17', '49 12 29');
	droptofloor();
};

/*QUAKED pinetree_dead (0 1 0) (-40 -43 -16) (51 39 160)
A pine trees that's dying, very little pines
*/
void() pinetree_dead =
{
	precache_model ("progs/pine_scraggy.mdl");
	setmodel (self, "progs/pine_scraggy.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "pinetree_dead";
	setsize(self, '-11 -16 -1', '10 12 23');
	droptofloor();
};

/*QUAKED pinetree (0 1 0) (-93 -90 -16) (94 97 175)
Normal (large) pinetree
*/
void() pinetree =
{
	precache_model ("progs/pinetree.mdl");
	setmodel (self, "progs/pinetree.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "pinetree";
	setsize(self, '-93 -90 -16', '94 97 175');
	droptofloor();
};

/*QUAKED telescope (0 1 0) (-25 -7 -17) (19 7 40)
Regular old telescope
*/
void() telescope =
{
	precache_model ("progs/telescope.mdl");
	setmodel (self, "progs/telescope.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "telescope";
	setsize(self, '-25 -7 -17', '19 7 40');
	droptofloor();
};


/*QUAKED pinetree_small (0 1 0) (-60 -68 -16) (61 63 128)
Normal (small) pinetree
*/
void() pinetree_small =
{
	precache_model ("progs/pinetreesm.mdl");
	setmodel (self, "progs/pinetreesm.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "pinetreesm";
	setsize(self, '-60 -68 -16', '61 63 128');
	droptofloor();
};

/*QUAKED statue (0 1 0) (-60 -68 -16) (41 55 136)
A large statue holding sword and shield,
drops to floor automatically
*/
void() statue =
{
	precache_model ("progs/statue.mdl");
	setmodel (self, "progs/statue.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue";
	self.touch = onground_touch;
	setsize(self, '-14 -38 -1', '41 55 136');
	droptofloor();
};

/*QUAKED statue4 (0 1 0) (-15 -16 -25) (30 32 59)
Statue of a knight holding a sword
*/
void() statue4 =
{
	precache_model ("progs/statue4.mdl");
	setmodel (self, "progs/statue4.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue4";
	self.touch = onground_touch;
	setsize(self, '-15 -16 -27', '30 32 59');
	droptofloor();
};

/*QUAKED cart (0 1 0) (-25 -52 -1) (42 71 32)
Just a plain old cart
*/
void() cart =
{
	precache_model ("progs/cart.mdl");
	setmodel (self, "progs/cart.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "cart";
	self.touch = onground_touch;
	setsize(self, '-25 -52 -1', '42 71 32');
	droptofloor();
};

/*QUAKED seaweed (0 1 0) (-4 -5 0) (8 10 72)
Seaweed for underwater
*/
void() seaweed =
{
	precache_model ("progs/seaweed.mdl");
	setmodel (self, "progs/seaweed.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "seaweed";
	setsize(self, '-4 -5 0', '8 10 72');
	droptofloor();
};

/*QUAKED bench (0 1 0) (-14 -38 -1) (14 37 25)
A bench that people typically sit on
*/
void() bench =
{
	precache_model ("progs/bench.mdl");
	setmodel (self, "progs/bench.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "bench";
	//self.touch = onground_touch;
	setsize(self, '-14 -38 -1', '14 37 12');
	droptofloor();
};

/*QUAKED curtain (0 1 0) (-1 -1 -1) (1 1 1)
A curtain blowing in the wind
*/
void() curtain =
{
	precache_model ("progs/curtain.mdl");
	setmodel (self, "progs/curtain.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "curtain";
	setsize(self, '0 0 0', '0 0 0');
};


/*QUAKED statue2 (0 1 0) (-39 -23 -6) (10 6 96)
A large statue of a hooded angel praying,
drops to floor automatically
*/
void() statue2 =
{
	precache_model ("progs/statue2.mdl");
	setmodel (self, "progs/statue2.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue2";
	self.touch = onground_touch;
	setsize(self, '-39 -23 -6', '10 6 96');
	droptofloor();
};

/*QUAKED statue3 (0 1 0) (-39 -136 -1) (94 85 295)
A very large statue of a naked chick,
drops to floor automatically
*/
void() statue3 =
{
	precache_model ("progs/statue3.mdl");
	setmodel (self, "progs/statue3.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue2";
	self.touch = onground_touch;
	setsize(self, '-39 -136 -1', '94 85 295');
	droptofloor();
};

/*QUAKED statue5 (0 1 0) (-28 -25 -1) (59 50 128)
Large statue of a noble king holding a sword downward.
*/
void() statue5 =
{
	precache_model ("progs/statue5.mdl");
	setmodel (self, "progs/statue5.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue5";
	self.touch = onground_touch;
	setsize(self, '-28 -25 -1', '59 50 128');
	droptofloor();
};

/*QUAKED statue6 (0 1 0) (-60 -24 -1) (87 48 87)
Snake statue that's connected to something
*/
void() statue6 =
{
	precache_model ("progs/statue6.mdl");
	setmodel (self, "progs/statue6.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue6";
//	self.touch = onground_touch;
	setsize(self, '-60 -24 -1', '87 48 87');
};

/*QUAKED statue7 (0 1 0) (-13 -11 -1) (17 12 56)
Praying angle
*/
void() statue7 =
{
	precache_model ("progs/statue7.mdl");
	setmodel (self, "progs/statue7.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue7";
	self.touch = onground_touch;
	setsize(self, '-13 -11 -1', '17 12 56');
	droptofloor();

};

/*QUAKED statue8 (0 1 0) (-13 -11 -1) (22 12 56)
A griffon statue
*/
void() statue8 =
{
	precache_model ("progs/statue8.mdl");
	setmodel (self, "progs/statue8.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue8";
	self.touch = onground_touch;
	setsize(self, '-13 -11 -1', '22 12 56');
	droptofloor();
};

/*QUAKED statue9 (0 1 0) (-14 -17 0) (15 15 97)
Naked venus statue
*/
void() statue9 =
{
	precache_model ("progs/statue9.mdl");
	setmodel (self, "progs/statue9.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue9";
	self.touch = onground_touch;
	setsize(self, '-14 -17 0', '15 15 97');
	droptofloor();
};


void() ThrowRubble;
void() statue10_remove_check =
{
	if (game_progress & IT_PROGRESS7)
	{
		remove(self);
		return;
	}
	frameskip(1);
};

void() statue10_death =
{
	local float ox, oy, oz, i;
	local entity effect, fx;

	self.takedamage = DAMAGE_NO;

	if (range(self, self.enemy) != RANGE_FAR && self.enemy)
		shake_camera(0.1);
	ox = self.origin_x + random() * 128 - 64;
	oy = self.origin_y;
	oz = self.origin_z + 16;

	sound (self, CHAN_BODY, "misc/explode.wav", 1, ATTN_NORM);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, ox);
	WriteCoord (MSG_BROADCAST, oy);
	WriteCoord (MSG_BROADCAST, oz);

	if (self.cnt >= 13)
	{
		if (range(self, self.enemy) != RANGE_FAR)
			self.enemy.owner.screenflash_finished = time + 0.5;

		effect = spawn();
		setorigin(effect, self.origin + v_up * 22);
		setmodel(effect, "progs/explode1.mdl");
		effect.movetype = MOVETYPE_NOCLIP;
		effect.think = explodemodel_think;
		effect.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
		effect.nextthink = time;
		effect.alpha = 1;
		effect.solid = SOLID_NOT;
		sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);

		fx = spawn(); // special flash
		setorigin(fx, self.origin + v_up * 22);
		setmodel(fx, "progs/efxflash.mdl");
		fx.movetype = MOVETYPE_NOCLIP;
		fx.alpha = 1;
		fx.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
		fx.think = efxflashe_think;
		fx.nextthink = time;
		fx.solid = SOLID_NOT;
			
		for (i = 0; i < 12; i = i+1)
			ThrowRubble();
			//golem_particle();

		if (self.enemy.owner)
		{
			setpause(1);
			centerprint (self.enemy.owner, "/P^bDragon Worship Statue Destroyed^b\n\n===========================\n\nYou hear a rumbling in the distance... The Eternal Dragon awaits!\n\n\n^3Press ATTACK or JUMP to resume ...");
		}

		if (!(game_progress & IT_PROGRESS7)) // Dragon Statue smashed
			game_progress = game_progress | IT_PROGRESS7; // Add it (True)

		remove(self);
		return;
	}
	self.cnt = self.cnt + 1;
	self.think = statue10_death;
	frameskip(0.25);
};

/*QUAKED statue10 (0 1 0) (-80 -52 -2) (58 42 67)
Dragon Head statue - spawnflag adds special condition
*/
void() statue10 =
{
	precache_sound ("misc/explode.wav");
	precache_model ("progs/statue10.mdl");
	precache_model ("progs/rubble1.mdl");
	precache_model ("progs/rubble2.mdl");
	precache_model ("progs/rubble3.mdl");
	setmodel (self, "progs/statue10.mdl");

	if (!self.spawnflags)
	{
		self.takedamage = DAMAGE_NO;
		self.classname = "statue10";
	}
	else
	{
		self.takedamage = DAMAGE_AIM;
		self.health = 333;
		self.classname = "breakable";
		self.th_die = statue10_death;
		self.think = statue10_remove_check;
		self.nextthink = time + 0.3;
	}
	self.netname = "solid";
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.touch = onground_touch;
	setsize(self, '-80 -52 -2', '58 42 67');
	droptofloor();
};

/*QUAKED lionhead (0 1 0) (-1 -29 -22) (47 28 31)
Lion head statue that attatches to walls
*/
void() lionhead =
{
	precache_model ("progs/lionhead.mdl");
	setmodel (self, "progs/lionhead.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "lionhead";
	setsize(self, '-1 -29 -22', '47 28 31');
	makestatic(self);
};

/*QUAKED candelabra (0 1 0) (-16 -17 -42) (16 15 13)
Decorative candelabra, very beautiful
*/
void() candelabra =
{
	precache_model ("progs/candelabra.mdl");
	setmodel (self, "progs/candelabra.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "candelabra";
	setsize(self, '-16 -17 0', '16 15 13');
	droptofloor();
	makestatic(self);
};

/*QUAKED candelabra2 (0 1 0) (-9 -25 -16) (9 25 97)
Decorative candelabra2, very beautiful and very large
*/
void() candelabra2 =
{
	precache_model ("progs/candelabr2.mdl");
	setmodel (self, "progs/candelabr2.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "candelabr2";
	setsize(self, '-9 -25 -16', '9 25 97');
	droptofloor();
	makestatic(self);
};


/*QUAKED beer (0 1 0) (-3 -3 -16) (2 3 -2)
A beer bottle, use .frame to change it's size (0 to 4)
*/
void() beer =
{
	precache_model ("progs/beer.mdl");
	setmodel (self, "progs/beer.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "beer";
	setsize(self, '-3 -3 -16', '2 3 -2');
	droptofloor();
	makestatic(self);
};

/*QUAKED bonepile (0 1 0) (-15 -16 -2) (11 15 11)
A pile of bones
*/
void() bonepile =
{
	precache_model ("progs/bonepile.mdl");
	setmodel (self, "progs/bonepile.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "bonepile";
	setsize(self, '-15 -16 -3', '11 15 11');
	droptofloor();
	makestatic(self);
};

/*QUAKED keg (0 1 0) (-15 -11 0) (19 11 23)
A keg, has frame 0 (with tap) and frame 1 (no tap)
*/
void() keg =
{
	precache_model ("progs/keg.mdl");
	setmodel (self, "progs/keg.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "keg";
	setsize(self, '-15 -11 -18', '19 11 6');
	droptofloor();
	makestatic(self);
};

/*QUAKED tree (0 1 0) (-1 -29 -22) (47 28 31)
Tree entity to decorate maps
drops to floor automatically
*/
void() tree =
{
	precache_model ("progs/tree.mdl");
	setmodel (self, "progs/tree.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "tree";
	self.touch = onground_touch;
	setsize(self, '-36 -37 -0', '48 27 103');
	droptofloor();
};

/*QUAKED tree2 (0 1 0) (-1 -29 -22) (47 28 31)
Tree entity to decorate maps, for slanted surfaces
drops to floor automatically
*/
void() tree2 =
{
	precache_model ("progs/tree2.mdl");
	setmodel (self, "progs/tree2.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "tree2";
	self.touch = onground_touch;
	setsize(self, '-36 -37 -0', '48 27 103');
	droptofloor();
};


/*QUAKED tree3 (0 1 0) (-1 -29 -22) (47 28 31)
Tree entity to decorate maps
drops to floor automatically
*/
void() tree3 =
{
	precache_model ("progs/tree3.mdl");
	setmodel (self, "progs/tree3.mdl");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "tree3";
	self.touch = onground_touch;
	setsize(self, '-17 -29 -16', '25 38 105');
	droptofloor();
};

/*QUAKED flag (0 1 0) (-7 -6 -7) (7 23 98)
A flag that flaps in the breeze, not solid
*/
void() flag =
{
	precache_model ("progs/flag.mdl");

	setmodel (self, "progs/flag.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "flag";
	setsize(self, '-7 -6 -7', '7 23 98');
	makestatic(self);
};

/*QUAKED flag2 (0 1 0) (-3 -33 -145) (3 32 1)
A flag that flaps in the breeze, not solid
uses framegroups and has several skins
*/
void() flag2 =
{
	precache_model ("progs/flag2.mdl");

	setmodel (self, "progs/flag2.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "flag2";
	setsize(self, '-3 -33 -145', '3 32 1');
	makestatic(self);
};

/*QUAKED axe (0 1 0) (-2 -6 -10) (1 8 17)
Axe decoration that hangs on a wall, non-solid
and it floats in mid air!
*/
void() axe =
{
	precache_model ("progs/axe.mdl");

	setmodel (self, "progs/axe.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "axe";
	setsize(self, '0 0 0', '0 0 0');
	makestatic(self);
};

/*QUAKED shield (0 1 0) (-2 -9 -10) (3 8 14)
Shield decoration that hangs on a wall, non-solid
and it floats in mid air!
*/
void() shield =
{
	precache_model ("progs/shield.mdl");

	setmodel (self, "progs/shield.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "shield";
	setsize(self, '0 0 0', '0 0 0');
	makestatic(self);
};

/*QUAKED sword (0 1 0) (-2 -4 -21) (1 4 20)
Sword decoration that hangs on a wall, non-solid
and it floats in mid air!
*/
void() sword =
{
	precache_model ("progs/sword.mdl");

	setmodel (self, "progs/sword.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "sword";
	setsize(self, '0 0 0', '0 0 0');
	makestatic(self);
};

void() cloud_touch =
{
	if (other.solid == SOLID_BSP)
	{
		remove(self);
		return;
	}
};

void() cloud_generate =
{
	local entity cl;

	cl = spawn();
	cl.movetype = MOVETYPE_FLY;
	cl.solid = SOLID_TRIGGER;
	cl.takedamage = DAMAGE_NO;
	cl.classname = "cloud";
	cl.angles_y = -90;
	cl.frame = random()*2; // random frame
	cl.angles_z = random()*360; // random spin angle
	cl.touch = cloud_touch;
	cl.fixangle = TRUE; // hell yeah
	setmodel (cl, "progs/cloud.spr");
	setsize (cl, '0 0 0', '0 0 0');
	if (!cl.cnt) cl.cnt = time + 3;
	cl.speed = ceil(random()*501)+499; // 500-1000
	cl.alpha = ceil(random()*5)*0.1; // 0.1 to 0.5 transparency
	cl.scale = ceil(random()*20)*0.1;
	cl.effects = EF_ADDITIVE;
	setorigin (cl, self.origin);

	// Move spawned cloud immediately
	makevectors(self.angles);
	cl.velocity = aim(self, cl.speed);
	cl.velocity = cl.velocity * cl.speed;

	// cloud generator think
	self.think = cloud_generate;
	self.nextthink = time + ceil(random()*4); // random 1-4 seconds
};

/*QUAKED misc_clouds (1 0 0) (0 0 0) (0 0 0)
Clouds that scroll by, randomly generates 3 between 1-4 seconds
and move at desired angle with varing transparencies, also you
must define how long before it's removed by editing "cnt" value!
.cnt defaults to 3, .speed changes speed
*/
void() misc_clouds =
{
	precache_model ("progs/cloud.spr");
	setmodel (self, "progs/null.spr");

	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "cloudgen";
	setsize(self, '0 0 0', '0 0 0');
	self.think = cloud_generate;
	self.nextthink = time + ceil(random()*4); // random 1-4 seconds
};

/*QUAKED anvil (0 1 0) (-9 -34 -1) (7 21 23)
An anvil that sits on the ground, is solid
drops to floor automatically
*/
void() anvil =
{
	precache_model ("progs/anvil.mdl");

	setmodel (self, "progs/anvil.mdl");
	setsize(self, '-9 -34 -1', '7 21 23');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "anvil";
	droptofloor();
};

/*QUAKED banner (0 1 0) (-1 -46 -107) (0 45 0)
A piece of cloth that hangs on walls, non-solid
it also floats
*/
void() banner =
{
	precache_model ("progs/banner.mdl");

	setmodel (self, "progs/banner.mdl");
	setsize(self, '-1 -46 -107', '0 45 0');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "banner";
	makestatic(self);
};

/*QUAKED stool (0 1 0) (-7 -7 0) (7 7 18)
A stool that sits on the ground, is solid
drops to floor automatically
*/
void() stool =
{
	precache_model ("progs/stool.mdl");

	setmodel (self, "progs/stool.mdl");
	setsize(self, '-7 -7 0', '7 7 25');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "stool";
	self.touch = onground_touch;
	droptofloor();
};

/*QUAKED bed (0 1 0) (-7 -7 0) (7 7 18)
A bed that sits on the ground, is solid
drops to floor automatically
*/
void() bed =
{
	precache_model ("progs/bed.mdl");

	setmodel (self, "progs/bed.mdl");
	setsize(self, '-55 -40 -1', '61 39 26');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "bed";
	self.touch = onground_touch;
	droptofloor();
};

/*QUAKED bed2 (0 1 0) (-7 -7 0) (7 7 18)
A bed that sits on the ground, is solid
drops to floor automatically
*/
void() bed2 =
{
	precache_model ("progs/bed2.mdl");

	setmodel (self, "progs/bed2.mdl");
	setsize(self, '-28 -20 0', '35 16 33');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "bed2";
	self.touch = onground_touch;
	droptofloor();
};

/*QUAKED chair (0 1 0) (-8 -0 -24) (17 18 30)
A chair that sits on the ground, is solid
drops to floor automatically
*/
void() chair =
{
	precache_model ("progs/chair.mdl");

	setmodel (self, "progs/chair.mdl");
	setsize(self, '-8 -0 -24', '17 18 30');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "chair";
	self.touch = onground_touch;
	droptofloor();
};


/*QUAKED light_flame_brazier_short (0 1 0) (-7 -6 -17) (7 7 -2)
A short pillar that hosts a flame on top
drops to floor automatically
*/
void() light_flame_brazier_short =
{
	precache_model ("progs/brazshrt.mdl");

	setmodel (self, "progs/brazshrt.mdl");
	setsize(self, '-7 -6 -17', '7 7 -2');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "braziers";
	droptofloor();
};

/*QUAKED light_flame_brazier_tall (0 1 0) (-7 -7 -65) (7 7 -8)
A tall pillar that hosts a flame on top
drops to floor automatically
*/
void() light_flame_brazier_tall =
{
	precache_model ("progs/braztall.mdl");

	setmodel (self, "progs/braztall.mdl");
	setsize(self, '-7 -7 -1', '7 7 95');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "braziert";
	droptofloor();
	makestatic(self);
};

/*QUAKED light_flame_brazier_tall_blue (0 1 0) (-7 -7 -65) (7 7 -8)
A tall pillar that hosts a blue flame on top
drops to floor automatically
*/
void() light_flame_brazier_tall_blue =
{
	precache_model ("progs/braztllb.mdl");

	setmodel (self, "progs/braztllb.mdl");
	setsize(self, '-7 -7 -1', '7 7 95');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "braziertb";
	droptofloor();
	makestatic(self);
};

/*QUAKED light_lantern (0 1 0) (-7 -7 -65) (7 7 -8)
A lantern, should be hung from ceilings
*/
void() light_lantern =
{
	precache_model ("progs/lantern.mdl");

	setmodel (self, "progs/lantern.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "light_lantern";
	setsize(self, '-10 -10 -44', '10 10 5');
	makestatic(self);
};

/*QUAKED light_lantern2 (0 1 0) (-7 -7 -65) (7 7 -8)
A swinging lantern, should be hung from ceilings
*/
void() light_lantern2 =
{
	precache_model ("progs/lantern2.mdl");

	setmodel (self, "progs/lantern2.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "light_lantern2";
	setsize(self, '-3 -3 -36', '4 4 1');
	makestatic(self);
};

/*QUAKED misc_zombie (0 1 0) (-3 -24 -25) (10 23 34)
Zombie hung to a wall shaking around
*/
void() misc_zombie =
{
	precache_model ("progs/hanged.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	setmodel (self, "progs/hanged.mdl");
	makestatic(self);
};

void() barrel_fadein =
{
	if (self.alpha < 1)
		self.alpha = self.alpha + 0.01;
	else
	{
		self.alpha = 1;
		return;
	}
	frameskip(0.025);
};

void() barrel_ressurect = // test if it's okay to respawn me
{
	local float res;

	self.movetype = MOVETYPE_STEP;
	self.origin_z = self.origin_z + 1;
	droptofloor();

	//MakeSolidList(FALSE);
	res = walkmove(self.angles_y, 0);
	
	if (res)
	{
		self.health = 10;
		self.takedamage = DAMAGE_AIM;
		self.model = self.mdl;
		self.solid = SOLID_SLIDEBOX;
		setorigin (self, self.origin);
		self.think = barrel_fadein;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.solid = SOLID_NOT;
		self.nextthink = time + 1;
	}
	self.movetype = MOVETYPE_NONE;

	//UnmakeSolidList();
};

void() barrel_break =
{
	sound (self, CHAN_AUTO, "misc/barrel.wav", 1, ATTN_NORM);

	GiveExperience(1);
	ThrowSceneryGib ("progs/barrelgb.mdl", self.origin);
	ThrowSceneryGib ("progs/barrelgb.mdl", self.origin);
	ThrowSceneryGib ("progs/barrelgb.mdl", self.origin);
	ThrowSceneryGib ("progs/barrelgb.mdl", self.origin);

	if (deathmatch == FALSE)
	{
		if (self.spawnflags & 1)
			drop_health();
		if (self.spawnflags & 2)
			drop_mana();
		if (random() < 0.5 || world.model == "maps/village.bsp") // always drop gold in the village
			drop_gold();
		remove(self);
		return;
	}
	else
	{
		self.alpha = 0.1;
		self.takedamage = DAMAGE_NO;
		self.model = string_null;
		self.solid = SOLID_NOT;
		self.think = barrel_ressurect;
		self.nextthink = time + 120;
	}
	return;
};

/*QUAKED barrel (0 1 0) (-14 -14 -22) (14 14 18)
A barrel Vigil is able to break, 1 experience point
is given; consider these bonuses on top of being detail objects
drops to floor automatically
Spawnflag 1 drops a health potion
Spawnflag 2 drops a mana potion
.cnt is used to determine how much potions give
*/
void() barrel =
{
	precache_model ("progs/barrel.mdl");
	precache_model ("progs/barrelgb.mdl");
	precache_model ("progs/mpot.mdl");
	precache_model ("progs/hpot.mdl");

	precache_sound ("misc/barrel.wav");
	precache_sound ("misc/potland.wav");

	setmodel (self, "progs/barrel.mdl");

	self.mdl = self.model;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_AIM;
	self.classname = "breakable";
	self.netname = "solid";
	self.touch = onground_touch;
	self.health = 10;
	setsize(self, '-15 -14 -25', '16 13 9');
	self.angles_y = random()*360;
	self.th_die = barrel_break;
	self.noblood = TRUE;
	droptofloor();
};

/*QUAKED light_torch_small_walltorch (0 1 0) (-10 -10 -10) (10 10 10)
Default light value is 200
Default style is 0
Must adjust angle away from wall
*/
void() light_torch_small_walltorch =
{
	precache_model ("progs/flame.mdl");
	setmodel (self, "progs/flame.mdl");
	makestatic (self);
};

/*QUAKED candle (0 1 0) (-10 -10 -10) (10 10 10)
candle that should be placed on walls
it doesn't give off any light, add that manually
*/
void() candle =
{
	precache_model ("progs/candle.mdl");
	setmodel (self, "progs/candle.mdl");
	makestatic (self);
};

/*QUAKED candle2 (0 1 0) (-10 -10 -10) (10 10 10)
candle that should be placed on the ground
it doesn't give off any light, add that manually
*/
void() candle2_think =
{
	if (self.frame <= 10)
		self.frame = self.frame + 1;
	else
		self.frame = 0;
	frameskip (0.1);
};

void() candle2 =
{
	precache_model ("progs/candle2.mdl");
	setmodel (self, "progs/candle2.mdl");
	setsize (self, '-3 -3 -10', '3 3 11');
	if (!self.spawnflags)
		droptofloor();
	self.frame = ceil(random()*12 - 1);
	self.think = candle2_think;
	self.nextthink = time;
};

/*QUAKED light_torch_long_walltorch (0 1 0) (-4 -3 -48) (9 3 25)
A torch that is mounted up against walls
*/
void() light_torch_long_walltorch =
{
	precache_model ("progs/longtrch.mdl");
	setmodel (self, "progs/longtrch.mdl");
	makestatic (self);
};

/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
Large yellow flame
*/
void() light_flame_large_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	self.frame = 1;
	makestatic (self);
};

/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small yellow flame
*/
void() light_flame_small_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	makestatic (self);
};

/*QUAKED light_flame_large_purple (0 1 0) (-10 -10 -12) (12 12 18)
Large purple flame
*/
void() light_flame_large_purple =
{
	precache_model ("progs/pflame.spr");
	setmodel (self, "progs/pflame.spr");
	makestatic (self);
};

/*QUAKED light_flame_small_purple (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small purple flame
*/
void() light_flame_small_purple =
{
	precache_model ("progs/pflame.spr");
	setmodel (self, "progs/pflame.spr");
	makestatic (self);
};

/*QUAKED grass (0 1 0) (-8 -8 -8) (8 8 8)
Tall grass patch
*/
void() grass =
{
	precache_model ("progs/grass.mdl");
	setmodel (self, "progs/grass.mdl");
	setsize (self, '0 0 0', '0 0 0');
	self.effects = EF_NOSHADOW; // No realtime lighting
	droptofloor();
	model_tilt();
};

/*QUAKED grass2 (0 1 0) (-8 -8 -8) (8 8 8)
Swaying grass clump
*/
void() grass2_think = 
{
	if (self.frame < 30)
		self.frame = self.frame + 1;
	else
		self.frame = 0;
	frameskip(0.1);
};

void() grass2 =
{
	precache_model ("progs/grass2.mdl");
	setmodel (self, "progs/grass2.mdl");
	setsize (self, '-15 -19 -16', '14 16 7');
	self.effects = EF_NOSHADOW; // No realtime lighting
	self.angles_y = random()*360;
	self.frame = random()*30;
	self.think = grass2_think;
	self.nextthink = time;
	droptofloor();
	model_tilt();
};

/*QUAKED grass3 (0 1 0) (-8 -8 -8) (8 8 8)
Swaying grass clump
*/
void() grass3_think = 
{
	if (self.frame < 30)
		self.frame = self.frame + 1;
	else
		self.frame = 0;
	frameskip(0.1);
};

void() grass3 =
{
	precache_model ("progs/grass3.mdl");
	setmodel (self, "progs/grass3.mdl");
	setsize (self, '-15 -19 -16', '14 16 7');
	self.effects = EF_NOSHADOW; // No realtime lighting
	self.frame = random()*30;
	self.think = grass3_think;
	self.nextthink = time;
	droptofloor();
	model_tilt();
};

void() ThrowRubble =
{
	local entity rock;
	local float x,y,z;

	x = random() * 32 - 16;
	y = random() * 32 - 16;
	z = random() * 16;

	rock = spawn();

	rock.angles_y = random() * 360;
	makevectors (rock.angles);
	rock.velocity = v_forward * 90;
	rock.velocity_z = 450;

	if (random() < 0.35) setmodel (rock, "progs/rubble1.mdl");
	else if (random() < 0.65) setmodel (rock, "progs/rubble2.mdl");
	else setmodel (rock, "progs/rubble3.mdl");
	setsize (rock, '0 0 0', '0 0 0');
	setorigin (rock, self.origin + v_forward*x + v_up*z + v_right*y);
	rock.avelocity = '600 1000 900';
	rock.movetype = MOVETYPE_BOUNCE;
	rock.solid = SOLID_TRIGGER;
	rock.alpha = 1;
	rock.think = SceneryGibRemove;
	rock.nextthink = time + 0.5;
};

void() boulder_use_touch =
{
	if (!other.takedamage)
	{
		ThrowRubble();
		ThrowRubble();
		ThrowRubble();
		ThrowRubble();
		remove(self);
		return;
	}
};

void() boulder_think =
{
	local entity y, oself, effect;

	y = searchradius(self.origin, 35);
	while (y)
	{
		if (y.classname == "breakable" || (y.netname == "solid" && y.takedamage))
		{
			oself = self;
			self = y;
			if (self.th_die && self.classname != "player")
				self.th_die();
			self = oself;

			ThrowRubble();
			ThrowRubble();
			ThrowRubble();
			ThrowRubble();
			sound (self, CHAN_BODY, "misc/rocks.wav", 1, ATTN_NORM);

			if (y.classname == "player")
			{
				if (!relics & IT_RELIC12)
				{
					T_Damage (y, self, self, 8, 0);
					y.velocity = '0 0 0';
				}
				else
				{
					// spawn a block sprite
					if (max_block_ents < 6)
					{
						effect = spawn();
						setorigin(effect, y.origin + v_up * 24);
						setmodel(effect, "progs/block.spr");
						effect.angles_y = -90;
						effect.angles_z = random()*360;
						effect.effects = EF_NODEPTHTEST;
						effect.movetype = MOVETYPE_NONE;
						effect.solid = SOLID_NOT;
						effect.scale = 2;
						effect.owner = y;
						effect.think = fx_think;
						effect.nextthink = time + 0.1;
						max_block_ents = max_block_ents + 1;
					}

					sound (self, CHAN_WEAPON, "player/block.wav", 1, ATTN_NORM);				
				}
			}
			else
				T_Damage (y, self, self, 8, 0);

			remove(self);
			return;
		}
		y = y.chain; // cycle to next entity
	}

	if (!self.velocity)
	{
		ThrowRubble();
		ThrowRubble();
		ThrowRubble();
		ThrowRubble();
		remove(self);
		return;
	}
	frameskip(0.01);
};

void() boulder_use =
{
	self.avelocity = '500 -500 0';
	self.movetype = MOVETYPE_TOSS;
	self.think = boulder_think;
	self.nextthink = time + 0.2;
};

/*QUAKED misc_boulder (0 1 0) (-8 -8 -8) (8 8 8)
A boulder that falls, damages player / func_destroy / monsters
Must be triggered to fall!
*/
void() misc_boulder =
{
	if (!self.targetname)
		objerror ("error: misc_boulder with no target name!\n");

	precache_model ("progs/boulder.mdl");
	precache_model ("progs/rubble1.mdl");
	precache_model ("progs/rubble2.mdl");
	precache_model ("progs/rubble3.mdl");

	precache_sound ("misc/rocks.wav");

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.touch = boulder_use_touch;
	self.use = boulder_use;
	setmodel (self, "progs/boulder.mdl");
	setsize (self, '-1 -1 -1', '1 1 1');
};