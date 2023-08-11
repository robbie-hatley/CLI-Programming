/// This is a 110-character-wide ASCII-encoded C++ header file.
#ifndef RH_BITMAP_CPP_HEADER_ALREADY_INCLUDED
#define RH_BITMAP_CPP_HEADER_ALREADY_INCLUDED
/************************************************************************************************************\
 * rhbitmap.hpp
 * Bitmap Classes Interface File
 * Instructions:         See "Instructions"    section below.
 * Technical Notes:      See "Technical Notes" section below.
 * Development Log:      See "Development Log" section at bottom of this file.
 * Author:               Robbie Hatley
 * Edit history:
 *    Sun Jan 13, 2002 - Started writing it.
 *    Thu May 01, 2003 - Various edits.
 *    Sat Jun 26, 2004 - Various edits.
 *    Thu Sep 23, 2004 - Added comments, removed packing from private members of Bitmap, reformatted.
 *    Sun Sep 26, 2004 - Rewrote RLE8 & filewrite; corrected errors in setcolor() and getcolor();
 *                       Corrected major errors in my understanding of how data is stored in bitmaps.
 *    Mon Oct 04, 2004 - Inverted semantics of hor_scale and ver_scale in Graph.
 *                       Corrected errors in getx(), gety(), geti(), and getj().
 *    Sat Nov 20, 2004 - Inserted compile conditions in rhbitmap.h for MS-VC++6.0
 *    Tue Jun 07, 2005 - #include rhtypedef.h in rhbitmap.h instead of using separate typedefs.
 *                       Also got rid of unused macro RHBITMAP_CPP in rhbitmap.cpp.
 *    Tue Aug 02, 2005 - Added "#include <wingdi.h>".
 *    Sun Feb 17, 2008 - Got rid of tabs that had gotten into the file.  Also got rid of  "ignored 'packed'
 *                       attributes" warnings by moving packing commands to after "struct" or "class".
 *    Sat Apr 09, 2016 - Got rid of all unnecessary usage of uint_8, uint_16, uint_32, replacing most such
 *                       usages with just "int", dramatically simplifying the programming and getting rid
 *                       of hundreds of warnings about dangerous conversions between types.
 *                       Also got rid of headers and other junk left over from DJGPP days. (Now using
 *                       an Asus notebook computer with Intel Core I5 CPU, Windows 10, Cygwin, MinTTY, Bash,
 *                       and Cygwin's port of GNU stuff (gcc, g++, Perl, etc), so a large amount of code
 *                       refactoring was necessary to change DJGPP-dependent stuff to work with my current
 *                       setup.
 *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Instructions:
 *
 * Instructions for compiling this library:
 * Compile using GNU g++, or other C++ compiler which has the GNU "__attribute__ ((packed))" extention
 * available, as 3 of the structs in this library use packing. Make sure that "rhbitmap.h" is in the
 * compiler's search path. Set the compiler to produce object file "rhbitmap.o" only. Do not link.
 * Leave symbol table intact if you want to do debugging. Archive object "rhbitmap.o" into library
 * "librh.a", because my programs will be looking for it there. Typical command lines:
 * g++ -I /rhe/include -Wall -std=gnu++14 -Og -c /rhe/src/librh/rhbitmap.cpp -o /rhe/lib/rhbitmap.o
 * ar -r /rhe/lib/librh.a /rhe/lib/rhbitmap.o
 * rm /rhe/lib/rhbitmap.o
 *
 * Instructions for using this library in a program:
 *   Include the following at the start of the program:
 *     #include "../lib/bitmap.h"
 *   Then compile and link like this:
 *     g++ -I /rhe/include -Wall -std=gnu++14 -Og blat.cpp -L /rhe/lib[64|32|li] -L /lib -lrh -lm -o /rhe/bin[64|32|li]/blat.exe
 *   where "blat" is any program that uses this library.
 *
 * Using "Color" objects:
 *   Objects of class "Color" contain four uint8_t elements named "red", "green", "blue", and "dummy".
 *   The "red", "green", and "blue" bytes are intensity numbers from 0 to 255, with 0 = zero intensity and
 *   255 = maximum intensity. (The "dummy" byte is functionless padding required by the "bmp" standard.)
 *   Hence if red=130, green=120, blue=120, the color is reddish-grey.
 *   The default color of a Color object is cream (240, 230, 220).
 *   Color has three constructors and an assignment operator:
 *     Color();                   // (explicit default constructor)
 *     Color(unsigned char r, unsigned char g, unsigned char b);
 *                                // (explicit parameterized constructor)
 *     Color(Color &color);       // (implicit copy constructor)
 *     operator=(Color &color);   // (implicit assignment operator)
 *   To make a new cream (240, 230, 220) Color object:
 *     Color mycolor;
 *   To make a new Color object of user-specified color:
 *     Color mycolor (243, 10, 157)
 *   To assign one Color object to another:
 *     color1=color2;
 *   To make a new Color object based on an old one:
 *     Color newcolor=oldcolor;
 *
 * Using "Bitmap" objects:
 *   Objects of class "Bitmap" are basically images in RAM of
 *   Microsoft Windows Device-Independent Bitmap files (*.bmp files).
 *   "Bitmap" objects are created by a parameterized constructor,
 *   with the height and width in pixels, bitcount in bits-per-pixel,
 *   and a true/false run-length compression flag as inputs:
 *   Bitmap::Bitmap(uint16_t w, uint16_t h, uint16_t b, bool c)
 *   The pixels are initialized to #F0F0F0 (light-grey) when a Bitmap object
 *   is constructed.  Any pixel can then be set to any color using the
 *   function:
 *     void Bitmap::setcolor(uint16_t x, uint16_t y, Color color)
 *   Example of use:
 *     // Make 800x600pixel, 24-bit, uncompressed bitmap:
 *     Bitmap mymap (800, 600, 24, 0);
 *     // Set point (500,335) of bitmap "mymap" to the color #807060:
 *     mymap.setcolor(500, 335, Color (0x80, 0x70, 0x60));
 *   The color of any pixel can be obtained using the function:
 *   Color getcolor(uint16_t i, uint16_t j)
 *   Example:
 *     Color muck = mymap.getcolor(333, 222);
 *   A Bitmap object can be written to a file using the function:
 *     void Bitmap::filewrite(char* path)
 *   Example:
 *     // write bitmap "mymap" to file "H:\Gallery\Mypics\foobar.bmp":
 *     mymap.filewrite("H:\Gallery\Mypics\foobar.bmp");
 *
 * Rows, Pixels, and Colors:
 *   The pixels of a bitmap are stored in horizontal rows (raster lines), not vertical columns.
 *   The raster lines are stored FROM BOTTOM TO TOP (***NOT*** TOP TO BOTTOM).
 *   The pixels within each line are stored from left to right.
 *
 *   That makes bitmap objects and files especially useful for graphing mathematical equations, because the
 *   pixel arrangement is like Quadrant I of a graph, with the origin (x,y)=(0,0) at the lower-left corner.
 *   The +y axis points upward along the left edge, and the +x axis points rightward along the bottom edge.
 *
 *   Be careful when setting colors of pixels not to confuse horizontal and vertical! Typically, you may
 *   be setting points using nested for() loops. Make the outer loop the VERTICAL loop (because data is
 *   stored by rows, not columns), and make the inner loop the HORIZONTAL loop. Typically your data will be
 *   in arrays of rows. In which case, the color-setting code will look something like this:
 *      for ( y = 0 ; y < height ; ++y ) // for each row
 *      {
 *         for ( x = 0 ; x < width ; ++x ) // for each column
 *         {
 *            bmp.setcolor (x, y, RandomColors[y][x]); // NOTE PLACEMENT OF x AND y !!!!
 *         }
 *      }
 *   That may look backwards, but it's not! The data matrix has to be addressed that way if the data is
 *   stored in rows, because the number of horizontal rows is the HEIGHT, and the number of vertical columns
 *   is the WIDTH, NOT vice-versa! This is a very easy thing to screw-up, and the result is program crashes,
 *   typically manifesting as "Segmentation fault (core dumped)" errors. So don't do that.
 *
 * Using "Datapoint" objects:
 *   "Datapoint" objects contain as members two "double" floating-
 *   point variables, "x" and "y",  and one "Color" object, "color".
 *   "Datapoint" objects can be directly plotted to a graph by using the
 *   "plotpoint" function of class "Graph".
 *   Example:
 *     Graph mygraph (-5, 5, -5, 5, 400, 400, 16, 1);
 *     Datapoint xxx (-2.4, -1.3, Color (13, 231, 201));
 *     mygraph.plotpoint(xxx);
 *
 * Using "Graph" objects:
 *   Class "Graph" is a derived class of, and a friend class to,
 *   class "Bitmap".  Each Graph object therefore contains an embedded
 *   Bitmap object, not as a member, but as a base.  Graph objects also
 *   contain members which serve as a reference frame which maps
 *   a rectangular region of the (x, y) plane onto the bitmap.
 *   "Graph" objects are created by a parameterized constructor:
 *     Graph::Graph(uint16_t h, uint16_t w,
 *       double xa, double xz, double ya, double yz);
 *   Example of instantiation:
 *     Graph mygraph (700, 450, 0.0, 17.0, -55.7, 55.7);
 *   Conversion between (i, j) pixel indices and (x, y) coordinates is done
 *   by these member functions:
 *     double getx(uint16_t i);
 *     double gety(uint16_t j);
 *     uint16_t geti(double x);
 *     uint16_t getj(double y);
 *   Data points can be plotted to the graph using this function:
 *     void Graph::plotpoint(const Datapoint &point); // plots a point
 *
 * See the "Technical Notes" section below for further information on these structures and classes.
 *
 * See the "Development notes" section at the bottom of this file for the development history of this module.
 *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Technical Notes:
 *
 * Packed Struct members:
 * Most compilers automatically pad the fields of structs with bytes of value 0x00 so that the field sizes
 * are always multiples of 4 bytes in size, for more-efficient data handling and storage.
 * However, in the Color, Bmfh, and Bmih structs below, it is imperative to turn-off this automatic padding,
 * because bmp file specs demand specific alignments, and padding of structs disrupts those alignments,
 * resulting in corrupted, unreadable bmp files when the structs are written to hard disk.  I disable
 * automatic padding in these structs by using the Gnu extension " __attribute__ ((packed)) " between
 * "class" or "struct" and the name of the class or struct.
 *
 * Little-Endian Issues:
 * Note that the hexidecimal numbers listed in Bmfh and Bmih under "Typical RAM image" are little-endian
 * images in RAM of typical values of the members in question.  For example, note that 40 == 0x28000000 ,
 * NOT 0x00000028 !!!  This is because most RAM or file dumpers display addresses increasing from left to
 * right, not right-to-left, and in a little-endian OS (such as all Microsoft OSs), numbers are stored in
 * RAM with the less significant bytes in the lower addresses, so a hexidecimal number such as 0x36A8, if
 * stored in a 32-bit unsigned integer, looks like 0xA8360000 in RAM!  This, like the packing issue above,
 * is critical to get right if a BMP file is to be uncorrupted.  Fortunately, Gnu seems to store numbers
 * in structs little-endian-ly, as the BMP file specs demand.  If other compilers are used, the code may
 * have to be altered to compensate.  (One approach would be to write to the struct one byte at a time,
 * using pointer arithmetic, then write from struct to hard disk the same way.)
 *
 * Color storage issues:
 *
 * For 24-bit images, each pixel is stored as a triplet of bytes, one byte indicating the intensity of each
 * of the three primary colors (red, green, blue). The color bytes within each pixel are stored in the order
 * (blue, green, red), NOT (red, green, blue) as you might expect.  This is because DOS and Windows use
 * little-endian rather than big-endian BYTE order. (But the BIT order within each byte is big-endian.)
 * Example: a bright orange pixel with HTML color description #FF8020 (Red=0xFF, Green = 0x80, Blue = 0x20)
 * would look like 0x2080FF in a RAM or disk dump. Also note that unlike in the color table, pixels in the
 * main bitmap data area of a 24-bit bitmap do not have fourth, "dummy" bytes. All pixels are stored as
 * 3-byte sequences, Blue-Green-Red. The ends of rows, however, do need to be zero-padded as necessary to
 * make rows end on 4-byte boundaries.
 *
 * For 8-bit images, each 8-bit data byte is an index to a table of 256 colors.
 *
 * For 4-bit images, each 4-bit data nybble is an index to a table of 16 colors.
 *
 * For 1-bit images, each data bit is an index to a table of 2 colors.
 *
 * Constant-Size Color Table:
 * The color table in class "Bitmap" in is always 256 colors, regardless of the actual color depth.
 * Either 0, or 2, or 16, or all 256 of these may be written to a file by Bitmap::filewrite().
 * Bits-per-pixel:        Colors:
 *       1                   2         (Each data  bit   is an index to one of these   2 colors.)
 *       4                  16         (Each data nybble is an index to one of these  16 colors.)
 *       8                 256         (Each data  byte  is an index to one of these 256 colors.)
 *      24                   0         (Each data Color  is a 24-bit color.  No table is used.)
\************************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <vector>
#include <string>

#include <cstdint>

#include "rhdefines.h"

typedef std::vector<uint8_t>::size_type vec_size_t;

namespace rhbitmap
{
// Snap-to-integer function:
double SnapToInt(double x, double p);

// 24-bit color data for a pixel (NOTE PACKING!):
class __attribute__ ((packed)) Color
{
   public:
      // default constructor:
      Color() : blue(240), green(240), red(240), dummy(0) {}
      // parameterized constructor:
      Color(int const & r, int const & g, int const & b);
      // Use implicit copy constructor.
      // Use implicit assignment operator.
      void set(int const & r, int const & g, int const & b);

   // Normally, the data section would be private, but I want these to be
   // easily writtable-to by any entity:
   public:
      uint8_t blue;
      uint8_t green;
      uint8_t red;
      uint8_t dummy;
};

// Inline inserter for writing Color objects to screen as 6-digit hexidecimal numbers:
inline std::ostream& operator<<(std::ostream& s, const Color& c)
{
   return                                     // return following expression:
   (                                          // begin expression
      s
         << '#'                               // output character '#'
         << std::hex                          // set base to hexidecimal
         << std::setw(6)                      // set field-width to 6
         << std::setfill('0')                 // set fill character to '0'
         << ((c.red<<16)+(c.green<<8)+c.blue) // output color in hex
         << std::dec                          // set base back to decimal
   );                                         // end expression
}

// Note: In the next two structs, all elements are fixed-size integer types, and all of these integers are
// stored in RAM in little-endian byte order, but NOT little-endian bit order. Hence, because each byte is
// 2 nybbles, and each nybble is 1 hexidecimal digit, the order of the hexidecimal digits is NOT simply
// reversed, but rather, the order of the PAIRS of digits are reversed. For example, 87285(dec) is usually
// written as 000154F5(hex), but the little-endian image in RAM is F5540100, NOT 5F451000. And the image on
// hard disk is the same as in RAM, so you'd also see F5540100 if you opened the file in HxD.

// Note: The next two structs are "packed", that is, they have no "padding" between elements. This is
// necessary because objects of these structs will be written to the headers of "*.bmp" files as-is,
// and that file format demands these elements, in this order, at these offsets, and any padding would
// invalidate the stated "offset" fields, hence padding cannot be allowed, hence the structs are "packed".
// Yes, this is a non-portable GNU "extension", but there is no way to do what needs to be done "portably",
// so I must do it UN-PORTABLY. That means, a compiler with this feature must be used. Live with it.

// Bmfh == Bit Map File Header (NOTE PACKING!):
struct __attribute__ ((packed)) Bmfh
{
   // Member:              Description:                     Typical RAM image (little-endian byte order):
   uint16_t filetype;   // File type, always "BM"            "BM" == 0x424D
   uint32_t filesize;   // File size, always 54+matrixsize  67804 == 0xDC080100
   uint16_t reserved1;  // Reserved 1 (not used)                0 == 0x0000
   uint16_t reserved2;  // Reserved 2 (not used)                0 == 0x0000
   uint32_t offset;     // Offset to data (54+table)           54 == 0x36000000
};

// Bmih == Bit Map Information Header (NOTE PACKING!):
struct __attribute__ ((packed)) Bmih
{
   // Member:                    Description:               Typical RAM image (little-endian byte order):
   uint32_t bmihsize;         // size of this header (40)       40 == 0x28000000
   uint32_t imagewidth;       // width  of image in pixels     800 == 0x20030000
   uint32_t imageheight;      // height of image in pixels     800 == 0x20030000
   uint16_t planes;           // number of image planes          1 == 0x0100
   uint16_t bitcount;         // bits per pixel                 24 == 0x1800
   uint32_t compression;      // compression code                0 == 0x00000000
   uint32_t matrixsize;       // matrix size in bytes       347502 == 0x6E4D0500
   uint32_t xpixelspermeter;  // H pixels per meter           3937 == 0x610F0000 for 100px/in
   uint32_t ypixelspermeter;  // V pixels per meter           3937 == 0x610F0000 for 100px/in
   uint32_t colorsused;       // colors used                     0 == 0x00000000
   uint32_t colorsimportant;  // colors important                0 == 0x00000000
};

// Class "Bitmap" is the "Base" class for all of my bitmap-related classes.
// This is basically an image in RAM of a Microsoft Windows Device-Independent Bitmap File,
// also known as a "*.bmp file" or a "BMP file" or a "bump file":
class Bitmap
{
   /* -------------------------------------------------------------------------- *\
    * Public Section
    * Contains the interfaces used by calling programs to access Bitmap objects:
   \* -------------------------------------------------------------------------- */
   public:
      // Parameterized constructor:
      Bitmap(int w, int h, int b, bool c);

      // destructor:
      ~Bitmap(void);

      // get number of colors in color table:
      int getcolors (void) {return colors;}

      // set a pixel's color (1-bit, 4-bit, 8-bit):
      void setcolor (int i, int j, int k);

      // set a pixel's color (24-bit):
      void setcolor (int x, int y, Color color);

      // get a pixel's color:
      Color getcolor (int x, int y);

      // set a color table entry (1-bit, 4-bit, 8-bit):
      void settable (int i, Color color);

      // get a color table entry (1-bit, 4-bit, 8-bit):
      Color gettable (int i);

      // get width in pixels
      int getwidth (void);

      // get height in pixels
      int getheight (void);

      // write bitmap to file:
      void filewrite (std::string path);

   /* -------------------------------------------------------------------------- *\
    * Protected Section
    * Contains data for use only by member functions of Bitmap and its children:
   \* -------------------------------------------------------------------------- */
   protected:
      int width;
      int height;
      int bitcount;
      int colors;
      int bytelength;
      int overrun;
      int pad;
      int rowlength;
      int colortablesize;
      int compression;
      vec_size_t matrixsize;
      vec_size_t filesize;

   /* ------------------------------------------------------------------------- *\
    * Private Section
    * Contains the file, image, and pixel data of the bitmap,
    * formatted the same way it will be written to disk.
    * Also contains any functions to be called only by Bitmap member functions.
   \* ------------------------------------------------------------------------- */
   private:
      Bmfh bmfh;              // bit map file header (file type, file size, etc.)
      Bmih bmih;              // bit map info header (image heigth, width, bitcount, etc.)
      Color colortable[256];  // table of colors (0, 2, 16, or 256 will actually be used)
      uint8_t **bytematrix;   // raw bitmap data
      std::vector<std::vector<uint8_t> > rlematrix; // run-length-encoded bitmap data

      // Note that packing is unnecessary in the private data members above.  Bmfh, Bmih, and colortable
      // are already packed internally, and they are written to disk individually, so the disk image will
      // be packed even though these members aren't packed in Bitmap.  (Also, only as many elements of
      // colortable as are actually needed are written to disk.)  And bytematrix and rlematrix are just
      // pointers to containers, the data in which will be written to disk 1 byte at a time, so that data
      // will be packed on disk also, even though it most assuredly is NOT packed in RAM.  For more on
      // this issue, see the comments to the function Bitmap::filewrite() in rhbitmap.cpp.

      void RLE4(void); // 4-bit run-length-encoding routine
      void RLE8(void); // 8-bit run-length-encoding routine
      void FileWriteInvalidParams(void); // Bad bitcount and/or compression code encountered in Filewrite()
};

