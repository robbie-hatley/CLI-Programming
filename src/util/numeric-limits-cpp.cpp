// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

// numeric-limits-cpp.cpp

#include <iostream>
#include <limits>

using std::cout;
using std::endl;
using std::numeric_limits;

int main(void)
{
   cout
   << "INTEGER TYPES:               "                                                 << endl
   << "short maximum:               " << numeric_limits<short>::max()                 << endl
   << "short minimum:               " << numeric_limits<short>::min()                 << endl
   << "short digits10:              " << numeric_limits<short>::digits10              << endl
   << "unsigned short maximum:      " << numeric_limits<unsigned short>::max()        << endl
   << "unsigned short minimum:      " << numeric_limits<unsigned short>::min()        << endl
   << "unsigned short digits10:     " << numeric_limits<unsigned short>::digits10     << endl
   << "int maximum:                 " << numeric_limits<int>::max()                   << endl
   << "int minimum:                 " << numeric_limits<int>::min()                   << endl
   << "int digits10:                " << numeric_limits<int>::digits10                << endl
   << "unsigned int maximum:        " << numeric_limits<unsigned int>::max()          << endl
   << "unsigned int minimum:        " << numeric_limits<unsigned int>::min()          << endl
   << "unsigned int digits10:       " << numeric_limits<unsigned int>::digits10       << endl
   << "long maximum:                " << numeric_limits<long>::max()                  << endl
   << "long minimum:                " << numeric_limits<long>::min()                  << endl
   << "long digits10:               " << numeric_limits<long>::digits10               << endl
   << "unsigned long maximum:       " << numeric_limits<unsigned long>::max()         << endl
   << "unsigned long minimum:       " << numeric_limits<unsigned long>::min()         << endl
   << "unsigned long digits10:      " << numeric_limits<unsigned long>::digits10      << endl
   << "long long maximum:           " << numeric_limits<long long>::max()             << endl
   << "long long minimum:           " << numeric_limits<long long>::min()             << endl
   << "long long digits10:          " << numeric_limits<long long>::digits10          << endl
   << "unsigned long long maximum:  " << numeric_limits<unsigned long long>::max()    << endl
   << "unsigned long long minimum:  " << numeric_limits<unsigned long long>::min()    << endl
   << "unsigned long long digits10: " << numeric_limits<unsigned long long>::digits10 << endl
   << "FLOATING-POINT TYPES:        "                                                 << endl
   << "float maximum:               " << numeric_limits<float>::max()                 << endl
   << "float minimum:               " << numeric_limits<float>::min()                 << endl
   << "float digits10:              " << numeric_limits<float>::digits10              << endl
   << "float epsilon:               " << numeric_limits<float>::epsilon()             << endl
   << "double maximum:              " << numeric_limits<double>::max()                << endl
   << "double minimum:              " << numeric_limits<double>::min()                << endl
   << "double digits10:             " << numeric_limits<double>::digits10             << endl
   << "double epsilon:              " << numeric_limits<double>::epsilon()            << endl
   << "long double maximum:         " << numeric_limits<long double>::max()           << endl
   << "long double minimum:         " << numeric_limits<long double>::min()           << endl
   << "long double digits10:        " << numeric_limits<long double>::digits10        << endl
   << "long double epsilon:         " << numeric_limits<long double>::epsilon()       << endl;
   return 0;
}
