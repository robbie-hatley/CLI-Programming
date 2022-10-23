// average.cpp

#include <iostream>
#include <vector>

double Average (std::vector<unsigned> & Items)
{
   double Sum = 0;
   for (double x : Items) {Sum+=x;}
   return Sum/double(Items.size());
}

int main (void)
{
   unsigned Number;
   std::vector<unsigned> Numbers;
   std::cout 
   << "This program calculates the average "
   << "of some positive integers." 
   << std::endl;
   while (42)
   {
      std::cout 
      << "\nEnter a positive integer "
      << "(or 0 to stop): ";
      std::cin >> Number;
      if (!Number) {break;}
      Numbers.push_back(Number);
   }
   std::cout 
   << "\nAverage = " 
   << Average(Numbers)
   << std::endl;
   return 0;
}

