#include "gener.h"
#include "dialogs.hpp"


void CopyArray(Variant *Dest,Variant *Src,int X,int Y){
  for (int x=0;x<X*Y;x++) {
    Dest[x]=NULL;
    Dest[x]=Src[x];
  }
}

TWTGenerator::~TWTGenerator()
{
 fclose(f);
 delete TypeStack;
 delete VarStack;
 delete OperStack;
 delete IDStack;
 delete VarsList;
 delete FuncList;
 delete ParamStack;
 delete PCountStack;
 delete ValueStack;
 delete MultiVars;
}

void TWTGenerator::Init(){
 ErrorCode=0;
 RepFlag=false;
 BEBalance=0;
 BEStop=-1;
 StopFlag=false;
 VarCount=0;
 LabelCount=0;
 RecCount=6;
 TypeStack->Clear();
 VarStack->Clear();
 OperStack->Clear();
 PCountStack->Clear();
 IDStack->Clear();
 MultiVars->Clear();
 for (int x=0;x<ValueStack->CountI;x++) {
   delete ValueStack->GetItem(x);
 }
 ValueStack->Clear();
 ParamStack->Clear();
 for (int x=0;x<VarsList->Count;x++){
   delete VarsList->GetVar(x);
 }
 VarsList->Clear();
 fclose(f);
 f=fopen("Rules.aaa","w");
}

TWTGenerator::TWTGenerator(char * FN)
{
 ErrorCode=0;
 OnDoFunction=NULL;
 OnDoMultiFunction=NULL;
 OnMultiVars=NULL;
 OnSetMultiVars=NULL;
 OnCheckParams=NULL;
 ReturnValue=NULL;
 RepFlag=false;
 BEBalance=0;
 BEStop=-1;
 StopFlag=false;
 VarCount=0;
 LabelCount=0;
 RecCount=6;
 TypeStack=new TTypeStack();
 VarStack=new TVarStack();
 OperStack=new TIntStack();
 PCountStack=new TIntStack();
 IDStack=new TCustomStack<AnsiString>();
 ValueStack=new TCustomStack<TWTValue*>();
 ParamStack=new TCustomStack<Variant>();
 VarsList= new TWTVarsList();
 FuncList= new TWTFuncList(this);
 MultiVars=new TStringList();
 strcpy(FName,FN);
 f=fopen("Rules.aaa","w");
}

