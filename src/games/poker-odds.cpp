/************************************************************************************************************\
 * File name:     poker-odds.cpp
 * Source for:    poker-odds.exe
 * Program name:  Poker Odds
 * Description:   Calculates and totals probability of all ranks of poker hands.
 * Author:        Robbie Hatley
 * Date written:  Sunday July 18, 2004
 * Last edited:   Sunday July 18, 2004
\************************************************************************************************************/

#include <cstdlib>
#include <cstring>
#include <cctype>
#include <cmath>

#include <iostream>
#include <iomanip>
#include <map>

#include "rhmath.hpp"

namespace MyNameSpace 
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::setw;
   using std::left;
   using std::right;
   using std::setfill;
   using std::showpoint;
   using std::fixed;
   using std::string;
   using std::map;
   
   using namespace rhmath;
   
   enum Hands
   {
      StraightFlush,
      FourOfAKind,
      FullHouse,
      Flush,
      Straight,
      ThreeOfAKind,
      TwoPair,
      Pair,
      NoPair
   };
}

int main()
{
   using namespace MyNameSpace;
   map<Hands, long int> CombTable;
   CombTable [ StraightFlush ] = 40;
   CombTable [ FourOfAKind   ] = 13*48;
   CombTable [ FullHouse     ] = 13*Comb(4,3)*12*Comb(4,2);
   CombTable [ Flush         ] = (Comb(13,5)-10)*4;
   CombTable [ Straight      ] = 10*(Pow(4,5)-4);
   CombTable [ ThreeOfAKind  ] = 13*Comb(4,3)*Comb(12,2)*4*4;
   CombTable [ TwoPair       ] = Comb(13,2)*Comb(4,2)*Comb(4,2)*11*4;
   CombTable [ Pair          ] = 13*Comb(4,2)*Comb(12,3)*4*4*4;
   CombTable [ NoPair        ] = (Comb(13, 5) - 10)*(Pow(4,5)-4);
   const long double T = static_cast<long double>(Comb(52,5));
   long int TotalHands = 0;
   map<Hands, long int>::iterator i;
   for (i=CombTable.begin(); i!=CombTable.end(); ++i)
   {
      TotalHands += (*i).second;
   }
   cout << fixed << showpoint;
   cout << "Hand              Combinations    Probability"   << endl;
   cout 
      << "Straight Flush:   "
      << setfill(' ') << right << setw( 9) << CombTable [ StraightFlush ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ StraightFlush ] / T << endl;
   cout
      << "Four of a Kind:   "
      << setfill(' ') << right << setw( 9) << CombTable [ FourOfAKind   ]
      << "       " 
      << setfill('0') << left  << setw(14) << CombTable [ FourOfAKind   ] / T << endl;
   cout
      << "Full House:       " 
      << setfill(' ') << right << setw( 9) << CombTable [ FullHouse     ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ FullHouse     ] / T << endl;
   cout
      << "Flush:            "
      << setfill(' ') << right << setw( 9) << CombTable [ Flush         ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ Flush         ] / T << endl;
   cout
      << "Straight:         "
      << setfill(' ') << right << setw( 9) << CombTable [ Straight      ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ Straight      ] / T << endl;
   cout
      << "Three of a Kind:  "
      << setfill(' ') << right << setw( 9) << CombTable [ ThreeOfAKind  ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ ThreeOfAKind  ] / T << endl;
   cout
      << "Two Pair:         "
      << setfill(' ') << right << setw( 9) << CombTable [ TwoPair       ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ TwoPair       ] / T << endl;
   cout
      << "Pair:             "
      << setfill(' ') << right << setw( 9) << CombTable [ Pair          ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ Pair          ] / T << endl;
   cout
      << "No Pair:          "
      << setfill(' ') << right << setw( 9) << CombTable [ NoPair        ]
      << "       "
      << setfill('0') << left  << setw(14) << CombTable [ NoPair        ] / T << endl;
   
   cout
      << "Total:            "
      << setfill(' ') << right << setw( 9) << CombTable [ StraightFlush ]
                                            + CombTable [ FourOfAKind   ]
                                            + CombTable [ FullHouse     ]
                                            + CombTable [ Flush         ]
                                            + CombTable [ Straight      ]
                                            + CombTable [ ThreeOfAKind  ]
                                            + CombTable [ TwoPair       ]
                                            + CombTable [ Pair          ]
                                            + CombTable [ NoPair        ]
      
      << "       " 
      
      << setfill('0') << left  << setw(14) 
                                           
                                           << CombTable [ StraightFlush ] / T
                                            + CombTable [ FourOfAKind   ] / T
                                            + CombTable [ FullHouse     ] / T
                                            + CombTable [ Flush         ] / T
                                            + CombTable [ Straight      ] / T
                                            + CombTable [ ThreeOfAKind  ] / T
                                            + CombTable [ TwoPair       ] / T
                                            + CombTable [ Pair          ] / T
                                            + CombTable [ NoPair        ] / T << endl;
   cout 
      << "52-comb-5:        "
      << setfill(' ') << right << setw(9) << Comb(52,5) << endl;
   return 0;
}
