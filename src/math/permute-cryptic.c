#include <stdio.h>
#include <string.h>
#include <time.h>
unsigned long int n = 0;
void g(char * a , char * b) {while ((*a++ = *b++));}
void f(const char *left, const char *right) 
{
   int  i;
   int  LL = (int)strlen(left);
   int  LR = (int)strlen(right);
   char temp_left  [21] = {'\0'};
   char temp_right [21] = {'\0'};
   strcpy(temp_left, left);
   if (1 == LR)
   {
      temp_left[LL] = right[0];
      printf("%s\n", temp_left);
      ++n;
      return;
   }
   else
   {
      for (i = 0; i < LR; ++i) 
      {
         strcpy(temp_right, right);
         temp_left[LL] = temp_right[i];
         g(&temp_right[i],&temp_right[i+1]);
         f(temp_left, temp_right);
      }
      return;
   }
}
int main(int Beren, char * Luthien[])
{
   if ( 2 != Beren ) return 666;
   size_t L = strlen(Luthien[1]);
   if (L < 2 || L > 20) return 666;
   f("", Luthien[1]);
   printf("number = %ld\n",n);
   return 0;
}