//---------------------------------------------------------------------------

#ifndef fWorkPlanAllH
#define fWorkPlanAllH


#include "ParamsForm.h"
#include "xlcClasses.hpp"
#include "xlReport.hpp"


class TfWorkPlan : public TWTDoc
{
public:

 TWTDBGrid* DBGrPlan;
 TWTQuery*  qWorkPlan;
// TWTDBGrid* DBGrPlanLines;
// TWTQuery*  qSebLines;
 TDateTime mmgg;
// TWTPanel* PSeb;

 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZQWork;
 TZPgSqlQuery *ZEqpQuery;

 __fastcall TfWorkPlan(TComponent* AOwner, int id_fider);
// void __fastcall FormCreate(TObject *Sender);
// void __fastcall FormClose(TObject *Sender, bool &CanClose);
// void __fastcall ShowData(int compid);

//void __fastcall SebDelete(TObject *Sender);
void __fastcall PlanRebuild(TObject *Sender);
//void __fastcall ClientSebPrint(TObject *Sender);
//void __fastcall AllSebPrint(TObject *Sender);
void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall PeriodSel(TObject *Sender);
void __fastcall ShowData(void);
// void __fastcall HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
 void _fastcall  OnChange(TWTField  *Sender);
// void __fastcall BefEdit(TWTDBGrid *Sender);
//void __fastcall SebDeleteAll(TObject *Sender);
//void __fastcall ReBuildGrid(void);
void __fastcall sbFiderClick(TObject *Sender);
void __fastcall PlaceAccept (TObject* Sender);

 TEdit* edFiderName;
 int FiderId;

 TWTField *Field1;
 TWTField *Field2;
 TWTField *Field3;
 TWTField *Field4;   
};


#endif
