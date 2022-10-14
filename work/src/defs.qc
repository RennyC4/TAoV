//+----+
//|Defs|
//+----+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| This contains necessary definitions from the original V1.06 defs.qc file.  |
//| This includes some basic constants, the built in function definitions, and |
//| some variable's used by the Quake Engine internally.                       |
//| Certain lines in this file are hardcoded into Quake engine, and -must- be  |
//| present and unchanged, in the order they are shown. Otherwise Quake will   |
//| refuse to run.                                                             |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

// These lines CANNOT be altered/moved
entity      self;
entity		other;
entity		world;
float		time;
float		frametime;
float		force_retouch;		// force all entities to touch triggers
string		mapname;
float		deathmatch;
float		coop;
float		teamplay;
float		serverflags;		// propagated from level to level, used to
float		total_secrets;
float		total_monsters;
float		found_secrets;		// number of secrets found
float		killed_monsters;	// number of monsters killed
float		parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16;
vector		v_forward, v_up, v_right;	// set by makevectors()
float		trace_allsolid;
float		trace_startsolid;
float		trace_fraction;
vector		trace_endpos;
vector		trace_plane_normal;
float		trace_plane_dist;
entity		trace_ent;
float		trace_inopen;
float		trace_inwater;

entity          msg_entity;                      // destination of single entity writes
void()          main;                            // only for testing
void()		StartFrame;
void() 		PlayerPreThink;
void() 		PlayerPostThink;
void()		ClientKill;
//void()		ClientConnect;
void() 		PutClientInServer;		// call after setting the parm1... parms
void()		ClientDisconnect;
void()		SetNewParms;			// called when a client first connects to
void()		SetChangeParms;			// call to set parms for self so they can
void		end_sys_globals;		// flag for structure dumping

.float		modelindex;		// *** model index in the precached list
.vector		absmin, absmax;	// *** origin + mins / maxs
.float		ltime;			// local time for entity
.float		movetype;
.float		solid;
.vector		origin;			// ***
.vector		oldorigin;		// ***
.vector		velocity;
.vector		angles;
.vector		avelocity;
.vector		punchangle;		// temp angle adjust from damage or recoil
.string		classname;		// spawn function
.string		model;
.float		frame;
.float		skin;
.float		effects;
.vector		mins, maxs;		// bounding box extents reletive to origin
.vector		size;			// maxs - mins
.void()		touch;
.void()		use;
.void()		think;
.void()		blocked;		// for doors or plats, called when can't push other
.float		nextthink;
.entity		groundentity;
.float		health;
.float		frags;
.float		weapon;			// one of the IT_SHOTGUN, etc flags
.string		weaponmodel;
.float		weaponframe;
.float		currentammo;
.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
.float		items;			// bit flags
.float		takedamage;
.entity		chain;
.float		deadflag;
.vector		view_ofs;			// add to origin to get eye point
.float		button0;		// fire
.float		button1;		// use
.float		button2;		// jump
.float		impulse;		// weapon changes
.float		fixangle;
.vector		v_angle;		// view / targeting angle for players
.float		idealpitch;		// calculated pitch angle for lookup up slopes
.string		netname;
.entity 	enemy;
.float		flags;
.float		colormap;
.float		team;
.float		max_health;		// players maximum health is stored here
.float		teleport_time;	// don't back up
.float		armortype;		// save this fraction of incoming damage
.float		armorvalue;
.float		waterlevel;		// 0 = not in, 1 = feet, 2 = waist, 3 = eyes
.float		watertype;		// a contents value
.float		ideal_yaw;
.float		yaw_speed;
.entity		aiment;
.entity 	goalentity;		// a movetarget or an enemy
.float		spawnflags;
.string		target;
.string		targetname;
.float		dmg_take;
.float		dmg_save;
.entity		dmg_inflictor;
.entity		owner;		// who launched a missile
.vector		movedir;	// mostly for doors, but also used for waterjump
.string		message;		// trigger messages
.float		sounds;		// either a cd track number or sound number
.string         noise, noise1, noise2, noise3;  // contains names of wavs to play

