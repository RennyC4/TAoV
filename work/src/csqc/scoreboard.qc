const float GAME_TEAMPLAY = 129;
typedef struct
{
	float is_team;
	string bottomcolor;
	float frags;
	string teamname;
} teamscores_t;
teamscores_t cl_teamscores[14];
teamscores_t cl_teamscores_ranked[4];

float(string pants1, string pants2) ComparePants =
{
	local vector v1, v2;

	v1 = stov(pants1);
	v2 = stov(pants2);

	local float dist, is_match;
	dist = vlen(v1 - v2);

	is_match = 0;

	if (dist < .03)
		is_match = 1;

	return is_match;
};

// happy little color names
static string teamname[14] =
{
	"Titanium White",
	"Van Dyke Brown",
	"Mountain Mixture",
	"Sap Green",
	"Alizarin Crimson",
	"Yellow Ochre",
	"Cadmium Orange",
	"Flower Pink",
	"Magenta Mauve",
	"Dusty Rose",
	"Dark Sienna",
	"Phthalo Green",
	"Indian Yellow",
	"Prussian Blue",
};

static string teamcolor[14] =
{
	"0.48 0.48 0.48",	// 0 Newspaper
	"0.33 0.23 0.11",  	// 1 Brown
	"0.31 0.31 0.45",	// 2 Light Blue
	"0.22 0.22 0.03",	// 3 Green
	"0.27 0.00 0.00",	// 4 Red
	"0.37 0.28 0.04",	// 5 Mustard
	"0.56 0.26 0.20",	// 6 Clay
	"0.50 0.33 0.23",	// 7 Flesh
	"0.34 0.21 0.26",	// 8 Lavendar
	"0.37 0.20 0.23",	// 9 Grape
	"0.42 0.34 0.28",	// 10 Biege
	"0.18 0.26 0.22",	// 11 Aqua
	"0.49 0.39 0.03",	// 12 Lemon
	"0.18 0.18 0.49"	// 13 Blue
};

void() Hud_UpdateScores =
{
	// reset all team scores to zero
	for (float t = 0 ; t < 14 ; t++)
	{
		cl_teamscores[t].is_team = 0;
		cl_teamscores[t].bottomcolor = "";
		cl_teamscores[t].frags = 0;
		cl_teamscores[t].teamname = "";
	}

	// for each player (negative numbers are players sorted by frags)
	float i = -1;
	while (1)
	{
		string name = getplayerkeyvalue(i, "name");

		if not (name)
			break; // end the loop, no more players

		float frags = stof(getplayerkeyvalue(i, "frags"));
		string bottomcolor = getplayerkeyvalue(i, "bottomcolor_rgb");

		// loop thru cl_teamscores looking for bottom color match
		float teamnum = 0;
		float nextnum = 0;
		for (float t = 0 ; t < 14 ; t++)
		{
			if (cl_teamscores[t].bottomcolor == bottomcolor)
				teamnum = t;

			if (cl_teamscores[t].bottomcolor == "")
				nextnum = t;
		}

		// if no teamnum was found
		if (!teamnum)
			teamnum = nextnum;

		cl_teamscores[teamnum].is_team = 1;
		cl_teamscores[teamnum].bottomcolor = bottomcolor;
		cl_teamscores[teamnum].frags += frags;

		// next player
		i--;
	}

	// reset all ranked team scores to zero
	for (float t = 0 ; t < 4 ; t++)
	{
		cl_teamscores_ranked[t].is_team = 0;
		cl_teamscores_ranked[t].bottomcolor = "";
		cl_teamscores_ranked[t].frags = 0;
		cl_teamscores_ranked[t].teamname = "";
	}
	for (float t = 0 ; t < 14 ; t++)
	{
		// order ranks
		if (cl_teamscores[t].is_team > 0)
		{
			// determine teamname
			for (float u = 0 ; u < 14 ; u++)
			{
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[0])) cl_teamscores[t].teamname = teamname[0];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[1])) cl_teamscores[t].teamname = teamname[1];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[2])) cl_teamscores[t].teamname = teamname[2];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[3])) cl_teamscores[t].teamname = teamname[3];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[4])) cl_teamscores[t].teamname = teamname[4];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[5])) cl_teamscores[t].teamname = teamname[5];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[6])) cl_teamscores[t].teamname = teamname[6];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[7])) cl_teamscores[t].teamname = teamname[7];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[8])) cl_teamscores[t].teamname = teamname[8];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[9])) cl_teamscores[t].teamname = teamname[9];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[10])) cl_teamscores[t].teamname = teamname[10];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[11])) cl_teamscores[t].teamname = teamname[11];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[12])) cl_teamscores[t].teamname = teamname[12];
				if (ComparePants(cl_teamscores[t].bottomcolor, teamcolor[13])) cl_teamscores[t].teamname = teamname[13];
			}

			if (cl_teamscores[t].frags >= cl_teamscores_ranked[0].frags)
			{
				cl_teamscores_ranked[3] = cl_teamscores_ranked[2];
				cl_teamscores_ranked[2] = cl_teamscores_ranked[1];
				cl_teamscores_ranked[1] = cl_teamscores_ranked[0];
				cl_teamscores_ranked[0] = cl_teamscores[t];
			}
			else if (cl_teamscores[t].frags >= cl_teamscores_ranked[1].frags)
			{
				cl_teamscores_ranked[3] = cl_teamscores_ranked[2];
				cl_teamscores_ranked[2] = cl_teamscores_ranked[1];
				cl_teamscores_ranked[1] = cl_teamscores[t];
			}
			else if (cl_teamscores[t].frags >= cl_teamscores_ranked[2].frags)
			{
				cl_teamscores_ranked[3] = cl_teamscores_ranked[2];
				cl_teamscores_ranked[2] = cl_teamscores[t];
			}
			else if (cl_teamscores[t].frags >= cl_teamscores_ranked[3].frags)
			{
				cl_teamscores_ranked[3] = cl_teamscores[t];
			}
		}
	}
};

