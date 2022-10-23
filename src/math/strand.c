// strand.c
#include <stdio.h>
#include <stdlib.h>

unsigned long int Sum (unsigned long int a, unsigned long int b)
{
   return (b-a+1)*(a+b)/2;
}

int main (int Beren, char **Luthien)
{
   unsigned long int  StLen  =  0;
   unsigned long int  HsNum  =  0;
   unsigned long int  LnMin  =  0;
   unsigned long int  LnMax  =  0;

   if (Beren != 3) exit(666);
   LnMin = strtoul(Luthien[1], NULL, 10);
   LnMax = strtoul(Luthien[2], NULL, 10);
   for ( StLen = LnMin ; StLen <= LnMax ; ++StLen )
   {
      for ( HsNum = 1 ; HsNum <= StLen ; ++HsNum )
      {
         if (Sum(1, HsNum-1) == Sum(HsNum+1, StLen))
         {
            printf("Solution: StLen = %lu, HsNum = %lu\n", StLen, HsNum);
         }
      }
   }
   return 0;
}