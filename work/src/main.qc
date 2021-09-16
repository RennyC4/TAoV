//+----+
//|Main|
//+----+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Contains some 'base' subroutines. As a general rule nothing in this file   |
//| does much, except to setup basic variables and entities.                   |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

//
// FTE - Only - Begin
//

#pragma target fte // TAoV is FTE only and proud
#pragma warning disable F304 // disable unnary operator warnings, not necessary as they're written for qc specifically
#pragma warning disable F317 // disable stale macro warnings, not necessary
#pragma warning disable F318 // disable duplicate macro warnings, taov's macros are stored in their own qc file
#pragma warning disable F302 // disable potentially uninitialised variable

//
// FTE - Only - End
//

void(float n) frameskip =
{
	if (frameskip_ent != self)
	{
		frameskip_delay = 0;
		frameskip_ent = self;
	}
	if (frametime > n + frameskip_delay)
	{
		frameskip_delay = frameskip_delay + n;
		self.think();
	}
	else
	{
		if (self.movetype != MOVETYPE_PUSH)
			self.nextthink = time + n;
		else // ltime used on movetype push
			self.nextthink = self.ltime + n;
	}
};


//
// Used by CSQC to resend all the data, fixes save game loading
//
void() CSEv_GrabCSQCValues =
{
	//
	//CSQC Setup
	//
	clientstat(STAT_GOLD, EV_FLOAT, gold);
	clientstat(STAT_SWORD, EV_FLOAT, swordlevel);
	clientstat(STAT_ARMOR2, EV_FLOAT, armorlevel);
	clientstat(STAT_MONSTER, EV_STRING, displayname);
	clientstat(STAT_SPELL, EV_FLOAT, currentspell);
	clientstat(STAT_COMBO, EV_FLOAT, combo);
	clientstat(STAT_PRICE, EV_FLOAT, display_price);
	globalstat(STAT_RELIC, EV_FLOAT, "relics");
	clientstat(STAT_PERFECTGUARD, EV_FLOAT, perfectguard_buff);
	clientstat(STAT_POUCH, EV_FLOAT, pouch);
	clientstat(STAT_MAXHEALTH, EV_FLOAT, max_health);
	clientstat(STAT_MANA, EV_FLOAT, mana);
	clientstat(STAT_MAXMANA, EV_FLOAT, max_mana);
	clientstat(STAT_EXP, EV_FLOAT, experience);
	globalstat(STAT_KEYS, EV_FLOAT, "keys");
	clientstat(STAT_FLASK, EV_FLOAT, hflask_amt);
	clientstat(STAT_FLASK_MAX, EV_FLOAT, hflask_max_amt);
	
	clientstat(STAT_STATUS_BLIND, EV_FLOAT, status_blind_finished);
	clientstat(STAT_STATUS_POISON, EV_FLOAT, status_poison_finished);
	clientstat(STAT_STATUS_BROKEN, EV_FLOAT, status_broken_finished);

	clientstat(STAT_ORIGINX, EV_FLOAT, vigil_x);
	clientstat(STAT_ORIGINY, EV_FLOAT, vigil_y);
	clientstat(STAT_ORIGINZ, EV_FLOAT, vigil_z);

	clientstat(STAT_CURRENTSHRINE, EV_FLOAT, currentshrine);
	globalstat(STAT_SHRINEHUD, EV_FLOAT, "shrineHUD_on");
	
	clientstat(STAT_LEVEL, EV_FLOAT, level);
};

float framecount, developer, difficulty, deathmatch, coop;

