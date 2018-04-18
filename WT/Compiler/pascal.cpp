#include "pascal.h"

void TWTTPC::Init(){
  Analizer->Init();
  strcpy(Dump,"");
}

TWTTPC::TWTTPC(/*TTMainForm *MForm*/)
{
// MainForm=MForm;
// Source=Src;
 Row=1;
 Simb=1;
 Grammar=new TWTGrammar();
 Grammar->LoadFromFile("pascal.kgc");
 if (DEBUG)
 {
  Grammar->ShowGrammar();
  cout << endl;
  Grammar->ShowDict();
 }
 strcpy(FName,"");
 char FN[12];
 FN[strlen(FN)-3]='a';
 FN[strlen(FN)-2]='s';
 FN[strlen(FN)-1]='m';
 Analizer=new TWTAnalizer(Grammar,FN);
 Analizer->Generator->TPComp=(TWTTPC*)this;
 strcpy(Dump,"");
 int i;
 char M[7][7]={//          o p Ў ж { } '
/*begin */      {0,0,0,0,0,1,0},
/*end */      {0,0,0,0,0,0,0},
/*error */      {0,0,0,0,0,0,0},
        {0,0,0,0,0,1,0},
        {0,0,0,0,0,1,0},
        {0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0}};
 for (i=0;i<7;i++) for (int x=0;x<7;x++) Message[i][x]=M[i][x];
 char F[7][7]={
        {4,0,1,1,0,0,0},
        {0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0},
        {3,2,1,1,0,0,0},
        {6,5,0,1,0,0,0},
        {0,0,0,0,0,0,0},
        {1,1,1,1,1,1,7}};
 for (i=0;i<7;i++) for (int x=0;x<7;x++) Function[i][x]=F[i][x];
 char J[7][7]={
        {0,0,3,4,5,2,6},
        {1,1,1,1,1,1,1},
        {2,2,2,2,2,2,2},
        {0,0,3,3,5,2,6},
        {0,0,2,4,5,2,6},
        {5,5,5,5,5,0,6},
        {6,6,6,6,6,6,0}};
 for (i=0;i<7;i++) for (int x=0;x<7;x++) Jump[i][x]=J[i][x];
 for(i=0;i<256;i++,Simbol[i]=0);
 Simbol[32]=1;     Simbol[10]=1;     Simbol[13]=1;     Simbol[9]=1;
 Simbol[97]=2;     Simbol[98]=2;     Simbol[99]=2;     Simbol[100]=2;
 Simbol[101]=2;    Simbol[102]=2;    Simbol[103]=2;    Simbol[104]=2;
 Simbol[105]=2;    Simbol[106]=2;    Simbol[107]=2;    Simbol[108]=2;
 Simbol[109]=2;    Simbol[110]=2;    Simbol[111]=2;    Simbol[112]=2;
 Simbol[113]=2;    Simbol[114]=2;    Simbol[115]=2;    Simbol[116]=2;
 Simbol[117]=2;    Simbol[118]=2;    Simbol[119]=2;    Simbol[120]=2;
 Simbol[121]=2;    Simbol[122]=2;    Simbol[65]=2;     Simbol[66]=2;
 Simbol[67]=2;     Simbol[68]=2;     Simbol[69]=2;     Simbol[70]=2;
 Simbol[71]=2;     Simbol[72]=2;     Simbol[73]=2;     Simbol[74]=2;
 Simbol[75]=2;     Simbol[76]=2;     Simbol[77]=2;     Simbol[78]=2;
 Simbol[79]=2;     Simbol[80]=2;     Simbol[81]=2;     Simbol[82]=2;
 Simbol[83]=2;     Simbol[84]=2;     Simbol[85]=2;     Simbol[86]=2;
 Simbol[87]=2;     Simbol[88]=2;     Simbol[89]=2;     Simbol[90]=2;
 Simbol[95]=2;     Simbol[48]=3;     Simbol[49]=3;     Simbol[50]=3;
 Simbol[51]=3;     Simbol[52]=3;     Simbol[53]=3;     Simbol[54]=3;
 Simbol[55]=3;     Simbol[56]=3;     Simbol[57]=3;     Simbol[123]=4;
 Simbol[125]=5;    Simbol[39]=2;     Simbol[46]=0;     Simbol[34]=6;
}

