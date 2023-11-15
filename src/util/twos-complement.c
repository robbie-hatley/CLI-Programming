/*********************************************************\
 * twos-complement.c
\*********************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <error.h>
#include <errno.h>

typedef union Data08_tag {
   int8_t   value;
   uint8_t  repre;
} Data08;

typedef union Data16_tag {
   int16_t  value;
   uint16_t repre;
} Data16;

typedef union Data32_tag {
   int32_t  value;
   uint32_t repre;
} Data32;

typedef union Data64_tag {
   int64_t  value;
   uint64_t repre;
} Data64;

void Help (void);
bool OOR64 (char *input);

int main (int Beren, char *Luthien[]) {
   __int128_t N;
   __int128_t X;
   if ( 2 == Beren && (0 == strcmp(Luthien[1], "-h") || 0 == strcmp(Luthien[1], "--help") ) ) {
      Help();
      exit(EXIT_SUCCESS);
   }

   if ( 3 != Beren ) {
      error
      (
         666,
         EINVAL,
         "Error: this program requires exactly two arguments:\n"
         "Arg1 = number of bits (8, 16, 32, or 64).\n"
         "Arg2 = integer to be represented.\n"
         "Arg2 must be representable by the number of bits given by Arg1.\n"
         "Type \"twos-complement -h\" to get more help.\n"
         "Error type"
      );
   }

   N = (__int128_t)strtol(Luthien[1], NULL, 10);
   X = (__int128_t)strtol(Luthien[2], NULL, 10);

   if ( 8 != N && 16 != N && 32 != N && 64 != N ) {
      error
      (
         666,
         EINVAL,
         "Error: Argument 1 must be 8, 16, 32, or 64.\n"
         "Type \"twos-complement -h\" to get more help.\n"
         "Error type"
      );
   }

   if ( 8 == N ) {
      if ( X < -128 || X > 127 ) {
         error
         (
            666,
            EINVAL,
            "Error: If Arg1 is 8, Arg2 must be in the closed interval\n"
            "[-128, 127].\n"
            "Error type"
         );
      }
      Data08 Number;
      Number.value = (int8_t)X;
      printf("Decimal value of number      = %hhd\n",   Number.value);
      printf("2's complement presentation  = %08hhb\n", Number.repre);
   }

   if ( 16 == N ) {
      if ( X < -32768 || X > 32767 ) {
         error
         (
            666,
            EINVAL,
            "Error: If Arg1 is 16, Arg2 must be in the closed interval\n"
            "[-32768, 32767].\n"
            "Error type"
         );
      }
      Data16 Number;
      Number.value = (int16_t)X;
      printf("Decimal value of number      = %hd\n",   Number.value);
      printf("2's complement presentation  = %016hb\n", Number.repre);
   }

   if ( 32 == N ) {
      if ( X < -2147483648 || X > 2147483647 ) {
         error
         (
            666,
            EINVAL,
            "Error: If Arg1 is 32, Arg2 must be in the closed interval\n"
            "[-2147483648, 2147483647].\n"
            "Error type"
         );
      }
      Data32 Number;
      Number.value = (int32_t)X;
      printf("Decimal value of number      = %d\n",   Number.value);
      printf("2's complement presentation  = %032b\n", Number.repre);
   }

   if ( 64 == N ) {
      if (OOR64(Luthien[2])) {
         error
         (
            666,
            EINVAL,
            "Error: If Arg1 is 64, Arg2 must be in the closed interval\n"
            "[-9223372036854775808, 9223372036854775807].\n"
            "Error type"
         );
      }
      Data64 Number;
      Number.value = (int64_t)X;
      printf("Decimal value of number      = %ld\n",  Number.value);
      printf("2's complement presentation  = %064lb\n", Number.repre);
   }

   exit(EXIT_SUCCESS);
}

void Help (void) {
   printf("This program prints two's complement representations of\n");
   printf("a 8-, 16-, 32-, or 64- bit signed integer.\n");
   printf("This program requires two arguments:\n");
   printf("Arg1 is number-of-bits, which must be 8, 16, 32, or 64.\n");
   printf("Arg2 is the integer to be represented, which must be\n");
   printf("representable by the number of bits in Arg1.\n");
   return;
}

bool OOR64 ( char *input ) {
   // Declare and initialize-to-zero all variables we'll need here:
   int   idx     = 0      ; // Index of first digit character of input.
   char  val[95] = {'\0'} ; // Value to be compared to limit.
   int   len     = 0      ; // Length of value.
   char  lim[95] = {'\0'} ; // Limit for comparison.
   bool  oor     = 0      ; // Boolean: out of range?

   // Figure-out and set the values of those variables:
   idx = ('-' == input[0]) ? 1 : 0;
   strncpy(val, input+idx, 90);
   len = (int)strlen(val);
   idx
   ? strncpy(lim, "9223372036854775808", 90)
   : strncpy(lim, "9223372036854775807", 90);

   // If length of value is less than 19, we're NOT out-of-range:
   if ( len < 19 ) {
      oor = 0;
   }

   // If length of value is more than 19, we ARE out-of-range:
   else if ( len > 19 ) {
      oor = 1;
   }

   // If length of value is exactly 19, use string comparison:
   else {
      oor = (strcmp(val, lim) > 0);
   }

   // Finally, return boolean indicating whether-or-not we're out-of-range:
   return oor;
}
