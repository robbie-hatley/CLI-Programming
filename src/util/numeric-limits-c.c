/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/* numeric-limits-c.c */

#include <stdio.h>
#include <limits.h>
#include <float.h>

int main(void)
{
   printf("\nINTEGER TYPE LIMITS:         \n"                                  );
   printf("char minimum:                %d\n",   CHAR_MIN                      );
   printf("char maxium:                 %d\n",   CHAR_MAX                      );
   printf("signed char minimum:         %d\n",   SCHAR_MIN                     );
   printf("signed char maxium:          %d\n",   SCHAR_MAX                     );
   printf("char maxium:                 %u\n",   UCHAR_MAX                     );
   printf("short minimum:               %d\n",   SHRT_MIN                      );
   printf("short maximum:               %d\n",   SHRT_MAX                      );
   printf("unsigned short maximum:      %u\n",   USHRT_MAX                     );
   printf("int minimum:                 %d\n",   INT_MIN                       );
   printf("int maximum:                 %d\n",   INT_MAX                       );
   printf("unsigned int maximum:        %u\n",   UINT_MAX                      );
   printf("long minimum:                %ld\n",  LONG_MIN                      );
   printf("long maximum:                %ld\n",  LONG_MAX                      );
   printf("unsigned long maximum:       %lu\n",  ULONG_MAX                     );
   printf("long long minimum:           %lld\n", LLONG_MIN                     );
   printf("long long maximum:           %lld\n", LLONG_MAX                     );
   printf("unsigned long long maximum:  %llu\n", ULLONG_MAX                    );
   printf("\nFLOATING-POINT TYPE LIMITS:    \n"                                );
   printf("float radix:                 %d\n",   FLT_RADIX                     );
   printf("float digits:                %d\n",   FLT_DIG                       );
   printf("float minimum:               %f\n",   FLT_MIN                       );
   printf("float maximum:               %E\n",   FLT_MAX                       );
   printf("float epsilon:               %f\n",   FLT_EPSILON                   );
   printf("double digits:               %d\n",   DBL_DIG                       );
   printf("double minimum:              %f\n",   DBL_MIN                       );
   printf("double maximum:              %E\n",   DBL_MAX                       );
   printf("double epsilon:              %f\n",   DBL_EPSILON                   );
   printf("long double digits:          %d\n",   LDBL_DIG                      );
   printf("long double minimum:         %Lf\n",  LDBL_MIN                      );
   printf("long double maximum:         %LE\n",  LDBL_MAX                      );
   printf("long double epsilon:         %Lf\n",  LDBL_EPSILON                  );
   printf("\nOTHER RELATED MACROS:         \n"                                 );
   printf("Bits per character:          %d\n",   CHAR_BIT                      );
   printf("max bytes per MB character:  %d\n",   MB_LEN_MAX                    );
   return 0;
}