void		end_sys_fields;			// flag for structure dumping
// End. Lines below this MAY be altered, to some extent

// Built In functions
void(vector ang) makevectors			= #1;	// sets v_forward, etc globals
void(entity e, vector o) setorigin		= #2;
void(entity e, string m) setmodel		= #3;	// set movetype and solid first
void(entity e, vector min, vector max) setsize	= #4;
void() break					= #6;
float() random					= #7;	// returns 0 - 1
//void(entity e, float chan, string samp, float vol, float atten) sound = #8;
vector(vector v) normalize			= #9;
void(string e) error				= #10;
void(string e) objerror				= #11;
float(vector v) vlen				= #12;
//float(vector v) vectoyaw			= #13;
entity() spawn					= #14;
void(entity e) remove				= #15;
void(vector v1, vector v2, float nomonsters, entity forent) traceline = #16;	
entity() checkclient				= #17;		// returns a client to look for
entity(entity start, .string fld, string match) find = #18;
string(string s) precache_sound			= #19;
string(string s) precache_model			= #20;
void(entity client, string s)stuffcmd		= #21;
//entity(vector org, float rad) searchradius	= #22;
void(string s) dprint				= #25;
string(float f) ftos				= #26;
string(vector v) vtos				= #27;
void() coredump					= #28;		// prints all edicts
void() traceon					= #29;		// turns statment trace on
void() traceoff					= #30;
void(entity e) eprint				= #31;		// prints an entire edict
//float(float yaw, float dist) walkmove		= #32;		// returns TRUE or FALSE
float() droptofloor	= #34;		// TRUE if landed on floor
//void(float style, string value) lightstyle	= #35;
float(float v) rint				= #36;		// round to nearest int
float(float v) floor				= #37;		// largest integer <= v
float(float v) ceil				= #38;		// smallest integer >= v
float(entity e) checkbottom			= #40;		// true if self is on ground
float(vector v) pointcontents			= #41;		// returns a CONTENT_*
float(float f) fabs				= #43;
vector(entity e, float speed) aim		= #44;		// returns the shooting vector
float(string s) cvar				= #45;		// return cvar.value
void(string s) localcmd				= #46;		// put string into local que
entity(entity e) nextent			= #47;		// for looping through all ents
void() ChangeYaw 				= #49;		// turn towards self.ideal_yaw
//vector(vector v) vectoangles			= #51;
void(float to, float f) WriteByte		= #52;
void(float to, float f) WriteChar		= #53;
void(float to, float f) WriteShort		= #54;
void(float to, float f) WriteLong		= #55;
void(float to, float f) WriteCoord		= #56;
void(float to, float f) WriteAngle		= #57;
void(float to, string s) WriteString		= #58;
void(float to, entity s) WriteEntity		= #59;
void(float step) movetogoal			= #67;
string(string s) precache_file			= #68;		// no effect except for -copy
//void() makestatic			= #69;
//void(string s) changelevel			= #70;
void(string var, string val) cvar_set		= #72;		// sets cvar.value
//void(entity client, string s) centerprint 	= #73;		// sprint, but in middle
void(entity client, string s, string s) centerprint2 = #73;
void(entity client, string s, string s, string s) centerprint3 = #73;
void(entity client, string s, string s, string s, string s) centerprint4 = #73;
void(entity client, string s, string s, string s, string s, string s) centerprint5 = #73;
void(entity client, string s, string s, string s, string s, string s, string s) centerprint6 = #73;
void(entity client, string s, string s, string s, string s, string s, string s, string s) centerprint7 = #73;
void(vector pos, string samp, float vol, float atten) ambientsound = #74;
string(string s) precache_model2		= #75;	// registered version only
string(string s) precache_sound2		= #76;	// registered version only
string(string s) precache_file2			= #77;	// registered version only
void(entity e) setspawnparms			= #78;	// set parm1... to the

//
// constants
//

float	FALSE					= 0;
float 	TRUE					= 1;

