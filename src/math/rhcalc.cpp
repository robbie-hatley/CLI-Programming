/************************************************************************************************************\
 * File name:       rhcalc.cpp
 * Note:            (No, I can't call it calc.cpp.  That launches the WINDOWS calculator instead.)
 * Program name:    Calculator
 * Author:          Robbie Hatley
 * Date written:    Saturday March 27, 2004
 * Edit history:
 *    Fri Jun 11, 2004
 *    Tue Sep 06, 2005
 * Description:     A command-line calculator
\************************************************************************************************************/

// ============= PREPROCESSOR DIRECTIVES: ====================================================================

// Include old C headers:
#include <cstdlib>
#include <cstring>
#include <cctype>
#include <cmath>

// Include new C++ headers:
#include <iostream>
#include <string>
#include <utility>
#include <map>

// Include personal class-library headers:
#include "rhutil.hpp"
#include "rhmath.hpp"

// ============= DECLARATIONS: ===============================================================================

using std::cout;
using std::endl;
using std::list;

namespace Eval
{
   using namespace rhutil;
   using namespace rhmath;

   using std::cout;
   using std::cerr;
   using std::endl;
   using std::string;
   using std::atof;
   using std::pair;
   using std::map;
   using std::make_pair;

   // Note that the following functions all have the same signature; that is so they can all be called by
   // pointer from the same code:
   inline double Ident   (double,   double b) {return   b;}
   inline double Invert  (double,   double b) {return  -b;}
   inline double Plus    (double a, double b) {return a+b;}
   inline double Minus   (double a, double b) {return a-b;}
   inline double Times   (double a, double b) {return a*b;}
   inline double Over    (double a, double b) {return a/b;}

   enum OpCodeType
   {
      IDENT         = 1001,
      INVERT        = 1002,
      PLUS          = 2001,
      MINUS         = 2002,
      TIMES         = 2003,
      OVER          = 2004
   };

   typedef double (*OpFuncPtrType)(double, double);

   std::map<OpCodeType, OpFuncPtrType> Operations;

   void InitOps(void);

   double Expression(string E);
}


int main(int, char* argv[])
{
   using namespace Eval;
   InitOps();
   string Input (argv[1]);
   cout << Input << " = " << Expression(Input) << endl;
   return 0;
}


void Eval::InitOps(void)
{
   Operations.insert(make_pair(IDENT,   Ident ));
   Operations.insert(make_pair(INVERT,  Invert));
   Operations.insert(make_pair(PLUS,    Plus  ));
   Operations.insert(make_pair(MINUS,   Minus ));
   Operations.insert(make_pair(TIMES,   Times ));
   Operations.insert(make_pair(OVER,    Over  ));
   return;
}


