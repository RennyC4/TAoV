


// Returns position of the only set bit in 'n' 
float powerofTwo(float n) 
{ 
    return n && (!(n & (n - 1))); 
} 

float findPosition(float n) 
{
    if !(powerofTwo(n))
	{
		return 0;
	}
	
	float i = 1;
	float pos = 0;
	
	
    while (!(i & n)) { 
        // shift over to next bit, inserting a 0 in its place
        i = i << 1; 
  
        // increment return value by 1
        pos++; 
    } 
  
    return pos; 
} 