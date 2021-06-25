

// 
// Menu Element types
float ME_TYPE_NULL			= 0;
float ME_TYPE_BUTTON		= 1;
float ME_TYPE_LIST			= 2;
float ME_TYPE_TEXTBOX		= 3;
float ME_TYPE_SLIDER		= 4;
float ME_TYPE_CHECKBOX 		= 5;
float ME_TYPE_TEXT 			= 6;



const float FONT_DEFAULT	= 0;
float FONT_MENU;




const float KEY_UNKNOWN				= -1;
const float KEY_GAME 				= 0;
const float KEY_MENU				= 2;
const float KEY_MENU_GRABBED		= 3;


const float SLIF_CNAME      = 0;
const float SLIF_PING       = 1;
const float SLIF_GAME       = 2;
const float SLIF_MOD        = 3;
const float SLIF_MAP        = 4;
const float SLIF_NAME       = 5;
const float SLIF_MAXPLAYERS = 6;
const float SLIF_NUMPLAYERS = 7;
const float SLIF_PROTOCOL   = 8;
const float SLIF_NUMBOTS    = 9;
const float SLIF_NUMHUMANS  = 10;
const float SLIF_FREESLOTS  = 11;
const float SLIF_QCSTATUS   = 12;
const float SLIF_PLAYERS    = 13;
const float SLIF_CATEGORY   = 14;
const float SLIF_ISFAVORITE = 15;


float frametime;
float lastframe;


vector screensize;
vector mousepos;

float mousetimeout;


.float modelindex;
.string model;
.vector colormod;
.vector origin;
.vector mins;
.vector maxs;
.vector angles;
.float scale;



struct keyBinding {
	string		name;
	
	string		cmd;
	float		key1;
	float		key2;
	
	keyBinding 	*prev;
	keyBinding 	*next;
};


struct menuList_Entry {
	string			text[4];
	string			textalt[4];
	vector			color[4];
	float			number[4];
};

struct menuList {
	menuList_Entry	entries[20];
	float			selected;
};

struct menuElement {
	vector			pos;
	vector			justify;
	
	
	vector			size;
	vector			textpos;
	vector			textsize;
	vector			textjustify;
	
	vector			vvalue;
	float			fvalue;
	float			fvalue2;
	
	float			kvalue;
	
	float			type;
	float			hide;
	string			name;
	string			img;
	string			imgalt;
	
	vector			color;
	vector			coloralt;
	
	void(menuElement *element)								hover;
	void(float key, float ascii, menuElement *element)		keyup;
	void(float key, float ascii, menuElement *element)		selectedkeyup;
	
	void(float key, float ascii, menuElement *element)		keydown;
	void(float key, float ascii, menuElement *element)		selectedkeydown;
	
	
	
	string			text;
	string			textfield;
	
	keyBinding		*bind;
	
	menuList		*array;
	
	menuElement 	*north;
	menuElement 	*south;
	menuElement 	*east;
	menuElement 	*west;
	
	menuElement		*next;
};

struct menuScreen {
	void()			draw;
	void(float key, float ascii)	keydown;
	void(float key, float ascii)	keyup;
	
	vector			scroll;
	
	menuElement		*list;
	
	menuScreen 		*next;
	
	menuElement		*default_element;
};



menuScreen *MENU_Main;
menuScreen *MENU_Load;
menuScreen *MENU_LoadExit;
menuScreen *MENU_Save;
menuScreen *MENU_Sett_Video;

float menuIsOn;

float mInputMode;
const int M_INPUT_MOUSE = 0;
const int M_INPUT_KEYBOARD = 1;
const int M_INPUT_XINPUT = 2;

menuElement 	*selected_element;
menuElement 	*over_element;
menuElement		*blank_element;

menuScreen		*current_menu;
menuScreen		*blank_menu;
menuScreen		*list_menu;


float round(float x1) {
	if ((x1 % 1) > 0.5) {
		return ceil(x1);
	} else {
		return floor(x1);
	}
}


void checkbox_toggle(float key, float ascii, menuElement *element) {
	if (key == K_MOUSE1) {
		if (element.textfield) {
			element.fvalue = !element.fvalue;
			localcmd(sprintf("%s %g\n",element.textfield,element.fvalue));
		}
	}
}


void linkElement(menuElement *element, menuScreen *menu) {
	
	element.next = menu.list;
	menu.list = element;
}

menuElement *elementByName(menuScreen *menu, string name) {
	local menuElement *list = menu.list;
	
	while (list != blank_element) {
		
		if (list.name == name)
			return list;
		
		list = list.next;
	}
	
	return blank_element;
}

menuElement *addCheckbox(menuScreen *menu, vector pos, string name) {
	menuElement *new_element = memalloc(sizeof(menuElement));
	new_element.type = ME_TYPE_CHECKBOX;
	
	new_element.coloralt = '1 0.7 0.2';
	new_element.color = '1 1 1';
	new_element.img = "gfx/menu/checkbox_off";
	new_element.imgalt = "gfx/menu/checkbox_on";
	
	new_element.pos = pos;
	new_element.size = '16 16';
	new_element.textsize = '10 10';
	new_element.textpos = '20 9';
	new_element.textjustify = '0 0.5';
	
	new_element.keydown = checkbox_toggle;
	
	new_element.array = blank_element.array;
	
	new_element.north = new_element;
	new_element.east = new_element;
	new_element.south = new_element;
	new_element.west = new_element;
	
	new_element.name = name;
	
	linkElement(new_element,menu);
	
	return new_element;
}

