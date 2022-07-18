//+--------+
//|Triggers|
//+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Triggers for maps and such are stored here.                                |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

.float height;
void() multi_trigger;

float	SPAWNFLAG_NOMESSAGE = 1;
float	SPAWNFLAG_NOTOUCH = 1;

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};

void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
	// trigger angles are used for one-way touches.  An angle of 0 is assumed
	// to mean no restrictions, so use a yaw of 360 instead.

	// This dumb if statement broke stuff on angle 0
//	if (self.angles != '0 0 0')
	SetMovedir ();
	
	if (self.classname != "changelevel")
		self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

float PUSH_ONCE = 1;
.float fly_time;
.float fly_sound;
void() trigger_push_touch =
{
	if (other.fly_time > time || self.cnt == TRUE)
		return;
	if (self.spawnflags & 16 && !other.flags & FL_MONSTER)
		return;
	if (other.health < 1)
		return;

	if (other.fly_sound < time)
	{
		if (!self.spawnflags & 4)
			sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
		if (self.spawnflags & 8)
			sound (other, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);
		other.fly_sound = time + 1.5;
	}

	makevectors (other.angles);

	other.angles = self.angles;
	other.velocity = '0 0 0';
	other.velocity = self.speed * self.movedir;
	other.velocity_z = self.height;

	if (other.flags & FL_ONGROUND)
		other.flags = other.flags - FL_ONGROUND;

	if (other.th_jump)
	{
		other.think = other.th_jump;
		other.nextthink = time + 0.1;
	}

	if (self.spawnflags & PUSH_ONCE)
	{
		remove(self);
		return;
	}
	other.fly_time = time + self.state;
};

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes any entity, at a given velocity one time per second
Inactive trigger_push is activated by another trigger
Spawnflag of 1 removes itself after being triggered
Spawnflag of 2 starts inactive
Spawnflag of 4 disables wind flying sound
Spawnflag of 8 plays player jump sound when touched
Spawnflag of 16 means only monsters
"speed":
40 (default) how fast of a velocity to push an object
*/
void() trigger_push =
{
	InitTrigger ();
	if (self.spawnflags & 2)
		self.cnt = TRUE; // inactive
	if (!self.spawnflags & 4)
		precache_sound ("ambience/windfly.wav");
	if (self.spawnflags & 8)
		precache_sound ("player/jump.wav");
	if (!self.state)
		self.state = 1;
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 40;
};

void() hurt_touch =
{
	if (other.takedamage && other.health > 0)
	{
		self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg, 0);
		self.think = hurt_on;
		self.nextthink = time + 1;
	}
	return;
};

/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
*/
void() trigger_hurt =
{
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger();
};

// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	if (self.nextthink > time)
		return;		// already been triggered

	// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;

	SUB_UseTargets();

	if (self.wait > 0)	
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called while C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void() multi_touch =
{
	// After Stained Glass Knight is defeated then the trigger_once
	// needs to be disabled!
	if (bosses & IT_BOSS1 && world.model == "maps/boss1.bsp")
		return;
	if (bosses & IT_BOSS2 && world.model == "maps/boss2.bsp")
		return;

	// default, player only
	// spawnflag 2 = monster only
	// spawnflag 4 = both player / monster
	if ((self.spawnflags & 2 && other.flags & FL_MONSTER) || (!self.spawnflags && other.classname == "player") || (self.spawnflags & 4))
	{
		self.enemy = other;
		multi_trigger ();
	}
};

/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
set "message" to text string
*/
void() trigger_multiple =
{	
	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch doesn't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if (!(self.spawnflags & SPAWNFLAG_NOTOUCH))
		{
			self.touch = multi_touch;
		}
	}
};

/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void() trigger_relay =
{
	self.use = SUB_UseTargets;
};

//===
// trigger change level
//===

string nextmap;

void() changelevel_touch =
{
	local string h, line;
	local float r;

	if (other.classname != "player")
		return;

	//
	// Stop Vigil from changing levels if engaged closely with a monster
	//   - prevents being smacked into a trigger_changelevel mainly -
	//
	
	if (self.map != "teleporter" && self.map != "boss1" && self.map != "boss2")
	{
		for (entity v = world; (v=nextent(v));)
		{
			if (!v.flags & FL_MONSTER)
				continue;

			if (v.enemy != world && v.health > 0 && v.enemy.classname == "player")
			{
				local entity oself;
				
				oself = self;
				self = v;
	
				r = vlen (self.origin - self.enemy.origin);

				if (r <= 300 && visible(self.enemy) && !oself.spawnflags)
				{
					centerprint (v.enemy.owner, "I cannot advance until pursuing enemies are defeated or far away ...");
					return;
				}

				self = oself;
			}
		}
	}

	//
	// if CNT2 is true then transport user using teleport.txt
	//
	if (self.cnt2 > 0) 
	{
		// Open "teleport" file for reading
		float f = fopen("teleport.txt", FILE_READ);
		if((line = fgets(f)))
			changelevel (line);
		fclose(f);
	}
	else // normal map change by trigger
	{
		//
		// store the last map name before level change
		//
		float g = fopen("teleport.txt", FILE_WRITE);
		if (g >= 0)
		{
			fputs(g, mapname, "\n");
			fclose(g);
		}
		h = ftos(self.cnt);
		cvar_set("gamecfg", h);
			
		nextmap = self.map;
		changelevel (nextmap);
	}
};

