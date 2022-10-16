/*
+--------+
|Dog     |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Melee fighting dog, cannot be grabbed, is very weak.                       |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

void() dog_stand1	=[	$stand1,	dog_stand2	] {ai_stand();};
void() dog_stand2	=[	$stand2,	dog_stand3	] {ai_stand();};
void() dog_stand3	=[	$stand3,	dog_stand4	] {ai_stand();};
void() dog_stand4	=[	$stand4,	dog_stand5	] {ai_stand();};
void() dog_stand5	=[	$stand5,	dog_stand6	] {ai_stand();};
void() dog_stand6	=[	$stand6,	dog_stand7	] {ai_stand();};
void() dog_stand7	=[	$stand7,	dog_stand8	] {ai_stand();};
void() dog_stand8	=[	$stand8,	dog_stand9	] {ai_stand();};
void() dog_stand9	=[	$stand9,	dog_stand1	] {ai_stand();};

void() dog_walk1	=[	$walk1,	dog_walk2	] {ai_walk(8);};
void() dog_walk2	=[	$walk2,	dog_walk3	] {ai_walk(8);};
void() dog_walk3	=[	$walk3,	dog_walk4	] {ai_walk(8);};
void() dog_walk4	=[	$walk4,	dog_walk5	] {ai_walk(8);};
void() dog_walk5	=[	$walk5,	dog_walk6	] {ai_walk(8);};
void() dog_walk6	=[	$walk6,	dog_walk7	] {ai_walk(8);};
void() dog_walk7	=[	$walk7,	dog_walk8	] {ai_walk(8);};
void() dog_walk8	=[	$walk8,	dog_walk1	] {ai_walk(8);};

void() dog_run1	=[	$run1,	dog_run2 	] {ai_walk(20);};
void() dog_run2	=[	$run2,	dog_run3 	] {ai_walk(20);};
void() dog_run3	=[	$run3,	dog_run4 	] {ai_walk(20);};
void() dog_run4	=[	$run4,	dog_run5 	] {ai_walk(20);};
void() dog_run5	=[	$run5,	dog_run6 	] {ai_walk(20);};
void() dog_run6	=[	$run6,	dog_run7 	] {ai_walk(20);};
void() dog_run7	=[	$run7,	dog_run8 	] {ai_walk(20);};
void() dog_run8	=[	$run8,	dog_run9 	] {ai_walk(20);};
void() dog_run9	=[	$run9,	dog_run10 	] {ai_walk(20);};
void() dog_run10	=[	$run10,	dog_run11	] {ai_walk(20);};
void() dog_run11	=[	$run11,	dog_run12 	] {ai_walk(20);};
void() dog_run12	=[	$run12,	dog_run1 	] {ai_walk(20);};

void() dog_atta1	=[	$attack1,	dog_atta2	] {};
void() dog_atta2	=[	$attack2,	dog_atta3	] {};
void() dog_atta3	=[	$attack3,	dog_atta4	] {};
void() dog_atta4	=[	$attack4,	dog_atta5	] {sound (self, CHAN_VOICE, "dog/bite.wav", 1, ATTN_NORM);};
void() dog_atta5	=[	$attack5,	dog_atta6	] {};
void() dog_atta6	=[	$attack6,	dog_atta7	] {FireMelee(5,45,0,25,0,0,0,FALSE,0,0);};
void() dog_atta7	=[	$attack7,	dog_atta8	] {};
void() dog_atta8	=[	$attack8,	dog_walk1	] {};

void() dog_leap1	=[	$pain1,		dog_leap2	] 
{
	sound (self, CHAN_VOICE, "dog/growl.wav", 1, ATTN_NORM);
	self.nextthink = time + 0.8; // give chance to dodge
};

void() dog_leap2	=[	$leap1,		dog_leap3	] {};
void() dog_leap3	=[	$leap2,		dog_leap4	]
{	
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 300 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() dog_leap4	=[	$leap3,		dog_leap5	] {FireMelee(1,0,1,30,0,0,1,TRUE,-22,0);};
void() dog_leap5	=[	$leap4,		dog_leap6	] {FireMelee(2,0,1,30,0,0,1,TRUE,-22,0);};
void() dog_leap6	=[	$leap5,		dog_leap7	] {FireMelee(1,0,1,30,0,0,1,TRUE,-22,0);};
void() dog_leap7	=[	$leap6,		dog_leap8	] {FireMelee(2,0,1,30,0,0,1,TRUE,-22,0);};
void() dog_leap8	=[	$leap7,		dog_leap9	] {FireMelee(1,0,1,30,0,0,1,TRUE,-22,0);};
void() dog_leap9	=[	$leap8,		dog_leap10	] {FireMelee(2,0,1,30,0,0,1,TRUE,-22,0);};
void() dog_leap10	=[	$leap9,		dog_leap10	] 
{
	if (self.flags & FL_ONGROUND)
		self.think = dog_walk1;
	FireMelee(2,0,1,35,0,0,1,TRUE,0,0);
};

void() dog_pain1	=[	$pain1 ,	dog_pain2	] {monster_removeslide();};
void() dog_pain2	=[	$pain2 ,	dog_pain3	] {monster_removeslide();};
void() dog_pain3	=[	$pain3 ,	dog_pain4	] {monster_removeslide();};
void() dog_pain4	=[	$pain4 ,	dog_pain5	] {monster_removeslide();};
void() dog_pain5	=[	$pain5 ,	dog_pain6	] {monster_removeslide();};
void() dog_pain6	=[	$pain6 ,	dog_walk1	] {monster_removeslide();};

void() dog_painb1	=[	$painb1 ,	dog_painb2	] {monster_removeslide();};
void() dog_painb2	=[	$painb2 ,	dog_painb3	] {monster_removeslide();};
void() dog_painb3	=[	$painb3 ,	dog_painb4	] {monster_removeslide();};
void() dog_painb4	=[	$painb4 ,	dog_painb5	] {monster_removeslide();};
void() dog_painb5	=[	$painb5 ,	dog_painb6	] {monster_removeslide();};
void() dog_painb6	=[	$painb6 ,	dog_painb7	] {monster_removeslide();};
void() dog_painb7	=[	$painb7 ,	dog_painb8	] {monster_removeslide();};
void() dog_painb8	=[	$painb8 ,	dog_painb9	] {monster_removeslide();};
void() dog_painb9	=[	$painb9 ,	dog_painb10	] {monster_removeslide();};
void() dog_painb10	=[	$painb10 ,	dog_painb11	] {monster_removeslide();};
void() dog_painb11	=[	$painb11 ,	dog_painb12	] {monster_removeslide();};
void() dog_painb12	=[	$painb12 ,	dog_painb13	] {monster_removeslide();};
void() dog_painb13	=[	$painb13 ,	dog_painb14	] {monster_removeslide();};
void() dog_painb14	=[	$painb14 ,	dog_painb15	] {monster_removeslide();};
void() dog_painb15	=[	$painb15 ,	dog_painb16	] {monster_removeslide();};
void() dog_painb16	=[	$painb16 ,	dog_walk1	] {monster_removeslide();};

void() dog_pain =
{
	self.touch = SUB_Null;

	sound (self, CHAN_VOICE, "dog/yelp.wav", 1, ATTN_NORM);
	if (random() > 0.5)
		dog_pain1 ();
	else
		dog_painb1 ();
	monster_pain(self.enemy);
};

void() dog_die1		=[	$death1,	dog_die2	] {monster_death();};
void() dog_die2		=[	$death2,	dog_die3	] {monster_death();};
void() dog_die3		=[	$death3,	dog_die4	] {monster_death();};
void() dog_die4		=[	$death4,	dog_die5	] {monster_death();};
void() dog_die5		=[	$death5,	dog_die6	] {monster_death();};
void() dog_die6		=[	$death6,	dog_die7	] {monster_death();};
void() dog_die7		=[	$death7,	dog_die8	] {monster_death();};
void() dog_die8		=[	$death8,	dog_die9	] {monster_death();};
void() dog_die9		=[	$death9,	dog_die9	] {monster_death();};

void() dog_dieb1		=[	$deathb1,	dog_dieb2	] {monster_death();};
void() dog_dieb2		=[	$deathb2,	dog_dieb3	] {monster_death();};
void() dog_dieb3		=[	$deathb3,	dog_dieb4	] {monster_death();};
void() dog_dieb4		=[	$deathb4,	dog_dieb5	] {monster_death();};
void() dog_dieb5		=[	$deathb5,	dog_dieb6	] {monster_death();};
void() dog_dieb6		=[	$deathb6,	dog_dieb7	] {monster_death();};
void() dog_dieb7		=[	$deathb7,	dog_dieb8	] {monster_death();};
void() dog_dieb8		=[	$deathb8,	dog_dieb9	] {monster_death();};
void() dog_dieb9		=[	$deathb9,	dog_dieb9	] {monster_death();};

void() dog_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  // otherwise player can keep knocking corpse for EXP
		GiveExperience(self.experience);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 -300 0';
		self.gaveexp = TRUE;
		sound (self, CHAN_VOICE, "dog/cry.wav", 1, ATTN_NORM);
	}
	if (self.damage_type == 5) // Sliced/Gored in half
	{
		sound (self, CHAN_BODY, "misc/guts.wav", 1, ATTN_NORM);
		ThrowBodyPart("progs/dog_c1.mdl");
		ThrowBodyPart("progs/dog_c2.mdl");
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		remove(self);
		return;
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	if (random() > 0.5)
		dog_die1 ();
	else
		dog_dieb1 ();
};

void() dog_jump	=[	$leap5,	dog_jump	] 
{
	if (self.flags & FL_ONGROUND)
		dog_walk1();
};

/*QUAKED monster_dog (1 0 0) (-32 -32 -24) (32 32 32)
"awareness":
0 (default) notice player when near and visible
1 notice player if visible at all
2 notice player instantly
3 ignore player, check if camera is infront of monster
4 not aware at all, must be triggered
"target":
If monster is given a target, when the monster dies it
can cause an event such as a door opening!
*/
void() monster_dog =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/dog.mdl");
	precache_model ("progs/dog_c1.mdl");
	precache_model ("progs/dog_c2.mdl");
	precache_sound ("dog/bite.wav");
	precache_sound ("dog/yelp.wav");
	precache_sound ("dog/cry.wav");
	precache_sound ("dog/growl.wav");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/dog.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);

	if (difficulty < 2)
		self.health = 51; // regular health, add 1 so fire headsmash doesn't kill in 1 hit every time
	else
		self.health = 100; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "dog";
	self.displayname = "Hunting Hound";
	self.experience = 10;
	self.maxgold = 50;
	
	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;
	self.th_jump = dog_jump;
	//spawn_shadow();

	enemy_start();
};