menuElement *addButton_custom(menuScreen *menu, vector pos, string name) {
	menuElement *new_element = memalloc(sizeof(menuElement));
	new_element.type = ME_TYPE_BUTTON;
	
	new_element.color = '1 1 1';
	new_element.coloralt = '1 0.8 0.4';
	new_element.img = "gfx/menu/button_simple";
	
	new_element.pos = pos;
	new_element.size = '64 16';
	new_element.textsize = '12 12';
	new_element.textpos = '8 8';
	new_element.textjustify = '0 0.5';
	
	new_element.array = blank_element.array;
	
	new_element.north = new_element;
	new_element.east = new_element;
	new_element.south = new_element;
	new_element.west = new_element;
	
	new_element.name = name;
	
	linkElement(new_element,menu);
	
	return new_element;
}

menuElement *addButton(menuScreen *menu, vector pos, string name) {
	menuElement *new_element = memalloc(sizeof(menuElement));
	new_element.type = ME_TYPE_BUTTON;
	
	new_element.array = blank_element.array;
	
	new_element.pos = pos;
	
	new_element.size = '128 24';
	new_element.textpos = '64 14';
	new_element.textsize = '12 12';
	new_element.textjustify = '0.5 0.5';
	
	new_element.color = '1 1 1';
	new_element.img = "gfx/menu/button_fancy";
	new_element.imgalt = "gfx/menu/button_fancy_pressed";
	
	new_element.north = new_element;
	new_element.east = new_element;
	new_element.south = new_element;
	new_element.west = new_element;
	
	new_element.name = name;
	
	linkElement(new_element,menu);
	
	return new_element;
}

menuElement *addSlider(menuScreen *menu, vector pos, string name) {
	menuElement *new_element = memalloc(sizeof(menuElement));
	new_element.type = ME_TYPE_SLIDER;
	
	new_element.array = blank_element.array;
	
	new_element.pos = pos;
	
	new_element.size = '96 24';
	new_element.textpos = '16 26';
	new_element.textsize = '18 18';
	new_element.textjustify = '0 0.5';
	
	new_element.color = '1 1 1';
	
	new_element.north = new_element;
	new_element.east = new_element;
	new_element.south = new_element;
	new_element.west = new_element;
	
	new_element.name = name;
	
	linkElement(new_element,menu);
	
	return new_element;
}

menuElement *addList(menuScreen *menu, vector pos, string name) {
	menuElement *new_element = memalloc(sizeof(menuElement));
	new_element.type = ME_TYPE_LIST;
	
	new_element.array = memalloc(sizeof(menuList));
	
	new_element.pos = pos;
	new_element.textjustify = '0 0.5';
	
	new_element.north = new_element;
	new_element.east = new_element;
	new_element.south = new_element;
	new_element.west = new_element;
	
	new_element.name = name;
	
	linkElement(new_element,menu);
	
	return new_element;
}

menuElement *addTextBox(menuScreen *menu, vector pos, string name) {
	menuElement *new_element = memalloc(sizeof(menuElement));
	new_element.type = ME_TYPE_TEXTBOX;
	
	new_element.array = blank_element.array;
	
	new_element.pos = pos;
	
	new_element.color = '1 1 1';
	new_element.coloralt = '1 0.8 0.2';
	
	new_element.size = '450 48';
	new_element.textpos = '16 26';
	new_element.textsize = '18 18';
	new_element.textjustify = '0 0.5';
	
	new_element.north = new_element;
	new_element.east = new_element;
	new_element.south = new_element;
	new_element.west = new_element;
	
	new_element.name = name;
	
	linkElement(new_element,menu);
	
	return new_element;
}

menuElement *addText(menuScreen *menu, vector pos, string name) {
	menuElement *new_element = memalloc(sizeof(menuElement));
	new_element.type = ME_TYPE_TEXT;
	
	new_element.array = blank_element.array;
	
	new_element.pos = pos;
	
	new_element.color = '1 1 1';
	new_element.coloralt = new_element.color;
	
	new_element.size = '0 0';
	new_element.textpos = '16 26';
	new_element.textsize = '18 18';
	new_element.textjustify = '0 0.5';
	
	new_element.north = new_element;
	new_element.east = new_element;
	new_element.south = new_element;
	new_element.west = new_element;
	
	new_element.name = name;
	
	linkElement(new_element,menu);
	
	return new_element;
}

void removeElement(menuElement *element, menuElement *list) {
	while (list != blank_element) {
		
		if (list.next == element) {
			list.next = element.next;
			
			memfree(element);
		}
		
		list = list.next;
	}
}

menuScreen *createMenu() {
	menuScreen *new_menu = memalloc(sizeof(menuScreen));
	
	new_menu.next = list_menu;
	list_menu = new_menu;
	
	new_menu.list = blank_element;
	
	return new_menu;
}

void removeMenu(menuScreen *menu) {
	local menuScreen *list = list_menu;
	
	while (list != blank_menu) {
		
		if (list.next == menu) {
			list.next = menu.next;
			
			
			
			memfree(menu);
			return;
		}
		
		list = list.next;
	}
}

void cleanupMenu(menuScreen *menu) {
	local menuElement *list = menu.list;
	
	while (list != blank_element) {
		local menuElement *next = list.next; 
		
		if (list.array != blank_element.array) {
			memfree(list.array);
		}
		
		memfree(list);
		
		list = next;
	}
	
	removeMenu(menu);
}



float element_select(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		selected_element = over_element;
		return TRUE;
	}
	
	return FALSE;
}








