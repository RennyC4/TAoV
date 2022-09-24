/*==========================================

HP Bar and Damage Displays

Installation Instructions

***NOTICE***
Intended to be run in Darkplaces or equivalent engine.  Your
engine should have the ability to replace sprites with .tga
files, or else you'll not get to see the pretty sprites and
will instead be screaming:
"O-MY-GOSH-ITS-UGLY-MY-EYES-MY-EYES-IT-BURNS!!!!!!"
because the default sprites for engines that don't support
this feature are rather pathetic...
You should also have support for .alpha, which should come
standard with most worth-while engines.
EF_NODEPTHTEST support helps a lot with the damage displays; 
otherwise they are inside the monster and nigh unreadable.
Nodrawtoclient is useful unless you want to see your own
health bar and damage prints blocking your vision.
And finally, your engine should support the CheckExtension
feature so my code doesn't crash it by asking about
movetype_follow.

You should also have dpextensions.qc in your progs.src already,
or else you'll get lots of compile errors complaining about
.alpha and such.

So, to summarize, please make sure your mod & engine support
these important, nay, critical-to-life features:

tga external textures		(DP_GFX_EXTERNALTEXTURES)
.nodrawtoclient			(DP_SV_NODRAWTOCLIENT)
.alpha				(DP_ENT_ALPHA)
EF_NODEPTHTEST			(DP_EF_NODEPTHTEST)
CheckExtension

MOVETYPE_FOLLOW is also a plus, but not really needed.

Thank you.  :D

----------------------
To install into a mod:
----------------------

1. Place this QC (hpbar.qc) inside your mod's source directory.

2.Copy the sprites:
  First copy the hpbar spr and tga files into a folder called 
    "hpbar" in the progs folder.
  Next copy the num0.spr and other num sprites and tga files 
    into a folder called "digit" in the progs dir
  You should end up with YOURMOD/progs/hpbar/ and YOURMOD/progs/digit/
    being filled with the appropriate files.

4. Add this before "combat.qc" in your progs.src:

hpbar.qc

5. Add these lines into the bottom of W_Precache in weapon.qc:

	HPBarPrecache();
	NumDisplayPrecache();

6. If you are not installing into a mod that has Wazat's 'Pausing Code' 
in it, do a search and replace (in hpbar.qc) for the word "gametime", 
replacing every instance with "time".

7. Open client.qc.  Add this line to the very bottom of PlayerPostThink:

	CheckEnemyHPBar();

8. Open combat.qc.  In the function T_Damage, you'll find a 
line that says:

	targ.health = targ.health - take;

and a line that says:

	if (targ.health <= 0)

*Between* those lines, paste in these lines:

	UpdateHPBar(targ);
	UpdateDamagePrint(targ, take);

9. Compile and run Darkplaces (or equivalent engine).


==========================================*/

.float t_length;
.float t_width;
.float lefty;
.entity hpbar;
.entity damageprint;

/*==========================================

HP Bar

Colored bar shows roughly what percent of
health a monster (or player) has, so the player
knows how effective his weapons are and how
close the monster is to death.

==========================================*/

void(entity targ) SpawnHPBar;
void() HPBarThink;

float(entity targ) HPBarFrame =
{
	local float hp, maxhp, hpframe;

	hp = targ.health;
	maxhp = targ.max_health;

	if (hp < 0)
		hp = 0;
	if (maxhp <= 0)
		maxhp = hp;
	if (maxhp <= 0)
		maxhp = 1;

	hpframe = rint((hp / maxhp)*10);

	if (hpframe < 0)
		hpframe = 0;
	if (hpframe > 10)
		hpframe = 10;

	return hpframe;
};

void(entity targ) UpdateHPBar =
{
	if (targ.hpbar == world)
		SpawnHPBar(targ);

	if (targ.hpbar == world)
		return; // didn't spawn

	targ.hpbar.frame = HPBarFrame(targ);
	targ.hpbar.nextthink = time; // update other stuff soon

	targ.hpbar.t_length = time + 1.5; // how long to wait before starting to fade out again
	targ.hpbar.t_width = 0;
	targ.hpbar.alpha = targ.hpbar.lefty;
};

