#if !defined(__GRAMM_H)
#define __GRAMM_H

#define REL_EQUAL 1  //'='
#define REL_PRIOR 2  //'>'
#define REL_POST  3  //'<'
#define DEBUG 1
#define MAX_MATRIX_SIZE 150

#include <iostream.h>
#include "string.h"
#include <stdlib.h>
#include <stdio.h>
#include "boolmatr.h"

struct TDictUnit
{
 int Kod;
 int IsTerm;
 char Item[30];
 TDictUnit * Next;
 void Show();
};

struct TLexicUnit
{
 TDictUnit * Item;
 TLexicUnit * Next;
};

struct TMLFormula
{
 int Number;
 int CountR;
 TDictUnit * Item;
 TLexicUnit * Right;
 TMLFormula * Next;
};

class TWTGrammar
{
 public:
  TWTGrammar();
  ~TWTGrammar()
  {
   delete RelMatrix;
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
  };
  TDictUnit *SpecSimbol;
  TWTMatrix *RelMatrix;
  int DictSize;
  int CountF;
  TDictUnit * Dictionary;
  TMLFormula * Formula;
  TMLFormula * TecFormula;
  TMLFormula * GetTecF();
  TMLFormula * NextFormula();
  TMLFormula * FirstFormula();
  TDictUnit * FindInDict(int,char*);
  TDictUnit * FindLexem(int,char*);
  TDictUnit * FindByKod(int);
  TLexicUnit * TecLex;
  TLexicUnit * FirstLex();
  TLexicUnit * NextLex();
  TLexicUnit * LastLex();
  TLexicUnit * GetTecLex();
  void CreateFirst(int size,TWTMatrix *M);
  void CreateLast(int size,TWTMatrix *M);
  void CreatePlus(TWTMatrix *M);
  void CreateEqual(char size,TWTMatrix *M);
  void CreatePost(TWTMatrix *E,TWTMatrix *FP,TWTMatrix *M);
  void CreatePrior(TWTMatrix *LP,TWTMatrix *E,TWTMatrix *FP,TWTMatrix *M);
  int Exist(int);
  void AddMLForm(int,char *);
  void AddLexicUnit(int,char *);
  void ShowGrammar();
  void ShowDict();
  void ShowRule(int);
  void GenerateMatrica();
  void SaveToFile(char *);
  void LoadFromFile(char *);
};

#endif
