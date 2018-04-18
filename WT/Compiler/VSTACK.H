#if !defined(__VSTACK_H)
#define __VSTACK_H

#include "ustack.h"

struct TVar
{
 int NType;
 char Name[20];
 TVar(int,char *);
 TVar() {};
};

TVar::TVar(int T, char * N)
{
 NType=T;
 strcpy(Name,N);
}

class TVarStack:public TCustomStack<TVar>
{
 public:
 int FindVar(char *);
 int Exist(char *);
};

int TVarStack::Exist(char * N)
{
 TStackItem<TVar> * Tec=Head;
 while (Tec!=NULL) 
 {
  if (!strcmp(N,Tec->Item.Name)) return 1;
  Tec=Tec->Next;
 }
 return 0;
}

int TVarStack::FindVar(char * N)
{
 TStackItem<TVar> * Tec=Head;
 while (Tec!=NULL) 
 {
  if (!strcmp(N,Tec->Item.Name)) return Tec->Item.NType;
  Tec=Tec->Next;
 }
 return 255;
}

#endif
