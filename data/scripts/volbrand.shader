progs/plyr2.mdl_0
{
    {
		map progs/plyr2.mdl_0
		rgbGen lightingDiffuse // proper shading for vertex lit models, or something. 
    }		
	{
		map progs/plyr2.mdl_0_gloss
		blendFunc GL_SRC_ALPHA GL_ONE
		alphaGen const 0.15
		tcGen environment
		rgbGen lightingDiffuse
	}
}