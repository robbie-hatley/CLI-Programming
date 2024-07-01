// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/****************************************************************************\
 * File name:   clock1.cpp
 * Title:       Clock1
 * Authorship:  Written Wednesday January 1, 2003, by Robbie Hatley.
 * Last edited: Sunday May 4, 2003.
 * Description: Prints current date and time.
 * Inputs:      None.
 * Outputs:     Date and time.
 * Notes:       A test of stringstream and altering arguments by reference.
 * To make:     Just compile.  (Doesn't use external object files.)
\****************************************************************************/


/****************************************************************************\
 *                  PREPROCESSOR DIRECTIVES:                                *
\****************************************************************************/

#include <ctime>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <vector>


/****************************************************************************\
 *                  GLOBAL DECLARATIONS:                                    *
\****************************************************************************/

// "using" declarations:
using std::cout;
using std::cerr;
using std::endl;
using std::string;
using std::stringstream;
using std::vector;
using std::setw;
using std::setfill;

// Function Prototypes:
void LoadStruct(tm&);
string ComposeDateString(const tm&);
string ComposeTimeString(const tm&);


/****************************************************************************\
 *                  FUNCTION DEFINTIONS:                                    *
\****************************************************************************/

void LoadStruct(tm& ts)
{
  time_t t;          // declare t to be a variable of type "time_t"
  time(&t);          // load current time into t from system clock
  ts=*localtime(&t); // load broken-down version of time info. from t into ts
  return;
}

string ComposeDateString(const tm& ts)
{
  static vector<string> days (7);
  days[0]="Sunday";         days[1]="Monday";        days[2]="Tuesday";
  days[3]="Wednesday";      days[4]="Thursday";      days[5]="Friday";
  days[6]="Saturday";
  static vector<string> months (12);
  months[0]="January";      months[1]="February";    months[2]="March";
  months[3]="April";        months[4]="May";         months[5]="June";
  months[6]="July";         months[7]="August";      months[8]="September";
  months[9]="October";      months[10]="November";   months[11]="December";
  stringstream datestream;
  datestream << days[ts.tm_wday] << " " << months[ts.tm_mon] << " ";
  datestream << ts.tm_mday << ", " << (1900+ts.tm_year);
  return datestream.str();
}

string ComposeTimeString(const tm& ts)
{
  int hour;
  if (0==ts.tm_hour || 12==ts.tm_hour)
    hour=12;
  else
    hour=ts.tm_hour%12;
  string mer;
  if (ts.tm_hour<12)
    mer="AM";
  else
    mer="PM";
  string sav;
  if (ts.tm_isdst>0)
    sav="PDT";
  else
    sav="PST";
  stringstream timestream;
  timestream << setw(2) << setfill(' ');
  timestream << hour << ":";
  timestream << setw(2) << setfill('0');
  timestream << ts.tm_min << ":";
  timestream << setw(2) << setfill('0');
  timestream << ts.tm_sec << mer << " " << sav;
  return timestream.str();
}


/****************************************************************************\
 *                  MAIN:                                                   *
\****************************************************************************/

int main(void)
{
  tm timeStruct;
  LoadStruct(timeStruct);
  string dateString, timeString;
  dateString=ComposeDateString(timeStruct);
  timeString=ComposeTimeString(timeStruct);
  cout << timeString << ", " << dateString;
  return 0;
}
