#if !defined(__GETGRAMM_H)
#define __GETGRAMM_H

#include <stdlib.h>
#include "gramm.h"

class TWTGramLexAn
{
 public:
  TDictUnit *SpecSimbol;
  char Message[19][13];
  char Function[19][13];
  char Jump[19][13];
  char Simbol[256];
  char Dump[256];
  char FName[20];
  int Num;
  int Row;
  int Simb;
  TWTGrammar *Grammar;
  void Dumping(char simbol);
  void IntDumping(char simbol);
  void Reset(char simbol);
  void ResetAll(char simbol);
  void ResetChar(char simbol);
  void TermReset(char simbol);
  void NTermReset(char simbol);
  void ProcessSimbol(int,unsigned char simbol,int &message,int &function,int &state);
  void ShowError(char * S,int,int);
  void ShowMessage(int message);
  void DoFunction(int function,unsigned char simbol);
  TWTGramLexAn(char *);
  ~TWTGramLexAn() {delete Grammar;};
  int Process();
};

#endif