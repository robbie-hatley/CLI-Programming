// fibonacci-ratios.c
#include <stdio.h>
int main (void)
{
	int     a       = 1;
	int     b       = 1;
	int     c       = 0;
	int     idx     = 0;
	double  ratio   = 0.0;
	for ( idx = 1 ; idx <= 20 ; ++idx )
	{
		ratio = (double)b/(double)a;
		printf("%30f\n", ratio);
		c=a+b;
		a=b;
		b=c;
	}
	return 0;
}