void(vector virtmin, vector virtsize) Hud_Scoreboard =
{
	vector pos = virtmin;

	if not (getplayerkeyvalue(-16, "name"))
		pos_y += (virtsize_y-200)/2;

	if (autocvar(cg_woot, 0)) // mostly just to demonstrate that you're actually using the csqc version...
		pos_x = (virtsize_x-320)/2 * (1+sin(time));
	else
		pos_x += (virtsize_x-320)/2;

	pos_x += 80;

	float test = autocvar(cl_hudtest, 0);

	// for counting players
	local float players = 0;

	// for printing team scores
	local float is_teamplay = getstatf(GAME_TEAMPLAY);
	if (autocvar(cl_teams, 0) || is_teamplay)
	{
		for (float t = 0 ; t < 4 ; t++)
		{
			if (cl_teamscores_ranked[t].is_team > 0)
			{
				players++;
				local string name = cl_teamscores_ranked[t].teamname;
				drawfill(pos+[0,0]+[0,10*players], ([40,8]), stov(cl_teamscores_ranked[t].bottomcolor), .75, 0);
				drawstring(pos+[8,0]+[0,10*players], strpad(-3, ftos(cl_teamscores_ranked[t].frags)), [8,8], [1,1,1], 1, 0);
				drawstring(pos+[64,0]+[0,10*players], strconv(0,2,2, name), [8,8], [1,1,1], 1, 0);
			}
		}
		players++;
	}

	players++;
	players++;
	drawstring(pos+[5,10*players], strconv(0,2,2, "Kills"), [6,6], [1,1,1], 1, 0);
	drawstring(pos+[64,0]+[0,10*players], strconv(0,2,2, "Name"), [6,6], [1,1,1], 1, 0);
	//drawstring(pos+[158,0]+[0,10*players], strconv(0,2,2, "Deaths"), [6,6], [1,1,1], 1, 0);
	players++;

	// negative numbers are players sorted by frags
	for (float i=-1; ; i--)
	{
		string name = getplayerkeyvalue(i, "name");
		if not (name)
			break;

		players++;

		float isspec = stof(getplayerkeyvalue(i, "*spectator"));
		float frags = stof(getplayerkeyvalue(i, "frags"));
		string ping = getplayerkeyvalue(i, "ping");
		vector top = stov(getplayerkeyvalue(i, "topcolor_rgb"));
		vector bot = stov(getplayerkeyvalue(i, "bottomcolor_rgb"));

		if (player_localentnum == stof(getplayerkeyvalue(i, "viewentity")))
		{
			drawfill([(virtsize_x/2)-140,pos_y-2]+[0,10*players], [280,12], [0,0,0], 0.5, 0);
			drawfill([(virtsize_x/2)-140,pos_y-2]+[0,10*players], [280,12], bot, 0.25, 0);
		}
		if (ping != "0" || test)
			drawstring(pos-[8*5,0]+[6,2]+[0,10*players], strpad(-4, strconv(0,2,2, ping)), [6,6], [1,1,1], 1, 0);
		drawfill(pos+[0,0]+[0,10*players], [40,4], top, 0.75, 0);
		drawfill(pos+[0,4]+[0,10*players], [40,4], bot, 0.75, 0);
		drawstring(pos+[8,0]+[0,10*players], strpad(-3, ftos(frags)), [8,8], [1,1,1], 1, 0);
		drawstring(pos+[64,0]+[0,10*players], name, [8,8], [1,1,1], 1, 0);
	}
};