progs/iced.mdl_0
{
	map $linear:progs/iced.png
    {
		map $linear:progs/iced.png
		rgbGen lightingDiffuse // proper shading for vertex lit models, or something. 
    }		
	{
		map $linear:progs/iced.png
		blendFunc GL_SRC_ALPHA GL_ONE
		alphaGen const 0.25
		tcGen environment
		rgbgen entity
	}
}

progs/icef.mdl_0
{
    {
		map $linear:progs/icef.png
		rgbGen lightingDiffuse // proper shading for vertex lit models, or something. 
    }		
	{
		map $linear:progs/icef.png
		blendFunc GL_SRC_ALPHA GL_ONE
		alphaGen const 0.25
		tcGen environment
		rgbgen entity
	}
}