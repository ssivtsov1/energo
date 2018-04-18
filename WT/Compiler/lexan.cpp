#include "lexan.h"

TWTAnalizer::TWTAnalizer(TWTGrammar *GL,char * FN)
{
 Generator=new TWTGenerator(FN);
 Grammar=GL;
}

void TWTAnalizer::Init(){
  Generator->Init();
  LS.Clear();
  RS.Clear();
}

void Show(TCharStack &X)
{
 TCharStack NewS;
 while (!X.Empty()) NewS.Push(X.Pop());
 while (!NewS.Empty())
 {
  cout << NewS.Top();
  X.Push(NewS.Pop());
 }
 cout << endl;
}

int TWTAnalizer::Analize(TWTLexema L)
{
 char R;
 int RR,SS;
 TMLFormula *MLF;
 if (LS.Empty()) LS.Push(L);
 else
 {
  while (Grammar->RelMatrix->GetData(LS.Top().Item->Kod,L.Item->Kod)==REL_PRIOR)
  {
   TCustomStack<TWTLexema> *PLS=new TCustomStack<TWTLexema>;
   RR=LS.Top().Row;
   SS=LS.Top().Simb;
   do
   {
    R=RS.Pop();
    PLS->Push(LS.Pop());
   }
   while (R!=REL_POST);
   if ((MLF=FindRule(PLS))==NULL)
   {
    while (!PLS->Empty()) PLS->Pop().Item->Show();
    return 200;      //не найдено правило
   }
   if (DEBUG) Grammar->ShowRule(MLF->Number);
   if (LS.Top().Item==Grammar->SpecSimbol)
   if (MLF->Item->Kod==0)
   if (L.Item==Grammar->SpecSimbol)
   {
    LS.Pop();
    delete PLS;
    return 0;
   }
   RS.Push(Grammar->RelMatrix->GetData(LS.Top().Item->Kod,MLF->Item->Kod));
   LS.Push(TWTLexema(MLF->Item,"",RR,SS));
   int Error=Generator->Generate(MLF->Number,PLS);
   if (Error) return Error;
   delete PLS;
  }
  switch (Grammar->RelMatrix->GetData(LS.Top().Item->Kod,L.Item->Kod))
  {
   case REL_EQUAL:
   {
    LS.Push(L);
    RS.Push(REL_EQUAL);
    break;
   }
   case REL_POST:
   {
    LS.Push(L);
    RS.Push(REL_POST);
    break;
   }
   default:
   {
    return 201;
   }
  }
 }
 return 0;
}

TMLFormula *TWTAnalizer::FindRule(TCustomStack<TWTLexema> *LS)
{
 TStackItem<TWTLexema> *Tec;
 if (LS->Empty()) return NULL;
 if (Grammar->FirstFormula()==NULL) return NULL;
 do
 {
  Tec=LS->Head;
  if ((Grammar->GetTecLex()!=NULL) && (Grammar->GetTecF()->CountR==LS->CountI))
  do
  {
   if (Tec->Item.Item->Kod!=Grammar->GetTecLex()->Item->Kod) break;
   Tec=Tec->Next;
   Grammar->NextLex();
  }
  while (Tec!=NULL);
  if (Tec==NULL) return Grammar->GetTecF();
 }
 while(Grammar->NextFormula()!=NULL);
 return NULL;
}

