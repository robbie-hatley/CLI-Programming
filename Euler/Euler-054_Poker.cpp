
/************************************************************************************************************\
 * Program name:  Poker
 * File name:     Euler-054_Poker.cpp
 * Source for:    Euler-054_Poker.exe
 * Description:   Determines which of two poker hands "wins".
 * Author:        Robbie Hatley
 * Inputs:        Reads file "D:\rhe\src\Euler\Euler-054_Poker-Hands.txt".
 * Outputs:       Prints how many "left" hands won and how many "right" hands won.
 * To make:       Link with modules rhutil.o and rhmath.o in library "librh.a" in folder "D:\rhe\lib".
 * Edit History:
 *   Thu Jan 04, 2018 - Wrote first draft. Just a stub at this point.
 *   Fri Jan 05, 2018 - Many changes, simplifications, and additions. Starting to gain functionality.
\************************************************************************************************************/

// Include old C headers:
#include <cstdio>

// Include new C++ headers:
#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>
#include <utility>
#include <string>

// Include personal library headers:
#include "rhutil.hpp"
#include "rhmath.hpp"

namespace ns_Poker
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::setfill;
   using std::setw;

   // Typedefs:
   
   typedef  std::vector<std::string>   VS;
   typedef  VS::iterator               VSI;
   typedef  VS::const_iterator         VSCI;

   // Structs and Classes:

   struct Settings_t  // Program settings (boolean or otherwise).
   {
      bool         bHelp;     // Did user ask for help?
      std::string  filename;  // File to open.
   };

   // Functions:

   // Set program settings based on Flags:
   void ProcessFlags(VS const & Flags, Settings_t & Settings);

   // Count how many left and right hands win:
   void Wins(std::string const & Line, int & LWins, int & RWins, int & Draws);

   // Determine the merit of a hand:
   long Merit(VS & Hand);

   // Return the rank of a card:
   int Rank(std::string const & Card);

   // Compare the rank between two cards:
   bool CompareRank(std::string const & CardL, std::string const & CardR);

   // Print an error message:
   void PrintErrorMessage(void);

   // Give the user some help:
   void GiveHelp(void);

} // end namespace ns_Poker


// Main program entry function:
int main (int Beren, char * Luthien[])
{
   // Set main namespace we're using:
   using namespace ns_Poker;

   // Seed random-number generator (this can be deleted if not using random numbers):
   srand(unsigned(time(0)));

   // Make a "settings" object to hold program settings:
   Settings_t Settings = Settings_t();

   // Make a "flags" object to hold flags:
   VS Flags;

   // Get flags (items in Luthien starting with '-'):
   rhutil::GetFlags (Beren, Luthien, Flags);
   
   // Process flags (set settings based on flags):
   ProcessFlags(Flags, Settings);

   // If user wants help, just print help and return:
   if (Settings.bHelp)
   {
      GiveHelp();
      exit(777);
   }

   // Make an "arguments" object to hold arguments:
   VS Arguments;

   // Get arguments (items in Luthien *not* starting with '-'):
   rhutil::GetArguments(Beren, Luthien, Arguments);

   // Check arguments for validity:
   if ( 1 != Arguments.size() )
   {
      PrintErrorMessage();
      GiveHelp();
      exit(666);
   }

   // If there is exactly one argument, assume it's the name of a file containing
   // pairs of poker hands:
   Settings.filename = Arguments[0];

   // Announce file name:
   cout << "File name = " << Settings.filename << endl;

   // Make buffer for line of text:
   std::string LineOfText;

   // Make counters for winning hands:
   int LWins = 0;
   int RWins = 0;
   int Draws = 0;

   // Open an input file stream:
   std::ifstream sHands(Settings.filename);
   if (!sHands)
   {
      cerr << "Error: couldn't open file " << Settings.filename << endl;
      exit(666);
   }

   // Get and display lines of text from file:
   while (1)
   {
      getline(sHands, LineOfText);           // Get a line of text.
      if (sHands.eof())  break;              // Break if stream is end-of-file.
      if (sHands.fail()) break;              // Break if stream is failed.
      if (sHands.bad())  break;              // Break if stream is bad.
      if (LineOfText.length() != 29)
      {
         PrintErrorMessage();
         GiveHelp();
         exit(666);
      }
      Wins(LineOfText, LWins, RWins, Draws);
   }
   
   // Close input file stream:
   sHands.close();

   // Announce wins:
   cout << "LWins = " << LWins << endl;
   cout << "RWins = " << RWins << endl;
   cout << "Draws = " << Draws << endl;

   // We be done, so scram:
   return 0;
} // end main()


