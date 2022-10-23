// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/****************************************************************************\
 * File name:     roman.cpp
 * Title:         Roman Numeral Generator
 * Executable:    roman.exe
 * Authorship:    Written by Robbie Hatley on Wednesday January 15, 2003.
 * Inputs:        One command-line argument: an Arabic numeral, 0-3999.
 * Outputs:       Prints equivalent Roman numeral.
 * Dependencies:  Uses std lib functions only (cstdlib, iostream, sstream, string).
 *                Uses no 3rd-party libraries.
 * Edit history:
 *    Sat May 03, 2003 - Wrote it.
 *    Sun May 15, 2011 - Cleaned up these comments.
\****************************************************************************/

#include <cstdlib>

#include <iostream>
#include <sstream>
#include <string>

using std::cout;
using std::cerr;
using std::endl;
using std::string;
using std::stringstream;

class RomanNumeral
{
  public:
    explicit RomanNumeral(int aa) : a(aa), r("") {r=convert(a);}
    static string convert(int i);
    string Roman() {return r;}
    int Arabic() {return a;}
  private:
    static const string table[6][10]; // Array, not vector!
    int    a; // Arabic representation of number
    string r; // Roman  representation of number
};

//         1 = I
//         5 = V
//        10 = X
//        50 = L
//       100 = C
//       500 = D
//      1000 = M
//      5000 = P (unofficial)
//     10000 = Q (unofficial)
//     50000 = S (unofficial)
//    100000 = T (unofficial)
//    500000 = W (unofficial)
//   1000000 = Z (unofficial)

const string RomanNumeral::table[6][10]=
{
  {"", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"},
  {"", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"},
  {"", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"},
  {"", "M", "MM", "MMM", "MP", "P", "PM", "PMM", "PMMM", "MQ"},
  {"", "Q", "QQ", "QQQ", "QS", "S", "SQ", "SQQ", "SQQQ", "QT"},
  {"", "T", "TT", "TTT", "TW", "W", "WT", "WTT", "WTTT", "TZ"}
};

// Now try doing THAT with a friggin' vector!!!  Not.
// ALWAYS use built-in arrays, not vectors, for all multi-dimensional 
// static const member variables.  That is the ONLY way to initialize 
// such variables to a table of values.  Any arguments?

string RomanNumeral::convert(int i)
{
  string result="";
  if (i>999999)
  {
    cerr << "Error: cannot convert number greater than 999999." << endl;
    return string("");
  }
  if (i<0)
  {
    cerr << "Error: cannot convert negative number." << endl;
    return string("");
  }
  string s="";
  stringstream ss1;
  ss1 << i;
  ss1 >> s;
  char c_digit;    // digit character
  int  i_digit;    // digit integer
  for ( unsigned int dx = 0 ; dx < s.size() ; ++dx )
  {
    c_digit=s[dx];
    stringstream ss2;
    ss2 << c_digit;
    ss2 >> i_digit;
    result += table[s.size()-dx-1][i_digit];
  }
  return result;
}

int main(int argc, char *argv[])
{
  for ( int i = 1 ; i < argc ; ++i)
  {
    RomanNumeral rn (atoi(argv[i]));
    cout << rn.Arabic() << "=" << rn.Roman() << endl;
  }
  return 0;
}
