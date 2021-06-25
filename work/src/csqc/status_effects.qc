// Reki: Function for drawing blindness overlay,
// example inputs: (player.origin, '320 270', width, height)
// 0  focus_point is where you want the "opening" to be
// 1  size is a vec2 of the opening elipse
// 2  width is screen width
// 3  height is screen height
// 4  alpha is alpha... yep
void(vector focus_point, vector size, float width, float height, float alpha) DrawBlindness =
{
    local vector cam_pos = getproperty(VF_ORIGIN);
    
    local float hudsizescalar = min(width/800,height/600);
    
    local vector blind_origin = project(focus_point);
    local vector blind_size = size*hudsizescalar;
    blind_size *= min(3,200/vlen(cam_pos-focus_point));
    
    blind_origin -= blind_size*0.5;
    
    drawfill('0 0', [blind_origin_x,height], '0 0 0', alpha); // left
    drawfill([blind_origin_x + blind_size_x, 0], [width - (blind_origin_x + blind_size_x),height], '0 0 0', alpha); // right
    drawfill([blind_origin_x, 0], [blind_size_x, blind_origin_y], '0 0 0', alpha); // top
    drawfill([blind_origin_x, blind_origin_y + blind_size_y], [blind_size_x, height - (blind_origin_y + blind_size_y)], '0 0 0', alpha); // bottom
    drawpic(blind_origin, "gfx/blindness", blind_size, '1 1 1', alpha);
};