// edict.flags
float	FL_FLY					= 1;
float	FL_SWIM					= 2;
float	FL_CLIENT				= 8;	// set for all client edicts
float	FL_INWATER				= 16;	// for enter / leave water splash
float	FL_MONSTER				= 32;
float	FL_GODMODE				= 64;	// player cheat
float	FL_NOTARGET				= 128;	// player cheat
float	FL_ITEM					= 256;	// extra wide size for bonus items
float	FL_ONGROUND				= 512;	// standing on something
float	FL_PARTIALGROUND		= 1024;	// not all corners are valid
float	FL_WATERJUMP			= 2048;	// player jumping out of water
float	FL_JUMPRELEASED			= 4096;	// for jump debouncing

// edict.movetype values
float	MOVETYPE_NONE			= 0;	// never moves
float   MOVETYPE_ANGLENOCLIP    = 1;
float   MOVETYPE_ANGLECLIP              = 2;
float	MOVETYPE_WALK			= 3;	// players only
float	MOVETYPE_STEP			= 4;	// discrete, not real time unless fall
float	MOVETYPE_FLY			= 5;
float	MOVETYPE_TOSS			= 6;	// gravity
float	MOVETYPE_PUSH			= 7;	// no clip to world, push and crush
float	MOVETYPE_NOCLIP			= 8;
float	MOVETYPE_FLYMISSILE		= 9;	// fly with extra size against monsters
float	MOVETYPE_BOUNCE			= 10;
float	MOVETYPE_BOUNCEMISSILE	= 11;	// bounce with extra size

// edict.solid values
float	SOLID_NOT				= 0;	// no interaction with other objects
float	SOLID_TRIGGER			= 1;	// touch on edge, but not blocking
float	SOLID_BBOX				= 2;	// touch on edge, block
float	SOLID_SLIDEBOX			= 3;	// touch on edge, but not an onground
float	SOLID_BSP				= 4;	// bsp clip, touch on edge, block

// range values
float	RANGE_CLOSE				= 0;
float	RANGE_MELEE				= 1;
float	RANGE_NEAR				= 2;
float	RANGE_MID				= 3;
float	RANGE_FAR				= 4;

// deadflag values

float	DEAD_NO					= 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				= 2;
float	DEAD_RESPAWNABLE		= 3;

// takedamage values

float	DAMAGE_NO				= 0;
float	DAMAGE_YES				= 1;
float	DAMAGE_AIM				= 2;

.void()		th_stand;
.void()		th_walk;
.void()		th_run;
.void()		th_die;
.void()           th_missile;
.void()           th_melee;
.void()           th_misc;

// point content values

float	CONTENT_EMPTY			= -1;
float	CONTENT_SOLID			= -2;
float	CONTENT_WATER			= -3;
float	CONTENT_SLIME			= -4;
float	CONTENT_LAVA			= -5;
float CONTENT_SKY                   = -6;

float   STATE_RAISED            = 0;
float   STATE_LOWERED           = 1;
float	STATE_UP		= 2;
float	STATE_DOWN		= 3;

vector	VEC_ORIGIN = '0 0 0';
vector	VEC_HULL_MIN = '-16 -16 -24';
vector	VEC_HULL_MAX = '16 16 32';

vector	VEC_HULL2_MIN = '-32 -32 -24';
vector	VEC_HULL2_MAX = '32 32 64';

