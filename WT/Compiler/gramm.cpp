#include "gramm.h"

void TWTGrammar::GenerateMatrica()
{
 int i;
 RelMatrix=new TWTMatrix(DictSize);
 TWTMatrix *FP=new TWTMatrix(DictSize);
 TWTMatrix *LP=new TWTMatrix(DictSize);
 TWTMatrix *E=new TWTMatrix(DictSize);
 CreateFirst(DictSize,FP);
 CreateLast(DictSize,LP);
 CreateEqual(DictSize,E);
 CreatePlus(FP);
 CreatePlus(LP);
 TWTMatrix *RM=new TWTMatrix(DictSize);
 CreatePrior(LP,E,FP,RM);
 for (i=0;i<RM->Size;i++) RM->SetData(i,RM->Size-1,1);
 for (i=0;i<RM->Size;i++) 
 for (int x=0;x<RM->Size;x++) 
 if (RM->GetData(i,x)) RelMatrix->SetData(i,x,REL_PRIOR);
 CreatePost(E,FP,RM);
 for (i=0;i<RM->Size-1;i++) RM->SetData(RM->Size-1,i,1);
 for (i=0;i<RM->Size;i++) 
 for (int x=0;x<RM->Size;x++) 
 if (RM->GetData(i,x)) 
 {
  if (RelMatrix->GetData(i,x)) cout << "Наложение матрицы Post на Prior в " << i << ","<< x << endl;
  RelMatrix->SetData(i,x,REL_POST);
 }
 for (i=0;i<RM->Size;i++) 
 for (int x=0;x<RM->Size;x++) 
 if (E->GetData(i,x)) 
 {
  if (RelMatrix->GetData(i,x)==REL_POST) cout << "Наложение матрицы Post на Equal в " << i << ","<< x << endl;
  if (RelMatrix->GetData(i,x)==REL_PRIOR) cout << "Наложение матрицы Prior на Equal в " << i << ","<< x << endl;
  RelMatrix->SetData(i,x,REL_EQUAL);
 }
 delete E;
 delete FP;
 delete LP;
 delete RM;
 SpecSimbol=FindByKod(DictSize-1);
}

TWTGrammar::TWTGrammar()
{
 CountF=0;
 Dictionary=NULL;
 Formula=NULL;
 TecFormula=NULL;
 DictSize=0;
}

void TWTGrammar::SaveToFile(char * FN)
{
 FILE *f;
 int x,i;
 char a;
 char Head[42]="KoVAX Grammar Compiller v1.00. April 1999.";
 f=fopen(FN,"wb");
 TDictUnit * Tec=Dictionary;
 fwrite(&Head,1,42,f); 
 fwrite(&DictSize,1,2,f); 
 for (i=0;i<DictSize;i++)
 {
  fwrite(&(x=strlen(Tec->Item)+1),1,2,f); 
  fwrite(&Tec->IsTerm,1,2,f); 
  fwrite(&(*Tec->Item),1,strlen(Tec->Item)+1,f); 
  Tec=Tec->Next;
 }
 fwrite(&CountF,1,2,f); 
 FirstFormula();
 for (i=0;i<CountF;i++)
 {
  fwrite(&TecFormula->Number,1,2,f); 
  fwrite(&TecFormula->Item->Kod,1,2,f); 
  fwrite(&TecFormula->CountR,1,2,f); 
  for (int ii=0;ii<TecFormula->CountR;ii++)
  {
   fwrite(&TecLex->Item->Kod,1,2,f); 
   NextLex();
  }
  NextFormula();
 }
 for (i=0;i<DictSize;i++)
 for (int ii=0;ii<DictSize;ii++)
 {
  a=RelMatrix->GetData(i,ii);
  fwrite(&a,1,1,f); 
 }
 fclose(f);
}