void() trigger_changelevel =
{
	if (!self.map && self.cnt2 < 1)
		objerror ("changelevel trigger doesn't have a map set");
	self.classname = "changelevel";
	self.solid = SOLID_TRIGGER;
	InitTrigger ();
	self.touch = changelevel_touch;
};

//===
// trigger change map - reset Vigils stats on level change
//===

string nextmap;
void() changemap_touch =
{
	local string h;

	if (other.classname != "player")
		return;
		
	h = self.targetname;
	localcmd ("map ", h, "\n");
};

void() trigger_changemap =
{
	if (!self.targetname)
		objerror ("changemap trigger requires a targetname for next map loaded\n");
	self.classname = "changemap";
	self.solid = SOLID_TRIGGER;
	InitTrigger ();
	self.touch = changemap_touch;
};

//===
// trigger fog - Allows mappers to adjust fog when trigger is touched by player
//===

.string fog;
void() fogchange_touch =
{
	if (other.classname != "player")
		return;
	
	if (other.fog != self.fog)
	{
		stuffcmd(other.owner, sprintf("fog %s\n", self.fog));
		other.fog = self.fog;
	}
};

void() trigger_fog =
{
	if (!self.fog)
		self.fog = "0";
	self.solid = SOLID_TRIGGER;
	InitTrigger ();
	self.touch = fogchange_touch;
};

//===
// trigger_skyroom - Sets a skyroom up by modifying the target value
//===

string skyroom_coord;
void() skyroom_touch =
{	
	if (other.classname != "player")
		return;

	// Spawnflag 1 allows for water brush rendering via skyroom
	// can lead to performance decrease in certain scenes
	if (self.spawnflags & 1)
	{
		if (cvar("r_portalrecursion") != 2)
			cvar_set("r_portalrecursion", "2");
	}

	if (skyroom_coord != self.target)
	{
		cvar_set("skyroom", self.target);
		skyroom_coord = self.target; // run once
	}
};

void() trigger_skyroom =
{
	self.solid = SOLID_TRIGGER;
	InitTrigger ();
	self.touch = skyroom_touch;	
};

//===
// trigger music - Allows mappers to change music track on touch or by targetting
// music done by trigger removes itself after one use unless .cnt flag is ON
//===

void() musicchange_use =
{
	local entity y;
	
	if (cvar("developer") == 3)
	{
		remove(self);
		return;
	}
	
	// Boss defeated, boss music triggers perma-removed
	if (bosses & IT_BOSS2 && world.model == "maps/boss2.bsp")
	{
		remove(self);
		return;
	}

	y = find(world, classname, "player");
	while (y)
	{
		if (y.music != self.music && (other.music != "sound/music/track9.ogg" || other.music != "sound/music/track16.ogg"))
		{
			y.music = self.music;
			stuffcmd (y.owner, sprintf("music %s\n", self.music));
		}
		y = find(y, classname, "player");
	}
	y = find(world, classname, "player");

	if (self.cnt == 0)
		remove(self);
	return;
};

void() musicchange_touch =
{	
	if (cvar("developer") == 3)
	{
		remove(self);
		return;
	}
	
	if (other.classname != "player")
		return;
	if (other.music == "sound/music/track9.ogg" || other.music == "sound/music/track16.ogg") // Don't turn off boss music
		return;
	if (other.music == self.music) //&& framecount > 9)
		return;

	stuffcmd (other.owner, sprintf("music %s\n", self.music));

	other.music = self.music;
};

void() trigger_music =
{
	if (!self.music)
		self.music = "";
	self.solid = SOLID_TRIGGER;
	InitTrigger ();
	if (self.targetname != "")
		self.use = musicchange_use;
	else
		self.touch = musicchange_touch;	
};

//===
// trigger_stopmusic - if boss music isn't playing it'll stop all music
//===

