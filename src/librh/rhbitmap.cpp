

/************************************************************************************************************\
 * rhbitmap.cpp
 * Bitmap Classes Implementation File
 * Instructions:         See "Instructions"    section at  top   of file "rhbitmap.hpp".
 * Technical Notes:      See "Technical Notes" section at  top   of file "rhbitmap.hpp".
 * Development Log:      See "Development Log" section at bottom of file "rhbitmap.hpp".
 * Author:               Robbie Hatley
 * Edit history:         See "Edit History" at top of file "rhbitmap.hpp".
\************************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <string>

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <cstdint>

#undef NDEBUG
//#define NDEBUG
#include <assert.h>
#include <errno.h>

//#define BLAT_ENABLE
#undef BLAT_ENABLE
#include "rhmath.hpp"
#include "rhbitmap.hpp"

using std::cout;
using std::cerr;
using std::endl;
using std::vector;
using std::string;
using std::exit;

typedef std::vector<uint8_t>::size_type vec_size_t;

// Parameterized constructor for class rhbitmap::Color :
// (Note no return value, not even void -- earmark of a constructor.)
rhbitmap::Color::Color
(
   int const & r,
   int const & g,
   int const & b
)
{
   // If any of the Red, Green, or Blue elements of this color are outside of
   // the range 0-255, print error message and exit program with code 666:
   if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255)
   {
      cerr << "Invalid rgb values " << r << ", " << g << ", " << b
           << " passed to" << endl
           << "parameterized constructor for rhbitmap::Color." << endl;
      exit(666);
   }
   // Otherwise, set object's R,G,B numbers as user requests:
   else
   {
      blue  = uint8_t(b);
      green = uint8_t(g);
      red   = uint8_t(r);
      dummy = uint8_t(0);
   }
} // end rhbitmap::Color parameterized constructor


// rhbitmap::Color set() method (sets the R, G, B numbers of a Color object):
void
rhbitmap::Color::set
(
   int const & r,
   int const & g,
   int const & b
)
{
   // If any of the Red, Green, or Blue elements of this color are outside of
   // the range 0-255, print error message and exit program with code 666:
   if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255)
   {
      cerr << "Invalid rgb values " << r << ", " << g << ", " << b
           << " passed to" << endl
           << "rhbitmap::Color.set() ." << endl;
      exit(666);
   }
   // Otherwise, set object's R,G,B numbers as user requests:
   else
   {
      blue  = uint8_t(b);
      green = uint8_t(g);
      red   = uint8_t(r);
      dummy = uint8_t(0);
   }
} // end rhbitmap::Color set() method


// class rhbitmap::Bitmap parameterized constructor
// (makes a bitmap with given width, height, bitcount, and compression)
rhbitmap::Bitmap::Bitmap
(int w, int h, int b, bool c)
{
   // Constructor for Bitmap.
   // Arguments are width, height, bitcount (bits-per-pixel), and compression.

   // Abort program if any of the inputs are invalid:
   if
      (
         w < 10 || w > 10001
         ||
         h < 10 || h > 10001
         ||
         !( 1 == b || 4 == b || 8 == b || 24 == b )
      )
   {
      cerr
         << "Error in Bitmap parameterized constructor:"              << endl
         << "width and height must be at least 10 and at most 10001," << endl
         << "and bitcount must be 1, 4, 8, or 24."                    << endl;
      cerr << endl;
      exit(1);
   }

   // Now that we've ascertained that the input are in-range,
   // store arguments in protected variables:
   width    = w;
   height   = h;
   bitcount = b;

   //////////////////////////////////////////////////////////////
   // Compute bitcount-dependent variables:                    //
   //    colors            (color depth)                       //
   //    colortablesize    (size of color table)               //
   //    compression       (compression code number)           //
   //    bytelength        (bytes of data per row)             //
   //////////////////////////////////////////////////////////////
   switch (bitcount)
   {
      case 1:
         colors = 2;
         colortablesize = 8; // 2 4-byte colors (RGBD)
         compression = 0; // can't compress 1-bit bitmaps...
         if (c) // ... but if user asks for compression, give warning:
         {
            cerr
               << endl
               << "Warning from Bitmap constructor: user specified compression, but 1-bit bitmaps" << endl
               << "cannot be RLE compressed." << endl;
         }
         // Each pixel is represented by one bit, so number of bytes used for data is
         // the ceiling of one-eighth the number of bits:
         bytelength = short(ceil(double(width)/8.0));
         break;
      case 4:
         colors = 16;
         colortablesize = 64; // 16 4-byte colors (RGBD)
         if (c)               // If user asks for compression:
            compression = 2;     // use 4-bit RLE compression;
         else                 // otherwise,
            compression = 0;     // use no compression
         // Each pixel is represented by one nybble, so number of bytes used for data is
         // the ceiling of half the number of nybbles:
         bytelength = short(ceil(double(width)/2.0 - 0.001));
         break;
      case 8:
         colors = 256;
         colortablesize = 1024; // 256 4-byte colors (RGBD)
         if (c)                          // If user wants compression,
            compression = 1;               // use 8-bit RLE compression;
         else                            // otherwise,
            compression = 0;               // use no compression.
         bytelength = width;             // 1 byte per pixel (interpreted as index to color table)
         break;
      case 24:
         colors = 16777216;  // Plenty o' colors.
         colortablesize = 0; // No color table for 24-bit bitmaps.
         compression = 0;    // Can't compress 24-bit bitmaps....
         if (c)              // ... but if user requests compression, issue warning:
         {
            cerr << "Warning from Bitmap constructor: cannot compress 24-bit ";
            cerr << "bitmaps.   Making uncompressed 24-bit bitmap instead.";
            cerr << endl;
         }
         // In 24-bits/pixel mode, bytematrix is a matrix of actual color values, not indexes.
         // Each pixel is a ordered triplet of color bytes: (Blue, Green, Red).
         bytelength = 3*width; // 3 bytes per pixel
         break;
      default:
         cerr << "Error in Bitmap parameterized constructor: ";
         cerr << "bitcount must be 1, 4, 8, or 24.";
         cerr << endl;
         exit(1);
   } // end switch (bitcount)

   /////////////////////////////////////////////////////////////////////
   // Based on bytelength, compute:                                   //
   //    overrun     (number of bytes rows run past 4-byte boundary)  //
   //    pad         (end-of-row zero-padding to 4-byte boundary)     //
   //    rowlength   (row length including pad)                       //
   //    matrixsize  (size of bytematrix)                             //
   //    filesize    (size of file)                                   //
   /////////////////////////////////////////////////////////////////////

   overrun    = bytelength % 4;     // amount of over-run past 4-byte boundary
   pad        = (4 - overrun) % 4;  // pad with enough bytes to bring row length to 4-byte boundary
   rowlength  = bytelength + pad;   // length of padded rows
   matrixsize = height*rowlength;   // size of bytematrix
   filesize   = 14 + 40 + colortablesize + matrixsize; // size of file
   // NOTE: if RLE compression is being used, both matrixsize and filesize will be drastically smaller
   // than the values calculated above, and hence they will have to be re-determined after RLE is complete.

   //========== Initialize the color table, whether it will be used or not: ==========//
   colortable[0]=Color(  0,   0,   0); // black  (index 0 = foreground color)
   colortable[1]=Color(240, 230, 220); // cream  (index 1 = background color)
   colortable[2]=Color(255, 255, 255); // white
   colortable[3]=Color(192, 192, 192); // silver
   colortable[4]=Color(128, 128, 128); // grey
   for ( int i = 5 ; i < 256 ; ++i )
   {
      colortable[i]=Color(0,0,0);      // black
   }
   // Note: These may be overridden later. Either 0, 2, 16, or all 256 of the entries will be written to file.
   // Note: If bitcount is 24, colortable won't be used and won't be written to the bmp file.

   //////////////////////////////////////////
   //                                      //
   // Allocate and initialize bytematrix:  //
   //                                      //
   //////////////////////////////////////////

   // dynamically allocate an array of pointers to uint8_t, one pointer per row
   // of this bitmap, and set pointer "bytematrix" to point to element 0 of this array:
   bytematrix = new uint8_t* [height];

   // then make each pointer in that array point to a new dynamically-allocated
   // array of uint8_t, each of these new arrays having length [rowlength],
   // turning bytematrix into a 2d array of size [height][rowlength] :
   for ( int j = 0 ; j < height ; ++j )
   {
      bytematrix[j]=new uint8_t [rowlength];
   }

   // Set padding bytes to zero:
   for ( int j = 0 ; j < height ; ++j )
   {
      for ( int i = bytelength ; i < rowlength ; ++i )
      {
         bytematrix[j][i] = 0;
      }
   }

   // initialize all pixels to background color (colortable index 1):
   for ( int j = 0 ; j < height ; ++j )
   {
      for ( int i = 0 ; i < width ; ++i )
      {
         if (24==bitcount)
         {
            setcolor(i, j, Color(240,230,220));
         }
         else
         {
            setcolor(i, j, 1);
         }
      }
   }

   //========== print protected variables: ==========//
   cout << endl;
   cout << "Finished constructing bitmap with these parameters:" << endl;
   cout << "width          = " << width          << endl;
   cout << "height         = " << height         << endl;
   cout << "bitcount       = " << bitcount       << endl;
   cout << "colors         = " << colors         << endl;
   cout << "compression    = " << compression    << endl;
   cout << "bytelength     = " << bytelength     << endl;
   cout << "overrun        = " << overrun        << endl;
   cout << "pad            = " << pad            << endl;
   cout << "rowlength      = " << rowlength      << endl;
   cout << "colortablesize = " << colortablesize << endl;
   if (0 == compression)
   {
      cout << "matrixsize     = " << matrixsize     << endl;
      cout << "filesize       = " << filesize       << endl;
   }
   else
   {
      cout << "matrixsize     = to be determined after run-length encoding" << endl;
      cout << "filesize       = to be determined after run-length encoding" << endl;
   }

   return;
} // end class rhbitmap::Bitmap parameterized constructor


// class rhbitmap::Bitmap destructor:
rhbitmap::Bitmap::~Bitmap
(void)
{
   for ( int j = 0 ; j < height ; ++j )
   {
      delete[] bytematrix[j];
   }
   delete[] bytematrix;
   return;
} // end class rhbitmap::Bitmap destructor


// Set the color setcolor() for 1-, 4-, and 8-bit bitmaps:
void
rhbitmap::Bitmap::setcolor
   (
      int i, // Horizontal index
      int j, // Vertical   index
      int k  // Color      index
   )
{
   // First, make sure arguments are correct:
   if (bitcount!=1 && bitcount!=4 && bitcount!=8)
   {
      cerr << "Error in 1,4,8-bit Bitmap::setcolor(): bitcount = " << bitcount << "." << endl;
      cerr << "This version of setcolor() may only be used for 1,4,8-bit bitmaps."    << endl;
      cerr << "For 24-bit bitmaps, use the version of setcolor() which specifies"     << endl;
      cerr << "a Color object instead of an integer color number."                    << endl;
      exit(1);
   }
   if (i > width-1 || j > height-1)
   {
      cerr << "Error in 1-,4-,8-bit Bitmap::setcolor():" << endl;
      cerr << "Invalid pixel (" << i << ", " << j << ") in " << endl;
      cerr << width << "x" << height << " bitmap." << endl;
      exit(1);
   }
   if (k < 0 || k > colors-1)
   {
      cerr << "Error in 1-,4-,8-bit Bitmap::setcolor():" << endl;
      cerr << "Invalid color selector argument " << k << endl;
      cerr << "in " << colors << "-color bitmap." << endl;
      cerr << "The minimum is 0 and the maximum is " << colors-1 << endl;
      exit(1);
   }
   switch(bitcount)
   {
      case 1:
      {
         int byteindex, bitindex, bits, mask1, mask2;
         byteindex=i/8;
         bitindex=i%8;
         bits=bytematrix[j][byteindex];          // get bits
         mask1=1;                                // 00000001
         mask1=mask1 << (7-bitindex);            // 00000001 -> 00010000
         mask1=~mask1;                           // 00010000 -> 11101111
         bits=bits&mask1;                        // reset specified pixel to 0
         mask2=k;                                // 00000000 or 00000001
         mask2=mask2 << (7-bitindex);            // 00000000 or 00010000
         bits=bits|mask2;                        // set selected bit to k
         bytematrix[j][byteindex]=uint8_t(bits); // store pattern back to matrix
         break;
      }
      case 4:
      {
         int byteindex, nybbleindex, bits, mask1, mask2;
         byteindex=i/2;
         nybbleindex=i%2;
         bits=bytematrix[j][byteindex];          // get bits
         if (0==nybbleindex) {                   // if left nybble...
            mask1=0x0F;                          // mask1=00001111
            mask2=k<<4;                          // mask2=kkkk0000
         }
         else {                                  // if right nybble...
            mask1=0xF0;                          // mask1=11110000
            mask2=k;                             // mask2=0000kkkk
         }
         bits=bits&mask1;                        // reset nybble to 0
         bits=bits|mask2;                        // set nybble to desired values
         bytematrix[j][byteindex]=uint8_t(bits); // store pattern back to matrix
         break;
      }
      case 8:
      {
         bytematrix[j][i] = uint8_t(k);
         break;
      }
   } // End switch (bitcount)
   return;
}


// setcolor() for 24-bit bitmaps:
void
rhbitmap::Bitmap::setcolor
(
   int i,
   int j,
   Color c
)
{
   // First, make sure arguments are correct:
   if (24!=bitcount)
   {
      cerr << "Error in 24-bit Bitmap::setcolor(): bitcount = " << bitcount << "." << endl;
      cerr << "This version of setcolor() may only be used for 24-bit bitmaps."    << endl;
      cerr << "For 1,2,4,8 -bit bitmaps, use the versopm of setcolor() which"      << endl;
      cerr << "specifies an integer color number instead of a Color object."       << endl;
      exit(1);
   }
   if (i > width-1 || j > height-1)
   {
      cerr << "Error in 24-bit Bitmap::setcolor():" << endl;
      cerr << "Invalid pixel (" << i << ", " << j << ") in " << endl;
      cerr << width << "x" << height << " bitmap." << endl;
      exit(1);
   }
   bytematrix[j][3*i+0] = c.blue;
   bytematrix[j][3*i+1] = c.green;
   bytematrix[j][3*i+2] = c.red;
   return;
}


// getcolor() for all bitmaps:
rhbitmap::Color
rhbitmap::Bitmap::getcolor
(
   int i,
   int j
)
{
   if (i > width-1 || j > height-1)
   {
      cerr << "Error in rhbitmap::Bitmap::getcolor: ";
      cerr << "Invalid pixel (" << i << ", " << j << ") " << endl;
      cerr << "in " << width << "x" << height << " bitmap." << endl;
      exit(1);
   }

   Color  color;
   int ByteIndex, NybbleIndex, BitIndex, bits, Nybble, bit;

   switch (bitcount)
   {
      case 24:
         color.blue  = bytematrix[j][3*i+0];
         color.green = bytematrix[j][3*i+1];
         color.red   = bytematrix[j][3*i+2];
         color.dummy = uint8_t(0);
         break;
      case 8:
         color       = colortable[bytematrix[j][i]];
         break;
      case 4:
         ByteIndex   = i/2;
         NybbleIndex = i%2;
         bits        = bytematrix[j][ByteIndex];
         Nybble      = 0x0F & (bits >> (4*(1 - NybbleIndex)));
         color       = colortable[Nybble];
         break;
      case 1:
         ByteIndex   = i/8;
         BitIndex    = i%8;
         bits        = bytematrix[j][ByteIndex];
         bit         = 0x01 & (bits >> (7 - BitIndex));
         color       = colortable[bit];
         break;
      default:
         cerr
            << "Error in rhbitmap::Bitmap::getcolor() : invalid bitcount: " << bitcount << endl;
         exit(666);
   }

   return color;
}


// settable():
void
rhbitmap::Bitmap::settable
(
   int i,
   Color  c
)
{
if (i < 0 || i > colors-1)
   {
      cerr << "Error in Bitmap::settable():" << endl;
      cerr << "Invalid color selector " << i << " in " << colors
         << "-color bitmap." << endl;
      cerr << "Color selector must be at least 0 and at most "
         << colors-1 << "." << endl;
      exit(1);
   }
   colortable[i]=c;
   return;
}


// Return width in pixels:
int
rhbitmap::Bitmap::getwidth
(void)
{
   return int(width);
}


// Return height in pixels:
int rhbitmap::Bitmap::getheight (void)
{
   return int(height);
}


// gettable():
rhbitmap::Color
rhbitmap::Bitmap::gettable
(
   int i
)
{
   if (i < 0 || i > colors-1)
   {
      cerr << "Error in Bitmap::gettable():" << endl;
      cerr << "Invalid color selector " << i << " in " << colors << "-color ";
      cerr << "bitmap." << endl << "Color selector must be at least 0 and ";
      cerr << "at most " << colors-1 << "." << endl;
      exit(1);
   }
   return colortable[i];
}


// filewrite():
void
rhbitmap::Bitmap::filewrite
(
   std::string path
)
{
   // This function performs RLE compression if requested, then writes bitmap to file.

   // First, request "register" ints for horizontal and vertical iterators:
   int i = 0;
   int j = 0;

   // Before loading protected variables into file headers, filter-out invalid bitcount/compression
   // combinations and perform RLE compression if requested and available:
   switch (10*bitcount+compression)
   {
      case 10:   // 1-bit, 2-color, non-compressed
         break;
      case 40:   // 4-bit, 16-color, non-compressed
         break;
      case 42:   // 4-bit, 16-color, RLE-compressed
         RLE4();
         break;
      case 80:   // 8-bit, 256-color, non-compressed
         break;
      case 81:   // 8-bit, 256-color, RLE-compressed
         RLE8();
         break;
      case 240:  // 24-bit, 16777216-color, non-compressed
         break;
      default:   // invalid bitcount/compression combination
         FileWriteInvalidParams();
   }

   // If RLE was performed, it should have updated matrixsize and filesize to indicate their new values,
   // so all protected variables should now be finalized and ready to be committed to file headers:

   //========== load data into bitmap file header: ==========//
   bmfh.filetype        = uint16_t(19778); // (ascii "BM")
   bmfh.filesize        = uint32_t(filesize);
   bmfh.reserved1       = uint16_t(0);
   bmfh.reserved2       = uint16_t(0);
   bmfh.offset          = uint32_t(14 + 40 + colortablesize);

   //========== load data into bitmap information header: ==========//
   bmih.bmihsize        = uint32_t(40);
   bmih.imagewidth      = uint32_t(width);
   bmih.imageheight     = uint32_t(height);
   bmih.planes          = uint16_t(1);
   bmih.bitcount        = uint16_t(bitcount);
   bmih.compression     = uint32_t(compression);
   bmih.matrixsize      = uint32_t(matrixsize);
   bmih.xpixelspermeter = uint32_t(3937);            // 100 pixels per inch horizontal
   bmih.ypixelspermeter = uint32_t(3937);            // 100 pixels per inch vertical
   bmih.colorsused      = uint32_t(0);               // always use maximum available colors
   bmih.colorsimportant = uint32_t(0);               // always use maximum available colors

   // Create stream and open file:
   std::ofstream out;
   out.open(path, std::ios::out|std::ios::binary);

   // If file is not open, print error message:
   if (!out.is_open())
   {
      cerr
         << "Error in Bitmap::filewrite:" << endl
         << "Could not open file " << path << endl
         << "for binary-mode write." << endl
         << "Exiting application." << endl;
      exit(1);
   }

   // Else announce file is open:
   cout
      << endl
      << "Successfully opened file " << path << endl
      << "for binary-mode write." << endl;

   // Announce commencment of file write:
   cout << endl;
   cout << "About to write bitmap with " << height << " rows of " << width << " pixels per row...." << endl;

   // Declare byte counter to count bytes written to file:
   int bytecounter = 0;

   // Write headers:
   cout
      << endl
      << "Now writing headers...." << endl;
   out.write(reinterpret_cast<char*>(&(bmfh)), 14);
   bytecounter += 14;
   out.write(reinterpret_cast<char*>(&(bmih)), 40);
   bytecounter += 40;
   cout
      << "Finished writing headers." << endl
      << "Matrix size written to bmih header = " << bmih.matrixsize << endl
      << "File   size written to bmfh header = " << bmfh.filesize   << endl;

   // If not 24-bit mode, write color table:
   if (24!=bitcount)
   {
      cout
         << endl
         << "Now writing color table...." << endl;
      for ( j = 0 ; j < colors ; ++j )
      {
         out.write(reinterpret_cast<char*>(&(colortable[j])), 4);
         bytecounter += 4;
      }
   }

   // Flush stream:
   out.flush();

   // If compression is 0, write raw data:
   if (0 == compression)
   {
      cout
         << endl
         << "Now writing uncompressed bitmap data to file " << path << " ...." << endl;
      for ( j = 0 ; j < height ; ++j )
      {
         for ( i = 0 ; i < rowlength ; ++i )
         {
            out.put(static_cast<char>(bytematrix[j][i]));
            ++bytecounter;
         }

         // IMPORTANT: FLUSH STREAM IMMEDIATELY AFTER WRITING EACH ROW TO DISK:

         out.flush();

         // The above flush is absolutely necessary at the end of each row, because otherwise the compiler
         // is likely to try to optimize by attempting to write the whole bytematrix at once.   This is
         // disastrous because bytematrix is NOT a single 2d array, but a loose collection of j 1d arrays,
         // which is NOT contiguous in memory!  The compiler doesn't know that, though, and data corruption
         // in the output file results.   So I must force the compiler to produce code which writes bytematrix
         // one row at a time, by inserting out.flush() after writing each row.

      }
   }

   // Otherwise, write RLE compressed data:
   else
   {
      cout
         << endl
         << "Now writing RLE-compressed bitmap data to file " << path << " ..." << endl;
      for ( j = 0 ; j < height ; ++j )
      {
         // To avoid comparing int index variable i in the inner for loop to a possibly-too-long value of the
         // current row's vector size, I first store the vector size in a temporary variable and "assert()"
         // that it's < 28000. VECTOR SIZES THAT LARGE SHOULD BE IMPOSSIBLE, but it's good to "assert()"
         // here and there in one's code that "impossible" things are not, in fact, occuring.
         // Of course, I could evade this issue by changing the index variable from "int" to "unsigned long",
         // but I'm loathe to do that, because the int *should* be big enough. But since "rlematrix[j].size()"
         // is technically capable of returning numbers over 18 quintillion, I feel compelled to make *sure*
         // that the numbers it's *actually* feeding me are < 28000.
         std::vector<unsigned char>::size_type VectorSize = rlematrix[j].size();
         assert(VectorSize < 28000);
         int RowSize = int(VectorSize);
         for ( i = 0 ; i < RowSize ; ++i )
         {
            out.put(char(rlematrix[j][i]));
            ++bytecounter;
         }

         // IMPORTANT: FLUSH STREAM IMMEDIATELY AFTER WRITING EACH ROW TO DISK:

         out.flush();

         // The above flush is absolutely necessary at the end of each row, because otherwise the compiler
         // is likely to try to optimize by attempting to write the whole rlematrix at once.   This is
         // disasatrous because rlematrix is NOT a single 2d array, but a vector of vectors of uint8_t,
         // which is NOT contiguous in memory!  The compiler may not know that, though, and data corruption
         // in the output file results.   So I must force the compiler to produce code which writes rlematrix
         // one row at a time, by inserting out.flush() after writing each row.
      }
   }

   // Flush stream:
   out.flush();

   // Close file:
   out.close();

   // Announce completion of file write:
   cout
      << endl
      << "Successfully wrote " << bytecounter << " bytes to file " << path << " ." << endl;

   // Return to calling function:
   return;
} // End Bitmap.filewrite()


// 4-bit RLE compression routine:
void
rhbitmap::Bitmap::RLE4
(
   void
)
{
   // First, request "register" ints for horizontal and vertical iterators:
   int i = 0;
   int j = 0;

   // Resize rlematrix to contain exactly height elements. (After doing 4-bit RLE encoding,
   // file size should be 70 plus the sum of the sizes of the rows.)
   rlematrix.resize(height);

   // Declare a buffer to hold RLE-compressed version of a row of pixels:
   vector<uint8_t> Buffer;

   // Set RowLimit and MatrixLimit variables to limit row lengths to 2*width bytes and total
   // compressed matrix to 2*width*height bytes. This this SHOULD be 4x overkill, because each
   // pixel SHOULD take less (hopefully FAR less) than 1/2 byte. But I'm making allowance in case of
   // pathological situations which cause the compressed file to be LARGER than the uncompressed file:
   vec_size_t RowLimit    = 2 * width;
   vec_size_t MatrixLimit = RowLimit * height;

   // Pre-allocate contiguous block RAM for Buffer:
   Buffer.reserve(RowLimit);

   // Make sure Buffer starts out empty (Buffer.end() == Buffer.begin()):
   Buffer.clear();

   // Declare a byte counter to tally all bytes of encoded data, one byte at a time:
   vec_size_t ByteCounter = 0;

   // Create a set of STATES for a finite state machine to control the encoding process:
   enum
   {
      ruf, // "ruf" = begin segment with variable  pixel values
      run  // "run" = begin segment with invariant pixel values
   } SegmentState;

   // Declare segment-related variables:
   int far           = 0;     // last-word marker
   int rowbytes      = 0;     // number of bytes required to hold one row of pixels
   int SegmentBegin  = 0;     // beginning of current segment
   int SegmentEnd    = 0;     // 1 byte past end of Segment
   int SegmentLength = 0;     // Segment length
   bool runFlag      = false; // invariant-pixel-run flag

   // Annouce commencement of encoding:
   cout
      << endl
      << "Now performing 4-bit run-length encoding...." << endl;

   // Set "far" marker to the beginning of the last full 4-byte block of each row of actual data bytes
   // (ignore padding bytes; these are not written to compressed bitmap). NOTE INTEGER DIVISION width/2.
   // Eg, for 101 pixels (nybbles), truncates 101/2 from 50.5 to 50.

   //far = (width/2 - ((width/2)%4)) - 4; // 577 -> 288-0-4=284
   // NO, that's wrong. We MUST allow enough bytes to hold all the data, and that's just not doing it.
   // Let's first calculate the number of data bytes needed:
   rowbytes = width/2 + width%2;         // eg, 101 pixels requires 51 bytes
   // Now calculate far from rowbytes:
   far = (rowbytes - (rowbytes%4)) - 4;  // 577 -> 289-1-4 -> 284

   BLAT("In RLE4(), before row loop. rowbytes = " << rowbytes    )
   BLAT("In RLE4(), before row loop. far      = " << far         )

   // Iterate up through rows, from bottom to top:
   for ( j = 0 ; j < height ; ++j )
   {
      // Clear row Buffer before processing each new row:
      Buffer.clear();

      // First segment starts at beginning of row, and is empty, so it's length is zero:
      SegmentBegin = SegmentEnd = SegmentLength = 0;

      // Guess state of first segment as "ruf". (If this guess is incorrect, we'll find out immediately and
      // change segment state to "run" in the "ruf" section below.)
      SegmentState = ruf;

      // Now, divide this row up into rough ("ruf") and/or smooth ("run") segments.  This kind of division
      // is best done by a finite state machine.  Now where did I put that?  AH!  Here it is:

      /***************************************************************************************************\
       * Enter finite state machine                                                                      *
      \***************************************************************************************************/

      // Loop while we have not yet reached the start of the last whole word of this row:
      while (SegmentBegin < far)
      {
         switch (SegmentState)
         {
            case ruf:
               // If we get to here, we have reason to believe (or are just guessing, if this is the
               // leftmost pixel of a raster-row of pixels) that the next 4 1-byte pixel-pairs are dissimilar.
               // Or, they may be similar TO EACH OTHER, but not to the previous 4 pixel-pairs.

               // Let's start by examining the 4-byte "words" beyond current segment end. For each "word",
               // if it consists of of 4 dissimilar bytes, increase segment size by 4 so that this segment
               // now includes that word. Keep increasing segment size as long as the texture remains "ruf".

               // But don't extend this segment beyond 124 bytes (248 pixels), because 124 is the greatest
               // multiple of 4 who's double is <= 255, which is the largest number of 1/2-byte pixels we can
               // specify using a uint8_t value. And don't extend this segment beyond the "far" marker:
               while (SegmentEnd - SegmentBegin < 124 && SegmentEnd < far)
               {
                  // Test to see if next 4 pixels are equal to each other:
                  runFlag =
                     bytematrix[j][SegmentEnd] == bytematrix[j][SegmentEnd+1]
                     &&
                     bytematrix[j][SegmentEnd] == bytematrix[j][SegmentEnd+2]
                     &&
                     bytematrix[j][SegmentEnd] == bytematrix[j][SegmentEnd+3];
                  if (runFlag)         // If those 4 bytes WERE all the same,
                     break;            // the texture is about to become "run", so break out of "ruf" loop.
                  else                 // otherwise the texture continues to be "ruf",
                     SegmentEnd += 4;  // so increment SegmentEnd by 4 bytes and loop again.
               } // continue looping while we haven't reached 124 or far yet

               // At this point, we've reached the end of a "ruf" segment.
               // If this segment is not empty, append it to our row buffer:
               SegmentLength = SegmentEnd - SegmentBegin;
               if (0 != SegmentLength)
               {
                  Buffer.push_back(uint8_t(0));
                  ++ByteCounter;
                  Buffer.push_back(uint8_t(2*SegmentLength)); // next 2*SegmentLength nybbles are raw pixels
                  ++ByteCounter;
                  for ( i = SegmentBegin ; i < SegmentEnd ; ++i )
                  {
                     Buffer.push_back(bytematrix[j][i]);
                     ++ByteCounter;
                  }
                  SegmentBegin = SegmentEnd; // Next segment begins 1 byte past end of this Segment.
               }
               SegmentState = run;
               break; // end case ruf

            case run:
               // If we get to here, we have reason to believe that the next 4 1-byte pixel-pairs are
               // identical.

               // Let's start by examining the 4-byte "words" beyond current segment end. For each "word",
               // if it consists of of 4 identical 1-byte pixels pairs, increase segment size by 4 so that
               // this segment now includes that word. Keep increasing segment size as long as the texture
               // remains "run".

               // But don't extend this segment beyond 124 bytes (248 pixels), because 124 is the greatest
               // multiple of 4 who's double is <= 255, which is the largest number of 1/2-byte pixels we can
               // specify using a uint8_t value. And don't extend this segment beyond the "far" marker:
               while (SegmentEnd - SegmentBegin < 124 && SegmentEnd < far)
               {
                  // Test next 4 pixels to see if they are equal to SegmentBegin:
                  runFlag =
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+0]
                     &&
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+1]
                     &&
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+2]
                     &&
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+3];
                  if (!runFlag)        // If these 4 bytes are NOT all equal to the comparison value,
                     break;            // the texture is about to become "ruf", so break out of "run" loop.
                  else                 // Otherwise, the texture continues to be "run",
                     SegmentEnd += 4;  // so increment SegmentEnd by 4 bytes and loop again.
               } // continue looping while we haven't reached 124 or far yet

               // At this point, we've reached the end of a "run" segment.
               // If this segment is not empty, append it to our row buffer:
               SegmentLength = SegmentEnd - SegmentBegin;
               if (0 != SegmentLength)
               {
                  Buffer.push_back(uint8_t(2*SegmentLength)); // run of 2*SegmentLength identical pixel-pairs
                  ++ByteCounter;
                  Buffer.push_back(uint8_t(bytematrix[j][SegmentBegin])); // first pair of identical set
                  ++ByteCounter;
                  SegmentBegin = SegmentEnd; // Next segment begins 1 byte past end of this Segment.
               }
               SegmentState = ruf;
               break; // end case run

            default:
               cerr
                  << "Error in rhbitmap::Bitmap::RLE4() : invalid state : " << SegmentState << endl;
               exit(666);
         } // End switch (SegmentState)

      } // End while (not yet reached start of last whole word)

      /***************************************************************************************************\
       * Exit finite state machine                                                                       *
      \***************************************************************************************************/

      BLAT("In RLE4(), after state machine. SegmentBegin = " << SegmentBegin)
      BLAT("In RLE4(), after state machine. SegmentEnd   = " << SegmentEnd  )
      assert(SegmentBegin == SegmentEnd);
      assert(SegmentBegin == far       );

      // Calculate SegmentLength for remaining 4-7 bytes (last whole word plus leftovers, if any):
      SegmentEnd    = rowbytes;
      SegmentLength = SegmentEnd - SegmentBegin;
      BLAT("In RLE4(), before writing final segment. SegmentLength = " << SegmentLength)
      assert(SegmentLength >= 4);
      assert(SegmentLength <= 7);
      assert(SegmentLength == 4 + rowbytes%4);

      // Write final segment, except for final padding byte:
      Buffer.push_back(uint8_t(0));
      ++ByteCounter;
      Buffer.push_back(uint8_t(2*SegmentLength)); // write 2*SegmentLength pixels (NYBBLES, NOT BYTES!!!)
      ++ByteCounter;
      for ( i = SegmentBegin ; i < SegmentEnd ; ++i )
      {
         Buffer.push_back(uint8_t(bytematrix[j][i]));
         ++ByteCounter;
      }

      // Now write a padding byte, if necessary.  No more than one byte will ever be necessary.  Whereas rows
      // in uncompressed bitmaps are lined-up on 32-bit (DWORD) boundaries, segments in 8-bit RLE bitmaps are
      // lined-up on 16-bit (WORD) boundaries.  So if and only if the length in bytes of the final segment is
      // odd, write one padding byte:
      if (0 != SegmentLength%2)
      {
         Buffer.push_back(uint8_t(0));
         ++ByteCounter;
      }

      // Write end-of-line marker 0x0000:
      Buffer.push_back(uint8_t(0));
      ++ByteCounter;
      Buffer.push_back(uint8_t(0));
      ++ByteCounter;

      // All data for this row has been written to Buffer, so write Buffer to rlematrix,
      // after first asserting that Buffer is not outrageously large:
      assert(Buffer.size() <= RowLimit);
      rlematrix[j] = Buffer;
   } // Loop to top of "for-each-row" loop

   // All rows in bitmap have now be written to disk.
   // Tack end-of-bitmap marker 0x0001 on end of last row:
   rlematrix[height-1].push_back(uint8_t(0));
   ++ByteCounter;
   rlematrix[height-1].push_back(uint8_t(1));
   ++ByteCounter;

   // Set matrixsize to the sum of the byte-lengths of all the rows of rlematrix:
   matrixsize = 0;
   for (j = 0 ; j < height ; ++j )
   {
      matrixsize += int(rlematrix[j].size());
   }

   // Set filesize to the sum of the lengths of the headers, color table, and matrix:
   filesize = 14 + 40 + colortablesize + matrixsize;

   // Announce ByteCounter, matrixsize, and filesize, if BLAT is enabled:
   BLAT("ByteCounter    = " << ByteCounter)
   BLAT("matrixsize     = " << matrixsize )

   // Assert that ByteCounter, RowSizeCounter, and matrixsize are equal and not excessively large;
   // if not, abort:
   assert ( matrixsize == ByteCounter );
   assert ( matrixsize <= MatrixLimit );

   // Print data on bitmap:
   cout
      << endl
      << "Finished 4-bit RLE compression."  << endl
      << "matrixsize = " << matrixsize      << endl
      << "filesize   = " << filesize        << endl
      << "Now exiting RLE4()."              << endl;

   return;
} // end RLE4()


