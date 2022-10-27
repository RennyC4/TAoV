*swater4
{
	surfaceparm water
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm trans
	deformvertexes wave 64 sin 0 0.5 0.2 1
	{
		map textures/water.png
		rgbGen identityLighting
		rgbGen const (0.1 0.1 0.1)
		tcMod rotate 5
        tcGen environment
		blendFunc GL_ONE GL_ONE
	}
	{
		map textures/water.png
		rgbGen identityLighting
		rgbGen const (0.1 0.1 0.1)
		tcMod rotate -5
        tcGen environment
		blendFunc GL_ONE GL_ONE
	}
}