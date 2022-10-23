// endian.c
#include <stdio.h> 
int main (void)  
{ 
   int      x = 1;
   size_t   s = sizeof(x);
   char   * p = (char *)&x;

   if (1 == (int)p[0])
   {
      printf("Little-Endian\n");
   }
   else if (1 == (int)p[s-1])
   {
      printf("Big-Endian\n");
   }
   else
   {
      printf("Middle-Endian\n");
   }
   return 0;
}