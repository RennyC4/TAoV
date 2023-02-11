godray-moon
{
	sort 9
    {
		map $lightmap
		blendFunc GL_DST_COLOR GL_DST_COLOR
	}
	{
		map $linear:textures/godray-moon.png
		alphaGen const 0.125
		tcMod scroll -0.05 0
		blendfunc blend
	}
	{
		map $linear:textures/godray-moon.png
		alphaGen const 0.125
		tcMod scroll 0.05 0
		blendfunc blend
	}
}