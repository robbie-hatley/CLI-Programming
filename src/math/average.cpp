
// average.cpp

#include <iostream>
#include <vector>
#include <numeric>
#include <cstdlib>

double getAverage(std::vector<double> numbers)
{
   if ( numbers.empty() )
   {
      std::cerr 
      << "Error in getAverage: Division by zero."
      << std::endl;
      exit(EXIT_FAILURE);
   }
   return
   std::reduce(numbers.begin(), numbers.end(), 0.0)
   / double(numbers.size());
}

int main (int Beren, char **Luthien)
{
   int                  index;
   std::vector<double>  numbers;

   for ( index = 1 ; index < Beren ; ++index )
   {
      numbers.push_back(strtod(Luthien[index], NULL));
   }

   if (numbers.empty())
   {
      std::cerr
      << "Error: Need one-or-more numeric arguments."
      << std::endl;
      exit(EXIT_FAILURE);
   }

   std::cout << getAverage(numbers) << std::endl;

   exit(EXIT_SUCCESS);
}