// Set program settings based on Flags:
void ns_Poker::ProcessFlags(VS const & Flags, Settings_t & Settings)
{
   BLAT("\nJust entered ProcessFlags().  About to set settings.\n")

   // Use InVec from rhutil:
   using rhutil::InVec;

   Settings.bHelp = InVec(Flags, "-h") or InVec(Flags, "--help"   );

   BLAT("About to return from ProcessFlags.\n")
   return;
} // end ns_Poker::ProcessFlags()


// Count how many left and right hands win:
void ns_Poker::Wins(std::string const & Line, int & LWins, int & RWins, int & Draws)
{
   VS    LHand;
   VS    RHand;
   long  MeritL  = 0;
   long  MeritR  = 0;

   // Separate text into hands and cards:
   int i = 0;
   for ( i = 0 ; i < 5 ; ++i)
   {
      LHand.push_back(Line.substr(3*i,2));
   }
   for ( i = 0 ; i < 5 ; ++i )
   {
      RHand.push_back(Line.substr(3*i+15,2));
   }

   // Determine "merit" of each hand (which also sorts the hands):
   MeritL = Merit(LHand);
   MeritR = Merit(RHand);

   // Print sorted hands:
   printf("%2s %2s %2s %2s %2s   %2s %2s %2s %2s %2s\n", 
   LHand[0].c_str(), LHand[1].c_str(), LHand[2].c_str(), LHand[3].c_str(), LHand[4].c_str(), 
   RHand[0].c_str(), RHand[1].c_str(), RHand[2].c_str(), RHand[3].c_str(), RHand[4].c_str());
   
   // If one hand wins, declare win:
   // otherwise, declare draw:
   if      (MeritL > MeritR) {++LWins;}
   else if (MeritR > MeritL) {++RWins;}
   else                      {++Draws;}

   return;
}


