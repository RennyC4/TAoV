*swater4
{
	surfaceparm water
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm trans
	tessSize 64
	deformvertexes normal 0.1 0.1
	deformvertexes wave 64 sin 0 0.5 0.2 1
	{
		map textures/water.png
		rgbGen identityLighting
		rgbGen const (0.3 0.3 0.3)
		tcMod rotate 5
        tcGen environment
		blendFunc GL_ONE GL_ONE
	}
	{
		map textures/water.png
		rgbGen identityLighting
		rgbGen const (0.3 0.3 0.3)
		tcMod rotate -5
        tcGen environment
		blendFunc GL_ONE GL_ONE
	}
    {
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
	}
}