int TWTGenerator::Generate(int NomRule,TCustomStack<TWTLexema> * Values)
{
 char SSS[20],TTT[20],UUU[20];
 int III,LLL,i;
// char *a=StrCat(IntToStr(NomRule).c_str(),"\n");
/* fputs(IntToStr(NomRule).c_str(),f);
 fputs("\n",f);*/
 Variant v;
 TWTValue *MVar;
 AnsiString a;
 TWTFunc *Func;
 Variant *VVV;

 //Правила для управления процессом выполнения
 switch (NomRule) {
// case 7:
 case 6: {
   if (BEStop==BEBalance) StopFlag=false;
   break;
 }
 case 102: {
 //  if (BEStop==BEBalance) StopFlag=!StopFlag;
   if (BEStop==-1) {
     StopFlag=!StopFlag;
     break;
   }
   if (BEStop>=BEBalance) StopFlag=false;
   else StopFlag=true;
   break;
 }
 case 117: {
   if ((BEStop==-1) || (BEStop==BEBalance)) {
     BEStop=-1;
     StopFlag=false;
   }
   break;
 }
 case 200: {
  BEBalance++;
  break;
  break;
 }
 case 201:
 case 202: {
  BEBalance--;
  break;
 }
 }
 if (StopFlag) return 0;

 //Правила для вычисления выражений и т.п.
 switch (NomRule)
 {
 case 1:
   break;
 case 9:
 case 10: {
   if (ReturnValue) delete ReturnValue;
   ReturnValue=ValueStack->Pop();
   break;
   }
 case 11: {
   int ss=PCountStack->Pop();
   TWTValue* V=NULL;
   a=IDStack->Pop();
   MultiVars->Add(a);
   if (OnCheckParams) {
     ErrorCode=OnCheckParams(MultiVars,ss,ValueStack);
     if (ErrorCode) return ErrorCode;
   }
   else {
     Func=FuncList->FuncByName(a);
     int Cnt=Func->ParamCount;
     if (Func==NULL) return 304;
     if (Func->ParamCount!=255) {
       if (Func->ParamCount!=ss) {return 306;} //несоответствие количества параметров
       for (int x=Cnt-1;x>=0;x--) {
         int TT=ValueStack->GetItem(x)->Value[0].Type();
         switch (Func->ParamType[Cnt-1-x]) {
         case 0: {
           break;
         }
         case 1: {
           if ((TT<1) || ((TT>6) && (TT!=11))) return 302; //несоответствие типов
           break;
         }
         case 2: {
           if (TT!=varString) return 302; //несоответствие типов
           break;
         }
         }
       }
     }
   }
   TWTValue *VV[100];
   for (int x=0;x<ss;x++) {
     VV[ss-x-1]=ValueStack->Pop();
   }
   if (MultiVars->Count==1) {
     if (OnDoMultiFunction) {
       V=OnDoFunction(a,ss,VV);
     }
   }
   else {
     if (OnDoMultiFunction) {
       V=OnDoMultiFunction(MultiVars,ss,VV);
     }
   }
   for (int x=0;x<ss;x++) {
     delete VV[x];
   }
   if (ErrorCode) return ErrorCode;
   if (V==NULL) return 308; //ошибка выполнения функции
   MultiVars->Clear();
   ValueStack->Push(V);
   break;
   }
 case 318: {
   a=Values->GetItem(1).Value;
   IDStack->Push(a);
   PCountStack->Push(0);
   break;
   }
 case 12: {
   a=Values->GetItem(0).Value;
   IDStack->Push(a);
   PCountStack->Push(0);
   break;
   }
 case 13:
 case 17: {
   PCountStack->Push(PCountStack->Pop()+1);
   break;
   }
 case 25: {
   OperStack->Push(0);
   break;
   }
 case 26: {
   OperStack->Push(3);
   break;
   }
 case 27: {
   OperStack->Push(1);
   break;
   }
 case 28: {
   OperStack->Push(2);
   break;
   }
 case 29: {
   OperStack->Push(0);
   break;
   }
 case 30: {
   OperStack->Push(1);
   break;
   }
 case 52:
   ValueStack->Push(SimpleVal(atof(Values->GetItem(0).Value)));
   break;
 case 53:
   ValueStack->Push(SimpleVal(Values->GetItem(0).Value));
   break;
 case 54:
   ValueStack->Push(SimpleVal(Values->GetItem(0).Value));
   break;
 case 55:
   ValueStack->Push(SimpleVal(-1.0));
   break;
 case 56:
   ValueStack->Push(SimpleVal(0.0));
   break;
 case 63:
   float CDX,CDY;
   try {
     MVar=ValueStack->Pop();
     CDY=MVar->Value[0];
     delete MVar;
     MVar=ValueStack->Pop();
     CDX=MVar->Value[0];
     delete MVar;
   } catch (...) {
     return 302;
   }
   if ((CDX!=int(CDX)) || (CDX<0) || (CDY!=int(CDY)) || (CDY<0)) return 302;
   MVar=VarsList->VarByName(IDStack->Pop());
   if (VarsList->ErrorCode) return 301; //не найдена переменная
   if ((CDX>=MVar->XDim) || (CDY>=MVar->YDim)) return 307; //out of range
   ValueStack->Push(SimpleVal(MVar->Value[int((MVar->XDim)*CDY+CDX)]));
   break;
 case 51: {
//   if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
   MVar=VarsList->ValByName(Values->GetItem(0).Value);
   if (VarsList->ErrorCode) return 301;
   TWTValue *V=new TWTValue("",(Variant*)calloc(MVar->XDim*MVar->YDim,sizeof(Variant)),MVar->XDim,MVar->YDim);
   CopyArray(V->Value,MVar->Value,MVar->XDim,MVar->YDim);
   ValueStack->Push(V);
   break;
 }
 case 36: {
   try {
     if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
     if ((ValueStack->GetItem(1)->XDim>1) || (ValueStack->GetItem(1)->YDim>1)) return 302;
     MVar=SimpleVal(ValueStack->GetItem(1)->Value[0]+ValueStack->GetItem(0)->Value[0]);
   }
   catch (...) {
     return 302;
   }
   ValueStack->Pop();
   ValueStack->Pop();
   ValueStack->Push(MVar);
   break;
 }
 case 57: {
   ResultVar=Values->GetItem(0).Value;
   OperStack->Push(-1);
   break;
 }
 case 65: {
   ResultVar=IDStack->Pop();
   float CDX,CDY;
   try {
     MVar=ValueStack->Pop();
     CDY=MVar->Value[0];
     delete MVar;
     MVar=ValueStack->Pop();
     CDX=MVar->Value[0];
     delete MVar;
   } catch (...) {
     return 302;
   }
   if ((CDX!=int(CDX)) || (CDX<0) || (CDY!=int(CDY)) || (CDY<0)) return 302;
   MVar=VarsList->VarByName(ResultVar);
   if (VarsList->ErrorCode) return 301; //не найдена переменная
   if ((CDX>=MVar->XDim) || (CDY>=MVar->YDim)) return 307; //out of range
   OperStack->Push(int((MVar->XDim)*CDY+CDX));
   break;
 }
 case 62: {
   int CD=OperStack->Pop();
   int Error;
   if (CD==-1) {
     if (ResultVar==""){
       MVar=ValueStack->Pop();
       if (OnSetMultiVars) Error=OnSetMultiVars(MultiVars,MVar);
       delete MVar;
       MultiVars->Clear();
       if (Error) return Error;
       break;
     }
     MVar=ValueStack->Pop();
     VarsList->ValByName(ResultVar);
     if (VarsList->ErrorCode) {
       MVar->VarName=ResultVar;
       VarsList->AddVar(MVar);
     } else {
       if ((VarsList->VarByName(ResultVar)->XDim!=MVar->XDim) || (VarsList->VarByName(ResultVar)->YDim!=MVar->YDim)) return 302;
       if (VarsList->VarByName(ResultVar)->Value[0].Type()!=MVar->Value[0].Type()) return 303;
       delete VarsList->VarByName(ResultVar)->Value;
       VarsList->VarByName(ResultVar)->Value=MVar->Value;
       MVar->Value=NULL;
       delete MVar;
     }
   } else {
     MVar=ValueStack->Pop();
     TWTValue* V=VarsList->VarByName(ResultVar);
     V->Value[CD]=MVar->Value[0];
     delete MVar;
   }
   break;
 }
 case 41:
 case 44:
 case 45:
 case 42: {
   if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
   if ((ValueStack->GetItem(1)->XDim>1) || (ValueStack->GetItem(1)->YDim>1)) return 302;
   switch (OperStack->Pop()) {
     case 0: {
       try {
         MVar=SimpleVal(ValueStack->GetItem(0)->Value[0]*ValueStack->GetItem(1)->Value[0]);
       }
       catch (...) {
         return 302;
       }
       delete ValueStack->Pop();
       delete ValueStack->Pop();
       ValueStack->Push(MVar);
       break;
     }
     case 1: {
       try {
         MVar=SimpleVal(int(ValueStack->GetItem(1)->Value[0]/ValueStack->GetItem(0)->Value[0]));
       }
       catch (...) {
         return 302;
       }
       delete ValueStack->Pop();
       delete ValueStack->Pop();
       ValueStack->Push(MVar);
       break;
     }
     case 2: {
       try {
         MVar=SimpleVal(ValueStack->GetItem(1)->Value[0]%ValueStack->GetItem(0)->Value[0]);
       }
       catch (...) {
         return 302;
       }
       delete ValueStack->Pop();
       delete ValueStack->Pop();
       ValueStack->Push(MVar);
       break;
     }
     case 3: {
       try {
         MVar=SimpleVal(ValueStack->GetItem(1)->Value[0]/ValueStack->GetItem(0)->Value[0]);
       }
       catch (...) {
         return 302;
       }
       delete ValueStack->Pop();
       delete ValueStack->Pop();
       ValueStack->Push(MVar);
       break;
     }
   };
   break;
 }
 case 48:
 case 34: {
  if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
  try {
    if (!OperStack->Pop()) ValueStack->GetItem(0)->Value[0]=-ValueStack->GetItem(0)->Value[0];
  }
  catch (...) {
    return 302;
  }
  break;
 }
 case 31:
  if (OperStack->Pop())
  {
   if (OperStack->Pop()) OperStack->Push(1); else OperStack->Push(0);
  }
  else
  {
   if (OperStack->Pop()) OperStack->Push(0); else OperStack->Push(1);
  }
  break;
 case 83: {
  OperStack->Push(0);
  break;
 }
 case 84: {
  OperStack->Push(1);
  break;
 }
 case 85: {
  OperStack->Push(2);
  break;
 }
 case 86: {
  OperStack->Push(3);
  break;
 }
 case 87: {
  OperStack->Push(4);
  break;
 }
 case 88: {
  OperStack->Push(5);
  break;
 }
 case 89: {
  OperStack->Push(6);
  break;
 }
 case 93: {
  OperStack->Push(7);
  break;
 }
 case 90:
 case 107:
 case 109: {
   if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
   if ((ValueStack->GetItem(1)->XDim>1) || (ValueStack->GetItem(1)->YDim>1)) return 302;
   switch (OperStack->Pop()) {
     case 0: {
       try {
         MVar=SimpleVal(ValueStack->GetItem(1)->Value[0]>ValueStack->GetItem(0)->Value[0]);
       }
       catch (...) {
         return 302;
       }
       break;
     }
     case 1: {
       try {
         Variant VV=float(ValueStack->GetItem(1)->Value[0]<ValueStack->GetItem(0)->Value[0]);
         MVar=SimpleVal(VV);
       }
       catch (...) {
         return 302;
       }
       break;
     }
     case 2: {
       try {
         MVar=SimpleVal(float(ValueStack->GetItem(1)->Value[0]>=ValueStack->GetItem(0)->Value[0]));
       }
       catch (...) {
         return 302;
       }
       break;
     }
     case 3: {
       try {
         MVar=SimpleVal(ValueStack->GetItem(1)->Value[0]<=ValueStack->GetItem(0)->Value[0]);
       }
       catch (...) {
         return 302;
       }
       break;
     }
     case 4: {
       try {
         MVar=SimpleVal(ValueStack->GetItem(1)->Value[0]!=ValueStack->GetItem(0)->Value[0]);
       }
       catch (...) {
         return 302;
       }
       break;
     }
     case 5: {
       try {
         MVar=SimpleVal(float(ValueStack->GetItem(1)->Value[0]) && float(ValueStack->GetItem(0)->Value[0]));
       }
       catch (...) {
         return 302;
       }
       break;
     }
     case 6: {
       try {
         MVar=SimpleVal(float(ValueStack->GetItem(1)->Value[0]) || float(ValueStack->GetItem(0)->Value[0]));
       }
       catch (...) {
         return 302;
       }
       break;
     }
     case 7: {
       try {
         MVar=SimpleVal(ValueStack->GetItem(1)->Value[0]==ValueStack->GetItem(0)->Value[0]);
       }
       catch (...) {
         return 302;
       }
       break;
     }
   };
   delete ValueStack->Pop();
   delete ValueStack->Pop();
   ValueStack->Push(MVar);
   break;
 }
 case 91:
 case 92: {
   if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
   try {
     MVar=ValueStack->Pop();
     if (MVar->Value[0]!=0) MVar->Value[0]=0.0; else MVar->Value[0]=-1.0;
     ValueStack->Push(MVar);
   }
   catch (...) {
     return 302;
   }
   break;
 }
 case 95: {
  if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
  if (ValueStack->GetItem(0)->Value[0]==0) {
    StopFlag=true;
    BEStop=BEBalance;
  }
  delete ValueStack->Pop();
  break;
 }
 case 100:
 case 101: {
  break;
 }
 case 80:
 case 81: {
  if ((ValueStack->GetItem(0)->XDim>1) || (ValueStack->GetItem(0)->YDim>1)) return 302;
  if (ValueStack->GetItem(0)->Value[0]!=0) {
    TPComp->Row=OperStack->Pop();
    TPComp->Simb=OperStack->Pop();
  }
  else {
/*    TMLFormula *MLF;
    TCustomStack<TWTLexema> *PLS=new TCustomStack<TWTLexema>;
    PLS->Push(TWTLexema(TPComp->Grammar->FindLexem(1,"end"),"",TPComp->Simb,TPComp->Row));
    TPComp->Analizer->RS.Push(TPComp->Grammar->RelMatrix->GetData(TPComp->Analizer->LS.Top().Item->Kod,PLS->GetItem(0).Item->Kod));
    TPComp->Analizer->LS.Push(PLS->Pop());

    PLS->Push(TWTLexema(TPComp->Grammar->FindLexem(1,";"),"",TPComp->Simb,TPComp->Row));
    TPComp->Analizer->RS.Push(TPComp->Grammar->RelMatrix->GetData(TPComp->Analizer->LS.Top().Item->Kod,PLS->GetItem(0).Item->Kod));
    TPComp->Analizer->LS.Push(PLS->Pop());

    delete PLS;*/
    OperStack->Pop();
    OperStack->Pop();
  }
  ValueStack->Pop();
  break;
 }
 case 103: {
/*  TMLFormula *MLF;
  RepFlag=true;
  TPComp->Analizer->RS.Pop();
  TWTLexema L=TPComp->Analizer->LS.Pop();
  TCustomStack<TWTLexema> *PLS=new TCustomStack<TWTLexema>;
  PLS->Push(TWTLexema(TPComp->Grammar->FindLexem(1,"begin"),"",TPComp->Simb,TPComp->Row));
  MLF=TPComp->Analizer->FindRule(PLS);
  TPComp->Analizer->RS.Push(TPComp->Grammar->RelMatrix->GetData(TPComp->Analizer->LS.Top().Item->Kod,MLF->Item->Kod));
  TPComp->Analizer->LS.Push(TWTLexema(MLF->Item,"",TPComp->Simb,TPComp->Row));
  TPComp->Analizer->RS.Push(TPComp->Grammar->RelMatrix->GetData(TPComp->Analizer->LS.Top().Item->Kod,L.Item->Kod));
  TPComp->Analizer->LS.Push(L);

  delete PLS;*/
  OperStack->Push(Values->GetItem(0).Simb-7);
  OperStack->Push(Values->GetItem(0).Row);
  break;
 }
 case 300: {
  IDStack->Push(Values->GetItem(0).Value);
  break;
 }
 case 301: {
  ValueStack->Push(SimpleVal(0));
  break;
 }
 case 303: {
  break;
 }
 case 310: {
  AnsiString aa=Values->GetItem(0).Value;
  MultiVars->Add(aa);
  break;
 }
 case 311: {
  AnsiString aa=Values->GetItem(1).Value;
  MultiVars->Add(aa);
  break;
 }
 case 312: {
  AnsiString aa=Values->GetItem(1).Value;
  MultiVars->Add(aa);
  if (!OnMultiVars) return 313; //не могу разрешить данную ссылку
  TWTValue *WTVal=OnMultiVars(MultiVars);
  if (!WTVal) return 314; //ссылка на неизвестный идентификатор в реестре
  ValueStack->Push(WTVal);
  MultiVars->Clear();
  break;
 }
 case 317: {
  AnsiString aa=Values->GetItem(1).Value;
  MultiVars->Add(aa);
  ResultVar="";
  OperStack->Push(-1);
  break;
 }
 }
return 0;
}