// Class Graph is a kind of a Bitmap, basically a Bitmap used to write graphs onto:
class Graph : public Bitmap
{
   public:
      // Parameterized constructor has eight inputs:
      // graph limits: xmin, xmax, ymin, ymax
      //  (these may be any real numbers as long as xmin < xmax and ymin < ymax )
      // bitmap parameters: width, height, bitcount, compression
      //  (width and height must be between 1 and 5999 inclusive,
      //   bitcount must be 1, 4, 8, or 24, and compression must be true or
      //   false.)
      Graph(double xa, double xz, double ya, double yz,
            int    w,  int    h,  int    b,  bool   c);
      double getx(int i);
      double gety(int j);
      int    geti(double x);
      int    getj(double y);
      double horscale(void) {return hor_scale;}
      double verscale(void) {return ver_scale;}
      int    plotpoint(double const & x, double const & y, int   const & colorselect);
      int    plotpoint(double const & x, double const & y, Color const & color      );
      int    plotpixel(int    const & i, int    const & j, int   const & colorselect);
      int    plotpixel(int    const & i, int    const & j, Color const & color      );

   protected:
      double x_min;      // horizontal number minimum
      double x_max;      // horizontal number minimum
      double y_min;      // vertical   number minimum
      double y_max;      // vertical   number maximum

