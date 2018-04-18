#if !defined(__LEXEM_H)
#define __LEXEM_H

#include <string.h>

struct TDictUnit;

class TWTLexema
{
 public:
  int Row;
  int Simb;
  TDictUnit * Item;
  char Value[255];
  ~TWTLexema() {};
  TWTLexema() {};
  TWTLexema(TDictUnit *, char *,int,int);
};

#endif
