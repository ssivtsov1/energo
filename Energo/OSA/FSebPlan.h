//---------------------------------------------------------------------------

#ifndef fSebListAllH
#define fSebListAllH


#include "ParamsForm.h"
#include "xlcClasses.hpp"
#include "xlReport.hpp"

class TFSebPlan : public TWTDoc
{
public:

 TWTDBGrid* DBGrSeb;
 TWTQuery*  qSebList;
 TWTDBGrid* DBGrSebLines;
 TWTQuery*  qSebLines;
 TDateTime mmgg;
 TDateTime pmmgg;
// TWTPanel* PSeb;

 TZPgSqlQuery *ParentDataSet;

 TZPgSqlQuery *ZEqpQuery;

 __fastcall TFSebPlan(TComponent* AOwner);
// void __fastcall FormCreate(TObject *Sender);
// void __fastcall FormClose(TObject *Sender, bool &CanClose);
// void __fastcall ShowData(int compid);

void __fastcall SebDelete(TObject *Sender);
void __fastcall SebRebuild(TObject *Sender);
void __fastcall ClientSebPrint(TObject *Sender);
void __fastcall AllSebPrint(TObject *Sender);
void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall PeriodSel(TObject *Sender);
void __fastcall ShowData(void);
void __fastcall SebDeleteAll(TObject *Sender);
//void __fastcall ReBuildGrid(void);
};

class TFSebNKRE4 : public TWTDoc
{
public:

 TWTDBGrid* DBGrSeb;
 TWTQuery*  qSebList;
 TWTDBGrid* DBGrSebLines;
 TWTQuery*  qSebLines;
 TDateTime mmgg;
// TWTPanel* PSeb;

 TZPgSqlQuery *ParentDataSet;

 TZPgSqlQuery *ZEqpQuery;

 __fastcall TFSebNKRE4(TComponent* AOwner);
// void __fastcall FormCreate(TObject *Sender);
// void __fastcall FormClose(TObject *Sender, bool &CanClose);
// void __fastcall ShowData(int compid);

void __fastcall SebDelete(TObject *Sender);
void __fastcall SebRebuild(TObject *Sender);
void __fastcall ClientSebPrint(TObject *Sender);
void __fastcall AllSebPrint(TObject *Sender);
void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall PeriodSel(TObject *Sender);
void __fastcall ShowData(void);
 void __fastcall HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
 void _fastcall  OnChange(TWTField  *Sender);
 void __fastcall BefEdit(TWTDBGrid *Sender);
void __fastcall SebDeleteAll(TObject *Sender);
//void __fastcall ReBuildGrid(void);
};

class TFSebiNKRE4 : public TWTDoc
{
public:

 TWTDBGrid* DBGrSeb;
 TWTQuery*  qSebList;
 TWTDBGrid* DBGrSebLines;
 TWTQuery*  qSebLines;
 TDateTime mmgg;
 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;

 __fastcall TFSebiNKRE4(TComponent* AOwner);
void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall ShowData(void);
 void __fastcall HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);

};

class TFSebState : public TWTDoc
{
public:
 TWTDBGrid* DBGrSeb;
 TWTQuery*  qSebList;
 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;
  TxlReport *xlReport;
   TZPgSqlQuery *ZQXLReps;
__fastcall TFSebState(TComponent* AOwner);
void __fastcall SebRebuild(TObject *Sender);
void __fastcall SebPrint(TObject *Sender);
void __fastcall ShowData(void);
void __fastcall HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);

};

#endif
