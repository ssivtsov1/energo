#include "tstack.h"

TType::TType(int T, char * N)
{
 NType=T;
 strcpy(Name,N);
}

int TTypeStack::Exist(char * N)
{
 TStackItem<TType> * Tec=Head;
 while (Tec!=NULL)
 {
  if (!strcmp(N,Tec->Item.Name)) return 1;
  Tec=Tec->Next;
 }
 return 0;
}

void TTypeStack::AddField(char * N,int T,char F[])
{
 TStackItem<TType> * Tec=Head;
 while (Tec!=NULL)
 {
  if (!strcmp(N,Tec->Item.Name))
  {
   Tec->Item.Fields.Push(TVar(T,F));
   return;
  }
  Tec=Tec->Next;
 }
}

int TTypeStack::ExistField(char * N,char * F)
{
 TStackItem<TType> * Tec=Head;
 while (Tec!=NULL)
 {
  if (!strcmp(N,Tec->Item.Name))
  {
   if (Tec->Item.Fields.Exist(F)) return 1;
   return 0;
  }
  Tec=Tec->Next;
 }
 return 0;
}

int TTypeStack::GetSize(int N)
{
 switch (N)
 {
 case 0:
 case 2:
  return 1;
 case 1:
  return 2;
 default:
  TStackItem<TType> * Tec=Head;
  while (Tec!=NULL)
  {
   if (N==Tec->Item.NType)
   {
    TStackItem<TVar> *TecF=Tec->Item.Fields.Head;
    int a=0;
    while (TecF!=NULL)
    {
     a+=GetSize(TecF->Item.NType);
     TecF=TecF->Next; 
    }
    return a;
   }
   Tec=Tec->Next; 
  }
  break;
 }
 return 0;
}

int TTypeStack::ExistFieldT(int N,char * F)
{
 TStackItem<TType> * Tec=Head;
 while (Tec!=NULL)
 {
  if (N==Tec->Item.NType)
  {
   if (Tec->Item.Fields.Exist(F)) return 1;
   return 0;
  }
  Tec=Tec->Next;
 }
 return 0;
}

int TTypeStack::FindField(int N,char * F)
{
 TStackItem<TType> * Tec=Head;
 while (Tec!=NULL)
 {
  if (N==Tec->Item.NType) return Tec->Item.Fields.FindVar(F);
  Tec=Tec->Next;
 }
 return 0;
}

int TTypeStack::FindType(char * N)
{
 TStackItem<TType> * Tec=Head;
 while (Tec!=NULL) 
 {
  if (!strcmp(N,Tec->Item.Name)) return Tec->Item.NType;
  Tec=Tec->Next;
 }
 return -1;
}

