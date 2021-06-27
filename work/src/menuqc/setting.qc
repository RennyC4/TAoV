
void Settings_slider_up(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1 && mInputMode == M_INPUT_MOUSE) {
		selected_element = blank_element;
	}
}

void Settings_slider_down(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		if (selected_element == over_element)
			selected_element = blank_element;
		else
			selected_element = over_element;
	} else {
		element.kvalue = key;
	}
}

void Settings_v_apply(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		selected_element = blank_element;
		
		local menuElement *vres = elementByName(MENU_Sett_Video,"v_resolution");
		local vector res = vres.vvalue;
		
		localcmd(sprintf("vid_width %d\n",res_x));
		localcmd(sprintf("vid_height %d\n",res_y));
		
		localcmd("vid_restart\n");
	}
}

float v_res_max;
float v_res_current;

void Settings_v_res_init()
{
	v_res_max = 1;
	
	local vector cres = [cvar("vid_width"),cvar("vid_height"),1];
	
	local float isfs = cvar("vid_fullscreen");
	
	local vector res = getresolution(0, isfs);
	
	local float n = 0;
	while (res_z) {
		res = getresolution(n, isfs);
		if !(res_z)
			return;
		
		if (cres == res) {
			v_res_current = n;
		}
		v_res_max = n;
		
		n++;
	}
}

void Settings_v_render_update()
{
	local menuElement *element = elementByName(MENU_Sett_Video,"v_renderscale");
	local menuElement *videl = elementByName(MENU_Sett_Video,"v_resolution");
	local vector res = videl.vvalue;
	
	if (videl.fvalue2)
		element.text = strcat("Scale: ", ftos(floor(element.fvalue*20)*(100/20)),"% ");
	else
		element.text = strcat("Scale: ", ftos(floor(element.fvalue*20)*(100/20)),"% ",sprintf("(%dx%d)", res_x*element.fvalue, res_y*element.fvalue));
}

void Settings_v_res_drag(menuElement *element)
{
	local vector just = element.justify;
	local vector pos = element.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = element.size;
	
	local float isfs = cvar("vid_fullscreen");
	local float inc = 1/v_res_max;
	
	
	if (mInputMode == M_INPUT_MOUSE)
	{
		element.fvalue = max(0,(mousepos_x - pos_x) / size_x);
	}
	
	if (element.fvalue > 1)
	{
		element.fvalue = 1;
		element.text = "Use Desktop Resolution";
		local vector res = getresolution(element.fvalue, isfs);
		element.vvalue = res;
		element.fvalue2 = 1;
		Settings_v_render_update();
		
		return;
	}
	else
	{
		element.fvalue = floor((element.fvalue/inc));
		element.fvalue2 = 0;
	}
	
	
	//local float spd = (element.fvalue*1500) + 500;
	
	local vector dres = getresolution(element.fvalue, isfs);
	
	//localcmd(sprintf("vid_width %d\n", res_x));
	//localcmd(sprintf("vid_height %d\n", res_y));
	element.vvalue = dres;
	element.text = sprintf("%dx%d", dres_x, dres_y);
	
	element.fvalue = (element.fvalue/v_res_max);
	Settings_v_render_update();
}

void Settings_v_render_drag(menuElement *element)
{
	local vector just = element.justify;
	local vector pos = element.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = element.size;
	
	local float isfs = cvar("vid_fullscreen");
	
	if (mInputMode == M_INPUT_MOUSE)
		element.fvalue = bound(0,(mousepos_x - pos_x) / size_x,4);
	
	local float inc = 20;
	element.fvalue = floor(element.fvalue*inc)/inc;
	
	
	//local float spd = (element.fvalue*1500) + 500;
	
	local menuElement *videl = elementByName(MENU_Sett_Video,"v_resolution");
	local vector newres = videl.vvalue;
	local float res = element.fvalue*inc;
	
	localcmd(sprintf("r_renderscale %g\n", res/inc));
	if (videl.fvalue2)
		element.text = strcat("Scale: ", ftos(floor(element.fvalue*20)*(100/20)),"% ");
	else
		element.text = strcat("Scale: ", ftos(floor(element.fvalue*20)*(100/20)),"% ",sprintf("(%dx%d)", newres_x*element.fvalue, newres_y*element.fvalue));
	
	localcmd("r_graphics 1\n");
	
	if (element.fvalue == 0) {
		localcmd("r_renderscale 0.5\nr_graphics 0\n");
	}
}