void() stopmusic_touch =
{
	if (other.classname != "player")
		return;

	other.music = "";
	localcmd ("stopmusic\n");
	remove(self);
	return;
};

void() trigger_stopmusic =
{
	self.solid = SOLID_TRIGGER;
	InitTrigger ();
	self.touch = stopmusic_touch;
};

void() counter_use =
{
	self.count = self.count - 1;

	// debugging
	//local string s = ftos(self.count);
	//bprint ("trigger_count: ", s, "\n");

	if (self.count < 0)
		return;
	
	if (self.count != 0)
		return;

	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_counter =
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};

//!! Camera tricks !!
// Vigil has to touch the trigger in order for it to work
// 0 = Return to normal
// 1 = Stop tracking
// 2 = Do not track Z angle. Up/Down
// 3 = Do not track X angle. Left/Right
// 4 = Envenom style, requires campos_angle!
// 5 = Dynamic camera is off, follow Vigil strictly

void() camstyle_touch =
{
	if (other.classname != "player")
		return; // No special camera in static mode / deathmatch / coop
	if (cvar("scratch3") == 1 && self.camerastyle == 4 || coop || deathmatch)
		return;

	other.owner.camerastyle = self.camerastyle;

	// Comparison
	if (self.zoom != 0)
	{
		self.new_zoom_y = other.owner.origin_zoom_y + self.zoom;
		if (other.owner.new_zoom_y != self.new_zoom_y)
			other.owner.new_zoom_y = self.new_zoom_y;
	}
	else if (other.owner.new_zoom_y != other.owner.origin_zoom_y) // Reset to original zoom position
		other.owner.new_zoom_y = other.owner.origin_zoom_y;

	if (self.camerastyle == 4)
	{
		if (other.owner.campos_x != self.campos_x || other.owner.campos_y != self.campos_y
		|| other.owner.campos_z != self.campos_z)
		{
			other.owner.campos_x = self.campos_x;
			other.owner.campos_y = self.campos_y;
			other.owner.campos_z = self.campos_z;
		}
	}
};

/*QUAKED trigger_camstyle (.5 .5 .5) ?
Vigil must touch this trigger for it to take effect,
remember you may have to set camera style back to 0
using another trigger!
"camerastyle":
0 (default) Default camera tracking method
1 Stop tracking all together
2 Do not track Up or Down / Z
3 Do not track Left or Right / X
4 Track at one location only, Envenom-style camera
*/
void() trigger_camstyle =
{
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.touch = camstyle_touch;
};

.vector pitplacement;
void() pit_touch =
{
	local entity temp;
	local entity spoint;
	local float f;

	if (other.pitdeath == TRUE || other.movetype == MOVETYPE_FLY || other.movetype == MOVETYPE_NOCLIP)
		return;

	if (other.classname == "player")
	{
		other.owner.nobackflip_finished = time + 999; // don't allow backflip
		if (self.pitplacement != '0 0 0') // warp Vigil to where the trigger pit tells him
			setorigin (other, self.pitplacement);
		else
		{
			if (other.invunerability_finished > time)
			{
				f = cvar("gamecfg");

				spoint = find(world, classname, "player_spawn");
				while (spoint)
				{
					if (spoint.cnt == f)
						setorigin(other, spoint.origin);
					spoint = find(spoint, classname, "player_spawn");
				}
			}
			else
				setorigin (other, other.lastpos);
		}
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_TELEPORT);
		WriteCoord (MSG_BROADCAST, other.origin_x);
		WriteCoord (MSG_BROADCAST, other.origin_y);
		WriteCoord (MSG_BROADCAST, other.origin_z);
		other.owner.telecam = TRUE;
	}
	// Monster hits trigger_hit
	if (other.flags & FL_MONSTER)
	{
		temp = self;
		self = other;
		SUB_UseTargets();
		self = temp;

		if (other.health > 0)
		{
			killed_monsters = killed_monsters + 1;
			WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
		}
		if (other.enemy.classname == "player" && other.enemy.health > 0) // reward for death
		{
			local entity oself;
			oself = self;
			self = other;
			GiveExperience(self.experience);
			self = oself;
		}
		remove(other);
		return;
	}
	other.pitdeath = TRUE;
	if (other.health > 0)
		T_Damage (other, self, self, self.cnt, 0);
};

/*QUAKED trigger_pit (.5 .5 .5) ?
Vigil health and is automatically warped
to a safe location, instant death
*/
void() trigger_pit =
{
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	if (!self.cnt)
		self.cnt = 10;
	self.touch = pit_touch;
};

