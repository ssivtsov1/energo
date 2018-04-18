#include "getgramm.h"

TWTGramLexAn::TWTGramLexAn(char *FN)
{
 Row=1;
 Simb=1;
 int i;
 Grammar=new TWTGrammar();
 Num=0;
 strcpy(Dump,"");
 strcpy(FName,FN);
 char M[19][12]={
        { 4, 4, 8, 4, 4, 4, 4, 4, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 1, 2, 3, 1, 1, 1, 1, 0, 1, 0, 1, 0},
        { 1, 2, 0, 6, 1, 1, 1, 0, 0, 0, 1, 0},
        { 7, 7, 7, 0, 7, 7, 7, 7, 7, 0, 7, 0},
        { 1, 2, 0, 6, 1, 1, 1, 1, 1, 0, 1, 0},
        { 7, 7, 7, 0, 7, 7, 7, 7, 7, 7, 7, 7},
        { 7, 7, 7, 7, 7, 0, 7, 7, 7, 7, 7, 7},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 1, 2, 3, 1, 1, 1, 1, 0, 1, 0, 1, 0},
        { 1, 2, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0},
        { 1, 2, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {10, 0, 8,10,10,10,10,10,10, 0,10, 0},
        { 5, 5, 5, 5, 5, 5, 0, 5, 0, 5, 5, 5},
        { 9, 0, 0, 0, 0, 0, 0, 0, 0,11, 0, 11},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};
 for (i=0;i<19;i++) for (int x=0;x<12;x++) Message[i][x]=M[i][x];
 char F[19][12]={
        { 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
        { 0, 0, 2, 0, 0, 0, 0, 1, 1, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 6, 0, 6, 6, 6, 6, 6, 1, 1, 0, 0, 0},
        { 7, 4, 7, 7, 4, 7, 7, 1, 1, 4, 0, 4},
        { 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
        { 0, 0, 5, 0, 0, 0, 0, 1, 0, 0, 0, 0},
        { 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 6, 0, 6, 6, 0, 6, 6, 1, 1, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0},
                          { 6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 6, 0},
                          { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};

 for (i=0;i<19;i++) for (int x=0;x<12;x++) Function[i][x]=F[i][x];
 char J[19][12]={
/*                         о  <  >  :  ;  =  .  б  ц  р  % \n */
/* begin */      { 2, 2, 2, 2, 2, 2, 2, 2,16, 0,18, 0},
/* finish */     { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1},
/* error */    { 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
/* 1 - 3 */          { 2, 2, 2, 2, 2, 2, 2, 4, 2, 3, 2, 3},
/* 2 - 4 */    { 2, 2, 5, 2, 2, 2, 2, 4, 4, 6, 2, 6},
/* 3 - 5 */              { 2, 2, 2, 7, 2, 2, 2, 2, 2, 5, 2, 5},
/* 4 - 6 */              { 2, 2, 5, 2, 2, 2, 2, 2, 2, 6, 2, 6},
/* 5 - 7 */              { 2, 2, 2, 8, 2, 2, 2, 2, 2, 2, 2, 2},
/* 6 - 8 */              { 2, 2, 2, 2, 2, 9, 2, 2, 2, 2, 2, 2},
/* 7 - 9 */              {14,11,14,14,14,14,14,10,10, 9,17, 9},
/* 8 - 10 */             {14,11,14,14, 0,14,14,10,10,14,17,14},
/* 9 - 11 */             { 2, 2, 2, 2, 2, 2, 2,12, 2,11, 2,11},
/* 10 - 12 */            { 2, 2,14, 2, 2, 2, 2,12, 2,13, 2,13},
/* 11 - 13 */            { 2, 2,14, 2, 2, 2, 2, 2, 2,13, 2,13},
/* 12 - 14 */            {14,11,14,14, 0,14,14,10,10,14,17,14},
/* 13 - 15 */            { 2, 3, 2, 2, 2, 2, 2, 2, 2,15, 2,15},
/* 14 - 16 */            { 2, 2, 2, 2, 2, 2,15, 2,16, 2, 2, 2},
/* 15 - 17 */            {14,14,14,14,14,14,14,14,14, 2,14, 2},
/* 16 - 18 */            {18,18,18,18,18,18,18,18,18,18,18, 0}};
 for (i=0;i<19;i++) for (int x=0;x<12;x++) Jump[i][x]=J[i][x];
 for(i=0;i<256;i++,Simbol[i]=0);
 Simbol[60]=1;     Simbol[62]=2;      Simbol[58]=3;     Simbol[59]=4;
 Simbol[61]=5;     Simbol[46]=6;      Simbol[97]=7;     Simbol[98]=7;
 Simbol[99]=7;     Simbol[100]=7;     Simbol[101]=7;    Simbol[102]=7;
 Simbol[103]=7;    Simbol[104]=7;     Simbol[105]=7;    Simbol[106]=7;
 Simbol[107]=7;    Simbol[108]=7;     Simbol[109]=7;    Simbol[110]=7;
 Simbol[111]=7;    Simbol[112]=7;     Simbol[113]=7;    Simbol[114]=7;
 Simbol[115]=7;    Simbol[116]=7;     Simbol[117]=7;    Simbol[118]=7;
 Simbol[119]=7;    Simbol[120]=7;     Simbol[121]=7;    Simbol[122]=7;
 Simbol[65]=7;     Simbol[66]=7;      Simbol[67]=7;     Simbol[68]=7;
 Simbol[69]=7;     Simbol[70]=7;      Simbol[71]=7;     Simbol[72]=7;
 Simbol[73]=7;     Simbol[74]=7;      Simbol[75]=7;     Simbol[76]=7;
 Simbol[77]=7;     Simbol[78]=7;      Simbol[79]=7;     Simbol[80]=7;
 Simbol[81]=7;     Simbol[82]=7;      Simbol[83]=7;     Simbol[84]=7;
 Simbol[85]=7;     Simbol[86]=7;      Simbol[87]=7;     Simbol[88]=7;
 Simbol[89]=7;     Simbol[90]=7;      Simbol[95]=7;     Simbol[48]=8;
 Simbol[49]=8;     Simbol[50]=8;      Simbol[51]=8;     Simbol[52]=8;
 Simbol[53]=8;     Simbol[54]=8;      Simbol[55]=8;     Simbol[56]=8;
 Simbol[57]=8;     Simbol[32]=9;      Simbol[10]=11;    Simbol[13]=11;
 Simbol[9]=9;      Simbol[37]=10;
}

void TWTGramLexAn::Dumping(char simbol)
{
 Dump[strlen(Dump)+1]=0;
 Dump[strlen(Dump)]=simbol;
}

void TWTGramLexAn::IntDumping(char simbol)
{
 Num=Num*10+simbol-48;
}

void TWTGramLexAn::Reset(char simbol)
{
 if (Grammar->Exist(Num))
 {
  ShowError("Правило с таким номером уже существует",Simb,Row);
  exit(0);
 }
 Grammar->AddMLForm(Num,Dump);
 strcpy(Dump,"");
 Num=0;
}

void TWTGramLexAn::ResetAll(char simbol)
{
 TermReset(simbol);
 ResetChar(simbol);
}

void TWTGramLexAn::ResetChar(char simbol)
{
 Dump[1]=0;
 Dump[0]=simbol;
 Grammar->AddLexicUnit(1,Dump);
 strcpy(Dump,"");
 Num=0;
}

void TWTGramLexAn::TermReset(char simbol)
{
// Grammar->AddLexicUnit(1,strlwr(Dump));
 Grammar->AddLexicUnit(1,Dump);
 strcpy(Dump,"");
}

void TWTGramLexAn::NTermReset(char simbol)
{
 Grammar->AddLexicUnit(0,Dump);
 strcpy(Dump,"");
}

void TWTGramLexAn::ProcessSimbol(int C_S,unsigned char simbol,int &message,int &function,int &state)
{
 message=Message[C_S][Simbol[simbol]];
 function=Function[C_S][Simbol[simbol]];
 state=Jump[C_S][Simbol[simbol]];
 return ;
}

void TWTGramLexAn::ShowError(char * S,int Simb,int Row)
{
 printf("%s. Строка %d : символ %d.\n",S,Row,Simb);
}

void TWTGramLexAn::ShowMessage(int message)
{
 switch(message)
 {
  case 0 : break;
  case 1 : ShowError("Недопустимый символ в имени нетерминала",Simb,Row) ;break;
  case 2 : ShowError("Недопустимая вложенность",Simb,Row) ;break;
  case 3 : ShowError("Имя нетерминала не может быть пустым",Simb,Row) ;break;
  case 4 : ShowError("Здесь должен стоять номер правила",Simb,Row) ;break;
  case 5 : ShowError("Номер правила должен оканчиваться точкой",Simb,Row) ;break;
  case 6 : ShowError("Отсутствует символ >",Simb,Row) ;break;
  case 7 : ShowError("Здесь должен стоять символ ::=",Simb,Row) ;break;
  case 8 : ShowError("Отсутствует символ <",Simb,Row) ;break;
  case 9 : ShowError("Недопустимый символ в имени терминала",Simb,Row) ;break;
  case 10 : ShowError("Здесь должно стоять имя нетерминала в <...>",Simb,Row) ;break;
  case 11 : ShowError("После управляющего символа должен стоять символ",Simb,Row) ;break;
 }
}

void TWTGramLexAn::DoFunction(int function,unsigned char simbol)
{
 switch(function)
 {
  case 1 : Dumping(simbol);break;
  case 2 : Reset(simbol);break;
  case 3 : IntDumping(simbol);break;
  case 4 : TermReset(simbol);break;
  case 5 : NTermReset(simbol);break;
  case 6 : ResetChar(simbol);break;
  case 7 : ResetAll(simbol);break;
 }
}

int TWTGramLexAn::Process()
{
 FILE *Source=fopen(FName,"rb");
 if (Source==NULL)
 {
  cout << "Невозможно открыть исходный файл." << endl;
  exit(0);
 }
 int J,M,F,Current_State=0;
 unsigned char Buf;
 while((Current_State!=2) && (Current_State!=1) && fread(&Buf,1,1,Source))
 {
  ProcessSimbol(Current_State,Buf,M,F,J);
  DoFunction(F,Buf);
  ShowMessage(M);
  Current_State=J;
  Simb++;
  if (Buf=='\n')
  {
   Row++;
   Simb=1;
  }
 }
 ProcessSimbol(Current_State,' ',M,F,J);
 DoFunction(F,' ');
 ShowMessage(M);
 SpecSimbol=Grammar->FindInDict(1,"##");
 fclose(Source);
 return Current_State;
}