// 8-bit run-length-encoding routine:
void
rhbitmap::Bitmap::RLE8
(
   void
)
{
   // Start by declaring the two fastest-changing variables used below as "register":
   int i = 0;
   int j = 0;

   // Resize rlematrix to contain exactly height elements. (After doing 8-bit RLE encoding,
   // file size should be 310 plus the sum of the sizes of the rows.)
   rlematrix.resize(height);

   // Declare a buffer to hold RLE-compressed version of a row of pixels:
   vector<uint8_t> Buffer;

   // Set RowLimit and MatrixLimit variables to limit row lengths to 4*width bytes and total
   // compressed matrix to 4*width*height bytes. This this SHOULD be 4x overkill, because each
   // pixel SHOULD take less (hopefully FAR less) than 1 byte. But I'm making allowance in case of
   // pathological situations which cause the compressed file to be LARGER than the uncompressed file:
   vec_size_t RowLimit    = 4 * width;
   vec_size_t MatrixLimit = RowLimit * height;

   // Pre-allocate contiguous block RAM for Buffer:
   Buffer.reserve(RowLimit);

   // Make sure Buffer starts out empty (Buffer.end() == Buffer.begin()):
   Buffer.clear();

   // Declare a byte counter to tally all bytes of encoded data, one byte at a time:
   vec_size_t ByteCounter = 0;

   // Create a set of STATES for a finite state machine to control the encoding process:
   enum
   {
      ruf, // "ruf" = begin segment with variable  pixel values
      run  // "run" = begin segment with invariant pixel values
   } SegmentState;

   // Declare segment-related variables:
   int far           = 0;     // last-word marker
   int rowbytes      = 0;     // number of bytes required to hold one row of pixels
   int SegmentBegin  = 0;     // beginning of current segment
   int SegmentEnd    = 0;     // 1 byte past end of Segment
   int SegmentLength = 0;     // Segment length
   bool runFlag      = false; // invariant-pixel-run flag

   // Annouce commencement of encoding:
   cout
      << endl
      << "Now performing 8-bit run-length encoding...." << endl;

   // Set "far" marker to the beginning of the last full 4-byte block of each row of actual data bytes
   // (ignore padding bytes; these are not written to compressed bitmap):
   rowbytes = width;
   far = (width - (width%4)) - 4;
   BLAT("In RLE8(), before row loop. rowbytes = " << rowbytes    )
   BLAT("In RLE8(), before row loop. far      = " << far         )

   // Iterate up through rows, from bottom to top:
   for ( j = 0 ; j < height ; ++j )
   {
      // Clear row Buffer before processing each new row:
      Buffer.clear();

      // First segment starts at beginning of row, and is empty, so it's length is zero:
      SegmentBegin = SegmentEnd = SegmentLength = 0;

      // Guess state of first segment as "ruf". (If this guess is incorrect, we'll find out immediately and
      // change segment state to "run" in the "ruf" section below.)
      SegmentState = ruf;

      // Now, divide this row up into rough ("ruf") and/or smooth ("run") segments.  This kind of division
      // is best done by a finite state machine.  Now where did I put that?  AH!  Here it is:

      /***************************************************************************************************\
       * Enter finite state machine                                                                      *
      \***************************************************************************************************/

      // Loop while we have not yet reached the start of the last whole word of this row:
      while (SegmentBegin < far)
      {
         switch (SegmentState)
         {
            case ruf:
               // If we get to here, we have reason to believe (or are just guessing, if this is the
               // leftmost pixel of a raster-row of pixels) that the next 4 1-byte pixels are dissimilar.
               // Or, they may be similar TO EACH OTHER, but not to the previous 4 bytes.

               // Let's start by examining the 4-byte "words" beyond current segment end. For each "word",
               // if it consists of of 4 dissimilar bytes, increase segment size by 4 so that this segment
               // now includes that word. Keep increasing segment size as long as the texture remains "ruf".
               // But don't extend this segment beyond 252 bytes or beyond the "far" marker:
               while (SegmentEnd - SegmentBegin < 252 && SegmentEnd < far)
               {
                  // Test to see if next 4 pixels are equal to each other:
                  runFlag =
                     bytematrix[j][SegmentEnd] == bytematrix[j][SegmentEnd+1]
                     &&
                     bytematrix[j][SegmentEnd] == bytematrix[j][SegmentEnd+2]
                     &&
                     bytematrix[j][SegmentEnd] == bytematrix[j][SegmentEnd+3];
                  if (runFlag)         // If those 4 bytes WERE all the same,
                     break;            // the texture is about to become "run", so break out of "ruf" loop.
                  else                 // otherwise the texture continues to be "ruf",
                     SegmentEnd += 4;  // so increment SegmentEnd by 4 bytes and loop again.
               } // end "ruf" inner while loop

               // At this point, we've reached the end of a "ruf" segment.
               // If this segment is not empty, append it to our row buffer:
               SegmentLength = SegmentEnd - SegmentBegin;
               if (0 != SegmentLength)
               {
                  Buffer.push_back(uint8_t(0));
                  ++ByteCounter;
                  Buffer.push_back(uint8_t(SegmentLength));
                  ++ByteCounter;
                  for ( i = SegmentBegin ; i < SegmentEnd ; ++i )
                  {
                     Buffer.push_back(bytematrix[j][i]);
                     ++ByteCounter;
                  }
                  SegmentBegin = SegmentEnd; // Next segment begins 1 byte past end of this Segment.
               }
               SegmentState = run;
               break; // end case ruf

            case run:
               // If we get to here, the current segment is a block of 4 equal 1-byte pixels.
               // Let's see if we can extend this "run" segment.  Begin looping at SegmentEnd, examining
               // pixels 4 at a time to see if they match SegmentBegin.  Cease looping if run-length limit
               // or "far" pointer is reached:
               while (SegmentEnd - SegmentBegin < 252 && SegmentEnd < far)
               {
                  // Test next 4 pixels to see if they are equal to SegmentBegin:
                  runFlag =
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+0]
                     &&
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+1]
                     &&
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+2]
                     &&
                     bytematrix[j][SegmentBegin] == bytematrix[j][SegmentEnd+3];
                  if (!runFlag)        // If these 4 bytes are NOT all equal to the comparison value,
                     break;            // the texture is about to become "ruf", so break out of "run" loop.
                  else                 // Otherwise, set SegmentEnd to beginning of next word and
                     SegmentEnd += 4;  // continue looping.
               } // end "run" inner while loop

               // At this point, we've reached the end of a "run" segment.
               // If this segment is not empty, append it to our row buffer:
               SegmentLength = SegmentEnd - SegmentBegin;
               if (0 != SegmentLength)
               {
                  Buffer.push_back(uint8_t(SegmentLength));
                  ++ByteCounter;
                  Buffer.push_back(uint8_t(bytematrix[j][SegmentBegin]));
                  ++ByteCounter;
                  SegmentBegin = SegmentEnd; // Next segment begins 1 byte past end of this Segment.
               }
               SegmentState = ruf;
               break; // end case run

            default:
               cerr
                  << "Error in rhbitmap::Bitmap::RLE8() : invalid state : " << SegmentState << endl;
               exit(666);
         } // End switch (SegmentState)
      } // end while (SegmentBegin < far)

      /***************************************************************************************************\
       * Exit finite state machine                                                                       *
      \***************************************************************************************************/

      BLAT("In RLE8(), after state machine. SegmentBegin = " << SegmentBegin)
      BLAT("In RLE8(), after state machine. SegmentEnd   = " << SegmentEnd  )
      assert(SegmentBegin == SegmentEnd);
      assert(SegmentBegin == far       );

      // Calculate SegmentLength for remaining 4-7 bytes (last whole word plus leftovers, if any):
      SegmentEnd    = rowbytes;
      SegmentLength = SegmentEnd - SegmentBegin;
      BLAT("In RLE8(), before writing final segment. SegmentLength = " << SegmentLength)
      assert(SegmentLength >= 4);
      assert(SegmentLength <= 7);
      assert(SegmentLength == 4 + rowbytes%4);

      // Write final segment, except for final padding byte:
      Buffer.push_back(uint8_t(0));
      ++ByteCounter;
      Buffer.push_back(uint8_t(SegmentLength));
      ++ByteCounter;
      for ( i = SegmentBegin ; i < SegmentEnd ; ++i )
      {
         Buffer.push_back(uint8_t(bytematrix[j][i]));
         ++ByteCounter;
      }

      // Now write a padding byte, if necessary.  No more than one byte will ever be necessary.  Whereas rows
      // in uncompressed bitmaps are lined-up on 32-bit (DWORD) boundaries, segments in 8-bit RLE bitmaps are
      // lined-up on 16-bit (WORD) boundaries.  So if and only if the length in bytes of the final segment is
      // odd, write one padding byte:
      if (0 != SegmentLength%2)
      {
         Buffer.push_back(uint8_t(0));
         ++ByteCounter;
      }

      // Write end-of-line marker 0x0000:
      Buffer.push_back(uint8_t(0));
      ++ByteCounter;
      Buffer.push_back(uint8_t(0));
      ++ByteCounter;

      // All data for this row has been written to Buffer, so write Buffer to rlematrix,
      // after first asserting that Buffer is not outrageously large:
      assert(Buffer.size() <= RowLimit);
      rlematrix[j] = Buffer;
   } // Loop to top of "for-each-row" loop

   // All rows in bitmap have now be written to disk.
   // Tack end-of-bitmap marker 0x0001 on end of last row:
   rlematrix[height-1].push_back(uint8_t(0));
   ++ByteCounter;
   rlematrix[height-1].push_back(uint8_t(1));
   ++ByteCounter;

   // Set matrixsize to the sum of the byte-lengths of all the rows of rlematrix:
   matrixsize = 0;
   for (j = 0 ; j < height ; ++j )
   {
      matrixsize += int(rlematrix[j].size());
   }

   // Set filesize to the sum of the lengths of the headers, color table, and matrix:
   filesize = 14 + 40 + colortablesize + matrixsize;

   // Announce ByteCounter, matrixsize, and filesize, if BLAT is enabled:
   BLAT("ByteCounter    = " << ByteCounter)
   BLAT("matrixsize     = " << matrixsize )

   // Assert that ByteCounter, RowSizeCounter, and matrixsize are equal and not excessively large;
   // if not, abort:
   assert ( matrixsize == ByteCounter );
   assert ( matrixsize <= MatrixLimit );

   // Print data on bitmap:
   cout
      << endl
      << "Finished 8-bit RLE compression."  << endl
      << "matrixsize = " << matrixsize      << endl
      << "filesize   = " << filesize        << endl
      << "Now exiting RLE8()."              << endl;

   return;
} // end RLE8()

