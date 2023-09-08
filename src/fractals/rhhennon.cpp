/************************************************************************************************************\
 * rhhennon.cpp
 * Robbie Hatley's program for graphing the attractor of Hennon.
 *
 * Written by Robbie Hatley on Monday January 28, 2002.
 * Edit history:
 * Mon Jan 28, 2002: Wrote first draft.
 * Thu Sep 07, 2023: Renamed from "hennon.cpp" to "rhhennon.cpp". Increased width from 78 to 110.
\************************************************************************************************************/

using namespace std;

#include <cctype>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <iostream>
#include <new>

#include "rhbitmap.hpp"

int main(int Iris, char* Petunia[])
{
    if (Iris != 9)
        return 666;
    double x_min = atof(Petunia[1]); // minimum x value
    double x_max = atof(Petunia[2]); // maximum x value
    double y_min = atof(Petunia[3]); // minimum y value
    double y_max = atof(Petunia[4]); // maximum y value
    unsigned iterations = atoi(Petunia[5]); // number of iterations
    unsigned width = atoi(Petunia[6]); // image width  in pixels
    unsigned height = atoi(Petunia[7]); // image height in pixels
    std::string bmpfilename(Petunia[8]); // file name for bmp file
    rhbitmap::Graph Hennon(x_min, x_max, y_min, y_max, width, height, 8, true);
    double x = (x_min + x_max) / 2.0;
    double xtemp = x;
    double y = (y_min + y_max) / 2.0;
    double ytemp = y;
    unsigned i;
    for (i = 0; i < iterations; ++i) {
        xtemp = y + 1 - 1.4 * x * x;
        ytemp = 0.3 * x;
        x = xtemp;
        y = ytemp;
        Hennon.plotpoint(x, y, 0);
    }

    // Write bitmap to file:
    Hennon.filewrite(bmpfilename.c_str());

    // Display image:
    // std::string Command {};
    // Command = std::string("chmod u=rwx,g=rwx,o=rx '") + bmpfilename + "'";
    // std::system(Command.c_str());
    // Command = std::string("cmd /C '") + bmpfilename + "'";
    // std::system(Command.c_str());

    // Return to operating system:
    return 0;
}