// protocol bytes
float	SVC_BAD			= 0;
float	SVC_NOP			= 1;
float	SVC_DISCONNECT		= 2;
float	SVC_UPDATESTAT		= 3;
float	SVC_VERSION		= 4;
float	SVC_SETVIEW		= 5;
float	SVC_SOUND		= 6;
float	SVC_TIME		= 7;
float	SVC_PRINT		= 8;
float	SVC_STUFFTEXT		= 9;
float	SVC_SETANGLE		= 10;
float	SVC_SERVERINFO		= 11;
float	SVC_LIGHTSTYLE		= 12;
float	SVC_UPDATENAME		= 13;
float	SVC_UPDATEFRAGS		= 14;
float	SVC_CLIENTDATA		= 15;
float	SVC_STOPSOUND		= 16;
float	SVC_UPDATECOLORS	= 17;
float	SVC_PARTICLE		= 18;
float	SVC_DAMAGE		= 19;
float	SVC_SPAWNSTATIC		= 20;
float	SVC_SPAWNBINARY		= 21;
float	SVC_SPAWNBASELINE	= 22;
float	SVC_TEMPENTITY		= 23;
float	SVC_SETPAUSE		= 24;
float	SVC_SIGNONNUM		= 25;
float	SVC_CENTERPRINT		= 26;
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_SPAWNSTATICSOUND	= 29;	// 1998-08-08 Complete SVC list by Zhenga
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE		= 31;
float	SVC_CDTRACK		= 32;
float	SVC_SELLSCREEN		= 33;
float	SVC_CUTSCENE		= 34;	// 1998-08-08 Complete SVC list by Zhenga

float	TE_SPIKE		= 0;
float	TE_SUPERSPIKE	= 1;
float	TE_GUNSHOT		= 2;
float	TE_EXPLOSION	= 3;
float	TE_TAREXPLOSION	= 4;
float	TE_LIGHTNING1	= 5;
float	TE_LIGHTNING2	= 6;
float	TE_WIZSPIKE		= 7;
float	TE_KNIGHTSPIKE	= 8;
float	TE_LIGHTNING3	= 9;
float	TE_LAVASPLASH	= 10;
float	TE_TELEPORT		= 11;

// sound channels
// channel 0 never willingly overrides
// other channels (1-7) allways override a playing sound on that channel
float	CHAN_AUTO		= 0;
float	CHAN_WEAPON		= 1;
float	CHAN_VOICE		= 2;
float	CHAN_ITEM		= 3;
float	CHAN_BODY		= 4;

float	ATTN_NONE		= 0;
float	ATTN_NORM		= 1;
float	ATTN_IDLE		= 2;
float	ATTN_STATIC		= 3;

// update types

float	UPDATE_GENERAL	= 0;
float	UPDATE_STATIC	= 1;
float	UPDATE_BINARY	= 2;
float	UPDATE_TEMP		= 3;

// entity effects

float	EF_BRIGHTFIELD	= 1;
float	EF_MUZZLEFLASH 	= 2;
float	EF_BRIGHTLIGHT 	= 4;
float	EF_DIMLIGHT 	= 8;


// messages
float	MSG_BROADCAST	= 0;		// unreliable to all
float	MSG_ONE			= 1;		// reliable to one (msg_entity)
float	MSG_ALL			= 2;		// reliable to all
float	MSG_INIT		= 3;		// write to the init string

float	AS_STRAIGHT		= 1;
float	AS_SLIDING		= 2;
float	AS_MELEE		= 3;
float	AS_MISSILE		= 4;

void() SUB_Null2 = {};

// Quake assumes these are defined.
entity activator;
string string_null;    // null string, nothing should be held here

.string wad, map;
.float worldtype, delay, wait, lip, light_lev, speed, style, skill;
.string killtarget;
.vector pos1, pos2, mangle;

void(vector o, vector d, float color, float count) particle = #48;// start a particle effect
// End

//======================================================
// TAOV SPECIFIC DEFINES
//======================================================

.float sound_finished;

//
// These are Vigil specific and used to belong to the top of player.qc
//
.float rollforward_fstab2;
.vector oangles; // old angles
.float inwater_pain; // in water pain handler
.vector rel_height; // for spin attack particles
.float wallhit_count; // how long to sticky on wall
.float charge_count; // Vigil's charge up attack counter
.float idle_count; // count frames during standing animation to go into idle frames
.float combo_finished;
.float spin_finished;
.float velocity_time; // this variable allows free velocity movement on the player, otherwise velocity is normally locked when required
.float runatk_speed; // variable that increases as the player skids along the ground during the running attack
.float dbltime;
.float backflip_finished; // Finished the backflip animation
.float doublejump; // Note! False means you're able to double jump, true means you cannot!
.float doublejump_finished; // when the animation is done itself
.float walljump; // jumped from a wall grab
.float nextspeed_time; // called from playerprethink
.float perform_divingswallow; // button pressed, so perform it when ready!
.float djump_spincnt; // how many times vigil can spin cut
.float sword_spincnt; // how many tiems vigil spun his sword around with the down, forward + attack move
.float wallrun_height;
.float chargespincnt;
.float mashattack; // Allow the player to mash the attack button for one swing to go straight to the next
.float fstab_cnt;

