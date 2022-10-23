/************************************************************************************************************\
 * This file is from Nanosoft's "Random Name Generator version 1.0", with comments added by Robbie Hatley on 
 * Mon Mar 21, 2016 and updated on Thu Feb 15, 2018.
 * This library generates random names. It was originally in C++, but I converted it to C so that it can be
 * used in both C and C++ programs.
 * This file is the header which should be included in programs using this library.
\************************************************************************************************************/

#ifdef __cplusplus

extern "C"
{
   char* getrandomname();
}
   
#else

char* getrandomname();

#endif
