{rtex158_
{
	fte_program eg_defaultwall
    deformvertexes normal 0.1 0.1
    deformvertexes wave 64 sin 0 0.5 0.2 1
	{
		map textures/rtex158.png
		blendfunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
	}
}