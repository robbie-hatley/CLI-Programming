// remove-digits.cpp
#include <iostream>
#include <string>
#include <regex>
using namespace std;
int main (void)
{
   string MyString;
   cout << "Enter a string: "             << endl;
   getline(cin, MyString);
   cout << "You entered:"                 << endl
        << MyString                       << endl;
   cout << "String with digits removed:"  << endl;
   regex digit("[[:digit:]]");
   cout << regex_replace(MyString, digit, "") << endl;
   return 0;
}