void() main = {};
void() worldspawn = 
{
	//
	// Setup Default Lightstyles
	//

	lightstyle(0, "m");
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	lightstyle(4, "mamamamamama");
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	lightstyle(6, "nmonqnmomnmomomno");
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	lightstyle(9, "aaaaaaaazzzzzzzz");
	lightstyle(10, "mmamammmmammamamaaamammma");
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	lightstyle(63, "a");

	// Forced normal precaches
	precache_model("progs/player.mdl");
	precache_sound("demon/dland2.wav");
	precache_model("progs/null.spr");
	// Forced normal precaches

	//
	// Precache Ingame resources
	//

	if (world.model != "maps/intro.bsp" && world.model != "maps/start.bsp" && world.model != "maps/menu.bsp")
	{
		//
		// 3D Models
		//

		precache_model ("progs/plyr.mdl");
		precache_model ("progs/plyr2.mdl");
		precache_model ("progs/plyr_armstab.mdl");
		precache_model ("progs/particle.mdl");
		precache_model ("progs/armor.mdl");
		precache_model ("progs/icef.mdl");
		precache_model ("progs/grounded.mdl");
		precache_model ("progs/iced.mdl");
		precache_model ("progs/beam1.mdl");
		precache_model ("progs/jatkspc.mdl");
		precache_model ("progs/beam2.mdl");
		precache_model ("progs/fball.mdl");
		precache_model ("progs/scrflash.mdl");
		precache_model ("progs/twister.mdl");
		precache_model ("progs/swordfx.mdl");
		precache_model ("progs/divs_hit.mdl");
		precache_model ("progs/shdowleg.mdl");
		precache_model ("progs/gib1.mdl");
		precache_model ("progs/gib2.mdl");
		precache_model ("progs/gib3.mdl");
		precache_model ("progs/explode1.mdl");
		precache_model ("progs/gold.mdl");
		precache_model ("progs/chrgebm.mdl");
		precache_model ("progs/efxflash.mdl");
		precache_model ("progs/blooddrop.mdl");
		precache_model ("progs/bloodsplat.mdl");
		precache_model ("progs/embers.mdl");

		//
		// 2D Sprites
		//

		// hp bar (mostly for monsters)
		precache_model ("progs/hpbar/hpbar.spr");

		precache_model ("progs/bubble.spr");
		precache_model ("progs/hflask.spr");
		precache_model ("progs/speed.spr");
		precache_model ("progs/levelup.spr");
		precache_model ("progs/shadow.spr");
		precache_model ("progs/s_bluep.spr");
		precache_model ("progs/s_redp.spr");
		precache_model ("progs/dust.spr");
		precache_model ("progs/lball.spr");
		precache_model ("progs/hit.spr");
		precache_model ("progs/hit2.spr");
		precache_model ("progs/star.spr");
		precache_model ("progs/star2.spr");
		precache_model ("progs/jhit.spr");
		precache_model ("progs/block.spr");
		precache_model ("progs/spells.spr");
		precache_model ("progs/lsprite.spr");
		precache_model ("progs/fire.spr");
		precache_model ("progs/lightnin.spr");
		precache_model ("progs/chargice.spr");
		precache_model ("progs/cursor2.spr");
		precache_model ("progs/cursor3.spr");
		precache_model ("progs/enrage.spr");
		precache_model ("progs/twisti.spr");
		precache_model ("progs/smoke.spr");

		//
		// Sounds
		//

		precache_sound ("weapons/lstart.wav");
		precache_sound ("hydra/swim.wav");
		precache_sound ("weapons/lhit.wav");
		precache_sound ("player/inlava.wav");
		precache_sound ("player/inslime.wav");
		precache_sound ("player/twoosh.wav");
		precache_sound ("player/owhit.wav");
		precache_sound ("player/invun.wav");
		precache_sound ("player/sword4.wav");
		precache_sound ("player/hugekick.wav");
		precache_sound ("player/ledge.wav");
		precache_sound ("player/grab.wav");
		precache_sound ("player/djump.wav");
		precache_sound ("player/climb.wav");
		precache_sound ("player/run.wav");
		precache_sound ("player/wrun1.wav");
		precache_sound ("player/wrun2.wav");
		precache_sound ("player/swrdwall.wav");
		precache_sound ("player/skid.wav");
		precache_sound ("player/sipflask.wav");
		precache_sound ("player/flaskmag.wav");
		precache_sound ("player/mmenu1.wav");
		precache_sound ("player/mmenu2.wav");
		precache_sound ("player/jmpflor.wav");
		precache_sound ("player/swrdspin.wav");
		precache_sound ("player/fast.wav");
		precache_sound ("player/sword.wav");
		precache_sound ("player/sword2.wav");
		precache_sound ("player/sword3.wav");
		precache_sound ("player/spinatk.wav");
		precache_sound ("player/swordhit.wav");
		precache_sound ("player/kickhit.wav");
		precache_sound ("player/hit.wav");
		precache_sound ("player/bighit.wav");
		precache_sound ("player/wallgrab.wav");
		precache_sound ("player/pain1.wav");
		precache_sound ("player/pain2.wav");
		precache_sound ("player/pain3.wav");
		precache_sound ("player/pain4.wav");
		precache_sound ("player/death.wav");
		precache_sound ("player/jmphit.wav");
		precache_sound ("player/yell1.wav");
		precache_sound ("player/yell2.wav");
		precache_sound ("player/yell3.wav");
		precache_sound ("player/yell4.wav");
		precache_sound ("player/taunt1.wav");
		precache_sound ("player/taunt2.wav");
		precache_sound ("player/taunt3.wav");
		precache_sound ("player/taunt4.wav");
		precache_sound ("player/taunt5.wav");
		precache_sound ("player/bigcut.wav");
		precache_sound ("player/broken.wav");
		precache_sound ("player/poison.wav");
		precache_sound ("player/blind.wav");
		precache_sound ("player/motion1.wav");
		precache_sound ("player/motion2.wav");
		precache_sound ("player/jump.wav");
		precache_sound ("player/block.wav");
		precache_sound ("player/perfblok.wav");
		precache_sound ("player/breath.wav");
		precache_sound ("player/fullmp.wav");
		precache_sound ("player/lowhealth.wav");
		precache_sound ("player/purge.wav");
		precache_sound ("player/statushit.wav");
		precache_sound ("spells/fbeam.wav");
		precache_sound ("spells/fball.wav");
		precache_sound ("spells/fhit.wav");
		precache_sound ("spells/freeze.wav");
		precache_sound ("spells/shatter.wav");
		precache_sound ("spells/flnch.wav");
		precache_sound ("spells/lightn.wav");
		precache_sound ("spells/charge.wav");
		precache_sound ("spells/iceyair.wav");
		precache_sound ("spells/twister.wav");
		precache_sound ("spells/enrage.wav");
		precache_sound ("weapons/lhit.wav");
		precache_sound ("misc/pickup.wav");
		precache_sound ("misc/fireout.wav");
		precache_sound ("misc/levelup.wav");
		precache_sound ("misc/levelup2.wav");
		precache_sound ("misc/land.wav");
		precache_sound ("misc/hitgrond.wav");
		precache_sound ("misc/h2ohit1.wav");
		precache_sound ("misc/guts.wav");
		precache_sound ("misc/blood.wav");
		precache_sound ("misc/gold.wav");
		precache_sound ("misc/teleport.wav");
	}

	//
	// Precache Title Screen
	//

	if (world.model == "maps/start.bsp")
	{
		precache_sound ("music/track2.ogg");
		precache_model ("progs/title.spr");
		precache_model ("progs/title2.spr");
		precache_sound ("misc/title.wav");
		precache_sound ("misc/title2.wav");
	}

	//
	// Read cvars and store them for reading
	//

	difficulty = cvar("skill");
	deathmatch = cvar("deathmatch");
	coop = cvar("coop");
	
	//CSQC Setup
	CSEv_GrabCSQCValues();
};

