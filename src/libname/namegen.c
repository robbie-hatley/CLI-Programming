
/************************************************************************************************************\
 * This file is from Nanosoft's "Random Name Generator version 1.0", with comments added by Robbie Hatley on 
 * Mon Mar 21, 2016 and updated on Thu Feb 15, 2018.
 * This library generates random names. It was originally in C++, but I converted it to C so that it can be
 * used in both C and C++ programs.
 * This file defines the function getrandomname() which generates random names.
\************************************************************************************************************/

#include <stdlib.h>
#include <malloc.h>
#include <string.h>

extern char* _nsn_firstname_list[];
extern long _nsn_firstname_amount;
extern char* _nsn_lastname_list[];
extern long _nsn_lastname_amount;

char* getrandomname()
{
        long firstname=rand()%_nsn_firstname_amount;
        long lastname=rand()%_nsn_lastname_amount;
        long firstnamelength=strlen( _nsn_firstname_list[firstname] );
        long totallength=firstnamelength+1;
        long lastnamelength=strlen( _nsn_lastname_list[lastname] );
        totallength+=lastnamelength+1;
        
        long useanotherlastname=rand()%4;
        long otherlastname, otherlastnamelength;
        if(!useanotherlastname)
        {
                otherlastname=rand()%_nsn_lastname_amount;
                otherlastnamelength=strlen( _nsn_lastname_list[otherlastname] );
                totallength+=otherlastnamelength+1;
        }
        char* thename=(char*)malloc(totallength);
        char* whereiam=thename;
        memcpy(whereiam, _nsn_firstname_list[firstname], firstnamelength);
        whereiam+=firstnamelength;
        *(whereiam++)=' ';
        memcpy(whereiam, _nsn_lastname_list[lastname], lastnamelength);
        whereiam+=lastnamelength;
        if(!useanotherlastname)
        {
                *(whereiam++)='-';
                memcpy(whereiam, _nsn_lastname_list[otherlastname], otherlastnamelength);
                whereiam+=otherlastnamelength;
        }
        *(whereiam++)=0;
        return thename;
}
