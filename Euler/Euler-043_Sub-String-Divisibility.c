/*
"Euler-043_Sub-String-Divisibility.c"
Attempts to solve problem 43 of Project Euler, "Sub-String Divisibility".
Author:  Robbie Hatley
Written: Thu Feb 01, 2018
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/time.h>

int pcnt;
static char perms[3628800][11];

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
   char temp_left  [11] = {'\0'};
   char temp_right [11] = {'\0'};
   strcpy(temp_left, left);
   if (2 == m)
   {
      temp_left[n]   = right[0];
      temp_left[n+1] = right[1];
      strcpy(perms[pcnt++], temp_left);
      temp_left[n]   = right[1];
      temp_left[n+1] = right[0];
      strcpy(perms[pcnt++], temp_left);
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

int SSD (char* s)
{
   static const unsigned long  primes[7]     = {2,3,5,7,11,13,17};
   int                         i             = 0;
   char                        substring[4]  = "";
   unsigned long               number        = 0UL;

   for ( i = 0 ; i < 7 ; ++i )
   {
      substring[0]=s[i+1];
      substring[1]=s[i+2];
      substring[2]=s[i+3];
      substring[3]='\0';
      number = strtoul(substring, NULL, 10);
      if (0UL != number%primes[i]) return 0;
   }
   return 1;
}

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
   int            i = 0; /* index  */
   int            c = 0; /* count  */
   unsigned long  s = 0; /* sum    */
   double         t1, t2, t3;

   t1=HiResTime();

   /* Clear prms and pcnt: */
   memset(&perms, 0, 39916800);
   pcnt=0;

   /* Collect all 0-9 10-digit pandigital numbers in prms: */
   Permute("", "0123456789");

   /* Print any that are Sub-String-Divisible: */
   for ( i = 0 ; i < pcnt ; ++i )        /* pcnt ; ++i ) */
   {
      if (SSD(perms[i]))
      {
         printf("%s is sub-string-divisible\n", perms[i]);
         ++c;
         s += strtoul(perms[i], NULL, 10);
      }
   }
   printf("Found %d sub-string-divisible 0-9 pandigital numbers.\n", c);
   printf("Sum = %ld\n", s);

   t2=HiResTime(); 
   t3=t2-t1;
   printf("Elapsed time = %f seconds\n", t3);
   return 0; 
}