   private:
      double x_span;     // horizontal number span
      double y_span;     // vertical   number span
      int    i_span;     // horizontal image span
      int    j_span;     // vertical   image span
      double hor_scale;  // horizontal scale (width  of one pixel)
      double ver_scale;  // vertical   scale (height of one pixel)
};

// class Fractal is a kind of a Graph, but with added features:
class Fractal : public Graph
{
   public:
      Fractal
         (
            int          Degree,
            int          Iterations,
            char         ColorSwitch,
            int          ColorsUsed,
            double       Cyclicity,
            double       SkewFactor,
            int          Granularity,
            std::string  FileName,
            double       xa,
            double       xz,
            double       ya,
            double       yz,
            int          w,
            int          h,
            int          b,
            bool         c
         )
      :
         Graph       (xa, xz, ya, yz, w, h, b, c),
         degree      (Degree),
         iterations  (Iterations),
         colorswitch (ColorSwitch),
         colors_used (ColorsUsed),
         cyclicity   (Cyclicity),
         skew_factor (SkewFactor),
         granularity (Granularity),
         filename    (FileName)
      {
         // Constructor body is empty;
         // all the work was done in the above initialization list.
      }

      ~Fractal() {} // Nothing for destructor to do.

    //Type         Member Name      Description                   Range
      int          degree;       // degree of equation            2,3,4,5,6,...
      int          iterations;   // number of iterations:         [1, 50000]
      char         colorswitch;  // colorization code character:  b, c, g, r, or y
      int          colors_used;  // number of colors:             [2, 16777216]
      double       cyclicity;    // number of color cycles:       [0.1, 1000000.0]
      double       skew_factor;  // amount of parabolic skew:     [0.0, 1.0]
      int          granularity;  // shotgun-matrix granularity:   [3, 7]
      std::string  filename;     // name of file
}; // end class Fractal

} // end namespace rhbitmap


