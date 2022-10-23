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