double Eval::Expression(string E)
{
   // Strip-out any whitespaces:
   E = rhutil::StripChar(E, ' ');
   E = rhutil::StripChar(E, '\t');

   // If this expression is a number, return its value:
   if (IsNumber(E)) {return atof(E.c_str());}

   int ParenLevel = 0; // current parenthetical level
   int MaxPriority = 0; // highest priority (lowest precedence; shallowest recursive level)
   string::size_type Size = E.size(); // size of string
   string::size_type i = 0;           // current position within string
   string::size_type OpPos = 0;       // position of highest-priority op found so far
   OpCodeType OpCode = IDENT;         // op-code  of highest-priority op found so far
   bool ParenZero = false; // did we attain paren. level zero after first char. but before last char.?

   // Parse the expression, noting whether paren-level-zero ops were found, and what the position of
   // the first of each type of found op was.
   for (i=0; i<Size; ++i)
   {
      switch (E[i])
      {
         case '(':
            ++ParenLevel;
            break;
         case ')':
            --ParenLevel;
            break;
         case '+':
            // Binary op.:
            if (i > 0 and i < Size-1)                       // If not first or last character,
            {
               if (')' == E[i-1] or isdigit(E[i-1]))        // and if char. to left is digit or ')',
               {                                            // then it's a binary operation.
                  if (0 == ParenLevel and MaxPriority < 3)  // Catch first paren-level-zero priority-3 binary op..
                  {
                     MaxPriority = 3;                       // Set max. priority to 3,
                     OpCode = PLUS;                         // set op. code to E[i],
                     OpPos   = i;                           // set op. position to i,
                     break;                                 // and break from switch.
                  }
               }
            }
            // Unary op. (identity):
            if (i < Size-1)                                 // If not last character,
            {
               if (!isdigit(E[i+1]))                        // and if not a sign on a number,
               {                                            // it's a unary op. (identity).
                  if (0 == ParenLevel and 1 > MaxPriority)  // Catch first paren-level-zero priority-1 unary op..
                  {
                     MaxPriority = 1;                       // Set max. priority to 1,
                     OpCode = IDENT;                        // set op. code to E[i],
                     OpPos   = i;                           // set op. position to i,
                     break;                                 // and break from switch.
                  }
               }
            }
            // If we get to here, this '+' sign is a syntax error, so ignore it:
            break;
         case '-':
            // Binary op.:
            if (i > 0 and i < Size-1)                       // If not first or last character,
            {
               if (')' == E[i-1] or isdigit(E[i-1]))        // and if char. to left is digit or ')',
               {                                            // then it's a binary operation.
                  if (0 == ParenLevel and 3 > MaxPriority)  // Catch first paren-level-zero priority-3 binary op..
                  {
                     MaxPriority = 3;                       // Set max. priority to 3,
                     OpCode = MINUS;                        // set op. code to E[i],
                     OpPos   = i;                           // set op. position to i,
                     break;                                 // and break from switch.
                  }
               }
            }
            // Unary op. (additive inverse):
            if (i < Size-1)                                 // If not last character,
            {
               if (!isdigit(E[i+1]))                        // and if not a sign on a number,
               {                                            // it's a unary op. (additive inverse).
                  if (0 == ParenLevel and 1 > MaxPriority)  // Catch first paren-level-zero priority-1 unary op..
                  {
                     MaxPriority = 1;                       // Set max. priority to 1,
                     OpCode = INVERT;                       // set op. code to E[i],
                     OpPos   = i;                           // set op. position to i,
                     break;                                 // and break from switch.
                  }
               }
            }
            // If we get to here, this '-' sign is a syntax error, so ignore it:
            break;
         case '*':
            if (i > 0 and i < Size-1)                       // If not first or last character,
            {
               if (')' == E[i-1] or isdigit(E[i-1]))        // and if char. to left is digit or ')',
               {                                            // then it's a binary operation (multiplication).
                  if (0 == ParenLevel and 2 > MaxPriority)  // Catch first paren-level-zero priority-2 binary op..
                  {
                     MaxPriority = 2;                       // Set max. priority to 2,
                     OpCode = TIMES;                        // set op. code to E[i],
                     OpPos   = i;                           // set op. position to i,
                     break;                                 // and break from switch.
                  }
               }
            }
            break;
         case '/':
            if (i > 0 and i < Size-1)                       // If not first or last character,
            {
               if (')' == E[i-1] or isdigit(E[i-1]))        // and if char. to left is digit or ')',
               {                                            // then it's a binary operation (division).
                  if (0 == ParenLevel and 2 > MaxPriority)  // Catch first paren-level-zero priority-2 binary op..
                  {
                     MaxPriority = 2;                       // Set max. priority to 2,
                     OpCode = OVER;                         // set op. code to E[i],
                     OpPos   = i;                           // set op. position to i,
                     break;                                 // and break from switch.
                  }
               }
            }
            break;
      } // End switch (E[i])

      // If paren-level zero has been attained before final character, set ParenZero flag:
      if (0 == ParenLevel and i<Size-1)
      {
         ParenZero = true;
      }

      // If paren-level ever gets negative, the user is a moron, so print error message and exit:
      if (ParenLevel < 0)
      {
         cerr << "ERROR: Too many right parentheses!" << endl;
         exit(666);
      }

   } // End for (each i)

   // If paren-level is now positive, the user is a moron, so print error message and exit:
   if (ParenLevel > 0)
   {
      cerr << "ERROR: Too many right parentheses!" << endl;
      exit(666);
   }

   // If the first character is '(' and the last character is ')' and ParenLevel never attained zero
   // after the opening left paren, strip parentheses and recurse:
   if ('(' == E[0] and ')' == E[Size-1] and not ParenZero)
   {
      return Expression(E.substr(1, Size-2));
   }

   // If MaxPriority is greater than 1, we found a paren-level-zero binary operation.   Glom the string as
   // two chunks separated by the highest-priority binary operation we found.   Send those two chunks
   // recursively back to Expression() and feed the two results into the function associated with the op..
   // This queues the highest-priority (lowest-precedence) operations to be executed LAST (at the shallowest
   // recursive levels), and forces the lowest-priority (highest-precedence) operators to execute FIRST
   // (at the deepest recursive levels).

   // Note that "priority", then, means "glomming priority", in that we first use the lowest-precedence
   // operators to glom the string into substrings (which are fed to the second recursive level); then use the
   // lowest-priority operators in the substrings to glom them to sub-sub-strings (which are fed to the third
   // recursive level); etc.   That way no actual operations are performed until the smallest substrings trickle
   // down to the lowest recursive level.   The the highest-precedence operations are performed, then the
   // second-highest, etc., going back up the recursive return trail, until finally the lowest-precedence
   // operations are performed at the highest recursive levels.

   // I believe the computer-science term for this nightmare is "recursive descent", if I'm not mistaken.
   // (This seems to carry overtones of "descent into Hell", which is not entirely inappropriate.)

   if (MaxPriority > 1) // If a paren-level-zero binary operation was found:
   {
      string Left   = E.substr(    0       ,      OpPos    );
      string Right = E.substr(OpPos+1 , Size-1-OpPos);
      return Operations[OpCode](Expression(Left), Expression(Right));
   }

   else if (MaxPriority == 1) // If a paren-level-zero unary operation was found:
   {
      string Right = E.substr(OpPos+1 , Size-1-OpPos);
      return Operations[OpCode](0, Expression(Right));
   }

   // If we get to here, the input string is neither a number, nor a mathematical expression,
   // so print an error message and exit program:
   else
   {
      cerr << "ERROR: invalid expression \"" << E << "\"." << endl;
      exit(666);
   }
}