// Determine the merit of a sorted hand:
long ns_Poker::Merit(VS & Hand)
{
   bool  Straight   = false;
   bool  Flush      = false;
   long  Merit      =0L;

   // Sort cards by rank:
   sort(Hand.begin(), Hand.end(), CompareRank);

   // Determine if hand is a straight:
   if 
      (                                             // Non-Ace-Low Straight?
        (Rank(Hand[4]) == (Rank(Hand[3]) + 1) &&
         Rank(Hand[3]) == (Rank(Hand[2]) + 1) && 
         Rank(Hand[2]) == (Rank(Hand[1]) + 1) && 
         Rank(Hand[1]) == (Rank(Hand[0]) + 1)   )
         ||                                         // Ace-Low Straight?
        (Rank(Hand[4]) == 14 &&                     // Ace
         Rank(Hand[0]) ==  2 &&                     // Deuce
         Rank(Hand[1]) ==  3 &&                     // Trey
         Rank(Hand[2]) ==  4 &&                     // 4
         Rank(Hand[3]) ==  5                     )  // 5
      )
   {
      Straight = true;
   }
         
   // Determine if hand is a flush:

   if (Hand[0][1] == Hand[1][1] && 
       Hand[1][1] == Hand[2][1] &&
       Hand[2][1] == Hand[3][1] &&
       Hand[3][1] == Hand[4][1])
   {
      Flush = true;
   }      

   // MERIT: Assign a "merit" number to each hand, describing what kind of hand it is and what it's degree 
   // of "merit" is relative to other hands. Royal Flushes get the highest merit (9), and No Pairs get the
   // lowest merit (0).

   // Is hand a royal flush?
   // (NOTE: We must check rank of top TWO cards, else we may mistake an Ace-LOW straight
   // for an Ace-HIGH straight!!! To be a "royal flush", hand MUST be "10 J Q K A".)
   if (Straight && Flush && 14 == Rank(Hand[4]) && 13 == Rank(Hand[3]))
   {
      Merit = 90000000000L ; // Royal Flush
   }

   // Else is hand a non-royal straight flush?
   else if (Straight && Flush)
   {
      if ( Rank(Hand[0]) == 2 && Rank(Hand[4]) == 14 ) // Ace-Low Straight! Ace is low card, not high.
      {
         Merit = 80000000000L + 5L;                    // High card is 5.
      }
      else                                             // NON-Ace-Low Straight. 
      {
         Merit = 80000000000L + Rank(Hand[4]);         // High card is highest-ranking card. 
      }
   }

   // Else is hand a Four Of A Kind?
   else if ( Rank(Hand[1]) == Rank(Hand[4]) )
   {
      Merit = 70000000000L + 1L * Rank(Hand[0]);
   }
   else if ( Rank(Hand[0]) == Rank(Hand[3]) )
   {
      Merit = 70000000000L + 1L * Rank(Hand[4]);
   }

   // Else is hand a Full House?
   else if ( Rank(Hand[0]) == Rank(Hand[1]) && Rank(Hand[2]) == Rank(Hand[4]) ) 
   {
      Merit = 60000000000L + 100L * Rank(Hand[4]) + 1L * Rank(Hand[1]);
   }
   else if ( Rank(Hand[0]) == Rank(Hand[2]) && Rank(Hand[3]) == Rank(Hand[4]) )
   {
      Merit = 60000000000L + 100L * Rank(Hand[2]) + 1L * Rank(Hand[4]);
   }

   // Else is hand a Flush?
   else if (Flush)
   {
      Merit = 50000000000L                 + 100000000L * Rank(Hand[4]) 
            +     1000000L * Rank(Hand[3]) +     10000L * Rank(Hand[2]) 
            +         100L * Rank(Hand[1]) +         1L * Rank(Hand[0]);

      }

   // Else is hand a Straight?
   else if (Straight)
   {
      if ( Rank(Hand[0]) == 2 && Rank(Hand[4]) == 14 ) // Ace-Low Straight! Ace is low card, not high.
      {
         Merit = 40000000000L + 5L;                    // High card is 5.
      }
      else                                             // NON-Ace-Low Straight. 
      {
         Merit = 40000000000L + Rank(Hand[4]);         // High card is highest-ranking card. 
      }
   }

   // Else is hand a Three Of A Kind?
   else if ( Rank(Hand[0]) == Rank(Hand[2]) )
   {
      Merit = 30000000000L + 10000L * Rank(Hand[2]) + 100L * Rank(Hand[4]) + Rank(Hand[3]);
   }
   else if ( Rank(Hand[1]) == Rank(Hand[3]) )
   {
      Merit = 30000000000L + 10000L * Rank(Hand[3]) + 100L * Rank(Hand[4]) + Rank(Hand[0]);
   }
   else if ( Rank(Hand[2]) == Rank(Hand[4]) )
   {
      Merit = 30000000000L + 10000L * Rank(Hand[4]) + 100L * Rank(Hand[1]) + Rank(Hand[0]);
   }

   // Else is hand a Two Pairs?
   else if ( Rank(Hand[0]) == Rank(Hand[1]) && Rank(Hand[2]) == Rank(Hand[3]) )
   {
      Merit = 20000000000L + Rank(Hand[4]);
   }
   else if ( Rank(Hand[0]) == Rank(Hand[1]) && Rank(Hand[3]) == Rank(Hand[4]) )
   {
      Merit = 20000000000L + Rank(Hand[2]);
   }
   else if ( Rank(Hand[1]) == Rank(Hand[2]) && Rank(Hand[3]) == Rank(Hand[4]) )
   {
      Merit = 20000000000L + Rank(Hand[0]);
   }

   // Else is hand a One Pair?
   else if ( Rank(Hand[0]) == Rank(Hand[1]) ) 
   {
      Merit = 10000000000L + 1000000L * Rank(Hand[1]) + 10000L * Rank(Hand[4]) 
                           +     100L * Rank(Hand[3]) +     1L * Rank(Hand[2]);
   }
   else if ( Rank(Hand[1]) == Rank(Hand[2]) )
   {
      Merit = 10000000000L + 1000000L * Rank(Hand[2]) + 10000L * Rank(Hand[4]) 
                           +     100L * Rank(Hand[3]) +     1L * Rank(Hand[0]);
   }
   else if ( Rank(Hand[2]) == Rank(Hand[3]) )
   {
      Merit = 10000000000L + 1000000L * Rank(Hand[3]) + 10000L * Rank(Hand[4]) 
                           +     100L * Rank(Hand[1]) +     1L * Rank(Hand[0]);
   }
   else if ( Rank(Hand[3]) == Rank(Hand[4]) )
   {
      Merit = 10000000000L + 1000000L * Rank(Hand[4]) + 10000L * Rank(Hand[2]) 
                           +     100L * Rank(Hand[1]) +     1L * Rank(Hand[0]);
   }

   // Else hand is a No Pairs:
   else
   {
      Merit =       0L                 + 100000000L * Rank(Hand[4]) 
            + 1000000L * Rank(Hand[3]) +     10000L * Rank(Hand[2]) 
            +     100L * Rank(Hand[1]) +         1L * Rank(Hand[0]);
   }
   
   // Return merit:
   return Merit;
}


