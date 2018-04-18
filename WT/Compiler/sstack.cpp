#include "sstack.h"

TWTStringStack::TWTStringStack()
{
 Head=NULL;
 CountI=0;
};

void TWTStringStack::GetItem(int Nom,char * R)
{
 TStringItem1 * Tec=Head;
 for (int i=0;i<Nom;i++,Tec=Tec->Next);
 strcpy(R,Tec->Item);
}

void TWTStringStack::Top(char * R)
{
 strcpy(R,Head->Item);
}

void TWTStringStack::Push(char * Param)
{
 TStringItem1 *I=new TStringItem1;
 I->Next=Head;
 Head=I;
 strcpy(Head->Item,Param);
 CountI++;
}

void TWTStringStack::Pop(char * R)
{
 if (!Empty())
 {
  TStringItem1 *I;
  I=Head;
  Head=Head->Next;
  strcpy(R,I->Item);
  delete I;
  CountI--;
 }
}

char TWTStringStack::Empty()
{
 return (char)(Head==NULL);
}

TWTStringStack::~TWTStringStack()
{
 char R[20];
 while(!Empty()) Pop(R);
}