/************************************************************************************************************\
 * Development Log:
 * 2001-07-22:
 *    I reduced the size of the matrix from 700x500 to 250x100,
 *    because I was getting SIGSEGV errors (stack errors).   I think this
 *    was because I ran out of memory.   How can I allocate more memory?
 * 2001-07-25:
 *    The problem is, a large array defined as a local variable, is
 *    stored in the "automatic" storage class, which is in the stack space,
 *    a very limited area of memory (around 50-100KB).   Always define
 *    large arrays to be "static", or define them globally.   Either
 *    puts them in the "static" storage class, in the heap rather than the
 *    stack.   I redefined "matrix" as a 901x500 static array, and now it
 *    no longer causes stack overflow.
 * 2002-01-06:
 *    Changed order of indices: array is now 500x901.   This stores each
 *    horizontal line of 901 pixels as a contiguous mempory block, like a
 *    TV raster scan.   This is also apparently the way that *.raw files are
 *    organized.
 * 2002-01-13:
 *    I encapsulated the bitmap logical construct in a class template which
 *    contains structs based on the struct templates Bmfh and Bmih,
 *    which are the two headers required in every bitmap file.   I also
 *    added command-line arguments as a way of getting data into the program
 *    at run time regarding image size and colors.   I also stopped
 *    development on the files bitmap.cpp and bitmap2.cpp and started
 *    work on this file, which goes beyond just making a bitmap to writing
 *    graphs to bitmaps.   My plan of action is to encapsulate more of the
 *    mundane tasks of getting the data into the bitmap into structs and
 *    subroutines, so I can concentrate more on the graphing aspect.
 * 2002-01-14:
 *    I separated my bitmap structures, classes, and functions into two files:
 *    a library file, bitmap.cpp,   and its associated header, bitmap.h.
 *    These files can now be accessed by many different programs.   To edit
 *    bitmapping for all my programs, I need edit only these two files.
 * 2002-01-19:
 *    I renamed these files "graphics.h" and "graphics.cpp", combining my
 *    bitmapping and graphing classes into one library.   This simplifies
 *    interactions between graphics structs and classes.
 * 2002-01-27:
 *    I recombined graphics.h and graphics.cpp into graphics.lib, because
 *    I can see no practical benefit in having the member function
 *    definitions separated into their own file.   That seemed to violate
 *    the spirit of encapsulation which drives object oriented programming.
 *    It's better to have all the parts of a set of related classes
 *    together in one library, so that library can be used as a self-
 *    contained module.
 * 2002-02-17:
 *    I deleted struct Datapoint and replaced it with struct Point, which is
 *    just a point in 2-space and does not contain any color information.
 *    I did this because of the disparity in parameters between 1,4,8-bit and
 *    24-bit calls to Bitmap::setcolor.   I created two overloaded versions of
 *    Graph::plotpoint() with signatures (const Point &, uint16_t) and
 *    (const Point &, const Color &) which call upon appropriate versions of
 *    Bitmap::setcolor().   This should simplify graphing.
 * 2002-11-17, 4:00PM:
 *    I must look-up that DJGPP trick for making "non-omptimized" classes that
 *    don't try to otimize by adding padding bytes between members, to make the
 *    effective width of the member a multiple of 4 bytes.   That way, I should
 *    be able to dramatically simplify Bitmap::filewrite() by writing a whole
 *    Bitmap object at once rather than wriing it one member at a time.
 * 2002-11-17, 5:00PM:
 *    Perhaps this trick from C:\computer-center\programming\DJGPP-website\
 *       Guide VBE 2_0 graphics modes.htm
 *    might work:
 *       typedef struct VESA_PM_INFO {
 *          unsigned short setWindow          __attribute__ ((packed));
 *          unsigned short setDisplayStart    __attribute__ ((packed));
 *          unsigned short setPalette         __attribute__ ((packed));
 *          unsigned short IOPrivInfo         __attribute__ ((packed));
 *       } VESA_PM_INFO;
 *    Hmmm...   lets try it.
 * 2002-11-17, 10:30PM:
 *    At first it didn't succeed, but then I discovered that a non-essential
 *    #included header (rhgraphics.h) had a bug in it, so now I'll try it without
 *    that header.
 * 2002-11-17, 10:50PM:
 *    I needed to take out unnecessary #inclusion of mathutil.h in order to
 *    prevent duplication of declarations, since this header is also #included
 *    in some programs that need to link to both rhbitmap.cpp and
 *    mathutil.cpp.
 * 2002-11-23, 6:06PM:
 *    The above note is false; it turned out that the duplications were due to
 *    a flaw in my compiler command line, in which I was linking two copies of
 *    the same object to each other.   No wonder things were "duplicated"! Doh.
 *    I've cleaned up a number of things, including removing unnecessary
 *    explicit assignment operator and copy constructor from struct Color.
 * 2002-12-22, 11:46PM:
 *    I cleaned up notes, comments, boxes, and other aesthetics, and updated
 *    the date stamps.   I also got the inserter for class Color to work right.
 * 2003-05-01:
 *    Some of the above is misleading.   The "__attribute__ ((packed))"
 *    did, indeed, prove to be the cure for the data corruption that was
 *    plagueing my structs.   And the "duplications" I mention above were, at
 *    least in part, due to not using "#ifndef RH_BITMAP" include-guards.
 *    It's amusing to look back now and see some of the misunderstandings I
 *    was laboring under as recently as a half-year ago.   Live and learn.
 * 2004-09-23:
 *    A couple of months ago, I re-wrote the 8-bit RLE routine in order to cast it as a clearly-formed
 *    finite state machine.  The code is now much cleaner... but alas, it does not work!  It produces
 *    corrupted BMP files that are either solid orange, or can't even be opened.  I need to debug this
 *    and see what is going on.
 * 2004-09-26:
 *    Part of the problem was that I was adding too-many pad bytes.  The rows of RLE compressed data need
 *    to end on WORD (2-byte) boundaries, not DWORD (4-byte) boundaries.  Upon fixing this, my RLE BMP files
 *    are now readable by PSP... but not MS Paint.  Another issue was my file sizes in my headers, which were
 *    all wrong, sometimes way too small, other times way too large.  On the one hand, I had forgotten that
 *    my "24-bit" Color objects are actually 32-bits, not 24; on the other hand, I had forgotten that the
 *    final file size of an RLE compressed file is going to be much SMALLER than the original, uncompressed
 *    size.  I'm fixing these things right now.  This involves using vectors as buffers (both a single
 *    current-row vector and a vector of vectors for the whole image1), and using .reserve() to pre-allocate
 *    10,000 bytes of space in my current-row buffer.
 * 2004-10-04:
 *    I changed the meanings of hor_scale and ver_scale in Graph to mean distance-per-pixels instead of
 *    pixels per unit distance.  This made horscale() and verscale() more useful in fractal graphics.
 *    I also corrected some minor errors in geti(), getj(), getx(), and gety().  getx() and gety() now
 *    return the center of the pixel (instead of the corner), and geti() and getj() now return the
 *    right-most or top-most pixel if waranted (intead of ignoring the right column and top row).
 * 2018-02-06:
 *    I did a massive cleanup of the "Instructions" and "Technical Notes" sections at the top of this file.
 *    I especially added info on pixel storage order and techniques for setting the colors of the pixels
 *    without buffer overruns resulting in segmentation faults. Also, many changes have been made to this
 *    file 2004-2018 that didn't get put into these notes. These changes include a massive re-write of
 *    everything due to upgrading from Windows-XP to Windows-10 and from DJGPP to Cygwin64+Mintty+Bash+Gnu.
 *    Everything in this file should now be compatible with use on Linux; just recompile for that OS.
\************************************************************************************************************/

// End include guard:
#endif
