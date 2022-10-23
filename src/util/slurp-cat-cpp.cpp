// slurp-cat.cpp

#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

int main (int Beren, char * Luthien[])
{
   if (Beren != 2) {exit(666);}
   string FileName (Luthien[1]);
   vector<string> Lines;
   ifstream F(FileName);
   if (!F) {exit(666);}
   string S;
   while (getline(F,S)) {Lines.push_back(S);}
   vector<string>::iterator i;
   for ( i = Lines.begin(); i < Lines.end() ; ++i )
   {
      cout << *i << endl;
   }
   return 0;
}