float(float f) fixbyte =
{
	f = rint(f);
	if (f > 255)
		f = 255;
	else if (f < 0)
		f = 0;
	return f & 255;
};

// no bit 24!! FIXME! For now use low values for 1st parm :)
float(float s1, float s2, float s3) encode =
{
	return fixbyte(s1) * 65536 + fixbyte(s2) * 256 + fixbyte(s3);
};

float(float parm, float which) decode =
{
	if (which == 1)
		return (parm / 65536) & 255;
	else if (which == 2)
		return (parm / 256) & 255;
	else
		return parm & 255;
};

void() SetNewParms = 
{
	parm1 = 75; // health
	parm2 = encode(0, 0, 0); // spells obtained, armor level, sword level
	parm3 = 0; // bosses defeated
	parm4 = encode(0, 1, 0); // current spell, level, keys
	parm5 = 0; // gold
	parm6 = 0; // game progress bit
	parm7 = 0; // hp max up progress bit
	parm8 = 0; // shrine progress bit
	parm9 = 0; // mana
	parm10 = 0; // turbo mode
	parm11 = 75; // vigils max health
	parm12 = 0; // vigil pouch status
	parm14 = 0; // vigils experience
	parm15 = 20; // vigils mana pool
	parm17 = 0; // relics
	parm18 = 15; // health flask amount
	parm19 = 15; // health flask max amount
};