void TWTGrammar::LoadFromFile(char * FN)
{
 FILE *f;
 short x,i,y,z;
 char a;
 char Head[42],Name[30];
 TDictUnit * Tec=Dictionary;
 while (Formula!=NULL)
 {
  while (Formula->Right!=NULL)
  {
   TecLex=Formula->Right;
   Formula->Right=TecLex->Next;
   delete TecLex;
  }
  TecFormula=Formula;
  Formula=Formula->Next;
  delete TecFormula;
 }
 TDictUnit *TecDict;
 while (Dictionary!=NULL)
 {
  TecDict=Dictionary;
  Dictionary=Dictionary->Next;
  delete TecDict;
 }
 CountF=0;
 DictSize=0;
 f=fopen(FN,"rb");
 if (f==NULL)
 {
  cout << "Невозможно открыть файл грамматики." << endl;
  exit(0);
 }
 fread(&Head,1,42,f);
 fread(&z,1,2,f);
 for (i=0;i<z;i++)
 {
  fread(&x,1,2,f);
  fread(&y,1,2,f);
  fread(&Name,1,x,f); 
  FindInDict(y,Name);
 }
 RelMatrix=new TWTMatrix(DictSize);
 fread(&z,1,2,f); 
 TDictUnit *DU;
 for (i=0;i<z;i++)
 {
  fread(&x,1,2,f);
  fread(&y,1,2,f); 
  AddMLForm(x,FindByKod(y)->Item);
  fread(&x,1,2,f); 
  for (int ii=0;ii<x;ii++)
  {
   fread(&y,1,2,f); 
   DU=FindByKod(y);
   AddLexicUnit(DU->IsTerm,DU->Item);
  }
 }
 for (i=0;i<DictSize;i++)
 for (int ii=0;ii<DictSize;ii++)
 {
  fread(&a,1,1,f);
  RelMatrix->SetData(i,ii,a);
 }
 fclose(f);
 SpecSimbol=FindByKod(DictSize-1);
}

TMLFormula * TWTGrammar::GetTecF()
{
 return TecFormula;
}

TLexicUnit * TWTGrammar::GetTecLex()
{
 return TecLex;
}

TMLFormula * TWTGrammar::NextFormula()
{
 TecLex=NULL;
 if ((TecFormula==NULL) || (TecFormula->Next==NULL)) return NULL;
 TecLex=TecFormula->Next->Right;
 return TecFormula=TecFormula->Next;
}

TLexicUnit * TWTGrammar::FirstLex()
{
 if (TecFormula==NULL) return NULL;
 return TecFormula->Right;
}

TLexicUnit * TWTGrammar::NextLex()
{
 if ((TecLex==NULL) || (TecLex->Next==NULL)) return NULL;
 return TecLex=TecLex->Next;
}

TLexicUnit * TWTGrammar::LastLex()
{
 if (TecFormula==NULL) return NULL;
 TLexicUnit *Tec=TecFormula->Right;
 while (Tec->Next!=NULL) Tec=Tec->Next;
 return Tec;
}

TMLFormula * TWTGrammar::FirstFormula()
{
 TecLex=NULL;
 if (Formula==NULL) return NULL;
 TecLex=Formula->Right;
 return TecFormula=Formula;
}

TDictUnit *TWTGrammar::FindInDict(int I,char* S)
{
// TDictUnit *Tec=Dictionary;
 TDictUnit *Tec;
 if (Dictionary==NULL) Dictionary=Tec=new TDictUnit;
 else
 {
  Tec=Dictionary;
  if ((Tec->IsTerm==I) && !strcmp(Tec->Item,S)) return Tec;
  while (Tec->Next!=NULL)
  {
   Tec=Tec->Next;
   if ((Tec->IsTerm==I) && !strcmp(Tec->Item,S)) return Tec;
  }
  Tec=Tec->Next=new TDictUnit;
 }
 strcpy(Tec->Item,S);
 Tec->IsTerm=I;
 Tec->Next=NULL;
 Tec->Kod=DictSize;
 DictSize++;
 if (DEBUG) cout << DictSize << endl;
 if (DictSize>=MAX_MATRIX_SIZE) 
 {
  cout << "Словарь превысил лимит." << endl;
  exit(0);
 }
 return Tec;
}

TDictUnit *TWTGrammar::FindByKod(int K)
{
 TDictUnit *Tec=Dictionary;
 for (int i=0;i<K;i++) Tec=Tec->Next;
 return Tec;
}

TDictUnit *TWTGrammar::FindLexem(int I,char* S)
{
 TDictUnit *Tec=Dictionary;
 if (Tec==NULL) return NULL;
 while (Tec->Next!=NULL)
 {
  if ((Tec->IsTerm==I) && !strcmp(Tec->Item,S)) return Tec;
  Tec=Tec->Next;
 }
 return NULL;
}

void TWTGrammar::AddMLForm(int Num,char * N)
{
 TMLFormula *Tec=Formula;
 if (Formula==NULL) Tec=Formula=new TMLFormula;
 else
 {
  while (Tec->Next!=NULL) Tec=Tec->Next;
  Tec=Tec->Next=new TMLFormula;
 }
 Tec->Number=Num;
 Tec->Right=NULL;
 Tec->Next=NULL;
 Tec->Item=FindInDict(0,N);
 Tec->CountR=0;
 CountF++;
}

void TWTGrammar::AddLexicUnit(int I,char *S)
{
 if (Formula==NULL) return;
 TMLFormula *Tec=Formula;
 while (Tec->Next!=NULL) Tec=Tec->Next;
 TLexicUnit *LTec=Tec->Right;
 if (LTec==NULL) LTec=Tec->Right=new TLexicUnit;
 else
 {
  while (LTec->Next!=NULL) LTec=LTec->Next;
  LTec=LTec->Next=new TLexicUnit;
 }
 LTec->Next=NULL;
 LTec->Item=FindInDict(I,S);
 Tec->CountR++;
}