//
// End
//

.float button3;
.float dmg; // for trigger hurt
.entity movetarget;
.float pausetime;
.entity	oldenemy;
.float dmgtime;
.string	mdl;

float   EF_NODEPTHTEST  = 8192;
float   EF_ADDITIVE     = 32;
float   EF_NOSHADOW     = 4096;
.entity drawonlytoclient;

float KEY_UP = 1;
float KEY_DOWN = 2;
float KEY_LEFT = 4;
float KEY_RIGHT = 8;

.float moveprog1_finished; // Timer to remove moveprog
.float moveprog2_finished; // Timer to remove moveprog
.float moveprog3_finished; // Timer to remove moveprog
.float moveprog4_finished; // Timer to remove moveprog
.float moveprog1; // Holds a value for each key pressed, used for special moves
.float moveprog2; // Holds a value for each key pressed, used for special moves
.float moveprog3; // Holds a value for each key pressed, used for special moves
.float moveprog4; // Holds a value for each key pressed, used for special moves
.float FL_MP1PRESSED; // Up press check
.float FL_MP2PRESSED; // Down press check
.float FL_MP3PRESSED; // Left press check
.float FL_MP4PRESSED; // Right press check

entity damage_attacker;	// set by T_Damage
float frameskip_delay; // keep low framerates in sync
entity frameskip_ent;

.float scale;
.float spawntime;
.entity char;                              // FrikaC, character control dummy
.entity charcursor;                        // RenegadeC, character cursor
.entity smooth_x_camera;                   // RenegadeC, smooth axis X camera entity
.float force_final_campos; 				   // used in trigger_teledoor
.float walkframe;
.vector test_org;
.float keyflags;
.entity lock_view;
.float paincount; // how many hits
.float oldhealth; // hold old health values
.float waterjump_finished; // don't spam water jump for AI

.void() th_pain;
.void() th_run;
.void() th_jump;
.void() th_magic;
.void() th_grab;
.void() th_block;
.void() th_swim;

.float combo; // combo counter
.float last_combo; // last combo achieved and recorded
.float safezone; // if enabled on client, Vigil cannot do anything harmful
.float flypain;
.float attack_finished;
.float aircombo_finished; // tell monsters they're being air comboed and not to BlockCancel();
.float pain_finished;
.float block_finished;
.float mode;
.float swing_count; // how many times vigil has swung
.float grab_count; // how many times vigil has grab attacked his combo
.float grab_finished; // how long to grab for
.float aircombo_count; // how many times vigil has air comboed
.float counter_finished;
.float FL_ATKPRESSED; // attack press check
.float FL_MGCPRESSED; // magic press check
.float FL_JMPPRESSED; // jump press check
.float FL_BLKPRESSED; // block press check
.float wallgrab; // wallgrab
.float wallrun; // wallrun
.float wallrun_finished; // finished his wall running
.float ledgegrab; // ledgegrab
.float swimming; // swimming boolean for Vigil
.float cnt;
.float cnt2;
.float ai_reattack; // tells AI to throw another attack immediately after the previous one
.float ai_blockfreq; // how often the enemy blocks
.float nopain_time; // if time is above 0, then monsters/players is no longer affected by pain
.float knockback; // can the enemy be knocked back
.float running; // true if the player/monster is running
.float tired_finished; // player casted a spell without full mana requirement met and is now tired
.float headsmash_recovery_finished; // player is in his recovery animation for head smashing
.float screenflash_finished; // screen flashes white
.float dodge_finished; // Vigil dodging
.float shadow_time; // shadow trails
.float softshadow_time; // soft shadow trails
.float speedline_time; // speed lines
.float swordshadow_time; // shadow trails
.float nodrop; // don't auto-drop to floor
.float experience; // rpg stats
.float level;      // rpg stats
.float gold;	   // rpg stats
.float maxgold;    // max gold monster can drop
.float mana;	   // mana pool
.float max_mana;   // max mana allowed
.string attackedname; // monsters know what they attacked by the classname of what they hit
.float stand_finished; // how long the ai will stand still during combat
.float noblock_finished; // vigil cannot block if this is true
.float nojump_finished; // vigil cannot jump if this is true
.float nospinatk_finished; // vigil cannot spin attack if this is true
.float nobackflip_finished; // vigil cannot backflip out if true
.float twister_damage_finished;
.float invunerability_finished; // entity cannot be damaged
.float berserk_finished; // berserk/enrage is on a monster
.float forcewalk_finished; // used for trigger_walk
.float inair; // how long Vigil's been considered 'in air'
.float bigfall; // Boolean for if Vigil fell from a massive height

