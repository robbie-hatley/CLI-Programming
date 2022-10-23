// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

// sizeofcpp.cpp

#include <cstdlib>
#include <cstdio>
#include <cstdint>

using namespace std;

struct Bobbie
{
   char Tom;
   int  Jack;
} Fred;

int main(void)
{
   printf("size of          char          = %2lu bits\n", 8 * sizeof(char));
   printf("size of       signed char      = %2lu bits\n", 8 * sizeof(signed char));
   printf("size of      unsigned char     = %2lu bits\n", 8 * sizeof(unsigned char));
   printf("size of        short int       = %2lu bits\n", 8 * sizeof(short int));
   printf("size of   unsigned short int   = %2lu bits\n", 8 * sizeof(unsigned short int));
   printf("size of          int           = %2lu bits\n", 8 * sizeof(int));
   printf("size of      unsigned int      = %2lu bits\n", 8 * sizeof(unsigned int));
   printf("size of        long int        = %2lu bits\n", 8 * sizeof(long int));
   printf("size of    unsigned long int   = %2lu bits\n", 8 * sizeof(unsigned long int));
   printf("size of      long long int     = %2lu bits\n", 8 * sizeof(long long int));
   printf("size of unsigned long long int = %2lu bits\n", 8 * sizeof(unsigned long long int));
   printf("size of          float         = %2lu bits\n", 8 * sizeof(float));
   printf("size of         double         = %2lu bits\n", 8 * sizeof(double));
   printf("size of       long double      = %2lu bits\n", 8 * sizeof(long double));
   printf("size of          Fred          = %2lu bits\n", 8 * sizeof(Fred));
   printf("size of         int8_t         = %2lu bits\n", 8 * sizeof(  int8_t));
   printf("size of        uint8_t         = %2lu bits\n", 8 * sizeof( uint8_t));
   printf("size of        int16_t         = %2lu bits\n", 8 * sizeof( int16_t));
   printf("size of       uint16_t         = %2lu bits\n", 8 * sizeof(uint16_t));
   printf("size of        int32_t         = %2lu bits\n", 8 * sizeof( int32_t));
   printf("size of       uint32_t         = %2lu bits\n", 8 * sizeof(uint32_t));
   printf("size of        int64_t         = %2lu bits\n", 8 * sizeof( int64_t));
   printf("size of       uint64_t         = %2lu bits\n", 8 * sizeof(uint64_t));
   printf("size of         size_t         = %2lu bits\n", 8 * sizeof( size_t));
   return 0;
}