void Settings_v_maxfps_drag(menuElement *element)
{	
	local vector just = element.justify;
	local vector pos = element.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = element.size;
	
	if (mInputMode == M_INPUT_MOUSE)
		element.fvalue = bound(0,(mousepos_x - pos_x) / size_x,1);
	
	local float fpsmax = (element.fvalue*191) + 60;
	
	if (fpsmax == 251) {
		localcmd("cl_maxfps 0\n");
		element.text = "Max FPS: Unlimited";
	} else {
		localcmd(sprintf("cl_maxfps %d\n", fpsmax));
		element.text = sprintf("Max FPS: %d", fpsmax);
	}
}

void Settings_v_msaa_drag(menuElement *element)
{	
	local vector just = element.justify;
	local vector pos = element.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = element.size;

	if (mInputMode == M_INPUT_MOUSE)
		element.fvalue = bound(0,(mousepos_x - pos_x) / size_x,1);
	
	local float inc = 3;
	element.fvalue = ceil(element.fvalue*inc)/inc;
	
	
	local float aaset = floor((element.fvalue*6) + 2);
	
	localcmd(sprintf("vid_multisample %d\n", aaset));
	element.text = sprintf("MSAA Sample: %dx", aaset);
}

void Settings_v_anisotropy_update(menuElement *element)
{
	if (cvar("gl_texture_anisotropic_filtering") != 0) {
		element.text = sprintf("Anisotropic Filtering: %dx", cvar("gl_texture_anisotropic_filtering"));
	} else {
		localcmd("gl_texture_anisotropic_filtering 0\n");
		element.text = "Trilinear Filtering";
	}
}

void Settings_v_anisotropy_drag(menuElement *element)
{	
	local vector just = element.justify;
	local vector pos = element.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = element.size;
	
	if (mInputMode == M_INPUT_MOUSE)
		element.fvalue = bound(0,(mousepos_x - pos_x) / size_x,1);
	
	local float inc = 4;
	element.fvalue = ceil(element.fvalue*inc)/inc;
	
	
	local float aaset = 1 << (element.fvalue*4);
	
	if (aaset != 1) {
		localcmd(sprintf("gl_texture_anisotropic_filtering %d\n", aaset));
		element.text = sprintf("Anisotropic Filtering: %dx", aaset);
	} else {
		localcmd("gl_texture_anisotropic_filtering 0\n");
		element.text = "Trilinear Filtering";
	}
}

void Settings_v_gamma_drag(menuElement *element)
{	
	local vector just = element.justify;
	local vector pos = element.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = element.size;
	
	if (mInputMode == M_INPUT_MOUSE)
		element.fvalue = bound(0,((mousepos_x - pos_x) / size_x),1);
	
	local float gammalevel = ((element.fvalue*0.5) + 0.75);
	
	localcmd(sprintf("gamma %f\n", gammalevel));
	element.text = sprintf("Gamma: %d%s", gammalevel*100, "%");
}

void Settings_v_draw()
{
	if (selected_element.name == "v_resolution") {
		Settings_v_res_drag(selected_element);
	} else if (selected_element.name == "v_renderscale") {
		Settings_v_render_drag(selected_element);
	} else if (selected_element.name == "v_maxfps") {
		Settings_v_maxfps_drag(selected_element);
	} else if (selected_element.name == "v_msaa_slider") {
		Settings_v_msaa_drag(selected_element);
	} else if (selected_element.name == "v_anisotropic") {
		Settings_v_anisotropy_drag(selected_element);
	} else if (selected_element.name == "v_gamma") {
		Settings_v_gamma_drag(selected_element);
	}
}

