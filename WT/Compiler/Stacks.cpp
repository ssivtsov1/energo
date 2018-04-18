//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Stacks.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
void* TCustomStack::GetItem(int Nom)
{
 TStackItem* Tec=Head;
 for (int i=0;i<Nom;i++,Tec=Tec->Next);
 return Tec->Item;
}

void* TCustomStack::Top()
{
 return Head->Item;
}

void TCustomStack::Push(void* Value)
{
 TStackItem* I=new TStackItem;
 I->Next=Head;
 Head=I;
 Head->Item=Value;
 CountI++;
}

void* TCustomStack::Pop()
{
 if (!Empty())
 {
  TStackItem *I;
  void* R;
  I=Head;
  Head=Head->Next;
  R=I->Item;
  delete I;
  CountI--;
  return R;
 }
 return NULL;
}

boolean TCustomStack::Empty()
{
 return Head==NULL;
}