void
rhbitmap::Bitmap::FileWriteInvalidParams
(void)
{
      cerr
         << endl
         << "Error in rhbitmap::Bitmap::filewrite(): invalid bitcount/compression combination." << endl
         << "      bitcount    =" << bitcount    << endl
         << "      compression =" << compression << endl
         << "There's an error code somewhere in my source code which needs to be fixed." << endl;
      exit(1);
}

// constructor for Graph:
rhbitmap::Graph::Graph
(
   double xa,
   double xz,
   double ya,
   double yz,
   int    w,
   int    h,
   int    b,
   bool   c
)
   : Bitmap(w, h, b, c),  // feed w, h, b, c to base-class constructor
     x_min(xa),
     x_max(xz),
     y_min(ya),
     y_max(yz),
     i_span(w),
     j_span(h)

{
   x_span    = x_max - x_min;
   y_span    = y_max - y_min;
   hor_scale = x_span / i_span;
   ver_scale = y_span / j_span;
   cout << endl;
   cout << "Finished constructing Graph object with these parameters:" << endl;
   cout << "x_min     = " << x_min     << endl;
   cout << "x_max     = " << x_max     << endl;
   cout << "y_min     = " << y_min     << endl;
   cout << "y_max     = " << y_max     << endl;
   cout << "x_span    = " << x_span    << endl;
   cout << "y_span    = " << y_span    << endl;
   cout << "i_span    = " << i_span    << endl;
   cout << "j_span    = " << j_span    << endl;
   cout << "hor_scale = " << hor_scale << endl;
   cout << "ver_scale = " << ver_scale << endl;
   return;
}

