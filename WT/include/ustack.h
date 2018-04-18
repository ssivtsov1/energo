#if !defined(__USTACK_H)
#define __USTACK_H

#include <System.hpp>

template <class Q>
class TStackItem
{
 public:
  TStackItem() {};
  TStackItem* Next;
  Q Item;
};

template<class T>
class TCustomStack
{
 public:
  int CountI;
  TCustomStack()
  {
   Head=NULL;CountI=0;
  };
  ~TCustomStack();
  T Top();
  void Push(T&);
  void Clear();
  T Pop();
  char Empty();
  TStackItem<T> * Head;
  T GetItem(int);
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

template<class T> void TCustomStack<T>::Clear()
{
  while (CountI>0) Pop();
}

template<class T> T TCustomStack<T>::Pop()
{
 T R;
 if (!Empty())
 {
  TStackItem<T> *I;
  I=Head;
  Head=Head->Next;
  R=I->Item;
  delete I;
  CountI--;
 }
  return R;
}

template<class T> char TCustomStack<T>::Empty()
{
 return (char)(Head==NULL);
}

template<class T> TCustomStack<T>::~TCustomStack()
{
 while(!Empty()) Pop();
}

typedef TCustomStack<char> TCharStack;
typedef TCustomStack<int> TIntStack;

#endif