void TWTVarsList::AddVar(AnsiString Name,Variant *Value,int X,int Y){
  TWTValue *MyVar=new TWTValue(Name,Value,X,Y);
  Add(MyVar);
}

TWTValue *TWTVarsList::ValByName(AnsiString Name){
  ErrorCode=0;
  for (int x=0;x<Count;x++) {
    if (((TWTValue*)Items[x])->VarName==Name)
      return (TWTValue*)Items[x];
  }
  ErrorCode=1;
}

TWTValue *TWTVarsList::VarByName(AnsiString Name){
  ErrorCode=0;
  for (int x=0;x<Count;x++) {
    if (((TWTValue*)Items[x])->VarName==Name) return (TWTValue*)Items[x];
  }
  ErrorCode=1;
}

TWTValue* TWTVarsList::GetVar(int Index){
  return (TWTValue*)Items[Index];
}

__fastcall TWTVarsList::~TWTVarsList(void){
  for (int x=0;x<Count;x++) delete (TWTValue*)Items[x];
}

__fastcall TWTValue::TWTValue(AnsiString Name,Variant *Val,int X,int Y){
  VarName=Name;
  Value=Val;
  XDim=X;
  YDim=Y;
}

__fastcall TWTValue::~TWTValue(void){
  if (Value) free(Value);
}

