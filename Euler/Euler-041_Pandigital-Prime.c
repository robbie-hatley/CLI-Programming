/*
"Euler-041_Pandigital-Prime.c"
Attempts to solve problem 41 of Project Euler, "Pandigital Prime".
Author:  Robbie Hatley
Written: Thu Feb 01, 2018
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/time.h>

int  pcnt;
static char perms[500000][10];

void ClearPerms (void)
{
   int i, j;
   for ( i = 0 ; i < 500000 ; ++i )
   {
      for ( j = 0 ; j < 10 ; ++j )
      {
         perms[i][j] = '\0';
      }
   }
   pcnt = 0;
   return;
}

void Elide(char *text, int index)
{
   while ('\0' != text[index])
   {
      text[index] = text[index+1];
      ++index;
   }
}

void Permute(const char *left, const char *right)
{
   int index;
   int n = (int)strlen(left);
   int m = (int)strlen(right);
   char temp_left  [10] = {'\0'};
   char temp_right [10] = {'\0'};
   strcpy(temp_left, left);
   if (2 == m)
   {
      temp_left[n]   = right[0];
      temp_left[n+1] = right[1];
      sprintf(perms[pcnt], "%s", temp_left);
      ++pcnt;
      temp_left[n]   = right[1];
      temp_left[n+1] = right[0];
      sprintf(perms[pcnt], "%s", temp_left);
      ++pcnt;
   }
   else
   {
      for (index = 0; index < m; ++index)
      {
         strcpy(temp_right, right);
         temp_left[n] = temp_right[index];
         Elide(temp_right, index);
         Permute(temp_left, temp_right);
      }
   }
   return;
}

/* Order-4 wheel (2*3*5*7=210, 48 spokes) for finding primes: */
static const int wheel[48] =
{
     1,  11,  13,  17,  19,  23,  29,  31,  37,  41,
    43,  47,  53,  59,  61,  67,  71,  73,  79,  83,
    89,  97, 101, 103, 107, 109, 113, 121, 127, 131,
   137, 139, 143, 149, 151, 157, 163, 167, 169, 173,
   179, 181, 187, 191, 193, 197, 199, 209
};

/* Integer Square Root: */
int IntSqrt (int n)
{
   int i = 1;
   while (i*i <= n)
   {
      ++i;
   }
   return i-1;
}

/* Is a given integer a prime number? */
int IsPrime (int n)
{
   int  i           ; // Divisor index.
   int  index    = 0; // Sieve index.
   int  row      = 0; // Sieve row.
   int  limit    = 0; // Upper limit for divisors to try.
   int  divisor  = 0; // Divisor.
   if (n<2) return 0;
   if (2==n||3==n||5==n||7==n) return 1;
   if (!(n%2)||!(n%3)||!(n%5)||!(n%7)) return 0;
   limit = IntSqrt(n);
   for ( i = 1 ; ; ++i )
   {
      row     = i/48;
      index   = i%48;
      divisor = 210*row + wheel[index];
      if (divisor > limit) return 1;
      if (!(n%divisor))    return 0;
   }
} // end IsPrime()

double HiResTime (void)
{
   struct timeval t;
   double td;
   gettimeofday(&t, NULL);
   td=(double)(t.tv_sec)+(double)(t.tv_usec)/1000000.0;
   return td;
}

int main(void)
{
   double   t0  = 0;
   int      i   = 0;
   int      n   = 0;
   int      c   = 0;
   int      m   = 0;

   t0 = HiResTime();

   /* Clear prms and pcnt: */
   ClearPerms();

   /* Collect all 4-digit and 7-pandigital numbers in perms: */
   Permute("", "1234");
   Permute("", "1234567");

   /* Print any that are prime: */
   for ( i = 0 ; i < pcnt ; ++i )
   {
      n=atoi(perms[i]);
      if (IsPrime(n))
      {
         printf("%d\n", n);
         ++c;
         if (n>m) {m=n;}
      }
   }
   printf("Found %d pandigital primes.\n",     c);
   printf("Maximal pandigital prime is %d.\n", m);

   printf("Elapsed time = %f seconds\n", HiResTime()-t0);

   return 0; 
}
