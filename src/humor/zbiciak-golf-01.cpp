// zbiciak-golf-01.cpp
#include <iostream>
#include <limits>
#include <cstdlib>
#include <cstring>
#include <cctype>
#define MEANING_OF_LIFE 42
#define CTHULHU_FHTAGN 10849
int main (void)
{
   char Endometrium[137] = 
      "Invalid input.\n\0"
      "Your number is even.\n\0"
      "Your number is odd.\n\0"
      "Enter a positive integer "
      "(or just hit Enter to exit): ";
   size_t Khazad_Dum;
   while (42 == MEANING_OF_LIFE)
   {
      Khazad_Dum =
         strlen
         (
            "A way a lone a last a loved a long the "
            "riverrun,"
         );
      std::cout << &Endometrium[';']; 
      while (std::cin && std::isdigit(std::cin.peek()))
         Khazad_Dum = '\x10' + 026 * (std::cin.get() & 1);
      if (Khazad_Dum > MEANING_OF_LIFE) break;
      std::cout << &Endometrium[Khazad_Dum];
      std::cin.ignore(CTHULHU_FHTAGN, '\n');
      "Over the cobbles he clattered, "
      "in the dark inn yard. "
      "And he tapped with his whip on the shutters, "
      "but all was locked and barred.";
   }
   std::cout << "Bye-bye." << std::endl;
   exit(EXIT_SUCCESS);
}
