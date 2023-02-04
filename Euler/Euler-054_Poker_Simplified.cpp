// Euler-054_Poker_Simplified.cpp

#include <cstdio>
#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>
#include <utility>
#include <algorithm>
#include <string>

namespace ns_Poker
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;

   typedef  std::vector<std::string>   VS;

   // Count how many left and right hands win:
   void Wins(std::string const & Line, int & LWins, int & RWins, int & Draws);

   // Determine the merit of a hand:
   long Merit(VS & Hand);

   // Return the rank of a card:
   int Rank(std::string const & Card);

   // Compare the rank between two cards:
   bool CompareRank(std::string const & CardL, std::string const & CardR);

} // end namespace ns_Poker

int main (int Beren, char * Luthien[])
{
   // Set main namespace we're using:
   using namespace ns_Poker;

   // Exit if # of args isn't 1:
   if ( 2 != Beren )
   {
      exit(666);
   }

   // If there is exactly one argument, assume it's the name of a file containing
   // pairs of poker hands:
   std::string FileName = std::string(Luthien[1]);

   // Make buffer for line of text:
   std::string LineOfText;

   // Make counters for winning hands:
   int LWins = 0;
   int RWins = 0;
   int Draws = 0;

   // Open an input file stream:
   std::ifstream sHands(FileName);
   if (!sHands)
   {
      cerr << "Error: couldn't open file." << endl;
      exit(666);
   }

   // Get text from file and compare hands:
   while (1)
   {
      getline(sHands, LineOfText);     // Get a line of text.
      if (sHands.eof())  break;        // Break if stream is end-of-file.
      if (sHands.fail()) break;        // Break if stream is failed.
      if (sHands.bad())  break;        // Break if stream is bad.
      if (LineOfText.length() != 29)   // Continue to next line.
      {
         continue;
      }
      Wins(LineOfText, LWins, RWins, Draws);
   }
   
   // Close input file stream:
   sHands.close();

   // Announce wins and draws:
   cout << "LWins = " << LWins << endl;
   cout << "RWins = " << RWins << endl;
   cout << "Draws = " << Draws << endl;

   // We be done, so scram:
   return 0;
} // end main()

// Count wins and draws:
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
   long  Merit      = 0L;

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
