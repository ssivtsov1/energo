#if !defined(__Pascal_h)
#define __Pascal_h

#include <iostream.h>
#include <stdio.h>
#include <string.h>
#include "gramm.h"
#include "getgramm.h"
#include "lexan.h"
#include "lexem.h"

#define ENGLISH_GRM 0
#define RUSSIAN_GRM 1

#define GRAMMA_LANGUAGE ENGLISH_GRM
#define SUPPORT_RUSSIAN_CP 1

//#include "ScriptForm.h"

class TWTAnalizer;
//class TWTScriptForm;
//class TTMainForm;

class TWTTPC
{
public:
//  TTMainForm *MainForm;
  TStrings *Source;
//  TWTScriptForm *ScriptForm;
  int Row;
  int Simb;
  int CurSimb;
  int ErrorCode;
  TWTGrammar *Grammar;
  TWTAnalizer *Analizer;
  char Message[7][8];
  char Function[7][8];
  char Jump[7][8];
  char Simbol[256];
  char Dump[256];
  char FName[20];
  int Dumping(char simbol);
  int Reset(char simbol);
  int ResetChar(unsigned char simbol);
  int ResetAll(unsigned char simbol);
  int ResetNum(char simbol);
  int ResetAllNum(unsigned char simbol);
  int ResetString(char simbol);
  int ProcessSimbol(int,unsigned char simbol,int &message,int &function,int &state);
  int ShowError(int ErrorCode);
//  int ShowMessage(int message);
  int DoFunction(int function,unsigned char simbol);
 public:
  ~TWTTPC() {delete Grammar;delete Analizer;};
  TWTTPC(/*TTMainForm *MForm*/);
  int Process(TStrings *Src);
  void Init();
};

#endif