int TWTTPC::Dumping(char simbol)
{
 Dump[strlen(Dump)+1]=0;
 Dump[strlen(Dump)]=simbol;
/* if (strlen(Dump)>=20)
 {
  return 100;
 }*/
 return 0;
}

int TWTTPC::Reset(char simbol)
{
 int Error;
 TDictUnit * DU;
 char ID[3]="ID";
// if ((DU=Grammar->FindLexem(1,strlwr(Dump)))==NULL)
 if ((DU=Grammar->FindLexem(1,Dump))==NULL)
 {
  if ((DU=Grammar->FindLexem(0,ID))==NULL)
  {
   return 101;
  }
  Error=Analizer->Analize(TWTLexema(DU,Dump,Row,Simb));
  if (Error) return Error;
 }
 else
 {
  Error=Analizer->Analize(TWTLexema(DU,"",Row,Simb));
  if (Error) return Error;
 }
 strcpy(Dump,"");
 return 0;
}

int TWTTPC::ResetChar(unsigned char simbol)
{
 int Error;
 TDictUnit * DU;
 Dump[1]=0;
 Dump[0]=simbol;
 if ((DU=Grammar->FindLexem(1,Dump))==NULL)
 {
  return 101;
 }
 Error=Analizer->Analize(TWTLexema(DU,"",Row,Simb));
 if (Error) return Error;
 strcpy(Dump,"");
 return 0;
};

int TWTTPC::ResetAll(unsigned char simbol)
{
 int Error;
 Error=Reset(simbol);
 if (Error) return Error;
 Error=ResetChar(simbol);
 if (Error) return Error;
 return 0;
};

int TWTTPC::ResetNum(char simbol)
{
 int Error;
 char Number[7]="number";
 TDictUnit * DU;
 if ((DU=Grammar->FindLexem(0,Number))==NULL)
 {
  return 102;
 }
 Error=Analizer->Analize(TWTLexema(DU,Dump,Row,Simb));
 if (Error) return Error;
 strcpy(Dump,"");
 return 0;
};

int TWTTPC::ResetAllNum(unsigned char simbol)
{
 int Error;
 Error=ResetNum(simbol);
 if (Error) return Error;
 Error=ResetChar(simbol);
 if (Error) return Error;
 return 0;
};

int TWTTPC::ResetString(char simbol)
{
 int Error;
 char Stroka[7]="string";
 char Simvol[5]="char";
 TDictUnit * DU;
 if (strlen(Dump)==1)
 {
  if ((DU=Grammar->FindLexem(0,Simvol))==NULL)
  {
   return 103;
  }
 }
 else
 if ((DU=Grammar->FindLexem(0,Stroka))==NULL)
 {
  return 104;
 }
 Error=Analizer->Analize(TWTLexema(DU,Dump,Row,Simb));
 if (Error) return Error;
 strcpy(Dump,"");
 return 0;
}

int TWTTPC::ProcessSimbol(int CS,unsigned char simbol,int &message,int &function,int &state)
{
 message=Message[CS][Simbol[simbol]];
 function=Function[CS][Simbol[simbol]];
 state=Jump[CS][Simbol[simbol]];
 return 0;
}

/*int TWTTPC::ShowMessage(int message)
{
/* switch(message)
 {
  case 1 : ShowError("ЋвбгвбвўгҐв ®вЄалў ой п бЄ®ЎЄ  { ");
 }; 
 return 0;
} */

int TWTTPC::DoFunction(int function,unsigned char simbol)
{
 switch(function)
 {
  case 0 : break;
  case 1 : return Dumping(simbol);
  case 2 : return Reset(simbol);
  case 3 : return ResetAll(simbol);
  case 4 : return ResetChar(simbol);
  case 5 : return ResetNum(simbol);
  case 6 : return ResetAllNum(simbol);
  case 7 : return ResetString(simbol);
 };
 return 0;
}

