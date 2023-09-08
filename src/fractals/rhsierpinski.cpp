/************************************************************************************************************\
 * rhsierpinski.cpp
 * Robbie Hatley's Sierpinski Carpet program.
 * Last updated Sunday April 21, 2003.
 * Makes 729x729 Sierpinski carpet bitmap.
 * Argument is file name.
 * To make, link with ../lib/rhbitmap.o
 *
 * Written by Robbie on Saturday February 16, 2002.
 * Edit history:
 * Sat Feb 16, 2002: Wrote first draft.
 * Thu Sep 07, 2023: Renamed from "sierpinski.cpp" to "rhsierpinski.cpp". Increased width from 78 to 110.
\************************************************************************************************************/

#include <cctype>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <iostream>
#include <new>

#include "rhbitmap.hpp"

using rhbitmap::Bitmap;
using rhbitmap::Color;
using rhbitmap::Graph;
using std::cerr;
using std::cin;
using std::cout;
using std::endl;

//========== Data-Type Declarations: ==========//

struct Rectangle {
    unsigned bottom;
    unsigned top;
    unsigned left;
    unsigned right;
};

//========== Global Variables: ==========//

Bitmap carpet(729, 729, 1, false);

//========== Function Prototypes: ==========//

void sierpinski(Rectangle a, unsigned depth);
void gobble(Rectangle a);
void bomb(void);

//========== Functions: ==========//

int main(int Rick, char** Mindy)
{
    if (Rick != 2)
        return 666;
    std::string bmpfilename(Mindy[1]);
    carpet.settable(0, Color(0, 0, 0)); // Black foreground.
    carpet.settable(1, Color(192, 192, 192)); // Grey  background.
    unsigned i, j, hortCount, vertCount;
    Rectangle r0;
    r0.bottom = 0;
    r0.top = 728;
    r0.left = 0;
    r0.right = 728;
    hortCount = r0.right - r0.left + 1;
    vertCount = r0.top - r0.bottom + 1;
    if (0 != hortCount % 729 || 0 != vertCount % 729)
        bomb();
    for (j = r0.bottom; j <= r0.top; ++j) {
        for (i = r0.left; i <= r0.right; ++i) {
            carpet.setcolor(i, j, 1);
        }
    }
    sierpinski(r0, 1);

    // Write bitmap to file:
    carpet.filewrite(bmpfilename);

    // Display image:
    // std::string Command {};
    // Command = std::string("chmod u=rwx,g=rwx,o=rx '") + bmpfilename + "'";
    // std::system(Command.c_str());
    // Command = std::string("cmd /C '") + bmpfilename + "' &";
    // std::system(Command.c_str());

    // Return to operating system:
    return 0;
}

void sierpinski(Rectangle a, unsigned depth)
{
    // Divide Rectangle a into nine equal square subregions:
    //            Col A                Col B               Col C
    //       -------------------------------------------------------------
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    // Row 3 |     r1          |         r2         |       r3           |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       -------------------------------------------------------------
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    // Row 2 |       r4        |        r5          |        r6          |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       -------------------------------------------------------------
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    // Row 1 |      r7         |         r8         |         r9         |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       |                 |                    |                    |
    //       -------------------------------------------------------------
    unsigned hortCount, vertCount, subHortCount, subVertCount;
    hortCount = a.right - a.left + 1;
    vertCount = a.top - a.bottom + 1;
    if (0 != hortCount % 3 || 0 != vertCount % 3) {
        bomb();
    }
    subHortCount = hortCount / 3;
    subVertCount = vertCount / 3;
    Rectangle r1, r2, r3, r4, r5, r6, r7, r8, r9;
    r1.left = r4.left = r7.left = a.left;
    r2.left = r5.left = r8.left = a.left + subHortCount;
    r3.left = r6.left = r9.left = a.left + 2 * subHortCount;
    r3.right = r6.right = r9.right = a.right;
    r2.right = r5.right = r8.right = a.right - subHortCount;
    r1.right = r4.right = r7.right = a.right - 2 * subHortCount;
    r7.bottom = r8.bottom = r9.bottom = a.bottom;
    r4.bottom = r5.bottom = r6.bottom = a.bottom + subVertCount;
    r1.bottom = r2.bottom = r3.bottom = a.bottom + 2 * subVertCount;
    r1.top = r2.top = r3.top = a.top;
    r4.top = r5.top = r6.top = a.top - subVertCount;
    r7.top = r8.top = r9.top = a.top - 2 * subVertCount;
    gobble(r5);
    if (depth < 6) {
        sierpinski(r1, depth + 1);
        sierpinski(r2, depth + 1);
        sierpinski(r3, depth + 1);
        sierpinski(r4, depth + 1);
        sierpinski(r6, depth + 1);
        sierpinski(r7, depth + 1);
        sierpinski(r8, depth + 1);
        sierpinski(r9, depth + 1);
    }
    return;
}

void gobble(Rectangle a)
{
    unsigned i, j;
    for (j = a.bottom; j <= a.top; ++j) {
        for (i = a.left; i <= a.right; ++i) {
            carpet.setcolor(i, j, 0);
        }
    }
    return;
}

void bomb(void)
{
    cerr << "Division error; quitting." << endl;
    exit(1);
}