void() SetChangeParms =
{
	parm1 = self.health;
	parm2 = encode(spells, self.armorlevel, self.swordlevel);
	parm3 = bosses; // bosses defeated
	parm4 = encode(self.currentspell, self.level, keys);
	parm5 = self.gold;
	parm6 = game_progress;
	parm7 = hp_max_ups;
	parm8 = shrine_progress;
	parm9 = self.mana;
	parm10 = turbo_mode;	
	parm11 = self.max_health;
	parm12 = self.pouch;
	parm14 = self.experience;
	parm15 = self.max_mana;
	parm17 = relics;
	parm18 = self.hflask_amt;
	parm19 = self.hflask_max_amt;
};

void() DecodeLevelParms =
{
	if (parm1 == 0 || world.model == "maps/start.bsp")
		SetNewParms();

	self.health = parm1;
	self.max_mana = 17 + (10*(self.owner.level / 3));
	spells = decode(parm2, 1); // Spells obtained
	self.armorlevel = decode(parm2, 2);
	self.swordlevel = decode(parm2, 3);
	bosses = parm3; // bosses defeated
	self.currentspell = decode(parm4, 1);
	self.level = decode(parm4, 2);
	keys = decode(parm4, 3);
	self.gold = parm5;
	game_progress = parm6;
	hp_max_ups = parm7;
	shrine_progress = parm8;
	self.mana = parm9;
	turbo_mode = parm10;	
	self.max_health = parm11;
	self.pouch = parm12;
	self.experience = parm14;
	self.max_mana = parm15;
	relics = parm17;
	self.hflask_amt = parm18;
	self.hflask_max_amt = parm19;
	self.level = parm20;
};

void() timer_levelchange =
{
	local entity y;
	local float r;

	y = find(world, classname, "misc_title2");

	if (y.mode == FALSE)
	{
		if (self.cnt ==  0)
		{
			changelevel ("intro");
			return;
		}
		else
		{
			r = random()*5;
			localcmd ("viewsize 110\n");
			if (r <= 1)
				localcmd ("playdemo demo1\n");
			else if (r <= 2)
				localcmd ("playdemo demo2\n");
			else if (r <= 3)
				localcmd ("playdemo demo3\n");
			else if (r <= 4)
				localcmd ("playdemo demo4\n");
			else
				localcmd ("playdemo demo5\n");
			return;
		}
	}
};

.float soulcandle_toggle;
.float soulcandle_cooldown;
void() SoulCandle_Think =
{
	if (self.owner.soulcandle_cooldown < time)
	{
		remove(self);
		return;
	}
	
	local vector v;
	v = '0 0 0';
	makevectors(v);

	setorigin (self, self.owner.origin + v_up * 16 - v_right * 16);

	frameskip(0.01);
};

