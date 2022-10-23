

/************************************************************************************************************\
 * Program name:  Eight Queens
 * Description:   Graphs solutions to the "Eight Queens" problem.
 * File name:     eight-queens.cpp
 * Source for:    eight-queens.cpp
 * Author:        Robbie Hatley
 * Date written:  Tue. Jun. 07, 2005
 * Inputs:        None.
 * Outputs:       Outputs solutions to "Eight Queens" problem on stdout .
 * To make:       No dependencies.  Just compile:  gpp eight-queens.cpp -o eight-queens.exe
 * Edit History:
 *    Tue. Jun. 07, 2005 - Removed command-line input controling output.  Just outputs to stdout now.
\************************************************************************************************************/

#include <cstring>
#include <cmath>
#include <iostream>
#include <iomanip>
#include <string>

namespace EQ
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::setw;
   using std::setfill;
   using std::string;
   using std::abs;
   
   // The trouble with nybbles is, they're 4 bits, but I need 3;
   // hence, instead of nybbles, I use Trybbles...
   
   struct Trybbles
   {
      unsigned short trybble0 : 3; // Little endian; this end incremented first if unioned as unsigned long.
      unsigned short trybble1 : 3;
      unsigned short trybble2 : 3;
      unsigned short trybble3 : 3;
      unsigned short trybble4 : 3;
      unsigned short trybble5 : 3;
      unsigned short trybble6 : 3;
      unsigned short trybble7 : 3;
      unsigned short dummy    : 8; // This is the "big" end.
   };

   union LongTryb
   {
      unsigned long  L;
      Trybbles       T;
   };
   
   class ChessBoard
   {
      public:
         ChessBoard(LongTryb T)
         {
            int Positions[8];
            Positions[0] = T.T.trybble0;
            Positions[1] = T.T.trybble1;
            Positions[2] = T.T.trybble2;
            Positions[3] = T.T.trybble3;
            Positions[4] = T.T.trybble4;
            Positions[5] = T.T.trybble5;
            Positions[6] = T.T.trybble6;
            Positions[7] = T.T.trybble7;
            strncpy(board[0], "0 1 2 3 4 5 6 7  \0", 18);
            for (int j=0; j<8; ++j)
            {
               for (int i=0; i<8; ++i)
               {
                  if (Positions[i] == j)
                  {
                     board[j+1][2*i+0] = 'Q';
                     board[j+1][2*i+1] = ' ';
                  }
                  else
                  {
                     board[j+1][2*i+0] = ' ';
                     board[j+1][2*i+1] = ' ';
                  }
               }
               board[j+1][16] = static_cast<char>(48+j);
               board[j+1][17] = '\0';
            }
         }
         void Print(void)
         {
            for (int j=0; j<9; ++j)
            {
               cout << board[j] << endl;
            }
            return;
         }
      private:
         char board[9][18];
   };
   
   bool War           (LongTryb const & T);
   void PrintSolution (LongTryb const & T);
   
}


int main(void)
{
   using namespace EQ;
   static int Count = 0;
   EQ::LongTryb i;
   i.L = 0;
   for (i.L=0; i.L<16777216; ++i.L) // 16777216 == 8^8
   {
      if (!EQ::War(i))
      {
         EQ::ChessBoard Board (i);
         ++Count;
         cout << "Solution #" << Count << " is:" << endl;
         Board.Print();
         cout << endl << endl;
      }
   }
   return 0;
}


bool 
EQ::
War
   (
      LongTryb const & T
   )
{
   bool War = false;
   int Positions[8];
   Positions[0] = T.T.trybble0;
   Positions[1] = T.T.trybble1;
   Positions[2] = T.T.trybble2;
   Positions[3] = T.T.trybble3;
   Positions[4] = T.T.trybble4;
   Positions[5] = T.T.trybble5;
   Positions[6] = T.T.trybble6;
   Positions[7] = T.T.trybble7;
   for (int i=0; i<7; ++i) // for each queen except the right-most...
   {
      for (int j=i+1; j<8; ++j) // for each neighboring queen to the right...
      {
         if                                               // Vertical war can't happen (one queen per column).
            (
               Positions[i] == Positions[j]               // If horizontal war happens,
               ||
               abs(i-j) == abs(Positions[i]-Positions[j]) // or if diagonal war happens,
            )
         {
            War = true;                                   // set "War" flag
            break;                                        // and break from inner for loop.
         }
      }
      if (War) break;                                     // If War, break from outer for loop.
   }
   return War;                                            // Return War flag.
}


// Disabled debug stuff:
#if 0
   /*
   i.L = 1;
   cout
      << "Finished setting i.L = 1 ."         << endl
      << "Trybble 0 = " << i.T.trybble0 << endl
      << "Trybble 1 = " << i.T.trybble1 << endl
      << "Trybble 2 = " << i.T.trybble2 << endl
      << "Trybble 3 = " << i.T.trybble3 << endl
      << "Trybble 4 = " << i.T.trybble4 << endl
      << "Trybble 5 = " << i.T.trybble5 << endl
      << "Trybble 6 = " << i.T.trybble6 << endl
      << "Trybble 7 = " << i.T.trybble7 << endl
      << "Dummy     = " << i.T.dummy    << endl;
   i.L = 8357;
   cout
      << "Finished setting i.L = 8357 ."         << endl
      << "Trybble 0 = " << i.T.trybble0 << endl
      << "Trybble 1 = " << i.T.trybble1 << endl
      << "Trybble 2 = " << i.T.trybble2 << endl
      << "Trybble 3 = " << i.T.trybble3 << endl
      << "Trybble 4 = " << i.T.trybble4 << endl
      << "Trybble 5 = " << i.T.trybble5 << endl
      << "Trybble 6 = " << i.T.trybble6 << endl
      << "Trybble 7 = " << i.T.trybble7 << endl
      << "Dummy     = " << i.T.dummy    << endl;
   i.L = rhmath::Pow(8L,8L) - 1;
   cout
      << "Finished setting i.L = 8^8 - 1 ."         << endl
      << "Trybble 0 = " << i.T.trybble0 << endl
      << "Trybble 1 = " << i.T.trybble1 << endl
      << "Trybble 2 = " << i.T.trybble2 << endl
      << "Trybble 3 = " << i.T.trybble3 << endl
      << "Trybble 4 = " << i.T.trybble4 << endl
      << "Trybble 5 = " << i.T.trybble5 << endl
      << "Trybble 6 = " << i.T.trybble6 << endl
      << "Trybble 7 = " << i.T.trybble7 << endl
      << "Dummy     = " << i.T.dummy    << endl;
   i.L = 438992765;
   cout
      << "Finished setting i.L = 438992765 ."      << endl
      << "Trybble 0 = " << i.T.trybble0 << endl
      << "Trybble 1 = " << i.T.trybble1 << endl
      << "Trybble 2 = " << i.T.trybble2 << endl
      << "Trybble 3 = " << i.T.trybble3 << endl
      << "Trybble 4 = " << i.T.trybble4 << endl
      << "Trybble 5 = " << i.T.trybble5 << endl
      << "Trybble 6 = " << i.T.trybble6 << endl
      << "Trybble 7 = " << i.T.trybble7 << endl
      << "Dummy     = " << i.T.dummy    << endl;
   */
#endif
