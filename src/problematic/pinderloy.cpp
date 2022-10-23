/************************************************************************************************************\
 * Program name:  Pinderloy
 * Description:   Creates an html file which renders pics from the Pinderloy web site.
 *                
 * File name:     pinderloy.cpp
 * Source for:    pinderloy.exe
 * Author:        Robbie Hatley
 * Date written:  circa 2002
 * Notes:         To use, redirect output from stdout to a file, using ">", like so:
 *                pinderloy > pind.html
\************************************************************************************************************/

#include <iostream>

int main(void)
{
   using std::cout;
   using std::endl;
   cout << "<html><head><title>asdf</title></head><body><div>" << endl;
   for ( int i = 1 ; i < 373 ; ++i )
   {
      cout
         << "<img src=\""
         << "http://www.pinderloy.com/photo/photo/images/p0"
         << i
         << "_jpg.jpg\" />" << endl;
   }
   cout << "</div></body></html>" << endl;
   return 0;
}