void TWTGrammar::ShowRule(int Num)
{
 TMLFormula *Tec=Formula;
 while (Tec!=NULL) 
 {
  if (Tec->Number==Num) break;
  Tec=Tec->Next;
 }
 if (Tec==NULL) return;
 cout << Tec->Number << ". <" <<Tec->Item->Item << "> ::=";
 TLexicUnit *LTec=Tec->Right;
 while (LTec!=NULL) 
 {
  if (!LTec->Item->IsTerm) cout << " <"; else cout << ' ';
  cout << LTec->Item->Item;
  if (!LTec->Item->IsTerm) cout << '>';
  LTec=LTec->Next;
 }
 cout << ';' << endl;
}

int TWTGrammar::Exist(int Num)
{
 TMLFormula *Tec=Formula;
 while (Tec!=NULL) 
 {
  if (Tec->Number==Num) break;
  Tec=Tec->Next;
 }
 if (Tec==NULL) return 0;
 return 1;
}

void TDictUnit::Show()
{
 if (!IsTerm) cout << " <"; else cout << ' ';
 cout << Item;
 if (!IsTerm) cout << '>';
}

void TWTGrammar::ShowGrammar()
{
 TMLFormula *Tec=Formula;
 if (Tec==NULL) return;
 TLexicUnit *LTec=Tec->Right;
 while (Tec!=NULL)
 {
  cout << Tec->Number << ". <" <<Tec->Item->Item << "> ::=";
  LTec=Tec->Right;
  if (LTec!=NULL)
  while (LTec!=NULL)
  {
   if (!LTec->Item->IsTerm) cout << " <"; else cout << ' ';
   cout << LTec->Item->Item;
   if (!LTec->Item->IsTerm) cout << '>';
   LTec=LTec->Next;
  }
  Tec=Tec->Next;
  cout << ';' << endl;
 }
}

void TWTGrammar::ShowDict()
{
 TDictUnit *Tec=Dictionary;
 if (Tec==NULL) return;
 cout << "  Dictionary:" << endl;
 while (Tec!=NULL)
 {
  cout << Tec->Kod << ". ";
  if (!Tec->IsTerm) cout << '<';
  cout << Tec->Item;
  if (!Tec->IsTerm) cout << '>';
  cout << endl;
  Tec=Tec->Next;
 }
 cout << endl;
}

void TWTGrammar::CreateFirst(int size,TWTMatrix *M)
{
 if (FirstFormula()==NULL) return ;
 do
  if (GetTecF()->Right!=NULL) M->SetData(GetTecF()->Item->Kod,FirstLex()->Item->Kod,1);
 while(NextFormula()!=NULL);
}

void TWTGrammar::CreateLast(int size,TWTMatrix *M)
{
 if (FirstFormula()==NULL) return ;
 do
  if (GetTecF()->Right!=NULL) M->SetData(GetTecF()->Item->Kod,LastLex()->Item->Kod,1);
 while(NextFormula()!=NULL);
}

void TWTGrammar::CreatePlus(TWTMatrix *M)
{
 int Changed=0;
 do 
 {
  Changed=0;
  for(int i=0;i<M->Size;i++)
  for(int j=0;j<M->Size;j++)
  if (M->GetData(j,i))
  {
   for(int k=0;k<M->Size;k++)
   if (M->GetData(i,k))
   {
    if (!M->GetData(j,k)) Changed=1;
    M->SetData(j,k,1);
   }
  }
 }
 while(Changed);
}

void TWTGrammar::CreateEqual(char size,TWTMatrix *M)
{
 TLexicUnit * TL;
 if (FirstFormula()==NULL) return ;
 do
 if (GetTecLex()!=NULL)
 while (GetTecLex()->Next!=NULL)
 {
  TL=GetTecLex();
  M->SetData(TL->Item->Kod,NextLex()->Item->Kod,1);
 }
 while(NextFormula()!=NULL);
}

void TWTGrammar::CreatePost(TWTMatrix *E,TWTMatrix *FP,TWTMatrix *M)
{
 E->Umn(FP,M);
}

void TWTGrammar::CreatePrior(TWTMatrix *LP,TWTMatrix *E,TWTMatrix *FP,TWTMatrix *M)
{
 TWTMatrix *I=new TWTMatrix(E->Size);
 TWTMatrix *Tec=new TWTMatrix(E->Size);
 I->Single();
 I->Plus(FP,I);
 LP->T(M);
 M->Umn(E,Tec);
 Tec->Umn(I,M);
 delete I;
 delete Tec;
}