// Health flask
.float hflask_amt;
.float hflask_max_amt;
.float hflask_drink_finished;
//

// Attack types, game can determine what kind of attack the player launched and
// what to do if a monster/player was hit by it!

// 0 = Regular
// 1 = Wind
// 2 = Fire
// 3 = Ice
// 4 = Lightning
// 5 = Sliced in half

//

.float attack_type; // used on attacking entity
.float damage_type; // what type of attack the entity was hit by

//
//

.vector turn;
.float count;
float SPELL_FIREBALL = 0;
float SPELL_LIGHTNING = 1;
float SPELL_ICE = 2;
float SPELL_BEAM = 4;
float SPELL_TWISTER = 8;
.float conversation; //boolean, true means in a conversation
.float currentspell;
.float armorlevel;
.float swordlevel;
.float magicmenu; // boolean, does the player have the magic menu open
.vector lastpos; // RenegadeC, last position before vigil jumps
.float pitdeath; // boolean, true if killed by bottomless pit
.float noblood; // object does not bleed (barrels)
.float nojump; // monster cannot jump, used by mappers
.float grabbed; // have I been grabbed?
.float splash_finished; // if > time, put water splashes at Vigils feet
.float bflipwall_finished; // variable for allowing Vigil to backflip after hitting an enemy with his diving swallow
.float gaveexp; // explained in monster's death function
.float grab_finished; // how long the person can stay stuck in their grabbed animation
.float onground; // A secondary on ground check for Vigil, TRUE if the traceline he shoots
		         // underneath him touches the ground, this traceline is also used to check if
		         // he should play his running animation (used for descending stairs properly with an animation glitch)
.float camerastyle; // camera has different tracking options, 0 is default, 1 stops tracking (sit still) and so forth
.float camshake_finished;
.float camchangetarget_finished; // allows the camera to briefly change targets away from the player
.float telecam; // boolean to teleport camera to player position right away
.float ledgegrab_finished; // if set, vigil cannot move in mid-air and the jump button is disabled
.float guardbreak_finished; // guard breaking
.float ignoreaircombo; // if TRUE monster isn't raised by Air Combo strikes from Vigil
.string displayname; // Monsters display name in the bottom right corner (CSQC)
.float displayname_finished; // for monster name relic and CSQC
.float monster_health; // for monster health CSQC display
.float monster_max_health; // for monster max health CSQC display
.float rainbow_finished; // rainbow colormod effect to flash on player/vigil
.float pouch; // boolean (True or False), does Vigil carry a pouch
float hint_step; // how many hints Vigil has receieved
nosave .string music; // no save, so that it plays music on savegame load
.float bigfall_recovery_finished; // vigil's in his 'big fall' recovery animation, prevent block/dodge
.float bighit_freeze; // halt the game momentarily to emphasize big hits

