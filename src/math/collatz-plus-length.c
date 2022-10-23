
// collatz-plus-length.c

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

unsigned long int Next (unsigned long int Number)
{
   if (0 == Number%2) return Number / 2;
   else               return Number * 3 + 1;
}

int main (int Beren, char * Luthien[])
{
   unsigned long int  Seed    = 0;
   unsigned long int  Number  = 0;
   unsigned long int  Length  = 0;
   unsigned long int  Limit   = 100;
   unsigned long int  Max     = 0;

   if (Beren > 1)
   {
      Limit = strtoul(Luthien[1], NULL, 10);
   }

   for ( Seed = 1 ; Seed <= Limit ; ++Seed )
   {
      Number = Seed; Length = 1; Max = Number;
      do
      {
         Number = Next(Number);
         ++Length;
         if (Number > Max) Max = Number;
      } while (1 != Number);
      printf("Seed = %10lu  Length = %10lu  Max = %10lu\n", 
              Seed,         Length,         Max);
   }
   return 0;
}