double
rhbitmap::Graph::getx
(int i)
{
   double x = 0.0;
   x = x_min + (static_cast<double>(i) + 0.5) * hor_scale;
   // Undo any corruption of integers due to floating-point math errors:
   x = rhmath::SnapToInt(x, 1.0e-12); // snap to int if within one part per trillion
   return x;
}

double
rhbitmap::Graph::gety
(int j)
{
   double y = 0.0;
   y = y_min + (static_cast<double>(j) + 0.5) * ver_scale;
   // Undo any corruption of integers due to floating-point math errors:
   y = rhmath::SnapToInt(y, 1.0e-12); // snap to int if within one part per trillion
   return y;
}

int
rhbitmap::Graph::geti
(double x)
{
   // If x is less than x_min, blat and bail:
   if (x < x_min)
   {
      cerr
         << "Error in rhbitmap::Graph::geti(): x is less than x_min." << endl
         << "x_min = " << x_min     << endl
         << "x     = " << x         << endl
         << "Aborting application." << endl;
      abort();
   }

   // If x is greater than x_max, blat and bail:
   if (x > x_max)
   {
      cerr
         << "Error in rhbitmap::Graph::geti(): x is greater than x_max." << endl
         << "x_max = " << x_max     << endl
         << "x     = " << x         << endl
         << "Aborting application." << endl;
      abort();
   }

   // Declare some useful variables:
   double   i    =  0.0;  // Floating-point   version of i
   int      ii   =  0;    // Signed   Integer version of i

   // Get floating-point version of i:
   i  = (x - x_min) / hor_scale;

   // Slightly squeeze i towards 0 by 1 part per 500,000 (1/100 pixel for 5000-pixel-wide graph),
   // so that a maxium x value will still generate an i value slightly less than (i_span - 1):
   i *= 0.999998;

   // Get int version of i:
   ii = int(floor(i));

   assert(ii >= 0);
   assert(ii <= (i_span - 1));

   // If we get to here, ii is in-range, so return it:
   return ii;
}