.float vcshift_ok; // must be true for v_cshift to be allowed, anti localcmd spam boolean
.float screentint_finished; // allows v_cshift for x amount of time
.float button2_buffer; // Jump buffer, when TRUE forces button2 (jump) ON Vigil, used for running attack short hop
float turbo_mode; // Turbo mode boolean, saved in parms
.float camera_forcezoom_finished; // if true, camera will force zoom out to help it get unstuck
.float ftspin_count;
.float lowceil; // low ceiling flag
.float oeffects; // old effects
.float nowaterremove_finished;
.float blockcount; // how many blocks before guard break happens
.float blockcount_finished; // timer to reset blockcount
.float current_damage; // record current damage for HUD
.float total_damage; // record total damage for HUD
.float playerhitframe_finished;

// Izuna drop
.entity izunatarg; // izuna drop target
.float izunaspin_speed;
.float izuna_apex;
.float izuna_exec_finished; // timer for how long the target can be air inzuna'd

.float attackhit; // timer on if an attack landed on the target
.float beenblocked; // timer record on both attacker / victim if blocking an attack has occured (melee only)

// Fireball target cycling is too expensive
//.entity fireball_targ; // Vigil's fireball target, called before launching a fireball

// Perfect Guard
.float perfectblock; // timer
.float perfectblock_cooldown;
.float perfectguard_buff; // timer, when on Vigil is a TAKEDAMAGE_NO; entity

// Spell absorbtion
.float absorb_finished;

// Send godmode status to CSQC
.float god;

// Purge
.float purge_finished;
.float purge_cooldown;
.float purge_toggle; // for camera effect
.vector purge_oldorigin;
.entity purge_targ;

float(string s) checkextension = #99;
void() InitTrigger;
.float state;
float	STATE_TOP	= 0;
float	STATE_BOTTOM	= 1;

// allow more targets per entity to fire
.string target2;
.string target3;
.string target4;
.string target5;
.string target6;
.string target7;
.string target8;
.string target9;

.string awaketarget; // monster only, fire target on wakeup
.string awaketarget2; // monster only, fire target on wakeup
.string awaketarget3; // monster only, fire target on wakeup
.string awaketarget4; // monster only, fire target on wakeup
.string awaketarget5; // monster only, fire target on wakeup
.string awaketarget6; // monster only, fire target on wakeup
.string awaketarget7; // monster only, fire target on wakeup
.string awaketarget8; // monster only, fire target on wakeup
.string awaketarget9; // monster only, fire target on wakeup

.string halfhealth_target; // monster only, fire target on half-health

//
// The Ascension of Vigil supports 4 players max!
//

float players; // how many players are currently in the game
float players_dead; // how many are dead
.float playerid; // the players ID of which # he is

//
//
//

// ! Graphical Menu specifics !
float menu_difficulty;
float menu_turbo;
float menu_seizurefx;
float menu_volume;
float menu_ccounter;
float menu_camera;

float freeze_finished;

// Camera
.float zoom_mode; // different zooming styles
.float current_zoom; // current zooming level
.float min_zoom; // minimum zoom level allowed
.float max_zoom; // maximum zoom level allowed

float FL_BOSS = 8192; // entity is a boss monster

//
// NPC function definitions
//

.float selection;
.float selection_up;
.float selection_down;
.float chatrefresh_finished;
.float npcmove_finished;
.float npcmove_mode;
.float npcturn_dir;
.float score;
.void() npc_talk;

//
// DEFINES FOR CSQC
//

#define STAT_GOLD 32
#define STAT_SWORD 33
#define STAT_ARMOR2 34
#define STAT_MONSTER_NAME 35
#define STAT_SPELL 36
#define STAT_COMBO 37
#define STAT_PRICE 38
#define STAT_RELIC 39
#define STAT_PERFECTGUARD 40
#define STAT_POUCH 41
#define STAT_MAXHEALTH 42
#define STAT_MANA 43
#define STAT_MAXMANA 44
#define STAT_EXP 45
#define STAT_KEYS 46
#define STAT_FLASK 47
#define STAT_FLASK_MAX 48

// Status effects
#define STAT_STATUS_BLIND 49
#define STAT_STATUS_POISON 50
#define STAT_STATUS_BROKEN 51

