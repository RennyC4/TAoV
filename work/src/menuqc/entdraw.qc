

void entdraw(entity ent, vector pos) {
	
	clearscene();
	setviewprop(VF_MIN, pos);
	setviewprop(VF_SIZE, [ent.maxs_x-ent.mins_x,ent.maxs_z-ent.mins_z]);
	
	setviewprop(VF_AFOV, 25);
	
	setviewprop(VF_ORIGIN, '-128 0 0');
	setviewprop(VF_ANGLES, '0 0 0');
	
	addentity(ent);
	renderscene();
}