void() StartFrame =
{
	local entity h;

	if (world.model == "maps/start.bsp")
	{
		if (framecount == 4)
		{
			h = spawn();
			setmodel (h, string_null);
			h.cnt = 0;
			h.think = timer_levelchange;
			h.nextthink = time + 25;
			
			turbo_mode = FALSE;
			cvar_set("sv_gamespeed", "1");
		}
	}
	if (world.model == "maps/intro.bsp")
	{
		if (framecount == 4)
		{
			h = spawn();
			setmodel (h, string_null);
			h.classname = "timer";
			h.cnt = 1;
			h.think = timer_levelchange;
			h.nextthink = time + 45;
			
			turbo_mode = FALSE;
			cvar_set("sv_gamespeed", "1");
		}
	}
	
	//
	// Break Save
	//
	
	if (framecount == 10)
	{
		if (NOSAVE_CHECK == FALSE)
			NOSAVE_CHECK = TRUE; // NoSave
	}
	else if (framecount > 10)
	{
		if (NOSAVE_CHECK == FALSE)
		{
			if (world.model != "maps/village.bsp")
				error("Save Game Not Authorized! Save in the Village Church!\n");
			else if (SAVE_GAME_LOADED == FALSE)
				SAVE_GAME_LOADED = TRUE;
		}
	}
	
	//
	// Custom Lighting - Stops Monsters / Players from going pitch black
	//
	
	for (entity v = world; (v=nextent(v));)
	{
		if (!v.flags & FL_MONSTER && !v.classname == "player")
			continue;

		// Colormod smooth removal on monsters
		if (v.flags & FL_MONSTER)
		{
			if (v.berserk_finished < time)
			{
				if (v.colormod_x > 1)
					v.colormod_x = v.colormod_x - (0.03 * 100) * frametime;
				else
					v.colormod_x = 1;

				if (v.colormod_y > 1)
					v.colormod_y = v.colormod_y - (0.03 * 100) * frametime;
				else
					v.colormod_y = 1;

				if (v.classname == "ethskull") // z = blue
				{
					if (v.colormod_z > 3)
						v.colormod_z = v.colormod_z - (0.03 * 100) * frametime;
					else
						v.colormod_z = 3;
				}
				else
				{
					if (v.colormod_z > 1)
						v.colormod_z = v.colormod_z - (0.03 * 100) * frametime;
					else
						v.colormod_z = 1;
				}
			}
			else if (v.colormod != '3 1 1') // berserk/enrage on, reset to those colours
			{
				if (v.colormod_x > 3)
					v.colormod_x = v.colormod_x - (0.03 * 100) * frametime;
				else
					v.colormod_x = 3;

				if (v.colormod_y > 1)
					v.colormod_y = v.colormod_y - (0.03 * 100) * frametime;
				else
					v.colormod_y = 1;

				if (v.colormod_z > 1)
					v.colormod_z = v.colormod_z - (0.03 * 100) * frametime;
				else
					v.colormod_z = 1;
			}
		}
		
		local vector x;
		x = getlight(v.origin);

		// Uncomment for lighting levels adjustment
		/*
		local string s;
		
		s = ftos(x_x);
		bprint ("x: ", s, "\n"); 

		s = ftos(x_y);
		bprint ("y: ", s, "\n"); 

		s = ftos(x_z);
		bprint ("z: ", s, "\n"); 
		bprint ("\n");
		*/
	
		//
		// Soul Candle Relic - On
		//		
		if (v.classname == "player" && (relics & IT_RELIC9))
		{
			if (x_x <= 14 || x_y <= 14 || x_z <= 14)
			{
				v.soulcandle_cooldown = time + 1;

				if (!v.soulcandle_toggle)
				{
					local entity flare;
					
					flare = spawn();
					flare.owner = v;
					flare.movetype = MOVETYPE_NOCLIP;
					flare.solid = SOLID_NOT;
					flare.effects = EF_NODEPTHTEST;
					
					setorigin (flare, v.origin + v_up * 16);
					
					flare.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_CORONA;
					flare.light_lev = 125;
					flare.color = [0, 2, 2];

					flare.think = SoulCandle_Think;
					flare.nextthink = time;
				
					sound (v, CHAN_AUTO, "misc/fireout.wav", 0.5, ATTN_NORM);
					v.soulcandle_toggle = TRUE;
				}
			}
			else if (v.soulcandle_cooldown < time)
			{
				if (v.soulcandle_toggle)
				{		
					sound (v, CHAN_AUTO, "misc/fireout.wav", 0.5, ATTN_NORM);
					v.soulcandle_toggle = FALSE;
				}
			}
		}
		
		if (x_x < 44 || x_y < 44 || x_z < 44)
		{
			v.drawflags = 7; // override lighting
			v.abslight = -44;
		}
		else
		{
			v.drawflags = 0;
			v.abslight = 0;
		}
	}
	
	frameskip_delay = 0;
	developer = cvar("developer");
	framecount = framecount + 1;
};

