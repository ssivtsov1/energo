#if !defined(__SSTACK_H)
#define __SSTACK_H

#include <System.hpp> 

class TStringItem1
{
 public:
  TStringItem1() {};
  TStringItem1* Next;
  char Item[20];
};

class TWTStringStack
{
 public:
  int CountI;
  TWTStringStack();
  ~TWTStringStack();
  void Top(char *);
  void Push(char *);
  void Pop(char *);
  char Empty();
  TStringItem1 * Head;
  void GetItem(int,char *);
};

#endif
