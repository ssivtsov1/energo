//---------------------------------------------------------------------------

#ifndef fbalConnSwH
#define fbalConnSwH


#include "ParamsForm.h"
class TfConnSwitch : public TWTDoc
{
public:

 TWTDBGrid* DBGrDoc;
 TWTQuery*  qDocList;
// TWTDBGrid* DBGrDocLines;
// TWTQuery*  qDocLines;
 TDateTime mmgg;
// TWTPanel* PTax;
 int id_client;

 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;

 __fastcall TfConnSwitch(TComponent* AOwner);

 void __fastcall ShowData(void);
 void __fastcall ShowData(TDateTime dt_from,TDateTime dt_to);
 void __fastcall NewDocInsert(TDataSet* DataSet);
 void _fastcall  SwitchNewGr(TWTDBGrid *Sender) ;
 void __fastcall SwitchNew(TObject* Sender) ;
 void __fastcall SwitchEdit (TObject* Sender) ;
 void __fastcall CancelInsert(TDataSet* DataSet);
 void __fastcall PeriodSel(TObject *Sender);
 void __fastcall PrintList(TObject *Sender);
 void __fastcall CheckIntervals(TObject *Sender);
 void __fastcall DrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,   TGridDrawState State);
 TDateTime DateFrom;
 TDateTime DateTo;
 int check_mode;
};

//---------------------------------------------------------------------------
//extern PACKAGE TWTWinDBGrid *WMeterGrid;
#endif