int
rhbitmap::Graph::getj
(double y)
{
   // If y is less than y_min, blat and bail:
   if (y < y_min)
   {
      cerr
         << "Error in rhbitmap::Graph::getj(): y is less than y_min." << endl
         << "y_min = " << y_min     << endl
         << "y     = " << y         << endl
         << "Aborting application." << endl;
      abort();
   }

   // If y is greater than y_max, blat and bail:
   if (y > y_max)
   {
      cerr
         << "Error in rhbitmap::Graph::getj(): y is greater than y_max." << endl
         << "y_max = " << y_max     << endl
         << "y     = " << y         << endl
         << "Aborting application." << endl;
      abort();
   }

   // Declare some useful variables:
   double    j    =  0.0;  // Floating-point   version of j
   int       jj   =  0;    // Signed   Integer version of j

   // Get floating-point version of j:
   j  = (y - y_min) / ver_scale;

   // Slightly squeeze j towards 0 by 1 part per 500,000 (1/100 pixel for 5000-pixel-tall graph),
   // so that a maxium y value will still generate a j value slightly less than (j_span - 1):
   j *= 0.999998;

   // Get signed-integer version of j:
   jj = int(floor(j));

   assert(jj >= 0);
   assert(jj <= (j_span - 1));

   // If we get to here, jj is in-range, so return it:
   return jj;
}