//Реализация списка стандартных функций
TWTValue *TWTFuncList::DoFunction(AnsiString Name,TCustomStack<TWTValue*> *Param){
}

TWTFunc *TWTFuncList::FuncByName(AnsiString Name){
  for (int x=0;x<Count;x++) {
    if (((TWTFunc*)Items[x])->FuncName==Name) return (TWTFunc*)Items[x];
  }
  return NULL;
}

void TWTFuncList::DelFunc(AnsiString Name){
  for (int x=0;x<Count;x++) {
    if (((TWTFunc*)Items[x])->FuncName==Name) {
      delete (TWTFunc*)Items[x];
      Delete(x);
    }
  }
}

TWTFunc* TWTFuncList::GetFunc(int Index){
  return (TWTFunc*)Items[Index];
}

__fastcall TWTFuncList::~TWTFuncList(void){
  for (int x=0;x<Count;x++) delete (TWTFunc*)Items[x];
}

__fastcall TWTFuncList::TWTFuncList(TWTGenerator *Gnt){

  Generator=Gnt;
  ReadFromFile("func.dat");
/*  AddFunc("Array",255);
  AddFunc("ArrayOfStr",2);
  AddFunc("ArrayOfNum",2);
  AddFunc("AAdd",2);
  AddFunc("Abs",1);
  AddFunc("AClone",1);
  AddFunc("ACopy",2);
  AddFunc("ADel",2);
  AddFunc("AFill",2);
  AddFunc("AIns",3);
  AddFunc("AllTrim",1);
  AddFunc("Asc",1);
  AddFunc("AScan",2);
  AddFunc("ASize",3);
  AddFunc("ASort",1);
  AddFunc("At",2);
  AddFunc("ATail",1);
  AddFunc("Cdow",1);
  AddFunc("Chr",1);
  AddFunc("CMonth",1);
  AddFunc("Date",0);
  AddFunc("Day",1);
  AddFunc("Dow",1);
  AddFunc("DToS",1);
  AddFunc("Int",1);
  AddFunc("IsAlpha",1);
  AddFunc("IsDigit",1);
  AddFunc("IsLower",1);
  AddFunc("IsUpper",1);
  AddFunc("Left",2);
  AddFunc("Length",1);
  AddFunc("Log",1);
  AddFunc("Lower",1);
  AddFunc("LTrim",1);
  AddFunc("Max",2);
  AddFunc("Min",2);
  AddFunc("Month",1);
  AddFunc("Rat",2);
  AddFunc("Right",2);
  AddFunc("Round",2);
  AddFunc("RTrim",1);
  AddFunc("Space",1);
  AddFunc("Sqrt",1);
  AddFunc("Str",1);
  AddFunc("StrReplace",3);
  AddFunc("SubStr",3);
  AddFunc("Time",0);
  AddFunc("Upper",1);
  AddFunc("Val",1);
  AddFunc("Year",1);

  SaveToFile("func.dat");*/
}

