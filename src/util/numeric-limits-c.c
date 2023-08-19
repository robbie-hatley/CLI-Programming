/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/* numeric-limits-c.c */

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <limits.h>
#include <float.h>

int main(void)
{
   printf("\nINTEGER TYPE LIMITS:         \n"                 );
   printf("char minimum:                % d\n",   CHAR_MIN    );
   printf("char maxium:                 % d\n",   CHAR_MAX    );
   printf("signed char minimum:         % d\n",   SCHAR_MIN   );
   printf("signed char maxium:          % d\n",   SCHAR_MAX   );
   printf("char maxium:                  %u\n",   UCHAR_MAX   );
   printf("short minimum:               % d\n",   SHRT_MIN    );
   printf("short maximum:               % d\n",   SHRT_MAX    );
   printf("unsigned short maximum:       %u\n",   USHRT_MAX   );
   printf("int minimum:                 % d\n",   INT_MIN     );
   printf("int maximum:                 % d\n",   INT_MAX     );
   printf("unsigned int maximum:         %u\n",   UINT_MAX    );
   printf("long minimum:                % ld\n",  LONG_MIN    );
   printf("long maximum:                % ld\n",  LONG_MAX    );
   printf("unsigned long maximum:        %lu\n",  ULONG_MAX   );
   printf("long long minimum:           % lld\n", LLONG_MIN   );
   printf("long long maximum:           % lld\n", LLONG_MAX   );
   printf("unsigned long long maximum:   %llu\n", ULLONG_MAX  );
   printf("__int128_t min:              -170141183460469231731687303715884105728 (non-std Gnu extension)\n");
   printf("__int128_t max:               170141183460469231731687303715884105727 (non-std Gnu extension)\n");
   printf("__uint128_t max:              340282366920938463463374607431768211455 (non-std Gnu extension)\n");
   printf("\nFLOATING-POINT TYPE LIMITS:    \n"                );
   printf("float radix:                 %d\n",   FLT_RADIX     );
   printf("float digits:                %d\n",   FLT_DIG       );
   printf("float min abs val:           %E\n",   FLT_MIN       );
   printf("float max abs val:           %E\n",   FLT_MAX       );
   printf("float epsilon:               %E\n",   FLT_EPSILON   );
   printf("double digits:               %d\n",   DBL_DIG       );
   printf("double min abs val:          %E\n",   DBL_MIN       );
   printf("double max abs val:          %E\n",   DBL_MAX       );
   printf("double epsilon:              %E\n",   DBL_EPSILON   );
   printf("long double digits:          %d\n",   LDBL_DIG      );
   printf("long double min abs val:     %LE\n",  LDBL_MIN      );
   printf("long double max abs val:     %LE\n",  LDBL_MAX      );
   printf("long double epsilon:         %LE\n",  LDBL_EPSILON  );
   printf("\nOTHER RELATED MACROS:         \n"                 );
   printf("Bits per character:          %d\n",   CHAR_BIT      );
   printf("max bytes per MB character:  %d\n",   MB_LEN_MAX    );
   return 0;
}