void dynamiclight_toggle(float key, float ascii, menuElement *element) {
	if (key == K_MOUSE1) {
		if (element.textfield) {
			element.fvalue = !element.fvalue;
			local menuElement *light_d = elementByName(MENU_Sett_Video,"v_light_dshadow");
			light_d.hide = !element.fvalue;
			
			localcmd(sprintf("%s %g\n",element.textfield,element.fvalue));
		}
	}
}

void bloom_toggle(float key, float ascii, menuElement *element) {
	if (key == K_MOUSE1) {
		if (element.textfield) {
			element.fvalue = !element.fvalue;
			
			if (element.fvalue)
				localcmd(sprintf("%s %g\n",element.textfield,0.15));
			else
				localcmd(sprintf("%s %g\n",element.textfield,0));
		}
	}
}

void crunchy_toggle(float key, float ascii, menuElement *element) {
	if (key == K_MOUSE1) {
		if (element.textfield) {
			element.fvalue = !element.fvalue;
			
			if (element.fvalue)
				localcmd(sprintf("%s %s\n", element.textfield, "nll"));
			else
				localcmd(sprintf("%s %s\n", element.textfield, "lll"));
		}
	}
}

void msaa_toggle(float key, float ascii, menuElement *element) {
	if (key == K_MOUSE1) {
		if (element.textfield) {
			element.fvalue = !element.fvalue;
			local menuElement *light_b = elementByName(MENU_Sett_Video,"v_light_bloom");
			light_b.hide = element.fvalue;
			
			local menuElement *msaa_slide = elementByName(MENU_Sett_Video,"v_msaa_slider");
			msaa_slide.hide = !element.fvalue;
			
			if (element.fvalue) {
				msaa_slide.fvalue = 0;//(element.fvalue - 2)*0.333;
				msaa_slide.text = "MSAA Sample: 2x";
				
				light_b.fvalue = 0;
				localcmd("r_bloom 0\n");
			}
			localcmd(sprintf("%s %g\n","vid_multisample",element.fvalue*2));
		}
	}
}

void Settings_back(float key, float ascii, menuElement *element)
{
	if (key != K_MOUSE1)
		return;

	over_element = blank_element;
	current_menu = MENU_Main;
}

string autocvar_gl_texturemode;

