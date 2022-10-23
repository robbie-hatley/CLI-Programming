/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/* myenv.c */

#include <stdio.h>
int main (int argc, char **argv, char **envp)
{
   for ( int i = 0 ; i < argc ; ++i )
   {
      printf("%s\n", argv[i]);
   }
   char **envstr = envp;
   while(*envstr)
   {
      puts(*envstr);
      ++envstr;
   }
   return 0;
}