/*QUAKED trigger_teledoor (0 .5 .8) ?
A teledoor is simply a silent teleporter and if touched will warp
the player to a new destination.
requires a target name

Spawnflags 1 - Camera auto teleports to final destination when trigger_camstyle is touched after
Spawnflags 2 - Monsters can use it as well
*/
void() player_move;
void() teledoor_touch =
{
	local entity t, oself;
	local vector org;

	if ((other.classname != "player" && !self.spawnflags & 2) || other.health < 1)
		return;

	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target for teledoor!");
	setorigin (other, t.origin);
	other.angles = t.angles;
	other.fixangle = TRUE;

	// teleport game camera to destination
	if (other.owner)
		other.owner.telecam = TRUE;

	// if spawnflag 1 is on, force camera to new Y position as determined by the trigger_camstyle 'zoom' field at teleport destination
	// if the 'cinematic' camera mode is on, then just warp to the final position
	if (self.spawnflags & 1 && other.owner)
		other.owner.force_final_campos = TRUE;

	// Force Vigil to run player_move, remove his velocity and drop him to the floor
	if (self.nodrop == FALSE)
	{
		oself = self;
		self = other;
		if (self.th_stand)
			self.th_stand();
		droptofloor();
		self.velocity = '0 0 0';
		self = oself;
	}
};

void() info_teledoor_destination =
{
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	if (!self.targetname)
		objerror ("no targetname on teledoor destination.\n");	
};

void() trigger_teledoor =
{
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.touch = teledoor_touch;
};

/*QUAKED trigger_walk (0 .5 .8) ?
When the player touches this entity, he is forced to walk in the direction
specified by the "angle" key. Accepted values are 0 to 360. If the "run"
spawnflag is checked (spawnflag 1), then the player is forced to run in
the specified direction. Currently run isn't implemented.
*/
void() walktrigger_touch =
{
	if (other.classname != "player")
		return;
	if (other.health < 1)
		return;
		
	other.fly_time = time; // fix for hitting trigger_pushes correctly
	other.angles_y = self.angles_y;
	other.fixangle = TRUE;
	other.owner.forcewalk_finished = time + 0.1;
};

void() trigger_walk =
{
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.touch = walktrigger_touch;
};

void() safezonetrigger_touch =
{
	if (other.classname != "player")
		return;
	if (self.cnt == 1) // cnt1 = safezone on
	{
		if (other.owner.safezone == FALSE)
		{
			other.owner.safezone = TRUE;
			other.running = FALSE; 
		}
	}
	else
	{
		if (other.owner.safezone == TRUE)
			other.owner.safezone = FALSE;
	}
};

void() trigger_safezone =
{
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.touch = safezonetrigger_touch;
};

.float trigger_spincut_finished;
void() spincut_touch =
{
	// Frame 136 = Head Smash
	// Frame 241 = $djump

	if (other.classname != "player")
		return;
	if (other.owner.ledgegrab)
		return;
	if (other.owner.wallgrab)
		return;

	other.owner.wallgrab = FALSE;
	other.owner.ledgegrab = FALSE;
	other.owner.walljump = FALSE;

	if (other.velocity_z > 0 && other.frame == 241 && other.djump_spincnt >= 2) // Going up
	{
		if (relics & IT_RELIC3) // Spin Cut relic only
		{
			other.djump_spincnt = 2;
			other.velocity_z = self.speed;
		}

		if (self.pain_finished < time)
		{
			if (!self.spawnflags) // Default green
				particle(other.origin, '0 0 0', 62, 50);
			sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);
			self.pain_finished = time + self.cnt;
		}
	}

	if (other.velocity_z < 0)
	{
		if (other.frame != 136) // Not head smashing
			other.velocity_z = other.velocity_z / 1.15;
		else
			other.velocity_z = other.velocity_z / 1.05;
		if (relics & IT_RELIC3 && other.frame != 241)
			other.owner.doublejump = FALSE; // Re-allow Double Jump

		other.owner.attack_finished = time;
		other.aircombo_count = 0;
	}
	other.velocity_y = other.velocity_y / 1.15;
	other.velocity_x = other.velocity_x / 1.15;

	other.owner.trigger_spincut_finished = time + 0.2; // special
};

/*QUAKED trigger_spincut (.5 .5 .5) ?
Spincut relic activated lift concerning progression
.speed - How fast Vigil ascends
.noise - Sound to play while ascending
.cnt - How often to play the sound
*/
void() trigger_spincut =
{
	InitTrigger ();
	if (!self.speed)
		self.speed = 200;
	if (!self.noise)
		self.noise = "misc/bushhit.wav";
	if (!self.cnt)
		self.cnt = 0.2;

	precache_sound (self.noise);

	self.solid = SOLID_TRIGGER;
	self.touch = spincut_touch;
};