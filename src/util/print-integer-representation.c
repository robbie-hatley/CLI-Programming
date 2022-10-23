#include <stdio.h> 
  
int main (void)
{ 
   int             x = 0x01234567;
   unsigned char * p = NULL;
   int             i;
   int             n;

   n = sizeof(x);
   p = (unsigned char *)&x;
   for ( i = 0 ; i < n ; ++i )
   {
      printf(" %02X", p[i]);
   }
   return 0; 
} 