#define STAT_ORIGINX 52
#define STAT_ORIGINY 53
#define STAT_ORIGINZ 54

#define STAT_CURRENTSHRINE 55
#define STAT_SHRINEHUD 56

#define STAT_LEVEL 57
#define STAT_ABSORB 58
#define STAT_COMBOMSG 59

// Vigil's mug on HUD
#define STAT_HEAD_PAIN 60
#define STAT_HEAD_GOD 61

// Total Damage on HUD
#define STAT_CURRENT_DAMAGE 62
#define STAT_TOTAL_DAMAGE 63

// Monster stats on HUD
#define STAT_MON_HEALTH 64
#define STAT_MON_MAXHEALTH 65

//

// Origin Grab for Vigil

.float vigil_x;
.float vigil_y;
.float vigil_z;

.float status_blind_finished;
.float status_poison_finished;
.float status_broken_finished;

.float display_price;

// Break Save
nosave float NOSAVE_CHECK;
nosave float SAVE_GAME_LOADED;

// CSQC Combo congrats display messages
.float combo_message;
.float combo_message_finished;

// Status Effect Behaviors
.float poison_tick_finished;
.float poison_snd_tick_finished;
.float blind_snd_tick_finished;
.float broken_tick_finished;

//=======================
//GAME PROGRESSION VALUES - Start
//=======================

float game_progress;
float IT_PROGRESS1 = 1; // Reached Village + Update death menu
float IT_PROGRESS2 = 2; // Cyclone Crush bought
float IT_PROGRESS3 = 8; // Rock smashed in Map01 (Wilderness)
float IT_PROGRESS4 = 16; // Diving Swallow bought
float IT_PROGRESS5 = 32; // Vigil reached the Castle
float IT_PROGRESS6 = 64; // Izuna Drop bought

float shrine_progress;
float shrineHUD_on; // Tells CSQC to draw the HUD for selection or not
.float currentshrine; // for selection on vigil
float IT_SHRINE0 = 0; // Village
float IT_SHRINE1 = 1; // Castle Entrance Shrine
float IT_SHRINE2 = 2; // Cursed Cavern Shrine
float IT_SHRINE3 = 4; // Grand Cathedral Shrine

float hp_max_ups;
// These are set one step up from spawnflags due to HPMAXUP1 being zero causes problems
float IT_HPMAXUP1 = 1;
float IT_HPMAXUP2 = 2;
float IT_HPMAXUP3 = 4;
float IT_HPMAXUP4 = 8;
float IT_HPMAXUP5 = 16;
float IT_HPMAXUP6 = 32;

// Keys
float keys;
float IT_KEY1 = 1; // Gold ("Church") key
float IT_KEY2 = 2; // Silver key

// Relics
float relics; // which relics you own
float IT_RELIC1 = 1; // ledge grab
float IT_RELIC2 = 2; // double Jump
float IT_RELIC3 = 4; // spin slash
float IT_RELIC4 = 8; // wall grab
float IT_RELIC5 = 16; // wall run
float IT_RELIC6 = 32; // water breathing
float IT_RELIC7 = 64; // cube of knowledge
float IT_RELIC8 = 128; // perfect guard
float IT_RELIC9 = 256; // soul candle
float IT_RELIC10 = 512; // burning epitome
float IT_RELIC11 = 1024; // stalwart perfect guard

// Spells
float spells;
float IT_SPELL1 = 1; // lightning storm
float IT_SPELL2 = 2; // ice field
float IT_SPELL3 = 4; // beam
float IT_SPELL4 = 8; // twister

// Bosses
float bosses;
float FL_BOSS1 = 1024; // Weird results with anything lower
float FL_BOSS2 = 2048;
float IT_BOSS3 = 4096;
float IT_BOSS4 = 8192;

//=======================
//GAME PROGRESSION VALUES - End
//=======================


//=======================
// CONSTANTS
//=======================

float	CONST_BIGHITSLOW		= 1; // Time * frametime, game freeze on big hits