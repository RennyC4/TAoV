//	This file implements NQ, QW, and N64-style huds in csqc. Its meant to be complete, while not otherwise being that different.
//	The hud layout+items used are specific to vanilla Quake. For the mission packs, you should use the appropriate alternative huds.
//	
//	The entry points are at the bottom of the file.
//	You can just add this file (and fteextensions.qc or qsextensions.qc) into any mod and then just adapt it as desired.
//
//	Note that it doesn't understand viewsizes all that well, but no worse than eg scr_sbaralpha<1 in QS (its default). (this keeps the api spec simpler.)
//	the 'simple csqc' api means that this file (and api defs) is all you need for a hud, and can be directly embedded into a regular nq progs.dat, if needed.
//
//	I have made attempts to avoid copying the engine code, however I will not be held liable if there's any GPL contagion.
//	There is otherwise no license for the code in this file.

//wad image names in array form, for easier access.
static string number[10] =
{
	"gfx/num_0",
	"gfx/num_1",
	"gfx/num_2",
	"gfx/num_3",
	"gfx/num_4",
	"gfx/num_5",
	"gfx/num_6",
	"gfx/num_7",
	"gfx/num_8",
	"gfx/num_9"
};

static string anumber[10] =
{
	"gfx/anum_0",
	"gfx/anum_1",
	"gfx/anum_2",
	"gfx/anum_3",
	"gfx/anum_4",
	"gfx/anum_5",
	"gfx/anum_6",
	"gfx/anum_7",
	"gfx/anum_8",
	"gfx/anum_9"
};

// view.qc
void(vector pos, float value, float threshhold) Hud_DrawLargeValue =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 24 * (3-len);
	
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawpic(pos + '1 1' + len * '24 0 0', number[c-'0'], '24 24 0', '0 0 0', 1, 0); // shadow
		drawpic(pos + len * '24 0 0', number[c-'0'], '24 24 0', '1 1 1', 1, 0);
	}
};

// view.qc
void(vector pos, float value, float threshhold) Hud_DrawLargeValue_Red =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 24 * (3-len);
	
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawpic(pos + '1 1' + len * '24 0 0', anumber[c-'0'], '24 24 0', '0 0 0', 1, 0); // shadow
		drawpic(pos + len * '24 0 0', anumber[c-'0'], '24 24 0', '1 1 1', 1, 0);
	}
};

//Hud entry point!
//showscores is set if +scores is held (check health yourself).
void(vector virtsize, float showscores) CSQC_DrawHud =
{
};

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
	precache_model ("progs/null.spr");
};