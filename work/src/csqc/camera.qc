//
// camera smoothing
vector cam_smoothorg;
vector cam_smoothang;

float(float start, float end) angle_diff =
{
    // result = how much to turn to go from 'start' to 'end'
    // result ranges from -180 to +180

    local float D = anglemod(end) - anglemod(start);

    if (D >  180) D = D - 360;
    if (D < -180) D = D + 360;

    return D;
};

void() Camera_Smooth =
{
    local vector cam_trueorg = getproperty(VF_ORIGIN);
    local vector cam_trueang = getproperty(VF_ANGLES);
    
    if (time < 2 || frametime > 0.025 || vlen(cam_smoothorg - cam_trueorg) > 64)
    {
        cam_smoothorg = cam_trueorg;
        cam_smoothang = cam_trueang;
        
        return;
    }
    
    if (vlen(cam_smoothorg - cam_trueorg) > 32)
        cam_smoothorg = cam_trueorg + (normalize(cam_trueorg - cam_smoothorg)*32);
    
    
    local float smoothing_value = 40;
    
    cam_smoothorg += (cam_trueorg - cam_smoothorg) * frametime * smoothing_value;
    
    cam_smoothang_x += angle_diff(cam_smoothang_x, cam_trueang_x) * frametime * smoothing_value;
    cam_smoothang_y += angle_diff(cam_smoothang_y, cam_trueang_y) * frametime * smoothing_value;
    cam_smoothang_z += angle_diff(cam_smoothang_z, cam_trueang_z) * frametime * smoothing_value;
    
    setproperty(VF_ORIGIN, cam_smoothorg);
    setproperty(VF_ANGLES, cam_smoothang);
};