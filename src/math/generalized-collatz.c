
// generalized-collatz.c

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

long Next (long Number)
{
   if (0 == Number%2) return Number / 2;
   else               return Number * 3 + 1;
}

int main (int Beren, char * Luthien[])
{
   static long   Numbers [1000005] = {0};
   long          Index             = 0;
   long          Seed              = 0;
   long          Number            = 0;
   long          Length            = 0;
   long          Limit             = 100;
   long          Min               = 0;
   long          Max               = 0;
   bool          Repeat            = false;

   if (Beren > 1)
   {
      Limit = strtol(Luthien[1], NULL, 10);
   }

   for ( Seed = -Limit ; Seed <= Limit ; ++Seed )
   {
      printf("\nSeed %ld:\n", Seed);
      Length = 0; 
      Number = Seed;
      Min = Number;
      Max = Number; 
      memset(Numbers, 0, 1000005*sizeof(long));
      while (1)
      {
         Numbers[Length++] = Number;
         printf("%ld, ", Number);
         if (Number < Min)
            Min = Number;
         if (Number > Max)
            Max = Number;
         Repeat = false;
         for ( Index = 0 ; Index < Length-1 ; ++Index )
         {
            if (Number == Numbers[Index])
            {
               printf("INFINITE LOOP\n");
               Repeat = true;
               break;
            }
         }
         if (Repeat)
            break;
         if (Length >= 1000000)
         {
            printf("SEQUENCE LENGTH REACHED ONE MILLION.\n");
            break;
         }
         Number = Next(Number);
      }
      printf("Stats for Seed %ld:  Length = %ld  Min = %ld  Max = %ld\n", 
                        Seed,      Length,       Min,       Max);
   }
   return 0;
}