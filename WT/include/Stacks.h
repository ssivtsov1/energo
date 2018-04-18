//---------------------------------------------------------------------------
#ifndef StacksH
#define StacksH
//---------------------------------------------------------------------------
typedef int* PInt;

class TStackItem
{
 public:
  TStackItem() {};
  TStackItem* Next;
  void* Item;
};

class TCustomStack
{
 public:
  int CountI;
  TCustomStack()
  {
    Head=NULL;CountI=0;
  };
  ~TCustomStack()
  {
    while(!Empty()) Pop();
  }
  void* Top();
  void Push(void* Value);
  void* Pop();
  boolean Empty();
  TStackItem* Head;
  void* GetItem(int);
};

class TIntStack: public TCustomStack
{
public:
  void Push(int Value) {
    PInt P=new int;
    *P=Value;
    TCustomStack::Push(P);
  };
  int Top() {
    if (Empty()) return NULL;
    return (GetItem(0));
  };
  int GetItem(int Index) {
    if (Empty()) return NULL;
    void* V=TCustomStack::GetItem(Index);
    return (*PInt(V));
  };
  int Pop() {
    if (Empty()) return NULL;
    void* V=TCustomStack::Pop();
    int I=*PInt(V);
    delete V;
    return (I);
  };
};

//typedef TCustomStack<int> TIntStack;
//typedef TCustomStack<char> TCharStack;*/

#endif