int TWTTPC::Process(TStrings *Src)
{
// FILE *Src=fopen("My.aaa","w");
/* if (Source==NULL)
 {
  cout << "ЌҐў®§¬®¦­® ®вЄалвм Ёбе®¤­л© д ©«." << endl;
  exit(0);
 } */
 Init();
 int Error, J,M,F,Current_State=0;
 Simb=1;
 Row=1;
 unsigned char Buf;
 Analizer->Analize(TWTLexema(Grammar->SpecSimbol,"",1,1));
// while((Current_State!=2) && (Current_State!=1) && fread(&Buf,1,1,Source))
 while((Current_State!=2) && (Current_State!=1)/* && ((Simb!=(Source->Strings[Row-1].Length()+1)) || (Row!=Source->Count))*/)
 {
//  int dd=CurSimb;//%(Form1->Memo1->Text.Length()-1);
  Buf=Src->Strings[Row-1][Simb];
  Simb++;
//  fputc(Buf,Src);
  ProcessSimbol(Current_State,Buf,M,F,J);
  Error=DoFunction(F,Buf);
  if (Error) {
    Init();
    ShowError(Error);
    return Error;
  }
//  ShowMessage(M);
  Current_State=J;
  if (Simb==(Src->Strings[Row-1].Length()+1)) {
    if (Row==Src->Count) break;
    Simb++;
    ProcessSimbol(Current_State,'\n',M,F,J);
    Error=DoFunction(F,'\n');
    if (Error) {
      Init();
      ShowError(Error);
      return Error;
    }
//    ShowMessage(M);
    Current_State=J;
    Row++;
    Simb=1;
  }
 }
 if (Current_State==2) return 2;
 ProcessSimbol(Current_State,' ',M,F,J);
 Error=DoFunction(F,' ');
 if (Error) {
   Init();
   ShowError(Error);
   return Error;
 }
// ShowMessage(M);
 Error=Analizer->Analize(TWTLexema(Grammar->SpecSimbol,"",1,1));
 if (Error) {
   Init();
   ShowError(Error);
   return Error;
 }
 //fclose(Src);
 return 0;
}

#include <dialogs.hpp>

int TWTTPC::ShowError(int ErrorCode)
{
  AnsiString ErrorStr="Error " + IntToStr(ErrorCode);
  AnsiString Error;
  AnsiString Coord=" ("+IntToStr(Row)+","+IntToStr(Simb)+")";
  switch (ErrorCode) {
  case 100: {
    Error=ErrorStr+Coord+": Длина идентификатора или строки превышает 20 символов";
    break;
  }
  case 101: {
    Error=ErrorStr+Coord+": Неизвестный терминал "+Dump;
    break;
  }
  case 102:  {
    Error=ErrorStr+": В словаре грамматики отсутствует нетерминал <number>";
    break;
  }
  case 103:  {
    Error=ErrorStr+": В словаре грамматики отсутствует нетерминал <char>";
    break;
  }
  case 104:  {
    Error=ErrorStr+": В словаре грамматики отсутствует нетерминал <string>";
    break;
  }
  case 105:  {
    Error=ErrorStr+": Невозможно открыть исходный файл.";
    break;
  }
  case 200: {
    Error=ErrorStr+Coord+": Правило не найдено";
    break;
  }
  case 201: {
    Error=ErrorStr+Coord+": Символы не могут стоять рядом";
    break;
  }
  case 301: {
    Error=ErrorStr+Coord+": Переменная еще не определена";
    break;
  }
  case 302: {
    Error=ErrorStr+Coord+": Несоответствие типов";
    break;
  }
  case 303: {
    Error=ErrorStr+Coord+": Попытка переопределения типа переменной";
    break;
  }
  case 304: {
    Error=ErrorStr+Coord+": Неизвестная функция";
    break;
  }
  case 306: {
    Error=ErrorStr+Coord+": Несоответствие количества параметров";
    break;
  }
  case 307: {
    Error=ErrorStr+Coord+": Out of range";
    break;
  }
  case 308: {
    Error=ErrorStr+Coord+": Ошибка выполнения функции";
    break;
  }
  case 313:
  case 322: {
    Error=ErrorStr+Coord+": Неразрешимая ссылка";
    break;
  }
  case 314:
  case 320: {
    Error=ErrorStr+Coord+": Ссылка на неизвестный идентификатор в реестре";
    break;
  }
  case 321: {
    Error=ErrorStr+Coord+": Попытка записи параметра Read Only";
    break;
  }
  default: {
    Error=ErrorStr+Coord+": Неизвестная ошибка";
    break;
  }
  };
  ShowMessage(Error);
  return 0;
}


