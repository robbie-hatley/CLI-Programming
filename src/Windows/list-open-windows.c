// list-open-windows.c
#define UNICODE
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <wchar.h>

int WindowCount = 0;

BOOL CALLBACK DisplayWindowTitle (HWND hwnd, LPARAM lParam)
{
   wchar_t windowText [1024] = L""; // text in the window's title bar
   if (GetWindowTextW(hwnd, windowText, 1023))
   {
      ++WindowCount;
       printf( "\n"                                              );
      wprintf(L"Window # %d"               , WindowCount         );
       printf( "\n"                                              );
      wprintf(L"Window Text Length = %lu"  , wcslen(windowText)  );
       printf( "\n"                                              );
      wprintf(L"Window Text: %ls"          , windowText          );
       printf( "\n"                                              );
      wprintf(L"lParam = %llu"             , lParam              );
       printf( "\n"                                              );
   }
   return TRUE;
}

int main (void)
{
   EnumDesktopWindows
   (
      NULL,               // Desktop to enumerate (NULL is default)
      DisplayWindowTitle, // Callback function
      0                   // lParam value to callback function
   ); 
   return 0;
}