// Return the rank of a card:
int ns_Poker::Rank(std::string const & Card)
{
   // static std::unordered_map<char, int> const Ranking 
   static const std::unordered_map<char, int> Ranking
   {
      std::pair<char,int>('2',  2),
      std::pair<char,int>('3',  3),
      std::pair<char,int>('4',  4),
      std::pair<char,int>('5',  5),
      std::pair<char,int>('6',  6),
      std::pair<char,int>('7',  7),
      std::pair<char,int>('8',  8),
      std::pair<char,int>('9',  9),
      std::pair<char,int>('T', 10),
      std::pair<char,int>('J', 11),
      std::pair<char,int>('Q', 12),
      std::pair<char,int>('K', 13),
      std::pair<char,int>('A', 14),
   };
   int RankNumber = 0;
   try
   {
      RankNumber = Ranking.at(Card[0]);
   }
   catch(std::out_of_range)
   {
      RankNumber = 0;
   }
   return RankNumber;
}


// Compare the rank between two cards:
bool ns_Poker::CompareRank(std::string const & CardL, std::string const & CardR)
{
   return Rank(CardL) < Rank(CardR);
}


// Print an error message:
void ns_Poker::PrintErrorMessage(void)
{
   cerr 
   << "Invalid number of arguments. This program takes exactly"         << endl
   << "one argument, which must be the path of a text file containing"  << endl
   << "pairs of 5-card poker hands."                                    << endl;
   return;
}


// Give the user some help:
void ns_Poker::GiveHelp(void)
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to Poker, Robbie Hatley's poker-hand analyzer."                     << endl
                                                                                   << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."         << endl
                                                                                   << endl
   << "Command-line syntax:"                                                       << endl
   << "Euler-054_Poker [-h|--help] InputFile"                                      << endl
                                                                                   << endl
   << "Switch:                      Meaning:"                                      << endl
   << "\"-h\" or \"--help\"             Print help and exit."                      << endl
                                                                                   << endl
   << "Poker takes exactly one argument, which must be the path of a text file"    << endl
   << "containing pairs of 5-card poker hands, one pair per row, like so:"         << endl
   << "8C TS KC 9H 4S 7D 2S 5D 3S AC"                                              << endl
   << "5C AD 5D AC 9C 7C 5H 8D TD KS"                                              << endl
   << "3H 7H 6S KC JS QH TD JC 2D 8S"                                              << endl
   << "The first  5 cards on each line are considered to be the \"left\"  hand."   << endl
   << "The second 5 cards on each line are considered to be the \"right\" hand."   << endl
   << "This program will print the number of winning left hands and the number of" << endl
   << "winning right hands."                                                       << endl;
   return;
} // end ns_Poker::Help()


/*

Development Notes:

Thu Jan 04, 2018:
Started writing this program. I'm getting back into playing with Project Euler after a long hiatus. 
Problem 54 is about poker. Given a text file with a bunch of pairs of poker hands, how many "left" 
hands win and how many "right" hands win? The answer to the problem is the count of "left" winners 
in the file provided (saved as "Euler-054_Poker-Hands.txt" on my system).

Fri Jan 05, 2018:
I'm getting back into the habit of using STL containers and container member functions. I'm (re)learning
STL features such as:
1. Iterating over containers using .begin() and .end() iterators
2. Using unordered_map , which is a new container in C++ as of 2011.
3. Accessing elements of a static const unordered_map by using .at() . (One can't can't use [] to 
   access elements of a const container because that "discards qualifiers"; must use .at() instead.)
4. Using a custom predicate function argument to sort() to do comparison using my own criteria.
5. Separating out the attribute being compared (Rank) from the comparison (CompareRank)
   as separate functions, as the rank returns type int but the comparison must return type bool.
   So, sort() uses function argument CompareRank(), which calls attribute-determiner Rank().

*/


// end file template.cpp