void() MakeSolidList =
{
	local entity y;

	y = find(world, netname, "solid");
	while (y)
	{
		if (y.solid != SOLID_SLIDEBOX && y.classname != "breakable" && y.health > 0) // dead bodies shant go solid
		{
			y.solid = SOLID_SLIDEBOX;
			setorigin(y, y.origin);
		}
		y = find(y, netname, "solid");
	}
	y = find(world, netname, "solid");
};

void() UnmakeSolidList =
{
	local entity y;

	y = find(world, netname, "solid");
	while (y)
	{
		if (y.classname != "breakable")
		{
			y.solid = SOLID_TRIGGER;
			setorigin(y, y.origin);
		}
		y = find(y, netname, "solid");
	}
	y = find(world, netname, "solid");
};

float bound2 (float bmin, float bvalue, float bmax)
{
 	if (bvalue < bmin)
 		return bmin;
 	else if (bvalue > bmax)
 		return bmax;
	return bvalue;
};

// =======
// new hit detection method
// =======

entity(vector org, float rad) searchradius =
{
	local entity y, head, ent;
	local vector v;

	head = world;

	y = find(world, netname, "solid");
	while(y)
	{
		v_x = bound2(y.absmin_x, org_x, y.absmax_x);
		v_y = bound2(y.absmin_y, org_y, y.absmax_y);
		v_z = bound2(y.absmin_z, org_z, y.absmax_z);

		if(vlen(v - org) < rad)
		{
			if (head)
				ent.chain = y;
			else
				head = y;
			ent = y;
		}
		y = find(y, netname, "solid");
	}
	if (head)
		ent.chain = world;
	return head;
};

float (float min, float max) RandomRange =
{
	local float width;
	local float offset;
	local float result;

	width = (max - min);
	offset = (random () * width);
	result = (offset + min);
	return (result);
};

// this visible function returns TRUE even if sight line crossed contents (above and below water)
// essential for boss monsters, also special tweaks for breakable scenery
float (entity targ) visible =
{
 	traceline (self.origin, targ.origin, TRUE, self); // "true", see through other monsters
 
	if (trace_fraction == 1 || (targ.solid == SOLID_BSP && targ.takedamage != DAMAGE_NO))
 		return TRUE;
	else
	 	return FALSE;
};

/*
=============
checkground

returns whether or not an entity is touching the ground using tracebox, replaces checkbottom
as checkbottom is slow

0 is false
1 is true
=============
*/

float(entity e) checkground =
{
	local vector source, dest;

	source = e.origin;
	dest = e.origin - v_up * 1;
		
	tracebox (source, e.mins, e.maxs, dest, TRUE, e);

	if (trace_fraction == 1) // Hit nothing
		return FALSE;

	return TRUE;
};

//
// Entity handler for sending information to CSQC
//

float(entity to, float sendflags) SendEntityToCSQC =
{
	WriteByte(MSG_ENTITY, 5);			//write some entity type header
	WriteByte(MSG_ENTITY, sendflags);	//tell the csqc what is actually present.
	if (sendflags & 1)
	{
		WriteCoord(MSG_ENTITY, self.origin_x);
		WriteCoord(MSG_ENTITY, self.origin_y);
		WriteCoord(MSG_ENTITY, self.origin_z);
	}
	if (sendflags & 2)
		WriteByte(MSG_ENTITY, self.frame);
	if (sendflags & 4)
		WriteByte(MSG_ENTITY, self.alpha * 255);
	if (sendflags & 8)
		WriteByte(MSG_ENTITY, self.effects);
	if (sendflags & 16)
		WriteString(MSG_ENTITY, self.classname);
	if (sendflags & 32)
		WriteByte(MSG_ENTITY, self.cnt);

	if (sendflags & 128)
		WriteByte(MSG_ENTITY, self.modelindex);	//sending a modelindex is smaller than sending an entire string

	return TRUE;	//handled. If you return FALSE here, the entity will be considered invisible to the player.
};