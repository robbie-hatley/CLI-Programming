/// This is a 110-character-wide ASCII-encoded C++ header file.
#ifndef RHEXPERIMENTAL_CPP_HEADER_ALREADY_INCLUDED
#define RHEXPERIMENTAL_CPP_HEADER_ALREADY_INCLUDED
/*
"rhexperimental.hpp"
*/

#include "rhdefines.h"

template<class T, class F>
class GlueFunctor_void
{
   public:
      GlueFunctor_void(T* p) : ptr(p) {}
      void operator()(void) {ptr->F();}
   private:
      T* ptr;
};


template<class T1, class T2>
class GlueFunctor_unary
{
   public:
      FileLineCounter(MyType* p) : ptr(p) {}
      void operator()(const FileRecord& File) {ptr->CountLinesInFile(File);}
   private:
      MyType* ptr;
};

// End include guard:
#endif
