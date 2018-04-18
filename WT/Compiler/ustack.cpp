#include "ustack.h"

template<class T> TCustomStack<T>::TCustomStack()
{
 Head=NULL;CountI=0;
};

template<class T> T TCustomStack<T>::GetItem(int Nom)
{
 TStackItem<T> * Tec=Head;
 for (int i=0;i<Nom;i++,Tec=Tec->Next);
 return Tec->Item;
}

template<class T> T TCustomStack<T>::Top()
{
 return Head->Item;
}

template<class T> void TCustomStack<T>::Push(T& Param)
{
 TStackItem<T> *I=new TStackItem<T>;
 I->Next=Head;
 Head=I;
 Head->Item=Param;
 CountI++;
}

template<class T> T TCustomStack<T>::Pop()
{
 if (!Empty())
 {
  TStackItem<T> *I;
  T R;
  I=Head;
  Head=Head->Next;
  R=I->Item;
  delete I;
  CountI--;
  return R;
 }
}

template<class T> char TCustomStack<T>::Empty()
{
 return (char)(Head==NULL);
}

/*template<class T> TCustomStack<T>::~TCustomStack()
{
 while(!Empty()) Pop();
} */