int
rhbitmap::Graph::plotpoint
   (
      double const & x,
      double const & y,
      int    const & colorselect
   )
{
   // 1,4,8-bit version of point-ploting function.
   // Given (x,y) coordinates and desired color,
   // calls setcolor() on appropriate pixel.

   // If point is inbounds, plot it:
   if ( x >= x_min && x <= x_max && y >= y_min && y <= y_max )
   {
      int i = geti(x);
      int j = getj(y);
      setcolor(i, j, colorselect);
      return 1;
   }
   // Otherwise, return 0 to indicate failure:
   else
   {
      return 0;
   }
}

int
rhbitmap::Graph::plotpoint
   (
      double const & x,
      double const & y,
      Color  const & color
   )
{
   // 24-bit version of point-ploting function.
   // Given (x,y) coordinates and desired color,
   // calls setcolor() on appropriate pixel.

   // If point is inbounds, plot it:
   if ( x >= x_min && x <= x_max && y >= y_min && y <= y_max )
   {
      int i = geti(x);
      int j = getj(y);
      setcolor(i, j, color);
      return 1;
   }
   // Otherwise, return 0 to indicate failure:
   else
   {
      return 0;
   }
}

int
rhbitmap::Graph::plotpixel
   (int const & i, int const & j, int const & colorselect)
{
   // 1,4,8-bit version of pixel-ploting function.
   // If all inputs are in-range, plot pixel and return 1:
   if ( i >= 0 && i <= width-1 && j >= 0 && j <= height-1 )
   {
      setcolor(i, j, colorselect);
      return 1;
   }
   // Otherwise, return 0 to indicate failure:
   else
   {
      return 0;
   }
}

int
rhbitmap::Graph::plotpixel
   (
      int   const & i,
      int   const & j,
      Color const & color
   )
{
   // 24-bit version of pixel-ploting function.
   // If all inputs are in-range, plot pixel and return 1:
   if ( i >= 0 && i <= width-1 && j >= 0 && j <= height-1 )
   {
      setcolor(i, j, color);
      return 1;
   }
   // Otherwise, return 0 to indicate failure:
   else
   {
      return 0;
   }
}
