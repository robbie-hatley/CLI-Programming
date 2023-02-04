// largest-3-3-palindrome.c
#include <stdio.h>

int main(void)
{
   int  Large     = 0;
   int  Small     = 0;
   int  Product   = 0;
   char String[9] = {'\0'};
   int  Largest   = 0;
   
   for ( Small = 999 ; Small >= 100 ; --Small )
   {
      for ( Large = 999 ; Large >= Small ; --Large )
      {
         Product = Small * Large;
         sprintf(String, "%d", Product);
         // Now, the largest number we can get from multiplying two 
         // 3-digit numbers is 999x999 = 999031 which is a 6-digit number;
         // and the smallest number we can get is 100x100 = 10000, which
         // is a 5-digit number. Hence we need only check for those cases:
         if ( Product > 99999 && Product < 1000000 ) // 6-digit?
         {
            if (    String[0] == String[5]
                 && String[1] == String[4]
                 && String[2] == String[3])
            {
               if (Product > Largest) {Largest = Product;}
            }
               
         }
         if ( Product > 9999 && Product < 100000 ) // 5-digit?
         {
            if (    String[0] == String[4]
                 && String[1] == String[3])
            {
               if (Product > Largest) {Largest = Product;}
            }
         }
      } // end for ( Large )
   } // end for ( Small )
   printf("%d\n", Largest); 
   return 0;
} // end main()