void Settings_Create()
{	
	MENU_Sett_Video = createMenu();
	local float yoff = -108;
	
	MENU_Sett_Video.draw = Settings_v_draw;
	
	local menuElement *apply = addButton(MENU_Sett_Video,'-224 -56', "apply");
	
	// apply button //
	local vector scl = apply.size;
	apply.justify = '1 1';
	apply.text = "Apply Changes"; apply.textjustify = '0.5 0.5';
	apply.keydown = Settings_v_apply;
	
	// back button //
	local menuElement *back = addButton(MENU_Sett_Video,'64 -56', "back");
	back.justify = '0 1';
	back.text = "Back"; back.textjustify = '0.5 0.5';
	back.keydown = Settings_back;
	apply.west = back;
	back.east = apply;
	
	// resolution
	local menuElement *fres = addSlider(MENU_Sett_Video,[-96, yoff], "v_resolution"); fres.size = '192 16'; fres.textpos = '198 9'; fres.textsize = '12 12';
	fres.justify = '0.5 0.5'; fres.color = '0.2 0.2 0.2'; fres.coloralt = '1 1 1';
	Settings_v_res_init();
	fres.vvalue = [cvar("vid_width"), cvar("vid_height")];
	if (vlen(fres.vvalue) > 0)
	{
		fres.text = sprintf("%dx%d",cvar("vid_width"),cvar("vid_height")); fres.fvalue = v_res_current/v_res_max; fres.fvalue2 = 0;
	}
	else
	{
		fres.text = "Use Desktop Resolution"; fres.fvalue = 1; fres.fvalue2 = 1;
	}

	fres.keydown = Settings_slider_down; fres.selectedkeyup = Settings_slider_up;
	yoff += 24;
	
	// render scale
	local menuElement *frender = addSlider(MENU_Sett_Video,[-96, yoff], "v_renderscale"); frender.size = '192 16'; frender.textpos = '198 9'; frender.textsize = '12 12';
	frender.justify = '0.5 0.5'; frender.color = '0.2 0.2 0.2'; frender.coloralt = '1 1 1';
	frender.fvalue = cvar("r_renderscale"); Settings_v_render_update();
	frender.keydown = Settings_slider_down; frender.selectedkeyup = Settings_slider_up;
	
	frender.north = fres;
	fres.south = frender;
	yoff += 24;
	
	
	// fullscreen
	local menuElement *fscreen = addCheckbox(MENU_Sett_Video,[-96, yoff], "v_fullscreen"); fscreen.text = "Fullscreen"; fscreen.textfield = "vid_fullscreen";
	fscreen.fvalue = cvar("vid_fullscreen"); fscreen.justify = '0.5 0.5';
	
	frender.south = fscreen;
	fscreen.north = frender;
	
	// dynamic lights
	local menuElement *light_d = addCheckbox(MENU_Sett_Video,[0, yoff], "v_light_dynamic"); light_d.text = "Dynamic Lights"; light_d.textfield = "r_shadow_realtime_dlight";
	light_d.fvalue = cvar("r_shadow_realtime_dlight"); light_d.justify = '0.5 0.5'; light_d.keydown = dynamiclight_toggle;
	yoff += 24;
	fscreen.east = light_d;
	light_d.west = fscreen;
	light_d.north = frender;
	
	// dynamic shadow
	local menuElement *light_ds = addCheckbox(MENU_Sett_Video,[0, yoff], "v_light_dshadow"); light_ds.text = "Dynamic Shadows"; light_ds.textfield = "r_shadow_realtime_dlight_shadows";
	light_ds.fvalue = cvar("r_shadow_realtime_dlight_shadows"); light_ds.justify = '0.5 0.5';
	if !(cvar("r_shadow_realtime_dlight"))
		light_ds.hide = TRUE;
	
	light_d.south = light_ds;
	light_ds.north = light_d;
	
	// bloom
	local menuElement *light_b = addCheckbox(MENU_Sett_Video,[-96, yoff], "v_light_bloom"); light_b.text = "Bloom"; light_b.textfield = "r_bloom";
	light_b.fvalue = (cvar("r_bloom") != 0); light_b.justify = '0.5 0.5'; light_b.keydown = bloom_toggle;
	yoff += 24;
	fscreen.south = light_b;
	light_b.north = fscreen;
	
	// fxaa
	local menuElement *fxaa = addCheckbox(MENU_Sett_Video,[-96, yoff], "v_fxaa"); fxaa.text = "FXAA"; fxaa.textfield = "r_fxaa";
	fxaa.fvalue = cvar("r_fxaa"); fxaa.justify = '0.5 0.5';
	light_b.south = fxaa;
	fxaa.north = light_b;
	
	// msaa
	local menuElement *msaa = addCheckbox(MENU_Sett_Video,[0, yoff], "v_msaa"); msaa.text = "MSAA"; msaa.textfield = "vid_multisample";
	msaa.fvalue = (cvar("vid_multisample") != 0); msaa.justify = '0.5 0.5'; msaa.keydown = msaa_toggle;
	yoff += 24;
	light_ds.south = msaa;
	msaa.north = light_ds;
	msaa.west = fxaa;
	fxaa.east = msaa;
	
	local menuElement *msaa_slide = addSlider(MENU_Sett_Video,[-96, yoff], "v_msaa_slider"); msaa_slide.size = '192 16'; msaa_slide.textpos = '198 9'; msaa_slide.textsize = '12 12';
	msaa_slide.justify = '0.5 0.5'; msaa_slide.color = '0.2 0.2 0.2'; msaa_slide.coloralt = '1 1 1';
	msaa_slide.text = sprintf("MSAA Sample: %dx",cvar("vid_multisample")); msaa_slide.fvalue = ((cvar("vid_multisample") - 2)*0.167);
	msaa_slide.keydown = Settings_slider_down; msaa_slide.selectedkeyup = Settings_slider_up;
	yoff += 24;
	msaa.south = msaa_slide;
	fxaa.south = msaa_slide;
	msaa_slide.north = msaa;
	
	if (msaa.fvalue) { light_b.hide = 1; } else { msaa_slide.hide = 1; }
	
	// anisotropic
	local menuElement *anisotropic = addSlider(MENU_Sett_Video,[-96, yoff], "v_anisotropic"); anisotropic.size = '192 16'; anisotropic.textpos = '198 9'; anisotropic.textsize = '12 12';
	anisotropic.justify = '0.5 0.5'; anisotropic.color = '0.2 0.2 0.2'; anisotropic.coloralt = '1 1 1';
	anisotropic.fvalue = floor((findPosition(cvar("gl_texture_anisotropic_filtering"))))/4; Settings_v_anisotropy_update(anisotropic);
	anisotropic.keydown = Settings_slider_down; anisotropic.selectedkeyup = Settings_slider_up;
	yoff += 24;
	msaa_slide.south = anisotropic;
	anisotropic.north = msaa_slide;
	
	// max fps
	local menuElement *maxfps = addSlider(MENU_Sett_Video,[-96, yoff], "v_maxfps"); maxfps.size = '192 16'; maxfps.textpos = '198 9'; maxfps.textsize = '12 12';
	maxfps.justify = '0.5 0.5'; maxfps.color = '0.2 0.2 0.2'; maxfps.coloralt = '1 1 1';
	if (cvar("cl_maxfps") == 0)
	{
		maxfps.text = "Max FPS: Unlimited"; maxfps.fvalue = 1;
	}
	else
	{
		maxfps.text = sprintf("Max FPS: %d",cvar("cl_maxfps")); maxfps.fvalue = (cvar("cl_maxfps")-60)/191;
	}
	maxfps.keydown = Settings_slider_down; maxfps.selectedkeyup = Settings_slider_up;
	yoff += 24;
	
	anisotropic.south = maxfps;
	maxfps.north = anisotropic;
	
	// gamma
	local menuElement *gamma = addSlider(MENU_Sett_Video,[-96, yoff], "v_gamma"); gamma.size = '192 16'; gamma.textpos = '198 9'; gamma.textsize = '12 12';
	gamma.justify = '0.5 0.5'; gamma.color = '0.2 0.2 0.2'; gamma.coloralt = '1 1 1';
	gamma.text = sprintf("Gamma: %d%s",cvar("gamma")*100,"%"); gamma.fvalue = ((cvar("gamma")) - 0.75)*2;
	gamma.keydown = Settings_slider_down; gamma.selectedkeyup = Settings_slider_up;
	yoff += 24;
	
	maxfps.south = gamma;
	gamma.north = maxfps;
	
	// crunchy
	local menuElement *crunchy = addCheckbox(MENU_Sett_Video,[-96, yoff], "v_crunchy"); crunchy.text = "Nearest Filter"; crunchy.textfield = "gl_texturemode";
	crunchy.justify = '0.5 0.5'; crunchy.keydown = crunchy_toggle;
	if (autocvar_gl_texturemode == "nll")
		crunchy.fvalue = 1;
	else
		crunchy.fvalue = 0;
	
	crunchy.south = apply;
	crunchy.north = gamma;
	gamma.south = crunchy;
	
	
	MENU_Sett_Video.default_element = fres;
	apply.north = crunchy;
	back.north = crunchy;
}
