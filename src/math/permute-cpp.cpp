
/*****************\
 * permute-4.cpp *
\*****************/

#include <iostream>
#include <string>

using std::cout;
using std::cerr;
using std::endl;
using std::string;

long int  Permutations  = 0;

string Elide(string const & Text, size_t Position);
void Permute(string left, string right);

int main(int Beren, char * Luthien[])
{
   long int enter_time;
   long int exit_time;

   // Print entry time:
   enter_time = time(0);
   cerr << "Enter time: " << enter_time << endl;

   // Make sure that user supplied exactly 1 argument:
   if ( 2 != Beren )
   {
      cerr 
      << "Error: Permute takes exactly 1 argument, which must be" << endl
      << "a string with at least 0 at most 4 billion characters." << endl;
      return 666;
   }

   // Start tree of recursive calls to Permute():
   Permute("", Luthien[1]);

   // Print total number of permutations found:
   cout << "Found " << Permutations << " permutations." << endl;

   // Print exit time and elapsed time:
   exit_time = time(0);
   cerr << "Exit time: " << exit_time << endl;
   cerr << "Elapsed time: " << exit_time - enter_time << endl;

   // We be done, so scram:
   return 0;
}

string Elide(string const & Text, size_t Position)
{
   string Output = Text;
   Output.erase(Position, 1);
   return Output;
}

void Permute(string left, string right)
{
   if (0 == right.size())
   {
      cout << left << '\n';
      ++Permutations;
      return;
   }
   else
   {
      for (size_t i = 0; i < right.size(); ++i)
      {
         string temp_left  = left + right[i];
         string temp_right = Elide(right, i);
         Permute(temp_left, temp_right);
      }
      return;
   }
}
