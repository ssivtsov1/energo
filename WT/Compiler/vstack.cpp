#include "vstack.h"

TVar::TVar(int T, char * N)
{
 NType=T;
 strcpy(Name,N);
}

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