TWTFunc *TWTFuncList::AddFunc(AnsiString Name, int PCount){
  TWTFunc *Func=new TWTFunc();
  Func->FuncName=Name;
  Func->ParamCount=PCount;
  Add(Func);
  return Func;
}

void __fastcall TWTFuncList::ReadFromFile(AnsiString FName){
 FILE *f=fopen(FName.c_str(),"r");
 int Simb;
 AnsiString Dump;
 TWTFunc* Func;

 while (true) {
   Dump="";
   Simb=fgetc(f);
   if (feof(f)) break;
   while (Simb!=0) {
     Dump=Dump+char(Simb);
     Simb=fgetc(f);
   }
   int Count=fgetc(f);
   Func=AddFunc(Dump,Count);
   if (Count==255) Count=1;
   for (int x=0;x<Count;x++) {
     Func->ParamType[x]=fgetc(f);
//     fread(&Func->ParamType[x].XDim,sizeof(int),1,f);
//     fread(&Func->ParamType[x].YDim,sizeof(int),1,f);
   }
 }
 fclose(f);
}

void __fastcall TWTFuncList::SaveToFile(AnsiString FName){
 FILE *f=fopen(FName.c_str(),"w");
 int Simb;
 AnsiString Dump;
 TWTFunc* Func;

 for (int x=0;x<Count;x++) {
//   if (GetFunc(x)->EventOnCall==NULL) {
     for (int y=1;y<=GetFunc(x)->FuncName.Length();y++) fputc(GetFunc(x)->FuncName[y],f);
     fputc(0,f);
     int Cnt=GetFunc(x)->ParamCount;
     fputc(Cnt,f);
     if (Cnt==255) Cnt=1;
   for (int y=0;y<Cnt;y++) {
     fputc(GetFunc(x)->ParamType[y],f);
//     fwrite(&Func->ParamType[x].XDim,sizeof(int),1,f);
//     fwrite(&Func->ParamType[x].YDim,sizeof(int),1,f);
   }
//   }
 }
 fclose(f);
}

TWTValue *SimpleVal(Variant& Value) {
  Variant *V=(Variant*)calloc(1,sizeof(Variant));
  V[0]=Value;
  return (new TWTValue("",V,1,1));
}