void() CheckEnemyHPBar =
{
	makevectors(self.v_angle);
	traceline(self.origin + '0 0 16', self.origin + '0 0 16' + v_forward * 800, FALSE, self);
	if (!trace_ent.takedamage)
		return;
	if (trace_ent.classname != "player" && !trace_ent.flags & FL_MONSTER)
		return;

	local entity e;
	local float wasshort=0, etime;
	e = trace_ent.hpbar;

	etime = 0.25;

	if (e != world)
	{
		if(e.t_length < time + etime)
			wasshort = 1;

		UpdateHPBar(trace_ent);

		if(wasshort)
			e.t_length = time + etime;
	}
	else
	{
		UpdateHPBar(trace_ent);

		e = trace_ent.hpbar;
		if (e == world)
			return;

		e.t_length = time + etime;
	}
};

void() HPBarThink =
{
	if (self.owner.health <= 0)
	{
		self.movetype = MOVETYPE_NOCLIP;
		self.velocity = '0 0 0';
	}
	else if (self.movetype != MOVETYPE_FOLLOW)
	{
		makevectors(self.enemy.angles);
		self.origin = self.owner.origin
		 + '0 0 1'	* self.view_ofs_z
		 + v_right	* self.view_ofs_y
		 + v_forward	* self.view_ofs_x;
		self.velocity = self.owner.velocity;
	}

	self.frame = HPBarFrame(self.owner);

	if (self.owner.health <= 0 || (self.t_length != 0 && self.t_length < time))
	{
		local float dissapeartime;
		dissapeartime = 1;//3;
		if (self.t_width)
		{
			if (self.t_width < time)
			{
				self.owner.hpbar = world;
				remove(self);
				return;
			}
			self.alpha = self.lefty*((self.t_width - time)/dissapeartime);
		}
		else
		{
			self.t_width = time + dissapeartime;
			if (self.delay > 0.1)
				self.delay = 0.1;
		}
	}
	self.nextthink = time + self.delay;
};

void(entity targ) SpawnHPBar =
{
	local entity e, oself;

	if (!targ.takedamage)
		return;

	if (targ.health <= 0)
		return;

	if (targ.classname != "player" && !targ.flags & FL_MONSTER)
		return; // hpbar only works for players and monsters

	e = spawn();
	e.owner = targ;
	targ.hpbar = e;
	e.nodrawtoclient = targ;

//	if (targ.max_health == 0)
//		targ.max_health = targ.health;

	if (targ.flags & FL_BOSS2)
		e.view_ofs = '0 0 1'*targ.maxs_z + '0 0 -50'; // offset from enemy.origin
	else
		e.view_ofs = '0 0 1'*targ.maxs_z + '0 0 5'; // offset from enemy.origin
	makevectors(targ.angles);
	e.origin = targ.origin
	 + '0 0 1'	* e.view_ofs_z
	 + v_right	* e.view_ofs_y
	 + v_forward	* e.view_ofs_x;
	if(checkextension("DP_MOVETYPEFOLLOW"))
	{
		e.movetype = MOVETYPE_FOLLOW;
		e.aiment = targ;

		e.delay = 0.5; // only bother thinking every once in a while
	}
	else // do it manually
	{
		e.movetype = MOVETYPE_NOCLIP;
		e.delay = 0.1;//0.05; // think rapidly
	}
	e.think = HPBarThink;

	e.lefty = e.alpha = 0.8;

	if (targ.flags & FL_BOSS)
		e.scale = 1.50; // bigger-size
	else
		e.scale = 0.75; // smaller-size

	e.effects = EF_NODEPTHTEST | EF_ADDITIVE;

	setmodel(e, "progs/hpbar/hpbar.spr");
	setsize(e, '0 0 0', '0 0 0');
	setorigin(e, e.origin);

	oself = self;
	self = e;

	self.think(); // instantly set origin and frame, and set up next think

	self = oself;
};