// ackermann.c
// Written Fri Sep 25, 2020 by Robbie Hatley
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>
#include <error.h>

int64_t  Recursion     = 0l;
int64_t  MaxRecursion  = 0l;

int64_t A (int64_t m, int64_t n)
{
   int64_t RetVal = 0l;
   ++Recursion;
   if (Recursion > MaxRecursion) {MaxRecursion = Recursion;}
   if (Recursion > 25000)
   {
      error
      (
         EXIT_FAILURE, 
         ERANGE, 
         "Error in A(): Recursion is out-of-range:\n"
         "Recursion = %ld ; MaxRecursion = %ld .\n",
         Recursion, MaxRecursion
      );
   }
   if (m<-1000000000000000000||n<-1000000000000000000||m>1000000000000000000||n>1000000000000000000)
   {
      error
      (
         EXIT_FAILURE, 
         EDOM, 
         "Error in A(): m and/or n is out-of-range:\n"
         "m = %ld and n = %ld .\n",
         m, n
      );
   }
   if (0 == m)
   {
      RetVal = n+1;
   }
   else
   {
      if (0 == n)
      {
         RetVal = A(m-1,1);
      }
      else
      {
         RetVal = A(m-1,A(m,n-1));
      }
   }
   --Recursion;
   return RetVal;
}

int main (int Beren, char ** Luthien)
{
   int64_t  m = 0ul;
   int64_t  n = 0ul;
   if (3 != Beren)
   {
      error
      (
         EXIT_FAILURE, 
         EINVAL, 
         "Error in main(): This program takes two arguments, which must be\n"
         "integers in the 0-9 range, but you typed %d arguments.\n",
         Beren
      );
   }
   m = (int64_t)strtol(Luthien[1], NULL, 10);
   n = (int64_t)strtol(Luthien[2], NULL, 10);
   printf("A(%ld,%ld) = %ld\n", m, n, A(m,n));
   printf("Max recursion used = %ld\n", MaxRecursion);
   return 0;
}